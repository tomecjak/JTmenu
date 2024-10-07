;=========================================================================
; Drainage.lsp
; Create by Jakub Tomecko
;
; Pocitanie vzdialenosti odvodnovacou a posudenie kapacity potrubia
;-------------------------------------------------------------------------

(defun c:JTDrainage ()

  ;definovanie listu typ odvodnovaca
  (setq TypOdvodnovaca (list "300x300 mm" "300x500 mm" "500x500 mm"))
  
  ;definovanie listu sucinitel odtoku
  (setq TypSucinitelaOdtoku (list "Kategoria A: 0.9" "Kategoria B: 0.4" "Kategoria C: 0.05"))
  
  ;definovanie typu potrubia
  (setq TypPotrubia (list "Polypropylen [PP]: 0.009" "Polyetylen [PE]: 0.009" "Liatina: 0.010" "Sklolaminat [GRP]: 0.009" "Koroziivzdorna ocel: 0.010"))

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Drainage.dcl"))

  ;test existencie dialogu
  (if (not (new_dialog "Drainage" dcl_id))
    (exit)
  )

  ;naplnenie listu typ odvodnovaca
  (start_list "typOdvodnovaca")
  (mapcar 'add_list TypOdvodnovaca)
  (end_list)
  
  ;naplnenie listu sucinitel odtoku
  (start_list "sucinitelOdtoku")
  (mapcar 'add_list TypSucinitelaOdtoku)
  (end_list)
  
  ;naplnenie listu typu potrubia
  (start_list "drsnostPotrubia")
  (mapcar 'add_list TypPotrubia)
  (end_list)
  
  ;definovanie tlacidla cancel
  (action_tile "cancel"
    "(UkoncenieDrainage)"
  )
  
  ;definovanie tlacidla vypocitaj
  (action_tile "vypocitaj"
    "(VypocetDrainage)"
  )
  
  ;definovanie tlacidla napoveda
  (action_tile "napoveda"
    "(NapovedaDrainage)"
  )
  
    ;definovanie tlacidla napoveda
  (action_tile "report"
    "(ReportDrainage)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
 
  (princ)

)

;definovanie funkcie vypoctu odvodnenia
(defun VypocetDrainage ()
  
  (setq kontrolaSpustenehoVypoctu 1)
  
  ;spustenie funkcie vypoctu hltnosti odvodnovaca
  (VypocetHltnostiOdvodnovaca)
  
  ;spustenie funkcie vypoctu mnozstva odvodnovacov
  (VypocetMnozstvaOdvodnovacov)
  
  ;spustenie funkcie posudenia kapacity potrubia
  (PosudenieKapacityPotrubia)

)

;definovanie funkcie vypoctu hltnosti odvodnovaca
(defun VypocetHltnostiOdvodnovaca ()
  ;definovanie premennych z dialogu
  ;pozdlzny spad konstrukcie
  (setq pozdlznySpad (get_tile "pozdlznySpad"))
  (setq i_Ppd (atof pozdlznySpad))
  
  ;priecny spad konstrukcie
  (setq priecnySpad (get_tile "priecnySpad"))
  (setq i_Ppr (atof priecnySpad))
  
  ;umiestnenie odvdovaca od obrubnika
  (setq umiestnenieOdObrubnika (get_tile "umiestnenieOdObrubnika"))
  (setq i_bobr (atof umiestnenieOdObrubnika))
  
  ;sucinitel drsnosti materialu
  (setq sucinitelDrsnosti (get_tile "sucinitelDrsnosti"))
  (setq i_n (atof sucinitelDrsnosti))
  
  ;sirka rozliatia
  (setq sirkaRozliatia (get_tile "sirkaRozliatia"))
  (setq i_B (atof sirkaRozliatia))
  
  ;sirka ramu odvodnovaca
  (setq sirkaRamuOdvodnovaca (get_tile "typOdvodnovaca"))
  (if (= sirkaRamuOdvodnovaca "0")
    (setq i_a 0.330)
    (if (= sirkaRamuOdvodnovaca "1")
      (setq i_a 0.333)
      (if (= sirkaRamuOdvodnovaca "2")
        (setq i_a 0.485)
      )
    )
  )
  
  ;vypocet hltnosti odvodnovaca
  ;vypocet vysky vody pri obrubniku
  (setq p_h (* i_B (/ i_Ppr 100)))
  
  ;vypocet plochy vody v rigole
  (setq p_A (* 0.5 i_B p_h))
  
  ;vypocet omoceneho obvodu
  (setq p_O (+ i_B p_h))
  
  ;vypocet hydraulickeho polomeru
  (setq p_R (/ p_A p_O))
  
  ;vypocet rychlostneho sucinitela
  (setq p_C ( /(expt p_R 0.1666666666666) i_n))
  
  ;vypocet rychlosti na vtoku
  (setq p_v (* p_C (expt p_R 0.5) (expt (/ i_Ppd 100) 0.5)))
  
  ;vypocet mnozstva vody pretekajucej rigolom
  (setq p_Q (* p_A p_v 1000))
  
  ;vypocet rychlosti vody na povrchu
  (setq p_v_ciarka (* p_v 1.15))
  
  ;vypocet vysky vody v osi odvodnovaca
  (setq p_h_ciarka_1 (* (- i_B i_bobr (/ i_a 2)) (/ i_Ppr 100)))
  
  ;urcenie typu odvodnovaca
  (if (<= p_v_ciarka 1)
    ;ak je podmienka splnena
    (progn
      (cond
        (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.045) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.045)))
        (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.042) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.042)))
        (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.038) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.038)))
        (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.035) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.035)))
        (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.030) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.030)))
        (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.027) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.027)))
        (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.023) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.023)))
        (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.020) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.020)))
        (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.015) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.015)))
        (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.012) (= sirkaRamuOdvodnovaca "300x300 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.012))) 
        (t (alert "Zmente vstupne parametre vypoctu!"))
      )  
    )
    (if (<= p_v_ciarka 1.5)
      ;ak je podmienka splnena
      (progn
        (cond
          (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.060) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.060)))
          (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.057) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.057)))
          (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.055) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.055)))
          (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.052) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.052)))
          (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.047) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.047)))
          (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.045) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.045)))
          (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.042) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.042)))
          (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.038) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.038)))
          (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.035) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.035)))
          (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.032) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.032)))
          (if (and (<= p_v_ciarka 1.1) (<= p_h_ciarka_1 0.028) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.028)))
          (if (and (<= p_v_ciarka 1.2) (<= p_h_ciarka_1 0.025) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.045)))
          (if (and (<= p_v_ciarka 1.3) (<= p_h_ciarka_1 0.022) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.022)))
          (if (and (<= p_v_ciarka 1.4) (<= p_h_ciarka_1 0.018) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.018)))
          (if (and (<= p_v_ciarka 1.5) (<= p_h_ciarka_1 0.015) (= sirkaRamuOdvodnovaca "300x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.015)))
          (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.075) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.075)))
          (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.072) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.072)))
          (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.065) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.065)))
          (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.062) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.062)))
          (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.060) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.060)))
          (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.058) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.058)))
          (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.052) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.052)))
          (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.048) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.048)))
          (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.042) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.042)))
          (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.040) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.040)))
          (if (and (<= p_v_ciarka 1.1) (<= p_h_ciarka_1 0.038) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.038)))
          (if (and (<= p_v_ciarka 1.2) (<= p_h_ciarka_1 0.032) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.032)))
          (if (and (<= p_v_ciarka 1.3) (<= p_h_ciarka_1 0.028) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.028)))
          (if (and (<= p_v_ciarka 1.4) (<= p_h_ciarka_1 0.025) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.025)))
          (if (and (<= p_v_ciarka 1.5) (<= p_h_ciarka_1 0.020) (= sirkaRamuOdvodnovaca "500x500 mm")) (progn (setq typNavrhovanehoOdvodnova "vyhovuje") (setq p_h_max 0.020)))
          (t (alert "Zmente vstupne parametre vypoctu!"))
        )
      )
      ;ak je podmienka nesplnena
      (alert "Rychlost vody na povrchu je priliz velka, prosim zmente vstupne parametre.")
    )
  )
  
  ;zistenie podmienky pre max. hladdinu vody
  (if (<= p_h_ciarka_1 p_h_max)
    (setq vyhodnotenieMaxHladinyVody "vyhovuje")
    (setq vyhodnotenieMaxHladinyVody "neyhovuje")
  )

  ;urcenie vysky vody odvodnovaca
  (setq p_h_1 p_h_ciarka_1 )

  ;vypocet sucinitela bocneho natoku
  (setq p_k (/ 5 p_v))

  ;vypocet prirahlej sirky
  (setq p_prirahlaSirka (* p_k p_h_1))

  ;vypocet spoluposobiacej sirky
  (setq p_male_a_1 (+ p_prirahlaSirka i_a (min i_bobr p_prirahlaSirka)))

  ;vypocet priemernej vysky vody
  (setq p_priemerna_h_1 (* (- i_B (/ p_male_a_1 2)) (/ i_Ppr 100)))

  ;vypocet plochy vodnej vrstvy pritekajucej k odvodnovacu
  (setq p_A_1 (* p_male_a_1 p_priemerna_h_1))

  ;vypocet mnozstva vody vtekajuceho do odvodnovaca - hltnost
  (setq p_Hod (* p_A_1 p_v 1000))
  
  ;nastavenie hodnot pre vysledky
  (set_tile "vyhodnotenieMaxHladinyVody" vyhodnotenieMaxHladinyVody)
  (set_tile "typNavrhovanehoOdvodnova" typNavrhovanehoOdvodnova)
  (setq vyslednaHltnostOdvodnovaca (strcat (rtos p_Hod 2 3) " l/s"))
  (set_tile "vyslednaHltnostOdvodnovaca" vyslednaHltnostOdvodnovaca)
)

