(defun C:JTRebarLength()
  
  ;definovanie listu betonov
  (setq BetonList (list "C12/15" "C16/20" "C20/25" "C25/30" "C30/37" "C35/45" "C40/50" "C45/55" "C50/60" "C55/67" "C60/75" "C70/85" "C80/95" "C90/105"))
  (setq TriedaBetonuList (list "1,10" "1,30" "1,50" "1,80" "2,00" "2,20" "2,50" "2,70" "2,90" "3,00" "3,10" "3,20" "3,40" "3,50"))
  
  ;definovanie listu ocele
  (setq OcelList (list "B500" "B550"))
  (setq TriedaOcelList (list "500" "550"))
  
  ;definovanie listu priemeru ocele
  (setq PriemerOceleList (list "6" "7" "8" "10" "12" "14" "16" "18" "20" "22" "25" "26" "28" "30" "32"))
  
  ;definovanie listu situacie pouzitia
  (setq SituaciaPouzitiaList (list "Trvale a docacne" "Mimoriadne"))
  (setq ParcialnySituaciaPouzitiaBetonList (list "1,50" "1,20"))
  (setq ParcialnySituaciaPouzitiaOcelList (list "1,15" "1,00"))
  
  ;definovanie listu podmienok sudrznosti
  (setq PodmienkySudrznostiList (list "Dobre" "Ostatne"))
  (setq KvalitaPodmienkySudrznostiList (list "1,00" "0,70"))
  
  ;definovanie listu percenta stykovanej vystuze
  (setq PercentoStykovanejVystuzeList (list "<25%" "33%" "50%" ">50%"))
  (setq SucinitelPercentoStykovanejVystuzeList (list "1,00" "1,15" "1,40" "1,50"))
  
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
    "(done_dialog)(setq userclick nil)"
  )
  
  ;definovanie tlacidla vypocitj
  (action_tile "vypocitaj"
    "(VypocetDlzky)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
  
  ;vyhodnotenie spustenia podla vyberu tlacidla
  (if userclick
    (alert (strcat i_fctk5 "+" i_fyk "+" i_fi "+" i_gamac "+" i_gamas "+" i_eta1 "+" i_alfa6))
  )
  
  (princ)
             
)



(defun VypocetDlzky ()
  ;definovanie premennych z dialogu
  (setq triedaBetonu (get_tile "triedaBetonu"))
  (setq i_fctk5 (nth (atoi triedaBetonu) TriedaBetonuList))
  
  (setq triedaOcele (get_tile "triedaOcele"))
  (setq i_fyk (nth (atoi triedaOcele) TriedaOcelList))
  
  (setq priemerOcele (get_tile "priemerOcele"))
  (setq i_fi (nth (atoi priemerOcele) PriemerOceleList))
  
  (setq situaciaPouzitia (get_tile "situaciaPouzitia"))
  (setq i_gamac (nth (atoi situaciaPouzitia) ParcialnySituaciaPouzitiaBetonList))
  (setq i_gamas (nth (atoi situaciaPouzitia) ParcialnySituaciaPouzitiaOcelList))
  
  (setq podmienkySudrznosti (get_tile "podmienkySudrznosti"))
  (setq i_eta1 (nth (atoi podmienkySudrznosti) KvalitaPodmienkySudrznostiList))
  
  (setq percentoStykovanejVystuze (get_tile "percentoStykovanejVystuze"))
  (setq i_alfa6 (nth (atoi percentoStykovanejVystuze) SucinitelPercentoStykovanejVystuzeList))
  
  ;(VypocetPresahov)
  ;(VypocetKotvenia x x x)
  
  ;zavretie dialogu
  (done_dialog)
  ;nastavenie userclick na true
  (setq userclick T)
)



;(defun VypocetPresahov ())



;(defun VypocetKotvenia (x x x))