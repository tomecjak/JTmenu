(vl-load-com)

(defun bx:get-folder (msg / sh folder item path)
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

(defun bx:get-dwg-files (folder)
  (if (and folder (vl-file-directory-p folder))
    (mapcar
      '(lambda (f) (strcat folder "\\" f))
      (vl-directory-files folder "*.dwg" 1)
    )
  )
)

(defun bx:write-line (fh s)
  (write-line s fh)
)

(defun bx:esc-path (s)
  (vl-string-subst "\\\\" "\\" s)
)

(defun c:BATCH_EXPLODE_DWG ( / ans folder files lspfile scrfile fh f oldcmdecho)
  (setq oldcmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)

  (alert
    (strcat
      "UPOZORNENIE!\n\n"
      "Bude vytvorený a automaticky spustený SCR batch,\n"
      "ktorý otvorí každý DWG, spustí LISP príkaz,\n"
      "uloží výkres a zavrie ho.\n\n"
      "Odporúča sa pracovať na kópiách."
    )
  )

  (initget "Pokracovat Zrusit")
  (setq ans (getkword "\nChceš pokračovať? [Pokracovat/Zrusit] <Zrusit>: "))

  (if (or (null ans) (= ans "Zrusit"))
    (alert "Proces bol zrušený.")
    (progn
      (setq folder (bx:get-folder "Vyber priečinok s DWG súbormi"))
      (setq files (bx:get-dwg-files folder))
      (setq lspfile (findfile "BX_WORKER.lsp"))

      (cond
        ((null folder)
          (alert "Nebol vybraný priečinok.")
        )
        ((null files)
          (alert "V zvolenom priečinku nebol nájdený žiadny DWG súbor.")
        )
        ((null lspfile)
          (alert "Súbor BX_WORKER.lsp nebol nájdený v support path.")
        )
        (T
          (setq scrfile (strcat folder "\\BX_BATCH.scr"))
          (setq fh (open scrfile "w"))

          (foreach f files
            (bx:write-line fh (strcat "_.OPEN \"" (bx:esc-path f) "\""))
            (bx:write-line fh (strcat "(load \"" (bx:esc-path lspfile) "\")"))
            (bx:write-line fh "BX_PROCESS_CURRENT")
            (bx:write-line fh "_.QSAVE")
            (bx:write-line fh "_.CLOSE")
          )

          (close fh)

          (alert
            (strcat
              "Batch script bol vytvorený a teraz sa automaticky spustí:\n"
              scrfile
            )
          )

          (command "_.SCRIPT" scrfile)
        )
      )
    )
  )

  (setvar "CMDECHO" oldcmdecho)
  (princ)
)