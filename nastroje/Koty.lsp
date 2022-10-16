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
  (Kota_1_milimetre)
  (Kota_2_milimetre)
  (Kota_5_milimetre)
  (Kota_10_milimetre)
  (Kota_20_milimetre)
  (Kota_25_milimetre)
  (Kota_50_milimetre)
  (Kota_100_milimetre)
  (Kota_200_milimetre)
  (Kota_250_milimetre)
  (Kota_500_milimetre)
  (Kota_1_meter)
  (Kota_2_meter)
  (Kota_5_meter)
  (Kota_10_meter)
  (Kota_20_meter)
  (Kota_25_meter)
  (Kota_50_meter)
  (Kota_100_meter)
  (Kota_200_meter)
  (Kota_250_meter)
  (Kota_500_meter)
)

;;----------------------------------------------------------------------;;
;;                          Koty - pevna dlzka                          ;;
;;----------------------------------------------------------------------;;

(defun KotyPevne()
  (Kota_1_milimetre_pevna)
  (Kota_2_milimetre_pevna)
  (Kota_5_milimetre_pevna)
  (Kota_10_milimetre_pevna)
  (Kota_20_milimetre_pevna)
  (Kota_25_milimetre_pevna)
  (Kota_50_milimetre_pevna)
  (Kota_100_milimetre_pevna)
  (Kota_200_milimetre_pevna)
  (Kota_250_milimetre_pevna)
  (Kota_500_milimetre_pevna)
  (Kota_1_meter_pevna)
  (Kota_2_meter_pevna)
  (Kota_5_meter_pevna)
  (Kota_10_meter_pevna)
  (Kota_20_meter_pevna)
  (Kota_25_meter_pevna)
  (Kota_50_meter_pevna)
  (Kota_100_meter_pevna)
  (Kota_200_meter_pevna)
  (Kota_250_meter_pevna)
  (Kota_500_meter_pevna)
)

;;----------------------------------------------------------------------;;
;;                     Koty - vlastna dlzka - mierka                    ;;
;;----------------------------------------------------------------------;;

(defun KotyVlastneMierka()
  (Kota_mierka_milimetre)
  (Kota_mierka_meter)
)

;;----------------------------------------------------------------------;;
;;                      Koty - pevna dlzka - mierka                     ;;
;;----------------------------------------------------------------------;;

(defun KotyPevnaMierka()
  (Kota_mierka_milimetre_pevna)
  (Kota_mierka_meter_pevna)
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:1 - milimetre                         ;;
;;----------------------------------------------------------------------;;

(defun Kota_1_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.001)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.0014)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0025)
  (setvar "DIMGAP" 0.0009)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [001]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:2 - milimetre                         ;;
;;----------------------------------------------------------------------;;

(defun Kota_2_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.002)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.0028)
  
  ;set tab Text
  (setvar "DIMTXT" 0.005)
  (setvar "DIMGAP" 0.0018)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [002]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:5 - milimetre                         ;;
;;----------------------------------------------------------------------;;

(defun Kota_5_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.005)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.007)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0125)
  (setvar "DIMGAP" 0.0045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [005]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:10 - milimetre                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_10_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.01)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.014)
  
  ;set tab Text
  (setvar "DIMTXT" 0.025)
  (setvar "DIMGAP" 0.009)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [010]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:20 - milimetre                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_20_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.02)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.028)
  
  ;set tab Text
  (setvar "DIMTXT" 0.05)
  (setvar "DIMGAP" 0.018)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [020]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:25 - milimetre                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_25_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.025)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.035)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0625)
  (setvar "DIMGAP" 0.0225)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [025]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:50 - milimetre                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_50_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.05)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.07)
  
  ;set tab Text
  (setvar "DIMTXT" 0.125)
  (setvar "DIMGAP" 0.045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [050]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:100 - milimetre                       ;;
;;----------------------------------------------------------------------;;

(defun Kota_100_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.1)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.14)
  
  ;set tab Text
  (setvar "DIMTXT" 0.250)
  (setvar "DIMGAP" 0.090)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [100]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:200 - milimetre                       ;;
;;----------------------------------------------------------------------;;

(defun Kota_200_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.2)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.25)
  
  ;set tab Text
  (setvar "DIMTXT" 0.500)
  (setvar "DIMGAP" 0.180)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [200]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:250 - milimetre                       ;;
;;----------------------------------------------------------------------;;

(defun Kota_250_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.25)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.35)
  
  ;set tab Text
  (setvar "DIMTXT" 0.625)
  (setvar "DIMGAP" 0.225)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [250]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:500 - milimetre                       ;;
;;----------------------------------------------------------------------;;

(defun Kota_500_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.5)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.70)
  
  ;set tab Text
  (setvar "DIMTXT" 1.250)
  (setvar "DIMGAP" 0.450)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [500]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:1 - milimetre - pevne                     ;;
;;----------------------------------------------------------------------;;

