;=========================================================================
; Koty.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Vytvorenie stylu kot
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                Vytvorenie jednotlivych stylov kot                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTKoty()
  
  ;vytvorenie textoveho stylu DP_ISOCPEUR
  (TextStyleCreator)
  
  ;vytvorenie listu nasobicov pre vytvorenie kot
  (setq listNasobic (list 0.02 0.04 0.1 0.2 0.4 0.5 1 2 4 5 10 20 40))

  ;vyhodnotenie pouzitia stylu kot podla modu
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (KotyKlasickyMod)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (KotyMierkaMod)
    )
  )
  
  (princ "\nStyly kot boli vytvorene!")
  (princ)
)

;;----------------------------------------------------------------------;;
;;                Vytvorenie kot pre klasicky styl                      ;;
;;----------------------------------------------------------------------;;

(defun KotyKlasickyMod ()
  
  ;vytvrenie premenej VyberStylKoty
  (setq VyberStylKoty
    (getstring "\nAku typ dlzky vynasacej ciary vytvorit? [Vlastna/Pevna] <Vlastna>: ")
  )
  
  ;vyhodnotenie VyberStylKoty
  (if (or (= VyberStylKoty "") (= VyberStylKoty "V") (= VyberStylKoty "v"))
    (KotyVlastne)
  
    (if (or (= VyberStylKoty "P") (= VyberStylKoty "p"))
    (KotyPevne)
    )
  )
  
  ;nastavenie predvybratoho kotovacieho stylu
  (command "dimstyle" "r" "DP_Kota [50]")
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
)

;;----------------------------------------------------------------------;;
;;                         Koty - vlastna dlzka                         ;;
;;----------------------------------------------------------------------;;

(defun KotyVlastne()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm  
  (foreach i listNasobic
    (DimensionCreator i 0 1000)
  )
  
  (foreach i listNasobic
    (DimensionCreator i 0 1)
  )
  
)

;;----------------------------------------------------------------------;;
;;                          Koty - pevna dlzka                          ;;
;;----------------------------------------------------------------------;;

(defun KotyPevne()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm  
  (foreach i listNasobic
    (DimensionCreator i 1 1000)
  )
  
  (foreach i listNasobic
    (DimensionCreator i 1 1)
  )
  
)

;;----------------------------------------------------------------------;;
;;                     Koty - vlastna dlzka - mierka                    ;;
;;----------------------------------------------------------------------;;

(defun KotyVlastneMierka()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm  
  (DimensionCreator 20 0 1000)
  (DimensionCreator 20 0 1)

)

;;----------------------------------------------------------------------;;
;;                      Koty - pevna dlzka - mierka                     ;;
;;----------------------------------------------------------------------;;

(defun KotyPevneMierka()

  ;parametre prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->m 1000->mm  
  (DimensionCreator 20 1 1000)
  (DimensionCreator 20 1 1)

)

;;----------------------------------------------------------------------;;
;;                      Nastavenie parametrov koty                      ;;
;;----------------------------------------------------------------------;;

(defun DimensionCreator (nasobicMierky prepinacDlzkyCiary prepinacJednotiek)

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
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
    (setq mierkaZatvorka (strcat "[" (rtos (* 50 nasobicMierky) 2 0) "] "))
    (setq mierkaZatvorka " ")
  )

  (command "dimstyle" "s" (strcat "DP_Kota " mierkaZatvorka jednotkaKoty))
  
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

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nKoty.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;