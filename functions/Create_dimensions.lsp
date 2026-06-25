;=========================================================================
; Create_dimensions.lsp
; Create by Jakub Tomecko
;
; Vytvorenie stylu kot
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                   Orchestrator vytvorenia kot                        ;;
;;----------------------------------------------------------------------;;

(defun c:JTCreateDimensions()
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;vytvorenie kot podla JTmenu
    (JTCreateDimensionsStyle)
    ;vytvorenie kot podla DPPtools
    (DPPCreateDimensionsStyle)
  )
  
)

;;----------------------------------------------------------------------;;
;;            Vytvorenie jednotlivych stylov kot podla JTmenu           ;;
;;----------------------------------------------------------------------;;

(defun JTCreateDimensionsStyle()
  
  ;vytvorenie textoveho stylu DP_ISOCPEUR
  (TextStyleCreator)
  
  ;vytvorenie listu nasobicov pre vytvorenie kot
  (setq listNasobic (list 0.02 0.04 0.1 0.2 0.4 0.5 1 2 4 5 10 20 40))

  ;vyhodnotenie pouzitia stylu kot podla modu
  (if (= (getenv "GlobalnaKotyDIMSCALEset") "Klasicky")
      (KotyKlasickyMod)
    (if (= (getenv "GlobalnaKotyDIMSCALEset") "Mierka")
        (KotyMierkaMod)
      (if (= (getenv "GlobalnaKotyDIMSCALEset") "Annotation")
          (KotyAnnotationMod)
      )
    )
  )
  
  (princ "\nStyly kot boli vytvorene!")
  (princ)
)

;;----------------------------------------------------------------------;;
;;                Vytvorenie kot pre klasicky styl                      ;;
;;----------------------------------------------------------------------;;

(defun KotyKlasickyMod ()
  
  ;nastavenie premennej DIMSCALE
  (setvar "DIMSCALE" 1.0)
  
  ;vytvrenie premenej VyberStylKoty
  (setq VyberStylKoty
    (getstring "\nAku typ dlzky vynasacej ciary vytvorit? [Vlastna/Pevna] <Vlastna>: ")
  )
  
  ;vyhodnotenie VyberStylKoty
  (if (or (= VyberStylKoty "") (= VyberStylKoty "V") (= VyberStylKoty "v"))
    (KotyVlastne)
  
    (if (or (= VyberStylKoty "P") (= VyberStylKoty "p"))
      (KotyPevne)
      
      (princ "\nNeplatny vyber.")
    )
  )
  
  ;nastavenie predvybratoho kotovacieho stylu
  (command "dimstyle" "r" "DP_Kota [50]")
  (princ)
)

;;----------------------------------------------------------------------;;
;;                Vytvorenie kot pre mierku DIMSCALE                    ;;
;;----------------------------------------------------------------------;;

(defun KotyMierkaMod ()
  
  ;vytvrenie premenej VyberStylKoty
  (setq VyberStylKoty
    (getstring "\nAku typ dlzky vynasacej ciary vytvorit? [Vlastna/Pevna] <Vlastna>: ")
  )
  
  ;vyhodnotenie VyberStylKoty
  (if (or (= VyberStylKoty "") (= VyberStylKoty "V") (= VyberStylKoty "v"))
    (KotyVlastneMierka)
  
    (if (or (= VyberStylKoty "P") (= VyberStylKoty "p"))
      (KotyPevneMierka)
    )
  )

  ;nastavenie predvybratoho kotovacieho stylu
  (command "dimstyle" "r" "DP_Kota")
  (princ)
)
  
;;----------------------------------------------------------------------;;
;;                    Vytvorenie kot pre Annotation                     ;;
;;----------------------------------------------------------------------;;

