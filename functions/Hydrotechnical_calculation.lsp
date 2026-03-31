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

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Hydrotechnical_calculation.dcl"))

  ;test existencie dialogu
  (if (not (new_dialog "Hydrotechnical_calculation" dcl_id))
    (exit)
  )
  
  ;definovanie tlacidla vyber polylinu
  (action_tile "polylinaKoryta"
  "(PolylineKorytaHydrotechnicalCalculation)"
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
  
  ;vypocet hydroraulickeho polomeru koryta
  ;(setq hydroraulickyPolomer_R (/ plocha_S obvod_O))
  
  ;vypocet rychlostneho sucinitela koryta
  ;(setq rychlostnySucinitelKoryta_C (* (/ 1.0 drsnost_n) (expt hydroraulickyPolomer_R (/ 2.0 3.0))))
  
  ;vypocet prietoku koryta
  ;(setq prietok_Q (* rychlostnySucinitelKoryta_C plocha_S (sqrt sklon_i))) 
  
  ;nastavenie hodnot pre vysledky
  ;vypocitany vyskovy rozdiel koryta
  ;(set_tile "vyskovyRozdielKoryta" (rtos delta_h 2 2))
  
  ;vypocitany sklon koryta
  ;(set_tile "vypocitanySklonKoryta" (rtos sklon_i 2 4))
  
  ;vypocitany hydroraulicky polomer koryta
  ;(set_tile "hydrailickyPolomer" (rtos hydroraulickyPolomer_R 2 2))
  
  ;vypocitany rychlostny sucinitel koryta
  ;(set_tile "rychlostniSucinitel" (rtos rychlostnySucinitelKoryta_C 2 4))
  
  ;vypocitany prietok koryta
  ;(set_tile "prietokoveMnozstvo" (rtos prietok_Q 2 2))
  
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
  ;placeholder - select polyline and calculate area and perimeter
  (princ "\nVyber polylinu pre hydrotechnicky vypocet.\n")
  ;(setq ent (entsel "\nVyber polylinu: "))
  ;if selected, get area and length
  ;but for now, do nothing
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
  (done_dialog)
  (princ "\nUkoncenie hydrotechnickeho vypoctu.\n")
  (exit)
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