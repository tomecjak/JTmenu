;=========================================================================
; Text_style.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Vytvorenie stylu textu
;-------------------------------------------------------------------------

(defun c:JTTextStyle ()
  (entmakex
  '(
    (0 . "STYLE")
    (100 . "AcDbSymbolTableRecord")
    (100 . "AcDbTextStyleTableRecord")
    (2 . "DP_ISOCPEUR")
    (70 . 0)
    (40 . 0.0);<- definovanie vysky textu
    (41 . 1.0)
    (50 . 0.0)
    (71 . 0)
    (42 . 2.0)
    (3 . "isocpeur.ttf")
    (4 . "")
  )
  )
  
  ;prednastavenie textoveho stylu DP_ISOCPEUR
  (setvar "textstyle" "DP_ISOCPEUR")
  
  (princ "\nStyl textu bol vytvoreny!")
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nText_style.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;