;definovanie funkcie vypoctu mnostva odvodnovacov
(defun VypocetMnozstvaOdvodnovacov ()
  ;definovanie premennych z dialogu
  ;dlzka odvodnovanej plochy
  (setq dlzkaOdvodnovacejPlochy (get_tile "dlzkaOdvodnovacejPlochy"))
  (setq i_l_plochy (atof dlzkaOdvodnovacejPlochy))  
  
  ;sirka odvodnovanej plochy
  (setq sirkaOdvodnovacejPlochy (get_tile "sirkaOdvodnovacejPlochy"))
  (setq i_s_plochy (atof sirkaOdvodnovacejPlochy)) 
  
  ;max. intenzita dazda
  (setq maxIntenziotaDazda (get_tile "maxIntenziotaDazda"))
  (setq i_q (atof maxIntenziotaDazda)) 
  
  ;sucinitel odtoku
  (setq sucinitelOdtokuMaterialu (get_tile "sucinitelOdtoku"))
  (if (= sucinitelOdtokuMaterialu "0")
    (setq i_fi_odtoku 0.9)
    (if (= sucinitelOdtokuMaterialu "1")
      (setq i_fi_odtoku 0.4)
      (if (= sucinitelOdtokuMaterialu "2")
        (setq i_fi_odtoku 0.05)
      )
    )
  )
  
  ;vypocet mnozstva odvodnovacov
  ;vypocet odvodnovanej plochy mosta
  (setq p_Fm (* i_l_plochy i_s_plochy))
  
  ;vypocet mnozstva odvadzanej vody
  (setq p_Qm (* p_Fm i_q i_fi_odtoku))
  
  ;stupen bezpecnosti
  (setq i_stupenBezpecnosti 2)
  
  ;vypocet vzdialenosti odvodnovacov
  (setq p_Lodv (/ p_Hod (* i_q i_s_plochy i_fi_odtoku i_stupenBezpecnosti)))
  
  ;nastavenie hodnot pre vysledky
  (setq maxVzdialenostOdvodnovacou (strcat (rtos p_Lodv 2 2) " m"))
  (set_tile "maxVzdialenostOdvodnovacou" maxVzdialenostOdvodnovacou)
  (if (> p_Lodv 7)
    (setq odvodnenieIzolacie "ano")
    (setq odvodnenieIzolacie "nie")
  )
  (set_tile "odvodnenieIzolacie" odvodnenieIzolacie)
  
  (if (or (<= i_l_plochy 20) (<= p_Fm 150))
    (alert "Je mozne zvazit ci je potrebny navrh odvodnenia, pretoze dlzka mosta\nje kratsia ako 20 m alebo plocha mosta je mensia ako 150 m2.")
  )
)



