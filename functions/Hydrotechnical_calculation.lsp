;=========================================================================
; Hydrotechnical_calculation.lsp
; Create by Jakub Tomecko
;
; Hydrotechnicky vypocet kapacity koryta
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                  Hlavna funkcia nacitania dialogu                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTHydrotechnical ()
  (vl-load-com)
  ;inicializacia globalnych premennych
  (if (not *hydro_vyska_zac*) (setq *hydro_vyska_zac* nil))
  (if (not *hydro_vyska_kon*) (setq *hydro_vyska_kon* nil))
  (if (not *hydro_dlzka*) (setq *hydro_dlzka* nil))
  (if (not *hydro_drsnost*) (setq *hydro_drsnost* nil))
  (if (not *hydro_plocha*) (setq *hydro_plocha* nil))
  (if (not *hydro_obvod*) (setq *hydro_obvod* nil))
  (if (not *hydro_q1*) (setq *hydro_q1* nil))
  (if (not *hydro_q2*) (setq *hydro_q2* nil))
  (if (not *hydro_q5*) (setq *hydro_q5* nil))
  (if (not *hydro_q10*) (setq *hydro_q10* nil))
  (if (not *hydro_q20*) (setq *hydro_q20* nil))
  (if (not *hydro_q50*) (setq *hydro_q50* nil))
  (if (not *hydro_q100*) (setq *hydro_q100* nil))
  (setq select_polyline nil)
  
  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Hydrotechnical_calculation.dcl"))

  ;test existencie dialogu
  (if (not (new_dialog "Hydrotechnical_calculation" dcl_id))
    (exit)
  )
  
  ;nastavenie hodnot z predchadzajuceho vyberu alebo ulozenia
  (if *hydro_vyska_zac* (set_tile "vyskaNaZaciatkuKoryta" (rtos *hydro_vyska_zac* 2 2)))
  (if *hydro_vyska_kon* (set_tile "vyskaNaKonciKoryta" (rtos *hydro_vyska_kon* 2 2)))
  (if *hydro_dlzka* (set_tile "dlzkaKoryta" (rtos *hydro_dlzka* 2 2)))
  (if *hydro_drsnost* (set_tile "stupenDrsnostiKoryta" (rtos *hydro_drsnost* 2 2)))
  (if *hydro_plocha* (set_tile "prietocnaPlochaKoryta" (rtos *hydro_plocha* 2 2)))
  (if *hydro_obvod* (set_tile "omocvenyObvodKoryta" (rtos *hydro_obvod* 2 2)))
  (if *hydro_q1* (set_tile "hodnotaPrietokuKorytaQ1" (rtos *hydro_q1* 2 2)))
  (if *hydro_q2* (set_tile "hodnotaPrietokuKorytaQ2" (rtos *hydro_q2* 2 2)))
  (if *hydro_q5* (set_tile "hodnotaPrietokuKorytaQ5" (rtos *hydro_q5* 2 2)))
  (if *hydro_q10* (set_tile "hodnotaPrietokuKorytaQ10" (rtos *hydro_q10* 2 2)))
  (if *hydro_q20* (set_tile "hodnotaPrietokuKorytaQ20" (rtos *hydro_q20* 2 2)))
  (if *hydro_q50* (set_tile "hodnotaPrietokuKorytaQ50" (rtos *hydro_q50* 2 2)))
  (if *hydro_q100* (set_tile "hodnotaPrietokuKorytaQ100" (rtos *hydro_q100* 2 2)))
  
  ;definovanie tlacidla vyber polylinu
  (action_tile "polylinaKoryta"
  "(setq select_polyline t) (done_dialog)"
  )
  
  ;definovanie tlacidla cancel
  (action_tile "cancel"
    "(UkoncenieHydrotechnicalCalculation)"
  )
  
  ;definovanie tlacidla vypocitaj
  (action_tile "vypocitaj"
    "(VypocetHydrotechnicalCalculation)"
  )
  
  ;definovanie tlacidla report
  (action_tile "report"
    "(ReportHydrotechnicalCalculation)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;ak bol vybrany vyber polyliny, vykonaj ho
  (if select_polyline
    (progn
      (PolylineKorytaHydrotechnicalCalculation)
      (c:JTHydrotechnical)
    )
  )
  
  ;unload dialogu
  (unload_dialog dcl_id)
 
  (princ)

)

;;----------------------------------------------------------------------;;
;;            Funkcia vypoctu hydrotechnickej kapacity koryta           ;;                 ;;
;;----------------------------------------------------------------------;;

