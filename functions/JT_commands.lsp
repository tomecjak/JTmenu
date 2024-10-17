;=========================================================================
; JT_commands.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Rozne prikazy pre ovladanie premennych v JTmenu
;-------------------------------------------------------------------------

(defun c:JT_BlockScaleVar()
  (setenv "GlobalnaBlocksScale" (getstring "Zadajte mierku pre vkladane bloky 1:"))
  (princ (strcat "Nastavena mierka je 1:" (getenv "GlobalnaBlocksScale") " pre vkladane bloky!"))
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nJT_commands.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;