(defun KotyAnnotationMod ()
  
  ;vytvrenie premenej VyberStylKoty
  (setq VyberStylKoty
    (getstring "\nAku typ dlzky vynasacej ciary vytvorit? [Vlastna/Pevna] <Vlastna>: ")
  )
  
  ;vyhodnotenie VyberStylKoty
  (if (or (= VyberStylKoty "") (= VyberStylKoty "V") (= VyberStylKoty "v"))
    (KotyVlastneAnnotation)
  
    (if (or (= VyberStylKoty "P") (= VyberStylKoty "p"))
      (KotyPevneAnnotation)
    )
  )

  ;nastavenie predvybratoho kotovacieho stylu
  (command "dimstyle" "r" "DP_Kota")
  (princ)
)

;;----------------------------------------------------------------------;;
;;                         Koty - vlastna dlzka                         ;;
;;----------------------------------------------------------------------;;

(defun KotyVlastne()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm, prepinacAnnotative = 0->NO 1->YES
  (foreach i listNasobic
    (DimensionCreator i 0 1000 0)
    (command "dimstyle" "s" (strcat "DP_Kota " mierkaZatvorka jednotkaKoty) "y")
  )
  
  (foreach i listNasobic
    (DimensionCreator i 0 1 0)
    (command "dimstyle" "s" (strcat "DP_Kota " mierkaZatvorka jednotkaKoty) "y")
  )
  
)

;;----------------------------------------------------------------------;;
;;                          Koty - pevna dlzka                          ;;
;;----------------------------------------------------------------------;;

(defun KotyPevne()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm, prepinacAnnotative = 0->NO 1->YES 
  (foreach i listNasobic
    (DimensionCreator i 1 1000 0)
    (command "dimstyle" "s" (strcat "DP_Kota " mierkaZatvorka jednotkaKoty) "y")
  )
  
  (foreach i listNasobic
    (DimensionCreator i 1 1 0)
    (command "dimstyle" "s" (strcat "DP_Kota " mierkaZatvorka jednotkaKoty) "y")
  )
  
)

;;----------------------------------------------------------------------;;
;;                     Koty - vlastna dlzka - mierka                    ;;
;;----------------------------------------------------------------------;;

(defun KotyVlastneMierka()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm, prepinacAnnotative = 0->NO 1->YES
  (DimensionCreator 20 0 1000 0)
  (DimensionCreator 20 0 1 0)
  
  (command "dimstyle" "s" (strcat "DP_Kota " mierkaZatvorka jednotkaKoty) "y")

)

;;----------------------------------------------------------------------;;
;;                      Koty - pevna dlzka - mierka                     ;;
;;----------------------------------------------------------------------;;

(defun KotyPevneMierka()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm, prepinacAnnotative = 0->NO 1->YES
  (DimensionCreator 20 1 1000 0)
  (DimensionCreator 20 1 1 0)
  
  (command "dimstyle" "s" (strcat "DP_Kota " mierkaZatvorka jednotkaKoty) "y")

)

;;----------------------------------------------------------------------;;
;;                     Koty - vlastna dlzka - annotation                 ;;
;;----------------------------------------------------------------------;;

(defun KotyVlastneAnnotation()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm, prepinacAnnotative = 0->NO 1->YES
  (DimensionCreator 20 0 1000 1)
  (DimensionCreator 20 0 1 1)
  
  (command "dimstyle" "_Annotative" "y" (strcat "DP_Kota") "s" (strcat "DP_Kota " jednotkaKoty))

)

;;----------------------------------------------------------------------;;
;;                      Koty - pevna dlzka - annotation                    ;;
;;----------------------------------------------------------------------;;

(defun KotyPevneAnnotation()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm, prepinacAnnotative = 0->NO 1->YES
  (DimensionCreator 20 1 1000 1)
  (DimensionCreator 20 1 1 1)
  
  (command "dimstyle" "_Annotative" "y" (strcat "DP_Kota") "s" (strcat "DP_Kota " jednotkaKoty))
  (command "_.dimstyle" "_R" "DP_Kota")       ;nastavit DP_Kota ako current
  (setvar "DIMLFAC" 1000.0)                   ;scale Factor = 1000
  (command "_.dimstyle" "_S" "DP_Kota" "y")   ;ulozit zmeny do stylu

)

