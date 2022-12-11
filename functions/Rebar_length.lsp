;=========================================================================
; Rebar_length.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Pocitanie dlzok kotvenia a presahu betonarskej vystuze
;-------------------------------------------------------------------------

(defun C:JTRebarLength()
  
  ;definovanie listu betonov
  (setq BetonList (list "C12/15" "C16/20" "C20/25" "C25/30" "C30/37" "C35/45" "C40/50" "C45/55" "C50/60" "C55/67" "C60/75" "C70/85" "C80/95" "C90/105"))
  (setq TriedaBetonuList (list "1.10" "1.30" "1.50" "1.80" "2.00" "2.20" "2.50" "2.70" "2.90" "3.00" "3.10" "3.20" "3.40" "3.50"))
  
  ;definovanie listu ocele
  (setq OcelList (list "B500" "B550"))
  (setq TriedaOcelList (list "500" "550"))
  
  ;definovanie listu priemeru ocele
  (setq PriemerOceleList (list "6" "7" "8" "10" "12" "14" "16" "18" "20" "22" "25" "26" "28" "30" "32"))
  
  ;definovanie listu situacie pouzitia
  (setq SituaciaPouzitiaList (list "Trvale a docacne" "Mimoriadne"))
  (setq ParcialnySituaciaPouzitiaBetonList (list "1.50" "1.20"))
  (setq ParcialnySituaciaPouzitiaOcelList (list "1.15" "1.00"))
  
  ;definovanie listu podmienok sudrznosti
  (setq PodmienkySudrznostiList (list "Dobre" "Ostatne"))
  (setq KvalitaPodmienkySudrznostiList (list "1.00" "0.70"))
  
  ;definovanie listu percenta stykovanej vystuze
  (setq PercentoStykovanejVystuzeList (list "<25%" "33%" "50%" ">50%"))
  (setq SucinitelPercentoStykovanejVystuzeList (list "1.00" "1.15" "1.40" "1.50"))
  
  ;definovanie vypoctovych hodnot (nemených)
  (setq alfacc 0.85) ;koeficient zohladnujuci vplyvy dlhodobych ucinkov na pevnost v tlaku
  (setq alfact 1.00) ;koeficient zohladnujuci vplyv dlhodobych ucinkov na pevnost v tahu
    
  (setq alfa1 1.00) ;sucinitel vplyvu tvaru za primeranej hrubky krytia
  (setq alfa2 1.00) ;sucinitel vplyvu minimalneho krytia
  (setq alfa3 1.00) ;sucinitel vplyvu ovinutia priecnou vystuzou neprivarenou k hlavnej vystuzi
  (setq alfa4 1.00) ;sucinitel vplyvu ovinutia priecnych privarenych prutov
  (setq alfa5 1.00) ;sucinitel vplyvu priecneho tlaku kolmeho na rovinu trhlin
  
  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Rebar_length.dcl"))

  ;test existencie dialogu
  (if (not (new_dialog "Rebar_length" dcl_id))
    (exit)
  )
  
  ;spustenie a naplnenie listu betonov
  (start_list "triedaBetonu")
  (mapcar 'add_list BetonList)
  (end_list)
  
  ;spustenie a naplnenie listu ocele
  (start_list "triedaOcele")
  (mapcar 'add_list OcelList)
  (end_list)
  
  ;spustenie a naplnenie listu priemeru ocele
  (start_list "priemerOcele")
  (mapcar 'add_list PriemerOceleList)
  (end_list)
  
  ;spustenie a naplnenie listu situacie pouzitia
  (start_list "situaciaPouzitia")
  (mapcar 'add_list SituaciaPouzitiaList)
  (end_list)
  
  ;spustenie a naplnenie listu podmienok sudrznosti
  (start_list "podmienkySudrznosti")
  (mapcar 'add_list PodmienkySudrznostiList)
  (end_list)  
  
  ;spustenie a naplnenie listu percenta stykovanej vystuze
  (start_list "percentoStykovanejVystuze")
  (mapcar 'add_list PercentoStykovanejVystuzeList)
  (end_list)  
  
  ;definovanie tlacidla cancel
  (action_tile "cancel"
    "(UkoncenieRebarLength)"
  )
  
  ;definovanie tlacidla vypocitaj
  (action_tile "vypocitaj"
    "(VypocetDlzky)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
 
  (princ)
             
)

;definovanie funkcie vypoctu dlzok vystuze
(defun VypocetDlzky ()
  ;definovanie premennych z dialogu
  ;charakteristicka pevnost betonu v tahu
  (setq triedaBetonu (get_tile "triedaBetonu"))
  (setq i_fctk5 (nth (atoi triedaBetonu) TriedaBetonuList))
  
  ;charakteristicka medza klzu vystuze
  (setq triedaOcele (get_tile "triedaOcele"))
  (setq i_fyk (nth (atoi triedaOcele) TriedaOcelList))
  
  ;priemer vystuze
  (setq priemerOcele (get_tile "priemerOcele"))
  (setq i_fi (nth (atoi priemerOcele) PriemerOceleList))
  
  ;parcialny sucinitel spolahlivosti pre beton a ocel
  (setq situaciaPouzitia (get_tile "situaciaPouzitia"))
  (setq i_gamac (nth (atoi situaciaPouzitia) ParcialnySituaciaPouzitiaBetonList))
  (setq i_gamas (nth (atoi situaciaPouzitia) ParcialnySituaciaPouzitiaOcelList))
  
  ;sucinitel zohladnujuci kvalitu podmienok sudrznosti
  (setq podmienkySudrznosti (get_tile "podmienkySudrznosti"))
  (setq i_eta1 (nth (atoi podmienkySudrznosti) KvalitaPodmienkySudrznostiList))
  
  ;percento stykovanej vystuze
  (setq percentoStykovanejVystuze (get_tile "percentoStykovanejVystuze"))
  (setq i_alfa6 (nth (atoi percentoStykovanejVystuze) SucinitelPercentoStykovanejVystuzeList))
  
  ;potrebna plocha vystuze (strana bezpecna)
  (setq potrebaPlochaVystuze (get_tile "potrebaPlochaVystuze"))
  (setq i_Asreq potrebaPlochaVystuze)
  
  ;navrhnuta pevnost betonarskej vystuze
  (setq navrhnutaPlochaVystuze (get_tile "navrhnutaPlochaVystuze"))
  (setq i_Aspor navrhnutaPlochaVystuze)
  
  ;vypocet navrhovej pevnosti betonu v tahu
  (setq fctd (/ (* alfact (atof i_fctk5)) (atof i_gamac)))
  
  ;vypocet sucinitela zavisleho od priemaru pruta
  (if (<= (atoi i_fi) 32)
    (setq i_eta2 1.0)
    (setq i_eta2 (/ (- 132 (atoi i_fi)) 100))
  )
  
  ;vypocet medzneho napatia
  (setq fbd (* 2.25 (atof i_eta1) i_eta2 fctd))
  
  ;vypocet navrhovanej pevnosti betonarksej vystuze
  (setq fyd (/ (atof i_fyk) (atof i_gamas)))
  
  ;vypocet napatia pruta v miestek odkial sa meria kotvenie
  (setq sigmasd (/ (* (atof i_Asreq) fyd) (atof i_Aspor)))
  
  ;zakladna kotevna dlzka
  (setq lbrqd (* (/ (/ (atof i_fi) 1000) 4) (/ sigmasd fbd)))
  
  ;funkcia pre vypocet dlzky kotvenia
  (VypocetKotvenia)
  
  ;funkcia pre vypocet dlzky presahu
  (VypocetPresahu)
  
  ;nastavanie hodnot pre vysledky
  (setq KotevnaDlzka (rtos KotevnaDlzka 2 2))
  (setq DlzaPresahu (rtos DlzaPresahu 2 2))
  (set_tile "kotevnaDlzka" KotevnaDlzka)
  (set_tile "dlzkaPresahu" DlzaPresahu)
)

;definovanie funkcie vypoctu kotvenia vystuze
(defun VypocetKotvenia ()
  ;zakladna kotevna dlzka v tahu
  (setq lbrqdTah (* 0.3 lbrqd))
  
  ;zakladna kotevna dlzka v tlaku
  (setq lbrqdTlak (* 0.6 lbrqd))
  
  ;10 nasobok priemeru vystuze
  (setq 10PriemerVystuz (* 10 (/ (atof i_fi) 1000)))
  
  ;100 milimetrov (minumum)
  (setq minMM 0.100)
  
  ;minimalna kotevna dlzka v tahu
  (setq lbminTah (max lbrqdTah 10PriemerVystuz minMM))
  
  ;minimalna kotevna dlzka v tlaku
  (setq lbminTlak (max lbrqdTlak 10PriemerVystuz minMM))
  
  ;navrhovana kotevna dlzka
  (setq KotevnaDlzka (* alfa1 alfa2 alfa3 alfa4 alfa5 lbrqd))

)

;definovanie funkcie vypoctu presahu vystuze
(defun VypocetPresahu ()
  ;navrhovana dlzka presahu
  (setq DlzaPresahu (* alfa1 alfa2 alfa3 alfa4 alfa5 (atof i_alfa6) lbrqd))
)

(defun UkoncenieRebarLength()
  (done_dialog)
  (princ "\nUkoncenie kalkulacky.\n")
  (exit)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nRebar_length.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;