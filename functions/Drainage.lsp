;=========================================================================
; Drainage.lsp
; Create by Jakub Tomecko
;
; Pocitanie vzdialenosti odvodnovacou a posudenie kapacity potrubia
;-------------------------------------------------------------------------

(defun c:JTDrainage ()

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Drainage.dcl"))

  ;test existencie dialogu
  (if (not (new_dialog "Drainage" dcl_id))
    (exit)
  )
  
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
  
  (princ typNavrhovanehoOdvodnova)

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
  (setq sirkaRamuOdvodnovaca (get_tile "sirkaRamuOdvodnovaca"))
  (setq i_a (atof sirkaRamuOdvodnovaca))
  
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
        (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.045)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.042)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.038)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.035)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.030)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.027)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.023)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.020)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.015)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm"))
        (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.012)) (setq typNavrhovanehoOdvodnova "Odvodnovac 300x300 mm")) 
      )  
    )
    (if (<= p_v_ciarka 1.5)
      ;ak je podmienka splnena
      (progn
        (cond
          (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.1) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.2) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.3) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.4) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.5) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.6) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.7) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.8) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 0.9) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 1.0) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 1.1) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 1.1) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 1.2) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 1.2) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 1.3) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 1.3) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 1.4) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 1.4) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
          (if (and (<= p_v_ciarka 1.5) (<= p_h_ciarka_1 0.06)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x300 mm") (if (and (<= p_v_ciarka 1.5) (<= p_h_ciarka_1 0.075)) (setq typNavrhovanehoOdvodnova "Odvodnovac 500x500 mm")))
        )
      )
      ;ak je podmienka nesplnena
      (alert "Rychlost vody na povrchu je priliz velka, prosim zmente vstupne parametre.")
    )
  )
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