;;----------------------------------------------------------------------;;
;;                      Nastavenie parametrov koty                      ;;
;;----------------------------------------------------------------------;;

(defun DimensionCreator (nasobicMierky prepinacDlzkyCiary prepinacJednotiek prepinacAnnotative)

  (SetDimensionParametres)
  
  ;set tab Lines
  (setvar "DIMEXE" (* 0.05 nasobicMierky))
  (setvar "DIMFXLON" prepinacDlzkyCiary)
  (setvar "DIMFXL" (* 0.250 nasobicMierky))
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" (* 0.07 nasobicMierky))

  ;set tab Text
  (setvar "DIMTXT" (* 0.125 nasobicMierky))
  (setvar "DIMGAP" (* 0.045 nasobicMierky))
  
  ;set tab Primary Units
  (setvar "DIMLFAC" prepinacJednotiek)
  
  ;nastavenie jednotky v nazve koty
  (if (= prepinacJednotiek 1000)
    (setq jednotkaKoty "")
    (setq jednotkaKoty "meter")
  )
  
  ;nastavenie zatvoriek v nazve koty
  (if (= (getenv "GlobalnaKotyDIMSCALEset") "Klasicky")
    (setq mierkaZatvorka (strcat "[" (rtos (* 50 nasobicMierky) 2 0) "] "))
    (setq mierkaZatvorka " ")
  )

)

;;----------------------------------------------------------------------;;
;;                 Pevne nastavenia pre vsetky koty                     ;;
;;----------------------------------------------------------------------;;

