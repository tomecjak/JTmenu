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
          (2 . "DP_ISOCPEUR")   ;nazov stylu textu
          (70 . 0)              ;standard flag values (bit-coded values) 
          (40 . 0.0)            ;vyska textu
          (41 . 1.0)            ;sirka textu
          (50 . 0.0)            ;uhol natočenia textu
          (71 . 0)              ;generovanie textu "0" normalny text
          (42 . 2.0)            ;posledna vyska textu
          (3 . "isocpeur.ttf")  ;nazov fontu
          (4 . "")              ;bigfont (prazde pre "no")
        )
      )
      ;prednastavenie textoveho stylu DP_ISOCPEUR
      (setvar "textstyle" "DP_ISOCPEUR")
    )
    ;vytvorenie stylu textu DPP_Text
    (progn
      ;DPP_Text 2.0
      (entmake
        (list
          '(0 . "STYLE")
          '(-3
            ("AcadAnnotative"
              (1000 . "AnnotativeData")
              (1002 . "{")
              (1070 . 1)
              (1070 . 1)
              (1002 . "}")
            )
          )
          
          '(100 . "AcDbSymbolTableRecord")
          '(100 . "AcDbTextStyleTableRecord")
          '(2 . "DPP_Text 2.0")   ;nazov stylu textu
          '(70 . 0)               ;standard flag values (bit-coded values)
          '(40 . 2.0)             ;vyska textu
          '(41 . 1.0)             ;sirka textu
          '(50 . 0.0)             ;uhol natočenia textu
          '(71 . 0)               ;generovanie textu "0" normalny text
          '(42 . 0)               ;posledna vyska textu
          '(3 . "isocpeur.ttf")   ;nazov fontu
          '(4 . "")               ;bigfont (prazde pre "no")
        )                        
      )                           
      ;DPP_Text 3.5
      (entmake
        (list
          '(0 . "STYLE")
          '(-3
            ("AcadAnnotative"
              (1000 . "AnnotativeData")
              (1002 . "{")
              (1070 . 1)
              (1070 . 1)
              (1002 . "}")
            )
          )
          
          '(100 . "AcDbSymbolTableRecord")
          '(100 . "AcDbTextStyleTableRecord")
          '(2 . "DPP_Text 3.5")   ;nazov stylu textu
          '(70 . 0)               ;standard flag values (bit-coded values)
          '(40 . 3.5)             ;vyska textu
          '(41 . 1.0)             ;sirka textu
          '(50 . 0.0)             ;uhol natočenia textu
          '(71 . 0)               ;generovanie textu "0" normalny text
          '(42 . 0)               ;posledna vyska textu
          '(3 . "isocpeur.ttf")   ;nazov fontu
          '(4 . "")               ;bigfont (prazde pre "no")
        )                        
      ) 
      ;DPP_Text 5.0
      (entmake
        (list
          '(0 . "STYLE")
          '(-3
            ("AcadAnnotative"
              (1000 . "AnnotativeData")
              (1002 . "{")
              (1070 . 1)
              (1070 . 1)
              (1002 . "}")
            )
          )
          
          '(100 . "AcDbSymbolTableRecord")
          '(100 . "AcDbTextStyleTableRecord")
          '(2 . "DPP_Text 5.0")   ;nazov stylu textu
          '(70 . 0)               ;standard flag values (bit-coded values)
          '(40 . 5.0)             ;vyska textu
          '(41 . 1.0)             ;sirka textu
          '(50 . 0.0)             ;uhol natočenia textu
          '(71 . 0)               ;generovanie textu "0" normalny text
          '(42 . 0)               ;posledna vyska textu
          '(3 . "isocpeur.ttf")   ;nazov fontu
          '(4 . "")               ;bigfont (prazde pre "no")
        )                        
      ) 
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