;definovanie funkcie posudenie kapacity potrubia
(defun PosudenieKapacityPotrubia ()
  ;definovanie premennych z dialogu
  ;vnutorny priemer potrubia
  (setq vnutornyPriemerPotrubia (get_tile "vnutornyPriemerPotrubia"))
  (setq i_dpot (atof vnutornyPriemerPotrubia))
  
  ;sklon potrubia
  (setq sklonPotrubia (get_tile "sklonPotrubia"))
  (setq i_ipod (atof sklonPotrubia))
  
  ;sucinitel odtoku
  (setq drsnostPotrubia (get_tile "drsnostPotrubia"))
  (if (= drsnostPotrubia "0")
    (setq i_npot 0.009)
    (if (= drsnostPotrubia "1")
      (setq i_npot 0.009)
      (if (= drsnostPotrubia "2")
        (setq i_npot 0.010)
        (if (= drsnostPotrubia "3")
          (setq i_npot 0.009)
          (if (= drsnostPotrubia "4")
            (setq i_npot 0.010)
          )
        )
      )
    )
  )
  
  ;posudenie kapacity potrubia
  ;vypocet prietokovej plochy potrubia
  (setq p_Spot (* PI (/ (expt i_dpot 2) 4)))
  
  ;vypocet omoceneho obvodu
  (setq p_Opot (* PI i_dpot))
  
  ;vypocet hydraulickeho polomeru
  (setq p_Rpot (/ p_Spot p_Opot))
  
  ;vypocet rychlostneho sucinitela
  (setq p_cpot (* (/ 1 i_npot) (expt p_Rpot 0.1666666666666)))
  
  ;vypocet strednej profilovej rychlosti
  (setq p_vpot (* p_cpot (expt (* p_Rpot (/ i_ipod 100)) 0.5)))
  
  ;vypocet objemoveho  prietoku potrubia
  (setq p_Qpot (* p_Spot p_vpot 1000))
  
  ;nastavenie hodnot pre vysledky
  (if (> p_Qpot p_Qm)
    (setq vyhodnoteniePosudenieKapacityPotrubia "vyhovuje")
    (setq vyhodnoteniePosudenieKapacityPotrubia "nevyhovuje")
  )
  (set_tile "vyhodnoteniePosudenieKapacityPotrubia" vyhodnoteniePosudenieKapacityPotrubia)
  (setq prietokPotrubia (strcat (rtos p_Qpot 2 2) " l/s"))
  (set_tile "prietokPotrubia" prietokPotrubia)
)

