;=========================================================================
; Drainage.lsp
; Create by Jakub Tomecko
;
; Pocitanie vzdialenosti odvodnovacou a posudenie kapacity potrubia
;-------------------------------------------------------------------------

(defun c:JTDrainage ()

  ;definovanie listu typ odvodnovaca
  (setq TypOdvodnovaca (list "300x300 mm" "300x500 mm" "500x500 mm"))

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
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
 
  (princ)

)

;definovanie funkcie vypoctu odvodnenia
(defun VypocetDrainage ()
  
  ;spustenie funkcie vypoctu hltnosti odvodnovaca
  (VypocetHltnostiOdvodnovaca)
  
  (princ sirkaRamuOdvodnovaca)
  (princ i_a)
  (princ p_v_ciarka)
  (princ p_h_ciarka_1)
  (princ typNavrhovanehoOdvodnova)
  (princ p_k)
  (princ p_prirahlaSirka)
  (princ p_a_1)
  (princ p_priemerna_h_1)
  (princ p_Hod)

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
  (setq p_C ( /(expt p_R 0.1666666) i_n))
  
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
        (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.045) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.042) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.038) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.035) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.030) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.027) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.023) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.020) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.015) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
        (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.012) (= sirkaRamuOdvodnovaca "300x300 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje")) 
        (t (alert "Zmente vstupne parametre vypoctu!"))
      )  
    )
    (if (<= p_v_ciarka 1.5)
      ;ak je podmienka splnena
      (progn
        (cond
          (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.060) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.057) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.055) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.052) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.047) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.045) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.042) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.038) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.035) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.032) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.1) (<= p_h_ciarka_1 0.028) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.2) (<= p_h_ciarka_1 0.025) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.3) (<= p_h_ciarka_1 0.022) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.4) (<= p_h_ciarka_1 0.018) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.5) (<= p_h_ciarka_1 0.015) (= sirkaRamuOdvodnovaca "300x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.075) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.072) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.065) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.062) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.060) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.058) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.052) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.048) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.042) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.040) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.1) (<= p_h_ciarka_1 0.038) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.2) (<= p_h_ciarka_1 0.032) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.3) (<= p_h_ciarka_1 0.028) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.4) (<= p_h_ciarka_1 0.025) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (if (and (<= p_v_ciarka 1.5) (<= p_h_ciarka_1 0.020) (= sirkaRamuOdvodnovaca "500x500 mm")) (setq typNavrhovanehoOdvodnova "Vybrany tyb odvodnovaca vyhovuje"))
          (t (alert "Zmente vstupne parametre vypoctu!"))
        )
      )
      ;ak je podmienka nesplnena
      (alert "Rychlost vody na povrchu je priliz velka, prosim zmente vstupne parametre.")
    )
  )

  ;urcenie vysky vody odvodnovaca
  (setq p_h_1 p_h_ciarka_1 )

  ;vypocet sucinitela bocneho natoku
  (setq p_k (/ 5 p_v))

  ;vypocet prirahlej sirky
  (setq p_prirahlaSirka (* p_k p_h_1))

  ;vypocet spoluposobiacej sirky
  (setq p_a_1 (+ p_prirahlaSirka i_a (min i_bobr p_prirahlaSirka)))

  ;vypocet priemernej vysky vody
  (setq p_priemerna_h_1 (* (- i_B (/ p_a_1 2)) (/ i_Ppr 100)))

  ;vypocet plochy vodnej vrstvy pritekajucej k odvodnovacu
  (setq p_A_1 (* p_a_1 p_priemerna_h_1))

  ;vypocet mnozstva vody vtekajuceho do odvodnovaca - hltnost
  (setq p_Hod (* p_A_1 p_v 1000))
)

;definovanie funkcie vypoctu mnostva odvodnovacov
;(defun VypocetMnozstvaOdvodnovacov ())

;definovanie funkcie posudenie kapacity potrubia
;(defun PosudenieKapacityPotrubia ())

;definovanie funkcie zavretia dialogoveho okna
(defun UkoncenieDrainage()
  (done_dialog)
  (princ "\nUkoncenie kalkulacky odvodnenia.\n")
  (exit)
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