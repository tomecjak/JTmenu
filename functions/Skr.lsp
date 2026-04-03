(vl-load-com)

(defun _bx:get-folder (msg / sh folder item path)
  (setq sh (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
  (setq folder (vlax-invoke-method sh 'BrowseForFolder 0 msg 0))
  (if folder
    (progn
      (setq item (vlax-get-property folder 'Self))
      (setq path (vlax-get-property item 'Path))
    )
  )
  (if sh (vlax-release-object sh))
  path
)

(defun _bx:get-dwg-files (folder / files)
  (if (and folder (vl-file-directory-p folder))
    (mapcar
      '(lambda (f) (strcat folder "\\" f))
      (vl-directory-files folder "*.dwg" 1)
    )
  )
)

(defun _bx:ss-by-filter (flt)
  (ssget "_X" flt)
)

(defun _bx:explode-ss (ss / n)
  (if ss
    (progn
      (setq n (sslength ss))
      (if (> n 0)
        (vl-cmdf "_.EXPLODE" ss "")
      )
    )
  )
)

(defun _bx:burst-textlike ( / ss )
  (setq ss (_bx:ss-by-filter '((0 . "INSERT"))))
  (if ss
    (_bx:explode-ss ss)
  )
)

(defun _bx:explode-dimensions ( / ss )
  (setq ss (_bx:ss-by-filter '((0 . "DIMENSION"))))
  (if ss
    (_bx:explode-ss ss)
  )
)

(defun _bx:explode-leaders ( / ss )
  (setq ss (_bx:ss-by-filter '((0 . "MULTILEADER,LEADER"))))
  (if ss
    (_bx:explode-ss ss)
  )
)

(defun _bx:explode-mtext ( / ss )
  (setq ss (_bx:ss-by-filter '((0 . "MTEXT"))))
  (if ss
    (_bx:explode-ss ss)
  )
)

(defun _bx:explode-tables ( / ss )
  (setq ss (_bx:ss-by-filter '((0 . "ACAD_TABLE"))))
  (if ss
    (_bx:explode-ss ss)
  )
)

(defun _bx:explode-nested-blocks ( / i ss )
  (setq i 0)
  (repeat 8
    (setq ss (_bx:ss-by-filter '((0 . "INSERT"))))
    (if ss
      (_bx:explode-ss ss)
    )
    (setq i (1+ i))
  )
)

(defun _bx:process-current-drawing ( / )
  (setvar "CMDECHO" 0)
  (setvar "NOMUTT" 1)

  (command "_.UNDO" "_BE")

  (_bx:explode-dimensions)
  (_bx:explode-leaders)
  (_bx:explode-mtext)
  (_bx:explode-tables)
  (_bx:burst-textlike)
  (_bx:explode-nested-blocks)

  (command "_.UNDO" "_E")
  (princ)
)

(defun _bx:save-doc (doc)
  (vl-catch-all-apply 'vla-save (list doc))
)

(defun _bx:close-doc (doc)
  (vl-catch-all-apply 'vla-close (list doc))
)

(defun _bx:process-file (filepath / acad docs doc err)
  (setq acad (vlax-get-acad-object))
  (setq docs (vla-get-documents acad))
  (setq err nil)

  (setq err
    (vl-catch-all-apply
      '(lambda ()
         (setq doc (vla-open docs filepath))
         (vla-activate doc)
         (_bx:process-current-drawing)
         (_bx:save-doc doc)
         (_bx:close-doc doc)
       )
    )
  )

  (if (vl-catch-all-error-p err)
    (prompt (strcat "\nChyba pri DWG: " filepath))
    (prompt (strcat "\nSpracované a uložené: " filepath))
  )
)

(defun c:BATCH_EXPLODE_DWG ( / ans folder files oldfiledia oldcmddia oldnomutt)
  (setq oldfiledia (getvar "FILEDIA"))
  (setq oldcmddia  (getvar "CMDDIA"))
  (setq oldnomutt  (getvar "NOMUTT"))

  (setvar "FILEDIA" 0)
  (setvar "CMDDIA" 0)
  (setvar "NOMUTT" 1)

  (alert
    (strcat
      "UPOZORNENIE!\n\n"
      "Skript otvorí viac DWG súborov,\n"
      "pokúsi sa rozbiť bloky, kóty, popisky,\n"
      "textové a podobné objekty,\n"
      "potom súbory uloží.\n\n"
      "Odporúča sa pracovať na kópiách."
    )
  )

  (initget "Pokracovat Zrusit")
  (setq ans (getkword "\nChceš pokračovať? [Pokracovat/Zrusit] <Zrusit>: "))

  (if (or (null ans) (= ans "Zrusit"))
    (progn
      (alert "Proces bol zrušený.")
    )
    (progn
      (setq folder (_bx:get-folder "Vyber priečinok s DWG súbormi"))
      (setq files (_bx:get-dwg-files folder))

      (if files
        (foreach f files
          (_bx:process-file f)
        )
        (alert "V zvolenom priečinku nebol nájdený žiadny DWG súbor.")
      )
    )
  )

  (setvar "FILEDIA" oldfiledia)
  (setvar "CMDDIA" oldcmddia)
  (setvar "NOMUTT" oldnomutt)

  (princ)
)