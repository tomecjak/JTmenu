;=========================================================================
; Inserting_blocks.lsp
; Create by Jakub Tomecko
;
; Vkladanie roznych blockov do modelu a layoutu autocadu
;-------------------------------------------------------------------------

;;----=={ Vkladanie roznych blockov do modelu a layoutu autocadu }==----;;
;;                                                                      ;;
;;  Tento program umoznuje vkladat rozne bloky do modelu a layautu      ;;
;;  autocadu. Zdrojove bloky si tahaju z priecinku "bloky". Pri vlozeni ;;
;;  blocku sa automaticky vytvori hladina, ktora sa zaradi do skupiny   ;;
;;  hladin s nazvom "DP Layers".                                        ;;
;;----------------------------------------------------------------------;;

;;----------------------------------------------------------------------;;
;;                Vyhodnotenie GlovalnaHladinaBlokov                    ;;
;;----------------------------------------------------------------------;;

(defun LayerSetting ( / oldLayer VytvorenieHladinyPopisu rec lay found )
  (setq oldLayer (getvar "CLAYER"))
  (setq VytvorenieHladinyPopisu (getenv "GlobalnaHladinaBlokov"))
  (setq found nil)

  (cond
    ((= VytvorenieHladinyPopisu "Popis")
     (setq rec (tblnext "LAYER" T))
     (while (and rec (not found))
       (setq lay (cdr (assoc 2 rec)))
       (if (wcmatch (strcase lay) "*POPIS")
         (setq found lay)
       )
       (setq rec (tblnext "LAYER"))
     )
     (if found
       (setvar "CLAYER" found)
       (setvar "CLAYER" "0")
     )
    )

    ((= VytvorenieHladinyPopisu "0")
     (setvar "CLAYER" "0")
    )
  )

  oldLayer
)

;;----------------------------------------------------------------------;;
;;                             Bloky do Modelu                          ;;
;;----------------------------------------------------------------------;;

