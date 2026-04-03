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

(defun bx:quote (s)
  (strcat "\"" s "\"")
)

(defun bx:to-fwd (p)
  ;; zmení C:\cesta\k\suboru na C:/cesta/k/suboru – vhodné pre load aj script
  (vl-string-subst "/" "\\" p)
)

(defun bx:ask-continue ( / dcl-id res)
  (setq res nil)
  (setq dcl-id (load_dialog "bx_batch.dcl"))

  (if (and dcl-id (new_dialog "bx_confirm" dcl-id))
    (progn
      (set_tile "msg"
        "Skript otvorí a upraví viaceré DWG súbory.\n\
Odporúča sa pracovať na kópiách súborov."
      )
      (action_tile "ok" "(setq res T) (done_dialog)")
      (action_tile "cancel" "(setq res nil) (done_dialog)")
      (start_dialog)
      (unload_dialog dcl-id)
      res
    )
    (progn
      (if dcl-id (unload_dialog dcl-id))
      (alert "DCL súbor 'bx_batch.dcl' sa nepodarilo načítať.")
      nil
    )
  )
)

(defun c:BATCH_EXPLODE_DWG ( / folder files lspfile scrfile fh f oldcmdecho run
                               lsp-path-fwd scr-path-fwd)
  (setq oldcmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)

  ;; dialóg s tlačidlami Pokračovať / Zrušiť
  (setq run (bx:ask-continue))

  (if (not run)
    (alert "Proces bol zrušený.")
    (progn
      (setq folder  (bx:get-folder "Vyber priečinok s DWG súbormi"))
      (setq files   (bx:get-dwg-files folder))
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

         ;; pre LSP aj SCR si urobíme forward-slash verziu cesty
         (setq lsp-path-fwd (bx:to-fwd lspfile))
         (setq scr-path-fwd (bx:to-fwd scrfile))

         (setq fh (open scrfile "w"))

         (foreach f files
           ;; DWG cesta – môže ostať so spätnými lomkami, ale pre istotu ju tiež prekonvertujeme:
           (bx:write-line fh (strcat "_.OPEN " (bx:quote (bx:to-fwd f))))
           ;; LOAD worker LISP – plná cesta s forward slashe
           (bx:write-line
             fh
             (strcat
               "(load "
               (bx:quote lsp-path-fwd)
               ")"
             )
           )
           ;; spusti worker príkaz
           (bx:write-line fh "BX_PROCESS_CURRENT")
           (bx:write-line fh "_.QSAVE")
           (bx:write-line fh "_.CLOSE")
         )

         (close fh)

         (alert
           (strcat
             "Batch script bol vytvorený a teraz sa automaticky spustí:\n"
             scr-path-fwd
           )
         )

         ;; automatické spustenie SCR – používame forward slashe a ocitovanú cestu
         (command "_.SCRIPT" (bx:quote scr-path-fwd))
        )
      )
    )
  )

  (setvar "CMDECHO" oldcmdecho)
  (princ)
)