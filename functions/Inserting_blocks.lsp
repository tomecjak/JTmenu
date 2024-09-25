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
;;                             Podporne funkcie                         ;;
;; Funkcia pre vytvarania hladin v modeli Nazov + farba + typ ciary     ;;
;; + hrubka ciary                                                       ;;
;;----------------------------------------------------------------------;;
(defun CreateLayers(lyrname Color ltype lweight)

  (if (tblsearch "LAYER" lyrname)
    (command "._Layer" "_Thaw" lyrname "_On" lyrname "_UnLock" lyrname "_Set" lyrname "")
    (command "._Layer" "_Make" lyrname "_Color"
      (if (or (null color)(= Color "")) "_White" Color)
      lyrname "LT" (if (or (null ltype)(= ltype "")) "Continuous" ltype)
      lyrname "LW" (if (or (null lweight)(= lweight "")) "default" lweight) lyrname ""
    )
  )
)

;;----------------------------------------------------------------------;;
;;                   Nastavenie hladiny Prefix_Popis                    ;;
;;----------------------------------------------------------------------;;
(defun SetLayerPrefixPopis()
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Popis") 7 "CONTINUOUS" "DEFAULT")
  ;nastavenie hladiny pre blok pomocou GlobalnaHladinaBlokov nastavena v Setting.lsp
  (command "._layer" "s" (strcat (getenv "GlobalnaPrefixHladiny") "Popis") "")
  
  ;vytvorenie group layer filtru Prefix Layers 
  (setq GroupPrefix (strcat (getenv "GlobalnaPrefixHladiny") "*,0,Defpoints," (getenv "GlobalnaPrefixHladinyNew") "*"))
  (command "_.LAYER" "_FILTER" "_Delete" (strcat (getenv "GlobalnaPrefixHladiny") "Layers") "")
    (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" GroupPrefix (strcat (getenv "GlobalnaPrefixHladiny") "Layers"))
    (if (> (getvar 'CMDACTIVE) 0) (command "")) 
)

;;----------------------------------------------------------------------;;
;;                  Nastavenie hladiny Prefix_Vystuz                    ;;
;;----------------------------------------------------------------------;;
(defun SetLayerPrefixVystuz()
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz") 7 "CONTINUOUS" "DEFAULT")
  ;nastavenie hladiny pre blok pomocou GlobalnaHladinaBlokov nastavena v Setting.lsp
  (command "._layer" "s" (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz") "")
  
  ;vytvorenie group layer filtru Prefix Layers 
  (setq GroupPrefix (strcat (getenv "GlobalnaPrefixHladiny") "*,0,Defpoints," (getenv "GlobalnaPrefixHladinyNew") "*"))
  (command "_.LAYER" "_FILTER" "_Delete" (strcat (getenv "GlobalnaPrefixHladiny") "Layers") "")
    (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" GroupPrefix (strcat (getenv "GlobalnaPrefixHladiny") "Layers"))
    (if (> (getvar 'CMDACTIVE) 0) (command ""))
)

;;----------------------------------------------------------------------;;
;;               Navrat na poslednu nastavenu hladinu                   ;;
;;----------------------------------------------------------------------;;

(defun NavratNaPoslednuHladinu()

  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (command "_.layerp")
  (command "_-layer" "_filter" "_set" "All" "")

)

;;----------------------------------------------------------------------;;
;;                Vyhodnotenie GlovalnaHladinaBlokov                    ;;
;;----------------------------------------------------------------------;;
(defun LayerSetting()
  ;vytvorenie premenej VytvorenieHladinyPopisu pre vyber hladiny pre vlozene bloky
  (setq VytvorenieHladinyPopisu
    (getenv "GlobalnaHladinaBlokov")
  )
  
  ;vyhodnotenie vyberu hladiny pre bloky
  (if (= VytvorenieHladinyPopisu (strcat (getenv "GlobalnaPrefixHladiny") "Popis"))
    ;vytvorenie a nastavenie hladinu na DP_Popis
    (SetLayerPrefixPopis)
  
    (if (= VytvorenieHladinyPopisu "0")
    ;bez vytvorenia hladiny a nastavenie na hladinu 0
    (command "._layer" "s" "0" "")
    (princ)
    )
  )
)

;;----------------------------------------------------------------------;;
;;                    Rescale symbol from milimeter                     ;;
;;----------------------------------------------------------------------;;

(defun ScaleRefactorToMeter()
  (if (= (getvar "INSUNITS") 4)
    (setq Refactor 1000)
    (setq Refactor 1)
  )
)

;;----------------------------------------------------------------------;;
;;                             Bloky do Modelu                          ;;
;;----------------------------------------------------------------------;;

;vlozenie bloku Smer
(defun c:JTDirection ()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku Smer
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "Smer" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "Smer" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  (princ "\nUrcite bod vlozenia znacky smeru:")
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Smer2
(defun c:JTDirection2 ()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku Smer2
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "Smer2" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "Smer2" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky smeru:")
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku SmerToku
(defun c:JTWaterDirection ()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku SmerToku
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "SmerToku" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "SmerToku" "_S" (* (getvar "dimscale") 20) "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky smeru toku:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vlozenie bloku Smer
(defun c:JTSymmetry ()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku Smer
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "SymbolSymetrie" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "SymbolSymetrie" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  (princ "\nUrcite bod vlozenia znacky symetrie:")
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku NazovPohladu
(defun c:JTViewName()
  
  ;nastavenie hladiny
  (LayerSetting)
  
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

  ;prikaz na vlozenie blocku NazovPohladu
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" blockType "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" blockType "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky pohladu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku NazovPohladuNAsic
(defun c:JTViewNameBasic()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku RezZvisly
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "NazovPohladuBasic" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "NazovPohladuBasic" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky rezu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZvisly
(defun c:JTSectionVertical()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku RezZvisly
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "RezZvisly" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "RezZvisly" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky rezu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezVodorovny
(defun c:JTSectionHorizontal()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku RezVodorovny
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "RezVodorovny" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "RezVodorovny" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky rezu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZlom
(defun c:JTSectionBreak()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku RezZlom
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "RezZlom" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "RezZlom" "_S" (* (getvar "dimscale") 20) "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky rezu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku ZarovnanyText
(defun c:JTAlignedText()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku ZarovnanyText
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "ZarovnanyText" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "ZarovnanyText" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky zarovnaneho textu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Text z bodom
(defun c:JTDotText()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku TextZBodom
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "TextZBodom" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "TextZBodom" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky text z bodom:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Sklon
(defun c:JTSlopeSymbol()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku Sklon
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "Sklon" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "Sklon" "_S" (* (getvar "dimscale") 20) "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky sklonu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Symbol Osi
(defun c:JTAxisSymbol()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku SymbolOsi
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "SymbolOsi" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "SymbolOsi" "_S" (* (getvar "dimscale") 30) "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky symbolu osi:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Symbol Detailu
(defun c:JTDetailSymbol()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku SymbolDetailu
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "SymbolDetailu" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "SymbolDetailu" "_S" (* (getvar "dimscale") 30) "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky symbolu detailu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                         Bloky pre vytycenie                          ;;
;;----------------------------------------------------------------------;;

;vloženie bloku Point Block
(defun c:JTPointBlock()
  
  ;nastavenie hladiny
  (LayerSetting)
    
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku OznacenieBodu
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "OznacenieBodu" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
      (command "._insert" "OznacenieBodu" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
    
  (princ "\nUrcite bod vlozenia znacky vysky bodu:")
      
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;vloženie bloku Vyska bodu
(defun c:JTPointHeight()

  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku VyskaBodu
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "VyskaBodu" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "VyskaBodu" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky vysky bodu:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)

  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Tabulka vysok
(defun c:JTHeightTable()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku TabulkaVysok
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "TabulkaVysok" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "TabulkaVysok" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky tabulka vysok:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Hektometricka siet
(defun c:JTHectometricNetwork()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku HectometricNetwork
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "HectometricNetwork" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "HectometricNetwork" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky hektometrickej siete:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku znacka loziska
(defun c:JTBearingSymbol()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku ZnackaLoziska
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "ZnackaLoziska" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "ZnackaLoziska" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky loziska:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku geodetickej znacky
(defun c:JTGeodeticMark()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku GeodetickaZnacka
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "GeodetickaZnacka" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "ZGeodetickaZnacka" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia geodetickej znacky:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku znacky konca valca
(defun c:JTCylinderEnd()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie znacky konca valca
  (command "._insert" "SymbolUkoncenieValca" "_S" 1 "_R" 0 pause)
  (princ "\nUrcite bod vlozenia blocku znacky:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                           Bloky do Layoutu                           ;;
;;----------------------------------------------------------------------;;

;vloženie bloku Tabuľku materiálov
(defun c:JTTabMaterial()
  
  ;nastavenie hladiny
  (LayerSetting)
  
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
  
  ;nastavenie funkcnosti prikazu len v Layoute
  (cond
    ((/= 1 (getvar 'cvport))
      (alert "\nPrikaz nie je dostupny v modelovom priestore.")
    )

    (
      ;prikaz na vlozenie blocku TabulkaMaterialov
      (command "._insert" blockType "_S" 1 "_R" 0 pause)  
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Tabuľku ohybov
(defun c:JTTabBends()
  
  ;nastavenie hladiny
  (LayerSetting)
  
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
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Poznámok
(defun c:JTNote()
  
  ;nastavenie hladiny
  (LayerSetting)
  
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
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                      Bloky pre vystuzovanie                          ;;
;;----------------------------------------------------------------------;;


;vloženie bloku Vystuz
(defun c:JTRebarDescription()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)

  ;prikaz na vlozenie blocku vystuze
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "PopisVystuze" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "PopisVystuze" "_S" (* (getvar "dimscale") 20) "_R" 0 pause)
    )
  )
  
  (princ "\nUrcite bod vlozenia blocku vystuze:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;


;vloženie bloku Popisu vystuze
(defun c:JTRebarMark()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)
  
  ;vytvrenie premenej VyberJTOznacenieVystuze pre vyber moznosi
  (setq VyberJTOznacenieVystuze
    (getstring "\nAku znacku pouzit? [Vystus/Kari siet] <Vystuz>: ")
  )
  
  ;vyhodnotenie vyberu UCS pred prikazom
  (if (or (= VyberJTOznacenieVystuze "") (= VyberJTOznacenieVystuze "V") (= VyberJTOznacenieVystuze "v")) 
      ;prikaz na vlozenie blocku symbolu Popis vystuze
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
        (command "._insert" "OznacenieVystuze" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
      (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "OznacenieVystuze" "_S" (* (getvar "dimscale") 20) "_R" 0 pause)
      )
    )
    
    (if (or (= VyberJTOznacenieVystuze "K") (= VyberJTOznacenieVystuze "k"))
        ;prikaz na vlozenie blocku symbolu Popis kari siete
        (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "OznacenieVystuzeKari" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
          (command "._insert" "OznacenieVystuzeKari" "_S" (* (getvar "dimscale") 20) "_R" 0 pause)
        )
        )     
    )
  )
   
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Vystuz
(defun c:JTRebar()
  
  ;nastavenie hladiny
  (SetLayerPrefixVystuz)

  ;prikaz na vlozenie blocku vystuze
  (command "._insert" "Vystuz" "_S" 1 "_R" 0 pause)
  (princ "\nUrcite bod vlozenia blocku vystuze:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Spony vystuze
(defun c:JTRebarClip()
  
  ;nastavenie hladiny
  (SetLayerPrefixVystuz)

  ;prikaz na vlozenie blocku vystuze
  (command "._insert" "VystuzSpona" "_S" 1 "_R" 0 pause)
  (princ "\nUrcite bod vlozenia blocku spony vystuze:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
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