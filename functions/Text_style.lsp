;=========================================================================
; Text_style.lsp
; Create by Jakub Tomecko
;
; Vytvorenie stylu textu
;-------------------------------------------------------------------------

(defun c:JTTextStyle ()
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;vytvorenie stylu textu DP_ISOCPEUR
    (progn
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
    )
    ;vytvorenie stylu textu DPP_Text
    (progn
      ;DPP_Text 2.0
      (entmakex
        '(
          (0 . "STYLE")
          (100 . "AcDbSymbolTableRecord")
          (100 . "AcDbTextStyleTableRecord")
          (2 . "DP_ISOCPEUR-test")
          (70 . 0)
          (40 . 2.0);<- definovanie vysky textu
          (41 . 1.0)
          (50 . 0.0)
          (71 . 0)
          (42 . 2.0)
          (3 . "isocpeur.ttf")
          (4 . "")
        )
      )
      ;DPP_Text 3.5
      ;DPP_Text 5.0
    )
  )
  
  (princ "\nStyl textu bol vytvoreny!")
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
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