(defun SetDimensionParametres ()
         
  ;set tab Lines
  (setvar "DIMDLI" 0.38)
  (setvar "DIMCLRD" 0)
  (setvar "DIMLTYPE" "BYBLOCK")
  (setvar "DIMLWD" -2)
  (setvar "DIMDLE" 0)
  (setvar "DIMCLRE" 0)
  (setvar "DIMLTEX1" "BYBLOCK")
  (setvar "DIMLTEX2" "BYBLOCK")
  (setvar "DIMLWE" -2)
  (setvar "DIMEXO" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMBLK" "_OBLIQUE")
  (setvar "DIMARCSYM" 0)
  
  ;set tab Text
  (setvar "DIMTXSTY" "DP_ISOCPEUR")
  (setvar "DIMCLRT" 0)
  (setvar "DIMTFILL" 0)
  (setvar "DIMTAD" 1)
  (setvar "DIMTIH" 0)
  (setvar "DIMTOH" 0)
  (setvar "DIMJUST" 0)
  (setvar "DIMTXTDIRECTION" 0)
  
  ;set tab Fit
  (setvar "DIMATFIT" 3)
  (setvar "DIMTMOVE" 1)
  (setvar "DIMUPT" 0)
  (setvar "DIMTOFL" 1)
  
  ;set tab Primary Units
  (setvar "DIMLUNIT" 2)
  (setvar "DIMDSEP" ".")
  (setvar "DIMRND" 0)
  (setvar "DIMAUNIT" 0)
  (setvar "DIMADEC" 0)
  (setvar "DIMDEC" 0)
)

;;----------------------------------------------------------------------;;
;;              Vytvorenie textoveho stylu DP_ISOCPEUR                  ;;
;;----------------------------------------------------------------------;;

(defun TextStyleCreator ()
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
)

;;----------------------------------------------------------------------;;
;;           Vytvorenie jednotlivych stylov kot podla DPPtools          ;;
;;----------------------------------------------------------------------;;

(defun DPPCreateDimensionsStyle()
  
  ;vytvorenie textoveho stylu DPP_Text 2.0
  (TextStyleCreatorDPP)
  
  (KotyDPPAnnotationMod)
  
  (princ "\nStyly kot boli vytvorene!")
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                  Koty DPP - pevna dlzka - annotation                 ;;
;;----------------------------------------------------------------------;;

(defun KotyDPPAnnotationMod()

  ;parametre prepinac
  (DimensionDPPCreator 1 1000 1)
  (DimensionDPPCreator 1 1 1)
  
  (command "dimstyle" "_Annotative" "y" (strcat "DPP_Kota mm") "s" (strcat "DPP_Kota " jednotkaKoty))
  (command "_.dimstyle" "_R" "DPP_Kota mm")      ;nastavit DPP_Kota mm ako current
  (setvar "DIMLFAC" 1000.0)
(setvar "DIMDEC" 0)  ;scale Factor = 1000
  (command "_.dimstyle" "_S" "DPP_Kota mm" "y")  ;ulozit zmeny do stylu
  
  (command "_.dimstyle" "_R" "DPP_Kota m")      ;nastavit DPP_Kota mm ako current
(setvar "DIMDEC" 2)  ;scale Factor = 1000
  (command "_.dimstyle" "_S" "DPP_Kota m" "y")  ;ulozit zmeny do stylu

)

;;----------------------------------------------------------------------;;
;;                   Nastavenie parametrov DPP koty                     ;;
;;----------------------------------------------------------------------;;

(defun DimensionDPPCreator (prepinacDlzkyCiary prepinacJednotiek prepinacAnnotative)

  (SetDPPDimensionParametres)
  
  ;set tab Lines
  (setvar "DIMEXE" 1)
  (setvar "DIMFXLON" prepinacDlzkyCiary)
  (setvar "DIMFXL" 4.5)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 1.4)

  ;set tab Text
  (setvar "DIMTXT" 1)
  (setvar "DIMGAP" 0.9)
  
  ;set tab Primary Units
  (setvar "DIMLFAC" prepinacJednotiek)
  
  ;nastavenie jednotky v nazve koty
  (if (= prepinacJednotiek 1000)
    (setq jednotkaKoty "mm")
    (setq jednotkaKoty "m")
  )
  
)

;;----------------------------------------------------------------------;;
;;               Pevne nastavenia pre vsetky DPP koty                   ;;
;;----------------------------------------------------------------------;;

(defun SetDPPDimensionParametres ()
         
  ;set tab Lines
  (setvar "DIMDLI" 3.8)
  (setvar "DIMCLRD" 0)
  (setvar "DIMLTYPE" "BYBLOCK")
  (setvar "DIMLWD" -2)
  (setvar "DIMDLE" 0)
  (setvar "DIMCLRE" 0)
  (setvar "DIMLTEX1" "BYBLOCK")
  (setvar "DIMLTEX2" "BYBLOCK")
  (setvar "DIMLWE" -2)
  (setvar "DIMEXO" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMBLK" "_OBLIQUE")
  (setvar "DIMARCSYM" 0)
  
  ;set tab Text
  (setvar "DIMTXSTY" "DPP_Text 2.0")
  (setvar "DIMCLRT" 0)
  (setvar "DIMTFILL" 0)
  (setvar "DIMTAD" 1)
  (setvar "DIMTIH" 0)
  (setvar "DIMTOH" 0)
  (setvar "DIMJUST" 0)
  (setvar "DIMTXTDIRECTION" 0)
  
  ;set tab Fit
  (setvar "DIMATFIT" 3)
  (setvar "DIMTMOVE" 1)
  (setvar "DIMUPT" 0)
  (setvar "DIMTOFL" 1)
  
  ;set tab Primary Units
  (setvar "DIMLUNIT" 2)
  (setvar "DIMDSEP" ".")
  (setvar "DIMAUNIT" 2)
  (setvar "DIMRND" 0)
  (setvar "DIMADEC" 0)
)

;;----------------------------------------------------------------------;;
;;              Vytvorenie textoveho stylu DPP_Text 2.0                 ;;
;;----------------------------------------------------------------------;;

(defun TextStyleCreatorDPP()

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

)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nCreate_dimensions.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;