(defun Kota_1_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.001)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.005)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.0014)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0025)
  (setvar "DIMGAP" 0.0009)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [001]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:2 - milimetre - pevne                     ;;
;;----------------------------------------------------------------------;;

(defun Kota_2_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.002)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.010)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.0028)
  
  ;set tab Text
  (setvar "DIMTXT" 0.005)
  (setvar "DIMGAP" 0.0018)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [002]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:5 - milimetre - pevne                     ;;
;;----------------------------------------------------------------------;;

(defun Kota_5_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.005)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.025)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.007)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0125)
  (setvar "DIMGAP" 0.0045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [005]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:10 - milimetre- pevne                     ;;
;;----------------------------------------------------------------------;;

(defun Kota_10_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.01)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.050)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.014)
  
  ;set tab Text
  (setvar "DIMTXT" 0.025)
  (setvar "DIMGAP" 0.009)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [010]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:20 - milimetre - pevne                    ;;
;;----------------------------------------------------------------------;;

(defun Kota_20_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.02)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.100)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.028)
  
  ;set tab Text
  (setvar "DIMTXT" 0.05)
  (setvar "DIMGAP" 0.018)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [020]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:25 - milimetre - pevne                    ;;
;;----------------------------------------------------------------------;;

(defun Kota_25_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.025)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.125)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.035)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0625)
  (setvar "DIMGAP" 0.0225)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [025]")
)


;;----------------------------------------------------------------------;;
;;                     Koty 1:50 - milimetre - pevne                    ;;
;;----------------------------------------------------------------------;;

(defun Kota_50_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.05)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.250)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.07)
  
  ;set tab Text
  (setvar "DIMTXT" 0.125)
  (setvar "DIMGAP" 0.045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [050]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:100 - milimetre - pevne                   ;;
;;----------------------------------------------------------------------;;

(defun Kota_100_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.1)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.500)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.14)
  
  ;set tab Text
  (setvar "DIMTXT" 0.250)
  (setvar "DIMGAP" 0.090)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [100]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:200 - milimetre - pevne                   ;;
;;----------------------------------------------------------------------;;

(defun Kota_200_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.2)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 1.000)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.25)
  
  ;set tab Text
  (setvar "DIMTXT" 0.500)
  (setvar "DIMGAP" 0.180)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [200]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:250 - milimetre - pevne                   ;;
;;----------------------------------------------------------------------;;

(defun Kota_250_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.25)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 1.250)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.35)
  
  ;set tab Text
  (setvar "DIMTXT" 0.625)
  (setvar "DIMGAP" 0.225)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [250]")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:500 - milimetre - pevne                   ;;
;;----------------------------------------------------------------------;;

(defun Kota_500_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.5)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 2.500)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.70)
  
  ;set tab Text
  (setvar "DIMTXT" 1.250)
  (setvar "DIMGAP" 0.450)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Koty [500]")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:1 - metre                             ;;
;;----------------------------------------------------------------------;;

(defun Kota_1_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.001)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.0014)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0025)
  (setvar "DIMGAP" 0.0009)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [001] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:2 - metre                             ;;
;;----------------------------------------------------------------------;;

(defun Kota_2_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.002)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.0028)
  
  ;set tab Text
  (setvar "DIMTXT" 0.005)
  (setvar "DIMGAP" 0.0018)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [002] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:5 - metre                             ;;
;;----------------------------------------------------------------------;;

(defun Kota_5_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.005)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.007)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0125)
  (setvar "DIMGAP" 0.0045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [005] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:10 - metre                            ;;
;;----------------------------------------------------------------------;;

(defun Kota_10_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.01)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.014)
  
  ;set tab Text
  (setvar "DIMTXT" 0.025)
  (setvar "DIMGAP" 0.009)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [010] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:20 - metre                            ;;
;;----------------------------------------------------------------------;;

(defun Kota_20_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.02)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.028)
  
  ;set tab Text
  (setvar "DIMTXT" 0.05)
  (setvar "DIMGAP" 0.018)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [020] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:25 - metre                            ;;
;;----------------------------------------------------------------------;;

(defun Kota_25_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.025)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.035)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0625)
  (setvar "DIMGAP" 0.0225)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [025] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:50 - metre                            ;;
;;----------------------------------------------------------------------;;

(defun Kota_50_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.05)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.07)
  
  ;set tab Text
  (setvar "DIMTXT" 0.125)
  (setvar "DIMGAP" 0.045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [050] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:100 - metre                            ;;
;;----------------------------------------------------------------------;;

(defun Kota_100_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.1)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.14)
  
  ;set tab Text
  (setvar "DIMTXT" 0.250)
  (setvar "DIMGAP" 0.090)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [100] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:200 - metre                           ;;
;;----------------------------------------------------------------------;;

(defun Kota_200_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.2)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.25)
  
  ;set tab Text
  (setvar "DIMTXT" 0.500)
  (setvar "DIMGAP" 0.180)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [200] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:250 - metre                           ;;
