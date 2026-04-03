(vl-load-com)

(defun _be:get-files (msg filter / sh files item lst sa)
  (setq sh (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
  (setq files
    (vlax-invoke-method sh 'BrowseForFolder
      0
      msg
      0
    )
  )
  (vlax-release-object sh)

  (if files
    (progn
      (setq item (vlax-get-property files 'Self))
      (setq folder (vlax-get-property item 'Path))
      (if folder
        (mapcar
          '(lambda (f) (strcat folder "\\" f))
          (vl-directory-files folder "*.dwg" 1)
        )
      )
    )
  )
)

(defun _be:ss-all-layouts (/ ss1 ss2)
  (setq ss1 (ssget "_X" '((410 . "Model"))))
  (setq ss2 (ssget "_X"))
  (cond
    ((and ss1 ss2) ss2)
    (ss1 ss1)
    (ss2 ss2)
    (T nil)
  )
)

(defun _be:explode-selection (ss / i en before after loops)
  (if ss
    (progn
      (setq loops 0)
      (repeat 20
        (setq before (sslength ss))
        (command "_.EXPLODE" ss "")
        (setq ss (_be:ss-all-layouts))
        (setq after (if ss (sslength ss) 0))
        (setq loops (1+ loops))
        (if (<= after before)
          (setq loops 999)
        )
        (if (= loops 999)
          (progn
            (setq loops 20)
          )
        )
      )
    )
  )
)

(defun _be:explode-pass (/ ss)
  (setq ss (_be:ss-all-layouts))
  (if ss
    (progn
      (command "_.UNDO" "_BE")
      (_be:explode-selection ss)
      (command "_.UNDO" "_E")
    )
  )
)

(defun _be:process-dwg (f / docs doc err)
  (setq docs (vla-get-Documents (vlax-get-acad-object)))
  (setq err nil)

  (vl-catch-all-apply
    '(lambda ()
       (setq doc (vla-open docs f))
       (vla-activate doc)
       (setvar "FILEDIA" 0)
       (setvar "CMDDIA" 0)
       (setvar "NOMUTT" 1)

       (command "_.TILEMODE" 1)
       (_be:explode-pass)

       (command "_.TILEMODE" 0)
       (_be:explode-pass)

       (command "_.QSAVE")
       (vla-close doc)
     )
  )
)

(defun c:BATCH_EXPLODE_DWG (/ files f oldfiledia oldcmddia oldnomutt)
  (setq oldfiledia (getvar "FILEDIA"))
  (setq oldcmddia  (getvar "CMDDIA"))
  (setq oldnomutt  (getvar "NOMUTT"))

  (alert
    (strcat
      "UPOZORNENIE!\n\n"
      "Táto funkcia hromadne otvorí DWG súbory,\n"
      "pokúsi sa rozbiť objekty pomocou EXPLODE,\n"
      "následne výkresy uloží.\n\n"
      "Odporúča sa pracovať iba na kópiách súborov."
    )
  )

  (setq files (_be:get-files "Vyber priečinok s DWG súbormi" "*.dwg"))

  (if files
    (progn
      (foreach f files
        (_be:process-dwg f)
      )
      (alert "Hotovo. Dávkové spracovanie DWG súborov bolo dokončené.")
    )
    (alert "Neboli vybrané žiadne DWG súbory.")
  )

  (setvar "FILEDIA" oldfiledia)
  (setvar "CMDDIA" oldcmddia)
  (setvar "NOMUTT" oldnomutt)

  (princ)
)