;definovanie funkcie zavretia dialogoveho okna
(defun UkoncenieDrainage()
  (ResetVariables)
  (done_dialog)
  (princ "\nUkoncenie kalkulacky odvodnenia.\n")
  (exit)
)

;funkcia tlacidla napoveda
(defun NapovedaDrainage ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id2 (load_dialog "Drainage.dcl"))
  
  ;test existencie dialogu NapovedaDrainageDialog
  (if (not (new_dialog "NapovedaDrainageDialog" dcl_id2))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritNapovedu"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id2)
)

;funkcia tlacidla report
(defun ReportDrainage ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id3 (load_dialog "Drainage.dcl"))
  
  ;test existencie dialogu ReportDrainageDialog
  (if (not (new_dialog "ReportDrainageDialog" dcl_id3))
    (exit)
  )
  
  ;sustenie funkcie naplnenia reportu udajmi
  (if (= kontrolaSpustenehoVypoctu nil)
    (progn
      (done_dialog)
      (alert "Nebol spusteny vypocet.")
    )
    (progn
      (set_tile "report_pozdlznySpad" (rtos i_Ppd 2 3))
      (set_tile "report_priecnySpad" (rtos i_Ppr 2 3))
      (set_tile "report_umiestnenieObrubnika" (rtos i_bobr 2 3))
      (set_tile "report_sucinitelDrsnosti" (rtos i_n 2 3))
      (set_tile "report_sirkaRozliatia" (rtos i_B 2 3))
      (set_tile "report_sirkaOdvodnovaca" (rtos i_a 2 3))
      (set_tile "report_vyskaVodyPriObrubniku" (rtos p_h 2 3))
      (set_tile "report_plochaVodyVRigole" (rtos p_A 2 3))
      (set_tile "report_omocenyObvod" (rtos p_O 2 3))
      (set_tile "report_hydraulickyPolomer" (rtos p_R 2 3))
      (set_tile "report_rychlostnySucinitel" (rtos p_C 2 3))
      (set_tile "report_rychlostNaVtoku" (rtos p_v 2 3))
      (set_tile "report_mnozstvoVodyPretekajucejRigolom" (rtos p_Q 2 3))
      (set_tile "report_rychlostVodyNaPovrchu" (rtos p_v_ciarka 2 3))
      (set_tile "report_vyskaVodyVOsiOdvodnovaca" (rtos p_h_ciarka_1 2 3))
      (set_tile "report_maxVyskaVodyVOsiOdvodnovaca" (rtos p_h_max 2 3))
      (set_tile "report_posudenieVyskyVodyVOsiOdvodnenia" vyhodnotenieMaxHladinyVody)
      (set_tile "report_sucinitelBocnehoNatoko" (rtos p_k 2 3))
      (set_tile "report_prirahlaSirka" (rtos p_prirahlaSirka 2 3))
      (set_tile "report_spoluposobiacaSirka" (rtos p_male_a_1 2 3))
      (set_tile "report_priemernaVyskaVody" (rtos p_priemerna_h_1 2 3))
      (set_tile "report_plochaVodnejVrstvyPritekajucejOdvodnovacu" (rtos p_A_1 2 3))
      (set_tile "report_mnozstvoVodyVtekajucejDoOdvodnovaca" (rtos p_Hod 2 3))
      (set_tile "report_dlzkaOdvodnovanejPlochy" (rtos i_l_plochy 2 3))
      (set_tile "report_sirkaOdvodnovanejPlochy" (rtos i_s_plochy 2 3))
      (set_tile "report_maxIntenzitaDazda" (rtos i_q 2 3))
      (set_tile "report_sucinitelOdtoku" (rtos i_fi_odtoku 2 3))
      (set_tile "report_odvodnovanaPlocha" (rtos p_Fm 2 3))
      (set_tile "report_mnozstvoOdvadzanejVody" (rtos p_Qm 2 3))
      (set_tile "report_stupenBezpecnosti" (rtos i_stupenBezpecnosti 2 3))
      (set_tile "report_vzdialenostOdvodnovacou" (rtos p_Lodv 2 3))
      (set_tile "report_vnutornyPriemerPotrubia" (rtos i_dpot 2 3))
      (set_tile "report_sklonPotrubia" (rtos i_ipod 2 3))
      (set_tile "report_drsnostPotrubia" (rtos i_npot 2 3))
      (set_tile "report_prietokovaPlochaPotrubia" (rtos p_Spot 2 3))
      (set_tile "report_omocenyObvodPotrubia" (rtos p_Opot 2 3))
      (set_tile "report_hydraulickyPolomerPotrubia" (rtos p_Rpot 2 3))
      (set_tile "report_rychlostnySucinitelPotrubia" (rtos p_cpot 2 3))
      (set_tile "report_strednaProfilovaRychlost" (rtos p_vpot 2 3))
      (set_tile "report_objemovyPrietokPotrubia" (rtos p_Qpot 2 3))
      (set_tile "report_posudenieKapacityPotrubia" vyhodnoteniePosudenieKapacityPotrubia)
    )
  )
  
  ;definicnia tlacidla export
  (action_tile "reportExport"
    "(creareReportExport)"
  )

  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritReport"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id3)
)