;;----------------------------------------------------------------------;;

(defun Kota_250_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.25)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.35)
  
  ;set tab Text
  (setvar "DIMTXT" 0.625)
  (setvar "DIMGAP" 0.225)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [250] meter")
)

;;----------------------------------------------------------------------;;
;;                         Koty 1:500 - metre                           ;;
;;----------------------------------------------------------------------;;

(defun Kota_500_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.5)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.70)
  
  ;set tab Text
  (setvar "DIMTXT" 1.250)
  (setvar "DIMGAP" 0.450)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [500] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:1 - metre - pevne                         ;;
;;----------------------------------------------------------------------;;

(defun Kota_1_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.001)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.005)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.0014)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0025)
  (setvar "DIMGAP" 0.0009)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [001] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:2 - metre - pevne                         ;;
;;----------------------------------------------------------------------;;

(defun Kota_2_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.002)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.010)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.0028)
  
  ;set tab Text
  (setvar "DIMTXT" 0.005)
  (setvar "DIMGAP" 0.0018)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [002] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:5 - metre - pevne                         ;;
;;----------------------------------------------------------------------;;

(defun Kota_5_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.005)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.025)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.007)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0125)
  (setvar "DIMGAP" 0.0045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [005] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:10 - metre - pevne                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_10_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.01)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.050)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.014)
  
  ;set tab Text
  (setvar "DIMTXT" 0.025)
  (setvar "DIMGAP" 0.009)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [010] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:20 - metre - pevne                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_20_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.02)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.100)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.028)
  
  ;set tab Text
  (setvar "DIMTXT" 0.05)
  (setvar "DIMGAP" 0.018)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [020] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:25 - metre - pevne                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_25_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.025)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.125)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.035)
  
  ;set tab Text
  (setvar "DIMTXT" 0.0625)
  (setvar "DIMGAP" 0.0225)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [025] meter")
)


;;----------------------------------------------------------------------;;
;;                     Koty 1:50 - metre - pevne                        ;;
;;----------------------------------------------------------------------;;

(defun Kota_50_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.05)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.250)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.07)
  
  ;set tab Text
  (setvar "DIMTXT" 0.125)
  (setvar "DIMGAP" 0.045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [050] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:100 - metre - pevne                       ;;
;;----------------------------------------------------------------------;;

(defun Kota_100_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.1)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 0.500)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.14)
  
  ;set tab Text
  (setvar "DIMTXT" 0.250)
  (setvar "DIMGAP" 0.090)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "KDP_Koty [100] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:200 - metre - pevne                       ;;
;;----------------------------------------------------------------------;;

(defun Kota_200_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.2)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 1.000)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.25)
  
  ;set tab Text
  (setvar "DIMTXT" 0.500)
  (setvar "DIMGAP" 0.180)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [200] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:250 - metre - pevne                       ;;
;;----------------------------------------------------------------------;;

(defun Kota_250_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.25)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 1.250)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.35)
  
  ;set tab Text
  (setvar "DIMTXT" 0.625)
  (setvar "DIMGAP" 0.225)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [250] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty 1:500 - metre - pevne                       ;;
;;----------------------------------------------------------------------;;

(defun Kota_500_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.5)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 2.500)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.70)
  
  ;set tab Text
  (setvar "DIMTXT" 1.250)
  (setvar "DIMGAP" 0.450)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Koty [500] meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty mierka - milimetre - vlastne                ;;
;;----------------------------------------------------------------------;;

(defun Kota_mierka_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 1)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 5)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 1.4)
  
  ;set tab Text
  (setvar "DIMTXT" 2.5)
  (setvar "DIMGAP" 0.9)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Kota")
)

;;----------------------------------------------------------------------;;
;;                     Koty mierka - milimetre - pevne                  ;;
;;----------------------------------------------------------------------;;

(defun Kota_mierka_milimetre_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 1)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 1.4)
  
  ;set tab Text
  (setvar "DIMTXT" 2.5)
  (setvar "DIMGAP" 0.9)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "DP_Kota")
)

;;----------------------------------------------------------------------;;
;;                     Koty mierka - metre - vlastne                    ;;
;;----------------------------------------------------------------------;;

(defun Kota_mierka_meter ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 1)
  (setvar "DIMFXLON" 1)
  (setvar "DIMFXL" 5)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 1.4)
  
  ;set tab Text
  (setvar "DIMTXT" 2.5)
  (setvar "DIMGAP" 0.9)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Kota meter")
)

;;----------------------------------------------------------------------;;
;;                     Koty mierka - metre - pevne                      ;;
;;----------------------------------------------------------------------;;

(defun Kota_mierka_meter_pevna ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 1)
  (setvar "DIMFXLON" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 1.4)
  
  ;set tab Text
  (setvar "DIMTXT" 2.5)
  (setvar "DIMGAP" 0.9)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1)

  (command "dimstyle" "s" "DP_Kota meter")
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