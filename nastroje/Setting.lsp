;=========================================================================
; Setting.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Nastavenie pre JTmenu
;-------------------------------------------------------------------------

(defun C:JTsetting()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Setting.dcl"))
  
  ;test existencie dialogu
  (if (not (new_dialog "Setting" dcl_id))
    (exit)
  )
  
  ;nastavenie prepinaca hladin dialogu podla GlobalnaHladinaBlokov
  (if (= (getenv "GlobalnaHladinaBlokov") "DP_Popis")
    ;splnena podmienka
    (set_tile "hladinaDpPopis" "1")
    ;nesplnena podmienka
    (set_tile "hladinaNula" "1")
  )
  
  ;nastavenie prepinaca modov dialogu podla GlobalnaDIMSCALEset
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
    ;splnena podmienka
    (set_tile "modKlasicky" "1")
    ;nesplnena podmienka
    (set_tile "modDimscale" "1")
  )
  
  ;nastavenie prepinaca modov dialogu podla GlobalnaKotyDIMSCALEset
  (if (= (getenv "GlobalnaKotyDIMSCALEset") "Klasicky")
    ;splnena podmienka
    (set_tile "modKotyKlasicky" "1")
    ;nesplnena podmienka
    (set_tile "modKotyDimscale" "1")
  )
  
  ;nacitanie verzie JTmenu do dialogu
  (set_tile "verziaJtMenu" (JTmenuVersion))
  
  ;definovanie tlacidla cancel
  (action_tile "cancel"
    "(done_dialog)"
  )
  
  ;definovanie tlacidla ulozit
  (action_tile "ulozit"
    "(UlozitNastavenia)(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
  
  ;vyhodnotenie vyberu hladiny pre bloky
  (if (= hladinaDpPopis "1")
    ;nastavenie hladinu na DP_Popis
    (setenv "GlobalnaHladinaBlokov" "DP_Popis")
  
    (if (= hladinaNula "1")
      ;nastavenie hladinu na O
      (setenv "GlobalnaHladinaBlokov" "0")
      (princ)
    )
  )
  
  ;vyhodnotenie vyberu modu pre bloky
  (if (= modKlasicky "1")
    ;nastavenie modu na Klasicky
    (setenv "GlobalnaDIMSCALEset" "Klasicky")
  
    (if (= modDimscale "1")
      ;nastavenie modu na Mierka
      (setenv "GlobalnaDIMSCALEset" "Mierka")
      (princ)
    )
  )
  
  ;vyhodnotenie vyberu modu pre bloky
  (if (= modKotyKlasicky "1")
    ;nastavenie modu na Klasicky
    (setenv "GlobalnaKotyDIMSCALEset" "Klasicky")
  
    (if (= modKotyDimscale "1")
      ;nastavenie modu na Mierka
      (setenv "GlobalnaKotyDIMSCALEset" "Mierka")
      (princ)
    )
  )
  
  ;hlaska o nastavenych parametroch
  (princ (strcat "\nNastavily ste hladinu " (getenv "GlobalnaHladinaBlokov") " pre vkladane bloky!"
                 "\nNastavily ste mod na " (getenv "GlobalnaDIMSCALEset") " pre vkladane bloky!"
                 "\nNastavily ste mod na " (getenv "GlobalnaKotyDIMSCALEset") " pre generovane koty!"))
  
  (princ)

)

;funkcia ulozenia nastavenia
(defun UlozitNastavenia ()
  (setq hladinaDpPopis (get_tile "hladinaDpPopis"))
  (setq hladinaNula (get_tile "hladinaNula"))
  (setq modKlasicky (get_tile "modKlasicky"))
  (setq modDimscale (get_tile "modDimscale"))
  (setq modKotyKlasicky (get_tile "modKotyKlasicky"))
  (setq modKotyDimscale (get_tile "modKotyDimscale"))
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nSetting.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