;vlozenie bloku Smer (vertical)
(defun c:JTDirection ()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Smer z JTMenu
    (progn
      (command "._insert" "Smer" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Smer_Z z DPPtools
    (progn
      (command "._-insert" "DPP_Smer_Z" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Smer2 (horizontal)
(defun c:JTDirection2 ()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Smer2 z JTmenu
    (progn
      (command "._insert" "Smer2" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Smer_V z DPPtools
    (progn
      (command "._-insert" "DPP_Smer_V" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku SmerToku
(defun c:JTWaterDirection ()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku SmerToku z JTmenu
    (progn
      (command "._insert" "SmerToku" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DDP_Smet_T z DPPtools
    (progn
      (command "._-insert" "DPP_Smer_T" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vlozenie bloku Smer
(defun c:JTSymmetry ()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Smer
    (progn
      (command "._insert" "SymbolSymetrie" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
     ;prikaz na vlozenie blocku DPP_Symetria z DPPtools
    (progn
      (command "._-insert" "DPP_Symetria" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )   
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku NazovPohladu
(defun c:JTViewName()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage
  (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
    ;splnena podmienka
    (setq blockType "NazovPohladuSVK")
      ;nesplnena podmienka
      (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
      ;splnena podmienka
      (setq blockType "NazovPohladuCZK")
      ;nesplnena podmienka
      (setq blockType "NazovPohladuENG")
      )
  )

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku NazovPohladu z JTmenu
    (progn
      (command "._insert" blockType "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Nazov_pohladu z DPPtools
    (progn
      (command "._-insert" "DPP_Nazov_pohladu" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZvisly
(defun c:JTSectionVertical()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku RezZvisly z JTMenu
    (progn
      (command "._insert" "RezZvisly" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Rez_zvisly z DPPtools
    (progn
      (command "._-insert" "DPP_Rez_zvisly" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezVodorovny
(defun c:JTSectionHorizontal()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku RezVodorovny z JTmenu
    (progn
      (command "._insert" "RezVodorovny" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Rez_vodorovny z DPPtools
    (progn
      (command "._-insert" "DPP_Rez_vodorovny" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZlom
(defun c:JTSectionBreak()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku RezZlom z JTmenu
    (progn
      (command "._insert" "RezZlom" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Rez_zlom z DPPtools
    (progn
      (command "._-insert" "DPP_Rez_zlom" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku ZarovnanyText
(defun c:JTAlignedText()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku ZarovnanyText z JTmenu
    (progn
      (command "._insert" "ZarovnanyText" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Text_zarovnany z DPPtools
    (progn
      (command "._-insert" "DPP_Text_zarovnany" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Text z bodom
(defun c:JTDotText()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku TextZBodom z JTmenu
    (progn
      (command "._insert" "TextZBodom" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Text_uzol z DPPtools
    (progn
      (command "._-insert" "DPP_Text_uzol" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Sklon
(defun c:JTSlopeSymbol()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
    
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Sklon z JTmenu
    (progn
      (command "._insert" "Sklon" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Sipka_sklonu z DPPtools
    (progn
      (command "._-insert" "DPP_Sipka_sklonu" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Symbol Osi
(defun c:JTAxisSymbol()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku SymbolOsi z JTmenu
    (progn
      (command "._insert" "SymbolOsi" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Os_oznacenie z DPPtools
    (progn
      (command "._-insert" "DPP_Os_oznacenie" "_S" 1 "_R" 0 pause)
      (princ)
   )
  )

  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Symbol Detailu
(defun c:JTDetailSymbol()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku SymbolDetailu
    (progn
      (command "._insert" "SymbolDetailu" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Detail z DPPtools
    (progn
      (command "._-insert" "DPP_Detail" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                         Bloky pre vytycenie                          ;;
;;----------------------------------------------------------------------;;

;vloženie bloku Point Block
(defun c:JTPointBlock()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku OznacenieBodu z JTmenu
    (progn
      (command "._insert" "OznacenieBodu" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku OznacenieBodu z DPPtools
    (progn
      (command "._insert" "DPP_Oznacenie_bodu" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
      
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;vloženie bloku Vyska bodu
(defun c:JTPointHeight()

  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku VyskaBodu
    (progn
      (command "._insert" "VyskaBodu" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku Vyskabodu z DPPtools
    (progn
      (command "._insert" "VyskaBodu" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )  
      
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)

  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Tabulka vysok
(defun c:JTHeightTable()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku TabulkaVysok
    (progn
      (command "._insert" "TabulkaVysok" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku TabulkaVysok z DPPtools
    (progn
      (command "._insert" "TabulkaVysok" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Hektometricka siet
(defun c:JTHectometricNetwork()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;prikaz na vlozenie blocku HectometricNetwork
  (command "._insert" "HectometricNetwork" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
  
  (princ)
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku znacka loziska
(defun c:JTBearingSymbol()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku ZnackaLoziska
    (progn
      (command "._insert" "ZnackaLoziska" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku ZnackaLoziska z DPPtools
    (progn
      (command "._insert" "ZnackaLoziska" "_S" 1 "_R" 0 pause)
      (princ)
    )
  ) 

  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku geodetickej znacky
(defun c:JTGeodeticMark()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku GeodetickaZnacka
    (progn
      (command "._insert" "GeodetickaZnacka" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku GeodetickaZnacka z DPPtools
    (progn
      (command "._insert" "GeodetickaZnacka" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )

  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku znacky konca valca
(defun c:JTCylinderEnd()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie znacky konca valca
    (progn
      (command "._insert" "SymbolUkoncenieValca" "_S" 1 "_R" 0 pause)
      (princ)
    )
    ;prikaz na vlozenie blocku DPP_Prerusenie_kruhove z DPPtools
    (progn
      (command "._-insert" "DPP_Prerusenie_kruhove" "_S" 1 "_R" 0 pause)
      (princ)
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                           Bloky do Layoutu                           ;;
;;----------------------------------------------------------------------;;

;vloženie bloku Tabuľku materiálov
(defun c:JTTabMaterial()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage
  (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
    ;splnena podmienka
    (setq blockType "TabulkaMaterialovSVK")
      ;nesplnena podmienka
      (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
      ;splnena podmienka
      (setq blockType "TabulkaMaterialovCZK")
      ;nesplnena podmienka
      (setq blockType "TabulkaMaterialovENG")
      )
  )
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku TabulkaMaterialov
    (progn
      ;nastavenie funkcnosti prikazu len v Layoute
      (cond
        ((/= 1 (getvar 'cvport))
          (alert "\nPrikaz nie je dostupny v modelovom priestore.")
        )
        (
          (command "._insert" blockType "_S" 1 "_R" 0 pause)  
        )
      )
    )
    ;prikaz na vlozenie blocku DPP_Tabulka_materialov z DPPtools
    (cond
      ((/= 1 (getvar 'cvport))
        (alert "\nPrikaz nie je dostupny v modelovom priestore.")
      )
      (progn
        (command "._-insert" "DPP_Tabulka_materialov" "_S" 1 "_R" 0 pause)
        (princ)
      )
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Tabuľku ohybov
(defun c:JTTabBends()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage
  (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
    ;splnena podmienka
    (setq blockType "TabulkaOhybovSVK")
      ;nesplnena podmienka
      (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
      ;splnena podmienka
      (setq blockType "TabulkaOhybovCZK")
      ;nesplnena podmienka
      (setq blockType "TabulkaOhybovENG")
      )
  )
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku TabulkaOhybov 
    (progn
      ;nastavenie funkcnosti prikazu len v Layoute
      (cond
        ((/= 1 (getvar 'cvport))
          (alert "\nPrikaz nie je dostupny v modelovom priestore.")
        )
        (
          ;prikaz na vlozenie blocku TabulkaOhybov  
          (command "._insert" blockType "_S" 1 "_R" 0 pause)
        )
      )
    )
      ;prikaz na vlozenie blocku DPP_Tabulka_ohybov z DPPtools
      (cond
        ((/= 1 (getvar 'cvport))
          (alert "\nPrikaz nie je dostupny v modelovom priestore.")
        )
        (progn
          (command "._-insert" "DPP_Tabulka_ohybov" "_S" 1 "_R" 0 pause)
          (princ)
        )
      )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Poznámok
(defun c:JTNote()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage
  (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
    ;splnena podmienka
    (setq blockType "PoznamkaSVK")
      ;nesplnena podmienka
      (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
      ;splnena podmienka
      (setq blockType "PoznamkaCZK")
      ;nesplnena podmienka
      (setq blockType "PoznamkaENG")
      )
  )
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Poznamka 
    ;nastavenie funkcnosti prikazu len v Layoute
    (cond
      ((/= 1 (getvar 'cvport))
        (alert "\nPrikaz nie je dostupny v modelovom priestore.")
      )
      (progn
        (
          (command "._insert" blockType "_S" 1 "_R" 0 pause)  
        )
      )
    )
    ;prikaz na vlozenie blocku DPP_Poznamky z DPPtools
    ;nastavenie funkcnosti prikazu len v Layoute
    (cond
      ((/= 1 (getvar 'cvport))
        (alert "\nPrikaz nie je dostupny v modelovom priestore.")
      )
      (progn
        (command "._-insert" "DPP_Poznamky" "_S" 1 "_R" 0 pause)
        (princ)
      )
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;vloženie bloku Ochranné pásma
(defun c:JTProtectionZone()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage
  (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
    ;splnena podmienka
    (setq blockType "OchrannePasmaSVK")
      ;nesplnena podmienka
      (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
      ;splnena podmienka
      (setq blockType "OchrannePasmaCZK")
      ;nesplnena podmienka
      (setq blockType "OchrannePasmaENG")
      )
  )
  
  ;nastavenie funkcnosti prikazu len v Layoute
  (cond
    ((/= 1 (getvar 'cvport))
      (alert "\nPrikaz nie je dostupny v modelovom priestore.")
    )

    (
      ;prikaz na vlozenie blocku Poznamka 
      (command "._insert" blockType "_S" 1 "_R" 0 pause)  
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                      Bloky pre vystuzovanie                          ;;
;;----------------------------------------------------------------------;;


;vloženie bloku Vystuz
(defun c:JTRebarDescription()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;prikaz na vlozenie blocku vystuze
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;vlozenie blocku z JTmenu
    (command "._insert" "PopisVystuze" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    ;vlozenie blocku z DPPtools
    (command "._insert" "PopisVystuze" "_S" 1 "_R" 0 pause)
  )
     
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;


;vloženie bloku Popisu vystuze
(defun c:JTRebarMark()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))

  ;vytvorenie premenej VyberJTOznacenieVystuze
  (initget "Vystuz KariSiet")
  (setq VyberJTOznacenieVystuze (getkword "\nAku znacku pouzit? [Vystuz/KariSiet] <Vystuz>: "))
  (if (null VyberJTOznacenieVystuze) (setq VyberJTOznacenieVystuze "Vystuz"))
  
  (cond
    ((= VyberJTOznacenieVystuze "Vystuz")
      ;prikaz na vlozenie blocku symbolu Popis vystuze
      (if (= (getenv "GlobalnaBlocksType") "JTmenu")
        ;vlozenie blocku z JTmenu
        (command "._insert" "OznacenieVystuze" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        ;vlozenie blocku z DPPtools
        (command "._insert" "OznacenieVystuze" "_S" 1 "_R" 0 pause)
      )
    )
    ((= VyberJTOznacenieVystuze "KariSiet")
      ;prikaz na vlozenie blocku symbolu Popis kari siete
      (if (= (getenv "GlobalnaBlocksType") "JTmenu")
        ;vlozenie blocku z JTmenu
        (command "._insert" "OznacenieVystuzeKari" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        ;vlozenie blocku z DPPtools
        (command "._insert" "OznacenieVystuzeKari" "_S" 1 "_R" 0 pause)
      )
    )
  )
   
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Vystuz
(defun c:JTRebar()
  
  ;prikaz na vlozenie blocku vystuze
  (command "._insert" "Vystuz" "_S" 1 "_R" 0 pause)
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Spony vystuze
(defun c:JTRebarClip()
  
  ;prikaz na vlozenie blocku vystuze
  (command "._insert" "VystuzSpona" "_S" 1 "_R" 0 pause)
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Spony vystuze
(defun c:JTRebarClip2()
  
  ;prikaz na vlozenie blocku vystuze
  (command "._insert" "VystuzSpona2" "_S" 1 "_R" 0 pause)
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nInserting_blocks.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;