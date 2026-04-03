(vl-load-com)

(defun _skr-get-save-folder (/ sh folder path)
  (setq sh (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
  (setq folder (vlax-invoke-method sh 'BrowseForFolder 0 "Vyber cieľový priečinok pre spracované DWG" 0))
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

(defun _skr-base-name (fn / pos)
  (setq pos (vl-string-position (ascii ".") fn t))
  (if pos
    (substr fn 1 pos)
    fn
  )
)

(defun _skr-ss-by-filter (flt)
  (ssget "_X" flt)
)

(defun _skr-safe-command (cmdargs)
  (vl-catch-all-apply
    '(lambda ()
       (apply 'command cmdargs)
     )
  )
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
      (setvar "CMDECHO" 0)
      (sssetfirst nil ss)
      (_skr-safe-command (list "_.txtexp"))
      (sssetfirst nil nil)
      (setq changed T)
    )
  )
  changed
)

(defun _skr-burst-pass (/ changed ss1 ss2 ss3 ss4 ss5 ss6)
  (setq changed nil)

  ;; bloky
  (setq ss1 (_skr-ss-by-filter '((0 . "INSERT"))))
  (if (_skr-explode-ss ss1) (setq changed T))

  ;; kóty
  (setq ss2 (_skr-ss-by-filter '((0 . "DIMENSION"))))
  (if (_skr-explode-ss ss2) (setq changed T))

  ;; multileadery
  (setq ss3 (_skr-ss-by-filter '((0 . "MULTILEADER"))))
  (if (_skr-explode-ss ss3) (setq changed T))

  ;; leadery
  (setq ss4 (_skr-ss-by-filter '((0 . "LEADER"))))
  (if (_skr-explode-ss ss4) (setq changed T))

  ;; mleader blokový obsah po rozbití môže vytvárať ďalšie insert-y
  (setq ss5 (_skr-ss-by-filter '((0 . "INSERT"))))
  (if (_skr-explode-ss ss5) (setq changed T))

  ;; texty
  (setq ss6 (_skr-ss-by-filter '((0 . "TEXT,MTEXT,ATTDEF,ATTRIB"))))
  (if (_skr-txtexp-ss ss6) (setq changed T))

  changed
)

(defun _skr-process-open-doc (doc outpath / oldfiledia oldcmdecho oldattreq oldexpert olddbmod pass changed)
  (vla-activate doc)
  (setvar "TILEMODE" (getvar "TILEMODE"))
  (command "_.ucs" "_world")
  (command "_.plan" "_world")

  (setq oldfiledia (getvar "FILEDIA"))
  (setq oldcmdecho (getvar "CMDECHO"))
  (setq oldattreq  (getvar "ATTREQ"))
  (setq oldexpert  (getvar "EXPERT"))

  (setvar "FILEDIA" 0)
  (setvar "CMDECHO" 0)
  (setvar "ATTREQ" 0)
  (setvar "EXPERT" 5)

  ;; viac priechodov kvôli vnoreným blokom a objektom vzniknutým po explode
  (setq pass 0)
  (repeat 6
    (setq changed (_skr-burst-pass))
    (setq pass (1+ pass))
  )

  (command "_.-purge" "_all" "*" "_n")

  (vla-saveas doc outpath)

  (setvar "FILEDIA" oldfiledia)
  (setvar "CMDECHO" oldcmdecho)
  (setvar "ATTREQ"  oldattreq)
  (setvar "EXPERT"  oldexpert)
)

(defun c:SKR_DWG_BURST_BATCH (/ files target app docs i fullpath fn newname outpath doc)
  (vl-load-com)

  ;; Vyber DWG súbory
  (setq files
    (getfiled
      "Vyber DWG súbory na spracovanie"
      ""
      "dwg"
      8
    )
  )

  (if (not files)
    (progn
      (princ "\nNeboli vybrané žiadne DWG súbory.")
      (princ)
    )
    (progn
      ;; Cieľový priečinok
      (setq target (_skr-get-save-folder))

      (if (not target)
        (progn
          (princ "\nNebola vybraná cieľová cesta.")
          (princ)
        )
        (progn
          (setq app  (vlax-get-acad-object))
          (setq docs (vla-get-Documents app))
          (setq i 0)

          ;; Načítanie Express Tools ak sú dostupné
          (vl-catch-all-apply '(lambda () (load "express")))

          (foreach fullpath files
            (setq fn (vl-filename-base fullpath))
            (setq newname (strcat fn "_SKR.dwg"))
            (setq outpath (strcat target newname))

            (princ (strcat "\nSpracovávam: " fullpath))

            (setq doc
              (vl-catch-all-apply
                'vla-open
                (list docs fullpath)
              )
            )

            (if (vl-catch-all-error-p doc)
              (princ (strcat "\nChyba pri otvorení súboru: " fullpath))
              (progn
                (setq doc (vl-catch-all-apply 'identity (list doc)))
                (_skr-process-open-doc doc outpath)
                (vla-close doc)
                (princ (strcat "\nUložené ako: " outpath))
              )
            )
          )

          (princ "\nHotovo.")
          (princ)
        )
      )
    )
  )
)