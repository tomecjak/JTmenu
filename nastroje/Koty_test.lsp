;=========================================================================
; Koty.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Vytvorenie stylu kot
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                Vytvorenie jednotlivych stylov kot                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTKoty_test()
  
  ;vytvorenie textoveho stylu DP_ISOCPEUR
  (TextStyleCreator)
  
  ;vytvorenie listu nasobicov pre vytvorenie kot
  (setq listNasobic (list 1 2 4))

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
  (cond ((or (= VyberStylKoty "P") (= VyberStylKoty "p")
    (KotyVlastne)
  )

    ((or (= VyberStylKoty "V") (= VyberStylKoty "v")
        (KotyPevne)
      )
    )
    )
  )
  
  (command "dimstyle" "r" "DP_Koty [050]")
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
  (cond ((or (= VyberStylKoty "V") (= VyberStylKoty "v")
    (KotyVlastneMierka)
  )

    ((or (= VyberStylKoty "P") (= VyberStylKoty "p")
        (KotyPevneMierka)
      )
    )
    )
  )
  
  (command "dimstyle" "r" "DP_Kota")
)

;;----------------------------------------------------------------------;;
;;                         Koty - vlastna dlzka                         ;;
;;----------------------------------------------------------------------;;

(defun KotyVlastne()

  ;parametre nasobicMierky = z 50, prepinacDlzkyCiary = 0->OFF 1->ON, prepinacJednotiek = 1->mm 1000->m  
  (foreach i listNasobic
    (Kota_50_milimetre i 0 1)
  )

)

;;----------------------------------------------------------------------;;
;;                          Koty - pevna dlzka                          ;;
;;----------------------------------------------------------------------;;


;;----------------------------------------------------------------------;;
;;                     Koty - vlastna dlzka - mierka                    ;;
;;----------------------------------------------------------------------;;


;;----------------------------------------------------------------------;;
;;                      Koty - pevna dlzka - mierka                     ;;
;;----------------------------------------------------------------------;;


;;----------------------------------------------------------------------;;
;;                         Koty 1:50 - milimetre                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_50_milimetre (nasobicMierky prepinacDlzkyCiary prepinacJednotiek)

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" (* 0.05 nasobicMierky))
  (setvar "DIMFXLON" prepinacDlzkyCiary)
  (setvar "DIMFXL" 0.250)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.07)
  
  ;set tab Text
  (setvar "DIMTXT" 0.125)
  (setvar "DIMGAP" 0.045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" (strcat "DP_Koty [" (rtos (* 50 nasobicMierky) 2 0) "]"))
  
)

;;----------------------------------------------------------------------;;
;;                 Pevne nastavenia pre vsetky koty                     ;;
;;----------------------------------------------------------------------;;

(defun DimensionCreator ()
       
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
  (setvar "DIMBLK1" "Oblique")
  (setvar "DIMBLK1" "Oblique")
  (setvar "DIMLDRBLK" "Oblique")
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