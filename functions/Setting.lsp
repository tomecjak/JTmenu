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
  (if (= (getenv "GlobalnaHladinaBlokov") "Popis")
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
  (if (= (getenv "GlobalnaPrefixHladinySeparator") "NS_")
    ;splnena podmienka
    (set_tile "layerPrefixSeparator" "NS_")
    ;nesplnena podmienka
    (set_tile "layerPrefixSeparator" (getenv "GlobalnaPrefixHladinySeparator"))
  )
  
  ;nastavenie prepinaca modov dialogu pre bloky JTmenu alebo DPPtools
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;splnena podmienka
    (set_tile "blokyJTmenu" "1")
    ;nesplnena podmienka
    (set_tile "blokyDPPtools" "1")
  )
  
  ;nastavenie prepinaca modov vystuzovania
  (if (= (getenv "GlobalnaRebarType") "Layer")
    ;splnena podmienka
    (set_tile "rebarLayerType" "1")
    ;nesplnena podmienka
    (set_tile "rebarPolylineType" "1")
  )
  
  ;nastavenie prepinaca modov dlzky vystuze
  (if (= (getenv "GlobalnaRebarLegth") "Os")
    ;splnena podmienka
    (set_tile "rebarLengthAxis" "1")
    ;nesplnena podmienka
    (set_tile "rebarLengthFace" "1")
  )
    
  ;nastavenie prepinaca mierky vkladanych blokov GlobalnaBlocksScale
  (if (= (getenv "GlobalnaBlocksScale") "50")
    ;splnena podmienka
    (set_tile "blocksScale" "50")
    ;nesplnena podmienka
    (set_tile "blocksScale" (getenv "GlobalnaBlocksScale"))
  )
  
  ;nastavenie prepinaca mierky vkladanych blokov DZ GlobalnaSignBlocksScale
  (if (= (getenv "GlobalnaSignBlocksScale") "1000")
    ;splnena podmienka
    (set_tile "signBlocksScale" "1000")
    ;nesplnena podmienka
    (set_tile "signBlocksScale" (getenv "GlobalnaSignBlocksScale"))
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
    (if (= (getenv "GlobalnaKotyDIMSCALEset") "Mierka")
      ;splnena podmienka
      (set_tile "modKotyDimscale" "1")
      ;nesplnena podmienka
      (set_tile "modKotyAnnotation" "1")
    )
  )
  
  ;nacitanie verzie JTmenu do dialogu
  (set_tile "verziaJtMenu" (JTmenuVersion))
  
    ;definicnia tlacicla sieteVsetkyCiaryInfo
  (action_tile "about"
    "(About)"
  )
  
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
    (setenv "GlobalnaHladinaBlokov" "Popis")
  
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
  (if (/= vykresVypracoval "-")
    (setenv "GlobalnaPrefixHladinySeparator" layerPrefixSeparator)
    (setenv "GlobalnaPrefixHladinySeparator" "-")
  )

  ;vyhodnotenie vyberu modov pre bloky JTmenu alebo DPPtools
  (if (= blokyJTmenu "1")
    (setenv "GlobalnaBlocksType" "JTmenu")
    (setenv "GlobalnaBlocksType" "DPPtools")
  )
  
  ;vyhodnotenie vyberu modu pre vystuzovanie
  (if (= rebarLayerType "1")
    (setenv "GlobalnaRebarType" "Layer")
    (setenv "GlobalnaRebarType" "Polyline")
  )
  
  ;vyhodnotenie vyberu modu pre dlzku vystuze
  (if (= rebarLengthAxis "1")
    (setenv "GlobalnaRebarLegth" "Os")
    (setenv "GlobalnaRebarLegth" "Povrch")
  )
    
  ;vyhodnotenie vyberu modu pre mierku blokov
  (if (/= blocksScale "50")
    (setenv "GlobalnaBlocksScale" blocksScale)
    (setenv "GlobalnaBlocksScale" "50")
  )
  
  ;vyhodnotenie vyberu modu pre mierku blokov dopravneho znacenia
  (if (/= signBlocksScale "1000")
    (setenv "GlobalnaSignBlocksScale" signBlocksScale)
    (setenv "GlobalnaSignBlocksScale" "1000")
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
  
  ;vyhodnotenie vyberu modu pre koty
  (if (= modKotyKlasicky "1")
    ;nastavenie modu na Klasicky
    (setenv "GlobalnaKotyDIMSCALEset" "Klasicky")
  
    (if (= modKotyDimscale "1")
      ;nastavenie modu na Mierka
      (setenv "GlobalnaKotyDIMSCALEset" "Mierka")
      
      (if (= modKotyAnnotation "1")
        ;nastavenie modu na Annotation
        (setenv "GlobalnaKotyDIMSCALEset" "Annotation")
        (princ)
      )
    )
  )
  
  ;hlaska o nastavenych parametroch
  (princ (strcat "\nNastavily ste hladinu " (getenv "GlobalnaHladinaBlokov") " pre vkladane bloky!"
                 "\nNastavily ste prefix hladiny na: " (getenv "GlobalnaPrefixHladiny") "!"
                 "\nNastavily ste rozdelovac hladiny na: " (getenv "GlobalnaPrefixHladinySeparator") "!"
                 "\nNastavily ste typ " (getenv "GlobalnaBlocksType") " pre vkladane bloky!"
                 "\nNastavily ste mod pre vystuzovanie na: " (getenv "GlobalnaRebarType") "!"
                 "\nNastavily ste mod pre vystuzovanie na: " (getenv "GlobalnaRebarLegth") "!"
                 "\nNastavily ste mierku 1:" (getenv "GlobalnaBlocksScale") " pre vkladane bloky!"
                 "\nNastavily ste mierku 1:" (getenv "GlobalnaSignBlocksScale") " pre vkladane bloky dopravneho znacenia!"
                 "\nNastavily ste jazyk pre vkladane bloky na: " (getenv "GlobalnaBlocksLanguage") "!"
                 "\nNastavily ste mod na " (getenv "GlobalnaKotyDIMSCALEset") " pre generovane koty!"))
  (princ)
)

