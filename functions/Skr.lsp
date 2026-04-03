(vl-load-com)

(defun _skr-msg (s) (princ (strcat "\n" s)))

(defun _skr-yesno (msg / ans)
  (initget "Ano Nie")
  (setq ans (getkword (strcat "\n" msg " [Ano/Nie] <Nie>: ")))
  (if (= ans "Ano") T nil)
)

(defun _skr-warning-confirm (/ ok1 ok2)
  (_skr-msg "UPOZORNENIE: Tento skript nenavratne meni obsah DWG.")
  (_skr-msg "Rozbije bloky, texty, kóty, popisy, objekty v Model aj vo všetkých Layoutoch.")
  (_skr-msg "Zároveň sa pokúsi odstrániť alebo konvertovať AEC/proxy objekty na natívne entity.")
  (_skr-msg "Takýto zásah môže zmeniť vzhľad výkresu, anotácie, fonty aj správanie objektov.")
  (_skr-msg "Originálne DWG síce ostanú zachované, ale výstupné súbory budú deštruktívne upravené.")
  (setq ok1 (_skr-yesno "Rozumieš, čo skript robí, a chceš pokračovať?"))
  (if ok1
    (setq ok2 (_skr-yesno "Potvrdzuješ, že si vedomý rizík a chceš spustiť dávkové spracovanie?"))
  )
  (and ok1 ok2)
)

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

(defun _skr-safe-command (args)
  (vl-catch-all-apply
    '(lambda () (apply 'command args))
  )
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
    (setq data (append (list (cons 410 "Model")) flt))
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

  ;; pokus 1: EXPORTTOAUTOCAD (preferované pri vertical/proxy prevode)
  (if (_skr-command-ok-p (list "_.-exporttoautocad" "_all" ""))
    (setq done T)
  )

  ;; pokus 2: AECTOACAD
  (if (not done)
    (if (_skr-command-ok-p (list "_.aectoacad"))
      (setq done T)
    )
  )

  ;; pokus 3: command line variant
  (if (not done)
    (if (_skr-command-ok-p (list "_.-aectoacad"))
      (setq done T)
    )
  )

  done
)

(defun _skr-process-space (layoutName / changed ss1 ss2 ss3 ss4 ss5 ss6 ss7 ss8)
  (setq changed nil)

  ;; bloky
  (setq ss1 (_skr-select-space-filter layoutName '((0 . "INSERT"))))
  (if (_skr-explode-ss ss1) (setq changed T))

  ;; kóty
  (setq ss2 (_skr-select-space-filter layoutName '((0 . "DIMENSION"))))
  (if (_skr-explode-ss ss2) (setq changed T))

  ;; multileadery
  (setq ss3 (_skr-select-space-filter layoutName '((0 . "MULTILEADER"))))
  (if (_skr-explode-ss ss3) (setq changed T))

  ;; leadery
  (setq ss4 (_skr-select-space-filter layoutName '((0 . "LEADER"))))
  (if (_skr-explode-ss ss4) (setq changed T))

  ;; tolerancie, tabuľky, mleader obsah po rozbití a pod.
  (setq ss5 (_skr-select-space-filter layoutName '((0 . "ACAD_TABLE,TOLERANCE"))))
  (if (_skr-explode-ss ss5) (setq changed T))

  ;; druhý priechod na novo vzniknuté inserty
  (setq ss6 (_skr-select-space-filter layoutName '((0 . "INSERT"))))
  (if (_skr-explode-ss ss6) (setq changed T))

  ;; texty
  (setq ss7 (_skr-select-space-filter layoutName '((0 . "TEXT,MTEXT,ATTDEF,ATTRIB"))))
  (if (_skr-txtexp-ss ss7) (setq changed T))

  ;; posledný dočisťovací priechod
  (setq ss8 (_skr-select-space-filter layoutName '((0 . "INSERT,DIMENSION,MULTILEADER,LEADER"))))
  (if (_skr-explode-ss ss8) (setq changed T))

  changed
)

(defun _skr-process-all-spaces (/ lays pass)
  ;; model
  (repeat 4
    (_skr-process-space nil)
  )

  ;; layouts
  (setq lays (_skr-layout-names))
  (foreach lay lays
    (_skr-msg (strcat "Spracovávam layout: " lay))
    (repeat 4
      (_skr-process-space lay)
    )
  )
)

(defun _skr-purge-audit ()
  (_skr-safe-command (list "_.-purge" "_all" "*" "_n"))
  (_skr-safe-command (list "_.audit" "_y"))
  (_skr-safe-command (list "_.-purge" "_all" "*" "_n"))
)

(defun _skr-process-open-doc (doc outpath / oldfiledia oldcmdecho oldattreq oldexpert oldproxynotice)
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

  ;; pokus o odstránenie/konverziu AEC a proxy objektov
  (_skr-msg "Pokus o čistenie AEC/proxy objektov...")
  (_skr-clean-proxy-aec)

  ;; spracovanie modelu aj layoutov
  (_skr-process-all-spaces)

  ;; čistenie
  (_skr-purge-audit)

  ;; uloženie výstupu
  (vla-saveas doc outpath)

  (setvar "FILEDIA" oldfiledia)
  (setvar "CMDECHO" oldcmdecho)
  (setvar "ATTREQ" oldattreq)
  (setvar "EXPERT" oldexpert)
  (setvar "PROXYNOTICE" oldproxynotice)
)

(defun c:SKR_DWG_BURST_BATCH (/ files target app docs fullpath fn outpath doc)
  (vl-load-com)

  (if (not (_skr-warning-confirm))
    (progn
      (_skr-msg "Operácia bola zrušená používateľom.")
      (princ)
    )
    (progn
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
          (_skr-msg "Neboli vybrané žiadne DWG súbory.")
          (princ)
        )
        (progn
          (setq target (_skr-get-save-folder))

          (if (not target)
            (progn
              (_skr-msg "Nebola vybraná cieľová cesta.")
              (princ)
            )
            (progn
              (setq app  (vlax-get-acad-object))
              (setq docs (vla-get-Documents app))

              ;; načítanie Express Tools, ak sú dostupné
              (vl-catch-all-apply '(lambda () (load "express")))

              (foreach fullpath files
                (setq fn (vl-filename-base fullpath))
                (setq outpath (strcat target fn "_SKR.dwg"))

                (_skr-msg (strcat "----------------------------------------"))
                (_skr-msg (strcat "Spracovávam: " fullpath))

                (setq doc
                  (vl-catch-all-apply
                    'vla-open
                    (list docs fullpath)
                  )
                )

                (if (vl-catch-all-error-p doc)
                  (_skr-msg (strcat "Chyba pri otvorení súboru: " fullpath))
                  (progn
                    (_skr-process-open-doc doc outpath)
                    (vla-close doc)
                    (_skr-msg (strcat "Uložené ako: " outpath))
                  )
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