;vytvorenie funkcie exportovanie udajov do csv
(defun creareReportExport ()
  (setq cestaReportExport (getfiled "Text File" "" "csv" 1))
  (setq suborReportCSV (close (open cestaReportExport "w")))
  (setq suborReportCSV (open cestaReportExport "a"))
  
  (write-line "sep=;" suborReportCSV)
  (write-line "Vypocet hltnosti odvodnenia" suborReportCSV)
  (write-line "Popis;Oznacenie;Hodnota;Jednotka;Vzorec" suborReportCSV)
  (write-line (strcat "Pozdlzny spad [vstupna hodnota];Ppd;" (rtos i_Ppd 2 3) ";%;") suborReportCSV)
  (write-line (strcat "Priecny spad [vstupna hodnota];Ppr;" (rtos i_Ppd 2 3) ";%;") suborReportCSV)
  (write-line (strcat "Umiestnenie od obrubnika [vstupna hodnota];bobr;" (rtos i_Ppd 2 3) ";m;") suborReportCSV)
  (write-line (strcat "Sucinitel drsnosti [vstupna hodnota];n;" (rtos i_Ppd 2 3) ";-;") suborReportCSV)
  (write-line (strcat "Sirka rozliatia [vstupna hodnota];B;" (rtos i_Ppd 2 3) ";m;") suborReportCSV)
  (write-line (strcat "Sirka (ramu) odvodnovaca [vstupna hodnota];a;" (rtos i_Ppd 2 3) ";m;") suborReportCSV)
  (write-line (strcat "Vyska vody pri obrubniku;h;" (rtos i_Ppd 2 3) ";m;h=B.Ppr") suborReportCSV)
  (write-line (strcat "Plocha vody v rigole (odvod. zlab);A;" (rtos i_Ppd 2 3) ";m2;A=0.5.B.h") suborReportCSV)
  (write-line (strcat "Omoceny obvod;O;" (rtos i_Ppd 2 3) ";m;O=B+h") suborReportCSV)
  (write-line (strcat "Hydraulicky polomer;R;" (rtos i_Ppd 2 3) ";m;R=A/O") suborReportCSV)
  (write-line (strcat "Rychlostny sucinitel;C;" (rtos i_Ppd 2 3) ";-;C=(R^1/6)/n") suborReportCSV)
  (write-line (strcat "Rychlost na vtoku;v;" (rtos i_Ppd 2 3) ";m/s;v=C.(R^1/2).(Ppd^1/2)") suborReportCSV)
  (write-line (strcat "Mnozstvo vody pretekajuci rigolom;Q;" (rtos i_Ppd 2 3) ";l/s;Q=A.v.1000") suborReportCSV)
  (write-line (strcat "Rychlost vody na povrchu;v';" (rtos i_Ppd 2 3) ";m/s;v'=v.1,15<1,0 (1,5)") suborReportCSV)
  (write-line (strcat "Vyska vody v osi odvodnovaca;h'1;" (rtos i_Ppd 2 3) ";m;h'1=(B-bobr-a/2).Ppr") suborReportCSV)
  (write-line (strcat "Max. vyska vody v osi odvodnovaca;hmax;" (rtos i_Ppd 2 3) ";m;") suborReportCSV)
  (write-line (strcat "Posudenie max. vysky vody;-;" xxx ";-;h'1<hmax") suborReportCSV)
  (write-line (strcat "Sucinitel bocneho natoku;k;" (rtos i_Ppd 2 3) ";-;k=5/v") suborReportCSV)
  (write-line (strcat "Prirahla sirka;k.h1;" (rtos i_Ppd 2 3) ";m;k.h1") suborReportCSV)
  (write-line (strcat "Spoluposobiaca sirka;a1;" (rtos i_Ppd 2 3) ";m;a1=k.h1+a+min(bobr;k.h1)") suborReportCSV)
  (write-line (strcat "Priemerna vyska vody;@h'1;" (rtos i_Ppd 2 3) ";m;@h'1=(B-a1/2).Ppr") suborReportCSV)
  (write-line (strcat "Plocha vodnej vrstvy prit. k odvod.;A1;" (rtos i_Ppd 2 3) ";m2;A1=a1.@h'1") suborReportCSV)
  (write-line (strcat "Mnozstvo vody vtekajucej do odvod.;Hod;" (rtos i_Ppd 2 3) ";l/s;Hod=A1.v.1000") suborReportCSV)
  (write-line "Vypocet mnozstva odvodnovacov" suborReportCSV)
  (write-line "Popis;Oznacenie;Hodnota;Jednotka;Vzorec" suborReportCSV)
  (write-line (strcat "Dlzka odvodnovanej plochy [vstupna hodnota];xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Sirka odvodnovanej plochy [vstupna hodnota];xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Max. privalova intenzita dazda [vstupna hodnota];xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Sucinitel odtoku [vstupna hodnota];xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Odvodnovana plocha mosta;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Mnozstvo odvadzanej vody;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Stupen bezpecnosti;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Vzdialenost odvodnovacov;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line "Posudenie kapacity potrubie" suborReportCSV)
  (write-line "Popis;Oznacenie;Hodnota;Jednotka;Vzorec" suborReportCSV)
  (write-line (strcat "Vnutorny priemer potrubia [vstupna hodnota];xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Sklon potrubia [vstupna hodnota];xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Drsnost potrubia [vstupna hodnota];xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Prietokova plocha potrubia;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Omoceny obvod;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Hydraulicky polomer;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Rychlostny sucinitel;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Stredna profilova rychlost;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Objemovy prietok potrubia;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
  (write-line (strcat "Posudenie potrubia;xx;" (rtos i_Ppd 2 3) ";xx;xx") suborReportCSV)
)

;resetovanie vsetkych premmnych po vypnuti programu
(defun ResetVariables ()
  (setq kontrolaSpustenehoVypoctu nil)
  (setq i_Ppd nil)
  (setq i_Ppr nil)
  (setq i_bobr nil)
  (setq i_n nil)
  (setq i_B nil)
  (setq i_a nil)
  (setq p_h nil)
  (setq p_A nil)
  (setq p_O nil)
  (setq p_R nil)
  (setq p_C nil)
  (setq p_v nil)
  (setq p_Q nil)
  (setq p_v_ciarka nil)
  (setq p_h_ciarka_1  nil)
  (setq p_h_max nil)
  (setq vyhodnotenieMaxHladinyVody nil)
  (setq p_k nil)
  (setq p_prirahlaSirka nil)
  (setq p_male_a_1 nil)
  (setq p_priemerna_h_1 nil)
  (setq p_A_1 nil)
  (setq p_Hod nil)
  (setq i_l_plochy nil)
  (setq i_s_plochy nil)
  (setq i_q nil)
  (setq i_fi_odtoku nil)
  (setq p_Fm nil)
  (setq p_Qm nil)
  (setq i_stupenBezpecnosti nil)
  (setq p_Lodv nil)
  (setq i_dpot nil)
  (setq i_ipod nil)
  (setq i_npot nil)
  (setq p_Spot nil)
  (setq p_Opot nil)
  (setq p_Rpot nil)
  (setq p_cpot nil)
  (setq p_vpot nil)
  (setq p_Qpot nil)
  (setq vyhodnoteniePosudenieKapacityPotrubia nil)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nDrainage.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;