;funkcia ulozenia nastavenia
(defun UlozitNastavenia()
  (setq hladinaPrefixPopis (get_tile "hladinaPrefixPopis"))
  (setq hladinaNula (get_tile "hladinaNula"))
  (setq layerPrefix (get_tile "layerPrefix"))
  (setq layerPrefixSeparator (get_tile "layerPrefixSeparator"))
  (setq blokyJTmenu (get_tile "blokyJTmenu"))
  (setq blokyDPPtools (get_tile "blokyDPPtools"))
  (setq rebarLayerType (get_tile "rebarLayerType"))
  (setq rebarPolylineType (get_tile "rebarPolylineType"))
  (setq blocksScale (get_tile "blocksScale"))
  (setq rebarLengthAxis (get_tile "rebarLengthAxis"))
  (setq rebarLengthFace (get_tile "rebarLengthFace"))
  (setq signBlocksScale (get_tile "signBlocksScale"))
  (setq blocksLanguageSK (get_tile "blocksLanguageSK"))
  (setq blocksLanguageCZ (get_tile "blocksLanguageCZ"))
  (setq blocksLanguageEN (get_tile "blocksLanguageEN"))
  (setq modKotyKlasicky (get_tile "modKotyKlasicky"))
  (setq modKotyDimscale (get_tile "modKotyDimscale"))
  (setq modKotyAnnotation (get_tile "modKotyAnnotation"))
)

;funkcia tlacidla zatvorit
(defun UkoncenieNastavenia()
  (done_dialog)
  (princ "\nNastavenia zostali bez zmeny.\n")
  (exit)
)

;funkcia tlacidla about
(defun About ()
  
  ;nacitanie dialogoveho okna About
  (setq dcl_id1 (load_dialog "Setting.dcl"))
  
  ;test existencie dialogu About
  (if (not (new_dialog "About" dcl_id1))
    (exit)
  )
  
  ;definicia tlacidla zatvorit About
  (action_tile "zatvoritAbout"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id1)

)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
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