(defun VypocetHydrotechnicalCalculation ()
  ;definovanie premennych z dialogu
  ;vyska na zaciatku koryta
  (setq VyskaNaZaciatkuKoryta (get_tile "vyskaNaZaciatkuKoryta"))
  (setq vyska_h1 (atof VyskaNaZaciatkuKoryta))
  
  ;vyska na zaciatku koryta
  (setq VyskaNaKonciKoryta (get_tile "vyskaNaKonciKoryta"))
  (setq vyska_h2 (atof VyskaNaKonciKoryta))
  
  ;celkova dlzka koryta
  (setq CelkovaDlzkaKoryta (get_tile "dlzkaKoryta"))
  (setq dlzka_L (atof CelkovaDlzkaKoryta))
  
  ;stupen drsnosti dna koryta
  (setq StupenDrsnostiKoryta (get_tile "stupenDrsnostiKoryta"))
  (setq drsnost_n (atof StupenDrsnostiKoryta))
  
  ;prietocna plocha koryta
  (setq PrietocnaPlochaKoryta (get_tile "prietocnaPlochaKoryta"))
  (setq plocha_S (atof PrietocnaPlochaKoryta))
        
  ;omoceny obvod koryta
  (setq OmocenyObvodKoryta (get_tile "omocvenyObvodKoryta"))
  (setq obvod_O (atof OmocenyObvodKoryta))
        
  ;hodnota prietoku Q1
  (setq HodnotaPrietokuQ1 (get_tile "hodnotaPrietokuKorytaQ1"))
  (setq prietok_Q1 (atof HodnotaPrietokuQ1))
        
  ;hodnota prietoku Q2
  (setq HodnotaPrietokuQ2 (get_tile "hodnotaPrietokuKorytaQ2"))
  (setq prietok_Q2 (atof HodnotaPrietokuQ2))
        
  ;hodnota prietoku Q5
  (setq HodnotaPrietokuQ5 (get_tile "hodnotaPrietokuKorytaQ5"))
  (setq prietok_Q5 (atof HodnotaPrietokuQ5))
        
  ;hodnota prietoku Q10
  (setq HodnotaPrietokuQ10 (get_tile "hodnotaPrietokuKorytaQ10"))
  (setq prietok_Q10 (atof HodnotaPrietokuQ10))
        
  ;hodnota prietoku Q20
  (setq HodnotaPrietokuQ20 (get_tile "hodnotaPrietokuKorytaQ20"))
  (setq prietok_Q20 (atof HodnotaPrietokuQ20))
        
  ;hodnota prietoku Q50
  (setq HodnotaPrietokuQ50 (get_tile "hodnotaPrietokuKorytaQ50"))
  (setq prietok_Q50 (atof HodnotaPrietokuQ50))
        
  ;hodnota prietoku Q100
  (setq HodnotaPrietokuQ100 (get_tile "hodnotaPrietokuKorytaQ100"))
  (setq prietok_Q100 (atof HodnotaPrietokuQ100))
  
  ;vypocet prietoku koryta
  ;vypocet delta vysok zaciatku a konca koryta
  (setq delta_h (- vyska_h1 vyska_h2))
  
  ;vypocet sklonu koryta
  (setq sklon_i (/ delta_h dlzka_L))
  
  ;vypocet hydroraulickeho polomeru koryta
  (setq hydroraulickyPolomer_R (/ plocha_S obvod_O))
  
  ;vypocet rychlostneho sucinitela koryta
  (setq rychlostnySucinitelKoryta_C (* (/ 1.0 drsnost_n) (expt hydroraulickyPolomer_R (/ 2.0 3.0))))
  
  ;vypocet prietoku koryta
  (setq prietok_Q (* rychlostnySucinitelKoryta_C plocha_S (sqrt sklon_i))) 
  
  ;nastavenie hodnot pre vysledky
  ;vypocitany vyskovy rozdiel koryta
  (set_tile "vyskovyRozdielKoryta" (rtos delta_h 2 2))
  
  ;vypocitany sklon koryta
  (set_tile "vypocitanySklonKoryta" (rtos sklon_i 2 2))
  
  ;vypocitany hydroraulicky polomer koryta
  (set_tile "hydrailickyPolomer" (rtos hydroraulickyPolomer_R 2 2))
  
  ;vypocitany rychlostny sucinitel koryta
  (set_tile "rychlostniSucinitel" (rtos rychlostnySucinitelKoryta_C 2 2))
  
  ;vypocitany prietok koryta
  (set_tile "prietokoveMnozstvo" (rtos prietok_Q 2 2))
  
  ;vyhodnotenie posudenia prietoku koryta pre Q1
  (if (> prietok_Q prietok_Q1)
    (setq vyhodnotenieQ1 "vyhovuje")
    (setq vyhodnotenieQ1 "nevyhovuje")
  )
  (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ1" vyhodnotenieQ1)

  ;vyhodnotenie posudenia prietoku koryta pre Q2
  (if (> prietok_Q prietok_Q2)
    (setq vyhodnotenieQ2 "vyhovuje")
    (setq vyhodnotenieQ2 "nevyhovuje")
  )
  (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ2" vyhodnotenieQ2)
  
  ;vyhodnotenie posudenia prietoku koryta pre Q5
  (if (> prietok_Q prietok_Q5)
    (setq vyhodnotenieQ5 "vyhovuje")
    (setq vyhodnotenieQ5 "nevyhovuje")
  )
  (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ5" vyhodnotenieQ5)
  
  ;vyhodnotenie posudenia prietoku koryta pre Q10
  (if (> prietok_Q prietok_Q10)
    (setq vyhodnotenieQ10 "vyhovuje")
    (setq vyhodnotenieQ10 "nevyhovuje")
  )
  (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ10" vyhodnotenieQ10)
  
  ;vyhodnotenie posudenia prietoku koryta pre Q20
  (if (> prietok_Q prietok_Q20)
    (setq vyhodnotenieQ20 "vyhovuje")
    (setq vyhodnotenieQ20 "nevyhovuje")
  )
  (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ20" vyhodnotenieQ20)
  
  ;vyhodnotenie posudenia prietoku koryta pre Q50
  (if (> prietok_Q prietok_Q50)
    (setq vyhodnotenieQ50 "vyhovuje")
    (setq vyhodnotenieQ50 "nevyhovuje")
  )
  (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ50" vyhodnotenieQ50)
  
  ;vyhodnotenie posudenia prietoku koryta pre Q100
  (if (> prietok_Q prietok_Q100)
    (setq vyhodnotenieQ100 "vyhovuje")
    (setq vyhodnotenieQ100 "nevyhovuje")
  )
  (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ100" vyhodnotenieQ100)

)

;;----------------------------------------------------------------------;;
;;            Funkcia vyberu polyliny pre hydrotechnicky vypocet        ;;
;;----------------------------------------------------------------------;;

(defun PolylineKorytaHydrotechnicalCalculation ()
  (vl-load-com)
  (setq ent (entsel "\nVyber polylinu koryta: "))
  (if ent
    (progn
      (setq obj (vlax-ename->vla-object (car ent)))
      (if (= (vla-get-objectname obj) "AcDbPolyline")
        (progn
          (setq *hydro_plocha* (vla-get-area obj))
          (setq *hydro_obvod* (vla-get-length obj))
          (princ (strcat "\nPlocha: " (rtos *hydro_plocha* 2 2) " m²\n"))
          (princ (strcat "Obvod: " (rtos *hydro_obvod* 2 2) " m\n"))
        )
        (princ "\nVybrana entita nie je polylina.\n")
      )
    )
    (princ "\nNevybral si ziadnu polylinu.\n")
  )
)

;;----------------------------------------------------------------------;;
;;                  Funkcia reportu                                     ;;
;;----------------------------------------------------------------------;;

(defun ReportHydrotechnicalCalculation ()
  (princ "\nGenerovanie reportu.\n")
  ;placeholder
)

;;----------------------------------------------------------------------;;
;;                  Funkcia zavretia dialogoveho okna                   ;;
;;----------------------------------------------------------------------;;

(defun UkoncenieHydrotechnicalCalculation()
  ;ulozenie hodnot pred zatvorenim
  (if (get_tile "vyskaNaZaciatkuKoryta") (setq *hydro_vyska_zac* (atof (get_tile "vyskaNaZaciatkuKoryta"))))
  (if (get_tile "vyskaNaKonciKoryta") (setq *hydro_vyska_kon* (atof (get_tile "vyskaNaKonciKoryta"))))
  (if (get_tile "dlzkaKoryta") (setq *hydro_dlzka* (atof (get_tile "dlzkaKoryta"))))
  (if (get_tile "stupenDrsnostiKoryta") (setq *hydro_drsnost* (atof (get_tile "stupenDrsnostiKoryta"))))
  ;plocha a obvod uz su ulozene
  ;a Q hodnoty
  (if (get_tile "hodnotaPrietokuKorytaQ1") (setq *hydro_q1* (atof (get_tile "hodnotaPrietokuKorytaQ1"))))
  (if (get_tile "hodnotaPrietokuKorytaQ2") (setq *hydro_q2* (atof (get_tile "hodnotaPrietokuKorytaQ2"))))
  (if (get_tile "hodnotaPrietokuKorytaQ5") (setq *hydro_q5* (atof (get_tile "hodnotaPrietokuKorytaQ5"))))
  (if (get_tile "hodnotaPrietokuKorytaQ10") (setq *hydro_q10* (atof (get_tile "hodnotaPrietokuKorytaQ10"))))
  (if (get_tile "hodnotaPrietokuKorytaQ20") (setq *hydro_q20* (atof (get_tile "hodnotaPrietokuKorytaQ20"))))
  (if (get_tile "hodnotaPrietokuKorytaQ50") (setq *hydro_q50* (atof (get_tile "hodnotaPrietokuKorytaQ50"))))
  (if (get_tile "hodnotaPrietokuKorytaQ100") (setq *hydro_q100* (atof (get_tile "hodnotaPrietokuKorytaQ100"))))
  (done_dialog)
  (princ "\nUkoncenie hydrotechnickeho vypoctu.\n")
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nHydrotechnical_calculation.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;