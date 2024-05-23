;=========================================================================
; Setting.lsp
; Create by Jakub Tomecko
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
  (if (= (getenv "GlobalnaHladinaBlokov") (strcat (getenv "GlobalnaPrefixHladiny") "Popis"))
    ;splnena podmienka
    (set_tile "hladinaPrefixPopis" "1")
    ;nesplnena podmienka
    (set_tile "hladinaNula" "1")
  )
  
  ;nastavenie klasickeho prefixu hladiny
  (if (= (getenv "GlobalnaPrefixHladiny") "DP_")
    ;splnena podmienka
    (set_tile "layerPrefix" "DP_")
    ;nesplnena podmienka
    (set_tile "layerPrefix" (getenv "GlobalnaPrefixHladiny"))
  )
  
  ;nastavenie prefixu hladiny noveho stavu
  (if (= (getenv "GlobalnaPrefixHladinyNew") "NS_")
    ;splnena podmienka
    (set_tile "layerPrefixNew" "NS_")
    ;nesplnena podmienka
    (set_tile "layerPrefixNew" (getenv "GlobalnaPrefixHladinyNew"))
  )
  
  ;nastavenie prepinaca modov dialogu podla GlobalnaDIMSCALEset
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
    ;splnena podmienka
    (set_tile "modKlasicky" "1")
    ;nesplnena podmienka
    (set_tile "modDimscale" "1")
  )
  
  ;nastavenie prepinaca mierky vkladanych blokov GlobalnaBlocksScale
  (if (= (getenv "GlobalnaBlocksScale") "50")
    ;splnena podmienka
    (set_tile "blocksScale" "50")
    ;nesplnena podmienka
    (set_tile "blocksScale" (getenv "GlobalnaBlocksScale"))
  )
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage
  (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
    ;splnena podmienka
    (set_tile "blocksLanguageSK" "1")
      ;nesplnena podmienka
      (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
      ;splnena podmienka
      (set_tile "blocksLanguageCZ" "1")
      ;nesplnena podmienka
      (set_tile "blocksLanguageEN" "1")
      )
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
    "(UkoncenieNastavenia)"
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
  (if (= hladinaPrefixPopis "1")
    ;nastavenie hladinu na Prefix_Popis
    (setenv "GlobalnaHladinaBlokov" (strcat (getenv "GlobalnaPrefixHladiny") "Popis"))
  
    (if (= hladinaNula "1")
      ;nastavenie hladinu na O
      (setenv "GlobalnaHladinaBlokov" "0")
      (princ)
    )
  )
  
  ;vyhodnotenie nastavenie prefixu hladiny
  (if (/= vykresVypracoval "JT_")
    (setenv "GlobalnaPrefixHladiny" layerPrefix)
    (setenv "GlobalnaPrefixHladiny" "JT_")
  )
  
  ;vyhodnotenie nastavenie prefixu hladiny pre novy stav
  (if (/= vykresVypracoval "NS_")
    (setenv "GlobalnaPrefixHladinyNew" layerPrefixNew)
    (setenv "GlobalnaPrefixHladinyNew" "NS_")
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
  
  ;vyhodnotenie vyberu modu pre mierku blokov
  (if (/= blocksScale "50")
    (setenv "GlobalnaBlocksScale" blocksScale)
    (setenv "GlobalnaBlocksScale" "50")
  )
  
  ;vyhodnotenie vyberu jazyka pre bloky
  (if (= blocksLanguageSK "1")
    ;nastavenie jazyka SK
    (setenv "GlobalnaBlocksLanguage" "SVK")
  
    (if (= blocksLanguageCZ "1")
      ;nastavenie jazyka CZ
      (setenv "GlobalnaBlocksLanguage" "CZK")
      
      (if (= blocksLanguageEN "1")
      ;nastavenie jazyka EN
      (setenv "GlobalnaBlocksLanguage" "ENG")
      (princ)
      )
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
                 "\nNastavily ste prefix hladiny na: " (getenv "GlobalnaPrefixHladiny") "!"
                 "\nNastavily ste prefix hladyne pre novy stav na: " (getenv "GlobalnaPrefixHladinyNew") "!"
                 "\nNastavily ste mod na " (getenv "GlobalnaDIMSCALEset") " pre vkladane bloky!"
                 "\nNastavily ste mierku 1:" (getenv "GlobalnaBlocksScale") " pre vkladane bloky!"
                 "\nNastavily ste jazyk pre vkladane bloky na: " (getenv "GlobalnaBlocksLanguage") "!"
                 "\nNastavily ste mod na " (getenv "GlobalnaKotyDIMSCALEset") " pre generovane koty!"))
  
  (princ)

)

;funkcia ulozenia nastavenia
(defun UlozitNastavenia()
  (setq hladinaPrefixPopis (get_tile "hladinaPrefixPopis"))
  (setq hladinaNula (get_tile "hladinaNula"))
  (setq layerPrefix (get_tile "layerPrefix"))
  (setq layerPrefixNew (get_tile "layerPrefixNew"))
  (setq modKlasicky (get_tile "modKlasicky"))
  (setq modDimscale (get_tile "modDimscale"))
  (setq blocksScale (get_tile "blocksScale"))
  (setq blocksLanguageSK (get_tile "blocksLanguageSK"))
  (setq blocksLanguageCZ (get_tile "blocksLanguageCZ"))
  (setq blocksLanguageEN (get_tile "blocksLanguageEN"))
  (setq modKotyKlasicky (get_tile "modKotyKlasicky"))
  (setq modKotyDimscale (get_tile "modKotyDimscale"))
)

;funkcia tlacidla zatvorit
(defun UkoncenieNastavenia()
  (done_dialog)
  (princ "\nNastavenia zostali bez zmeny.\n")
  (exit)
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
