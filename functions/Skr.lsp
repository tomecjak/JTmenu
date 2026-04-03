(vl-load-com)

(defun _skr-msg (s) (princ (strcat "\n" s)))

(defun _skr-warning-confirm (/ dcl_id dcl_file result)
  (setq dcl_file "SKR_WARNING.dcl")
  (setq result nil)
  (setq dcl_id (load_dialog dcl_file))
  (if (and dcl_id (new_dialog "skr_warning" dcl_id))
    (progn
      (action_tile "accept" "(setq result T)(done_dialog 1)")
      (action_tile "cancel" "(setq result nil)(done_dialog 0)")
      (start_dialog)
      (unload_dialog dcl_id)
      result
    )
    (progn
      (if dcl_id (unload_dialog dcl_id))
      (alert
        (strcat
          "Nepodarilo sa nacitat dialog SKR_WARNING.dcl.\n"
          "Skontroluj, ci je DCL subor v support path alebo v rovnakom priecinku."
        )
      )
      nil
    )
  )
)

(defun _skr-browse-folder (title / sh folder path)
  (setq sh (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
  (setq folder (vlax-invoke-method sh 'BrowseForFolder 0 title 0))
  (vlax-release-object sh)
  (if folder
    (progn
      (setq path (vlax-get-property (vlax-get-property folder 'Self) 'Path))
      (if (= (substr path (strlen path) 1) "\\")
        path
        (strcat path "\\")
      )
    )
  )
)

(defun _skr-get-source-folder ()
  (_skr-browse-folder "Vyber priečinok so vstupnými DWG súbormi")
)

(defun _skr-get-save-folder ()
  (_skr-browse-folder "Vyber cieľový priečinok pre spracované DWG")
)

(defun _skr-list-dwgs (folder / files out)
  (setq files (vl-directory-files folder "*.dwg" 1))
  (setq out '())
  (foreach f files
    (setq out (cons (strcat folder f) out))
  )
  (reverse out)
)

(defun _skr-safe-command (args)
  (vl-catch-all-apply '(lambda () (apply 'command args)))
)

(defun _skr-command-ok-p (args)
  (not (vl-catch-all-error-p (_skr-safe-command args)))
)

(defun _skr-layout-names (/ doc lst lay name)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq lst '())
  (vlax-for lay (vla-get-Layouts doc)
    (setq name (vla-get-Name lay))
    (if (/= (strcase name) "MODEL")
      (setq lst (cons name lst))
    )
  )
  (reverse lst)
)

(defun _skr-select-space-filter (layoutName flt / data)
  (if layoutName
    (setq data (append (list (cons 410 layoutName)) flt))
    (setq data flt)
  )
  (ssget "_X" data)
)

(defun _skr-explode-ss (ss / i e changed)
  (setq changed nil)
  (if ss
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq e (ssname ss i))
        (_skr-safe-command (list "_.explode" e))
        (setq i (1+ i))
        (setq changed T)
      )
    )
  )
  changed
)

(defun _skr-txtexp-ss (ss / changed)
  (setq changed nil)
  (if ss
    (progn
      (sssetfirst nil ss)
      (_skr-safe-command (list "_.txtexp"))
      (sssetfirst nil nil)
      (setq changed T)
    )
  )
  changed
)

(defun _skr-clean-proxy-aec (/ done)
  (setq done nil)
  ;; -EXPORTTOAUTOCAD je interaktívny a v batch režime často padá na promptoch.
  ;; Preto používame iba best-effort AECTOACAD, ak je dostupný.
  (if (_skr-command-ok-p (list "_.-aectoacad"))
    (setq done T)
  )
  (if (not done)
    (if (_skr-command-ok-p (list "_.aectoacad"))
      (setq done T)
    )
  )
  done
)

(defun _skr-process-space (layoutName / changed ss1 ss2 ss3 ss4 ss5 ss6 ss7 ss8)
  (setq changed nil)
  (setq ss1 (_skr-select-space-filter layoutName '((0 . "INSERT"))))
  (if (_skr-explode-ss ss1) (setq changed T))
  (setq ss2 (_skr-select-space-filter layoutName '((0 . "DIMENSION"))))
  (if (_skr-explode-ss ss2) (setq changed T))
  (setq ss3 (_skr-select-space-filter layoutName '((0 . "MULTILEADER"))))
  (if (_skr-explode-ss ss3) (setq changed T))
  (setq ss4 (_skr-select-space-filter layoutName '((0 . "LEADER"))))
  (if (_skr-explode-ss ss4) (setq changed T))
  (setq ss5 (_skr-select-space-filter layoutName '((0 . "ACAD_TABLE,TOLERANCE"))))
  (if (_skr-explode-ss ss5) (setq changed T))
  (setq ss6 (_skr-select-space-filter layoutName '((0 . "INSERT"))))
  (if (_skr-explode-ss ss6) (setq changed T))
  (setq ss7 (_skr-select-space-filter layoutName '((0 . "TEXT,MTEXT,ATTDEF,ATTRIB"))))
  (if (_skr-txtexp-ss ss7) (setq changed T))
  (setq ss8 (_skr-select-space-filter layoutName '((0 . "INSERT,DIMENSION,MULTILEADER,LEADER"))))
  (if (_skr-explode-ss ss8) (setq changed T))
  changed
)

(defun _skr-process-all-spaces (/ lays)
  (repeat 4 (_skr-process-space nil))
  (setq lays (_skr-layout-names))
  (foreach lay lays
    (_skr-msg (strcat "Spracovávam layout: " lay))
    (repeat 4 (_skr-process-space lay))
  )
)

(defun _skr-purge-audit ()
  (_skr-safe-command (list "_.-purge" "_all" "*" "_n"))
  (_skr-safe-command (list "_.audit" "_y"))
  (_skr-safe-command (list "_.-purge" "_all" "*" "_n"))
)

(defun _skr-process-open-doc (doc outpath / oldfiledia oldcmdecho oldattreq oldexpert oldproxynotice saver err)
  (vla-activate doc)
  (setq oldfiledia     (getvar "FILEDIA"))
  (setq oldcmdecho     (getvar "CMDECHO"))
  (setq oldattreq      (getvar "ATTREQ"))
  (setq oldexpert      (getvar "EXPERT"))
  (setq oldproxynotice (getvar "PROXYNOTICE"))
  (setvar "FILEDIA" 0)
  (setvar "CMDECHO" 0)
  (setvar "ATTREQ" 0)
  (setvar "EXPERT" 5)
  (setvar "PROXYNOTICE" 0)
  (_skr-msg "Pokus o čistenie AEC/proxy objektov...")
  (_skr-clean-proxy-aec)
  (_skr-process-all-spaces)
  (_skr-purge-audit)
  (setq saver (_skr-safe-command (list "_.saveas" "" outpath)))
  (if (vl-catch-all-error-p saver)
    (progn
      (setq err (vl-catch-all-error-message saver))
      (_skr-msg (strcat "SAVEAS zlyhal: " err))
      nil
    )
    T
  )
  (setvar "FILEDIA" oldfiledia)
  (setvar "CMDECHO" oldcmdecho)
  (setvar "ATTREQ" oldattreq)
  (setvar "EXPERT" oldexpert)
  (setvar "PROXYNOTICE" oldproxynotice)
)

(defun c:SKR_DWG_BURST_BATCH (/ src target files app docs fullpath fn outpath doc)
  (vl-load-com)
  (if (not (_skr-warning-confirm))
    (progn (_skr-msg "Operácia bola zrušená používateľom.") (princ))
    (progn
      (setq src (_skr-get-source-folder))
      (if (not src)
        (progn (_skr-msg "Nebola vybraná vstupná cesta.") (princ))
        (progn
          (setq files (_skr-list-dwgs src))
          (if (not files)
            (progn (_skr-msg "Vo vybranom priečinku sa nenašli žiadne DWG súbory.") (princ))
            (progn
              (setq target (_skr-get-save-folder))
              (if (not target)
                (progn (_skr-msg "Nebola vybraná cieľová cesta.") (princ))
                (progn
                  (setq app  (vlax-get-acad-object))
                  (setq docs (vla-get-Documents app))
                  (vl-catch-all-apply '(lambda () (load "express")))
                  (foreach fullpath files
                    (setq fn (vl-filename-base fullpath))
                    (setq outpath (strcat target fn "_SKR.dwg"))
                    (_skr-msg "----------------------------------------")
                    (_skr-msg (strcat "Spracovávam: " fullpath))
                    (if (findfile fullpath)
                      (progn
                        (setq doc (vl-catch-all-apply 'vla-open (list docs fullpath)))
                        (if (vl-catch-all-error-p doc)
                          (_skr-msg (strcat "Chyba pri otvorení súboru: " fullpath))
                          (progn
                            (setq doc (vla-get-ActiveDocument app))
                            (if (_skr-process-open-doc doc outpath)
                              (_skr-msg (strcat "Uložené ako: " outpath))
                              (_skr-msg (strcat "Nepodarilo sa uložiť: " outpath))
                            )
                            (vla-close doc :vlax-false)
                          )
                        )
                      )
                      (_skr-msg (strcat "Súbor neexistuje alebo nie je dostupný: " fullpath))
                    )
                  )
                  (_skr-msg "Hotovo.")
                  (princ)
                )
              )
            )
          )
        )
      )
    )
  )
)

(princ "\nPríkaz načítaný. Spusti SKR_DWG_BURST_BATCH.")
(princ)
