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
    ;(SetLayerPrefixPopis)
    (progn
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
        (command "._layer" "s" "0" "")
      )
      (princ)
    )
  
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

;vlozenie bloku Smer (vertical)
(defun c:JTDirection ()
  
  ;nastavenie hladiny
  (LayerSetting)

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Smer z JTMenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "Smer" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "Smer" "_S" (getvar "dimscale") "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky smeru:")
    )
    ;prikaz na vlozenie blocku DPP_Smer_Z z DPPtools
    (progn
      (command "._-insert" "DPP_Smer_Z" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Smer_Z!")
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Smer2 (horizontal)
(defun c:JTDirection2 ()
  
  ;nastavenie hladiny
  (LayerSetting)

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Smer2 z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "Smer2" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "Smer2" "_S" (getvar "dimscale") "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky smeru:")
    )
    ;prikaz na vlozenie blocku DPP_Smer_V z DPPtools
    (progn
      (command "._-insert" "DPP_Smer_V" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Smer_V!")
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku SmerToku
(defun c:JTWaterDirection ()
  
  ;nastavenie hladiny
  (LayerSetting)

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku SmerToku z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "SmerToku" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "SmerToku" "_S" (* (getvar "dimscale") 1) "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky smeru toku:")
    )
    ;prikaz na vlozenie blocku DDP_Smet_T z DPPtools
    (progn
      (command "._-insert" "DPP_Smer_T" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Smer_T!")
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vlozenie bloku Smer
(defun c:JTSymmetry ()
  
  ;nastavenie hladiny
  (LayerSetting)
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Smer
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "SymbolSymetrie" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "SymbolSymetrie" "_S" (getvar "dimscale") "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky symetrie:")
    )
     ;prikaz na vlozenie blocku DPP_Symetria z DPPtools
    (progn
      (command "._-insert" "DPP_Symetria" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Symetria!")
    )
  )   
    
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

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku NazovPohladu z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" blockType "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" blockType "_S" (getvar "dimscale") "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky pohladu:")
    )
    ;prikaz na vlozenie blocku DPP_Nazov_pohladu z DPPtools
    (progn
      (princ "\nUrcite bod vlozenia znacky:")
      (command "._-insert" "DPP_Nazov_pohladu" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Nazov_pohladu!")
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZvisly
(defun c:JTSectionVertical()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku RezZvisly z JTMenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "RezZvisly" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "RezZvisly" "_S" (getvar "dimscale") "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky rezu:")
    )
    ;prikaz na vlozenie blocku DPP_Rez_zvisly z DPPtools
    (progn
      (command "._-insert" "DPP_Rez_zvisly" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Rez_zvisly!")
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezVodorovny
(defun c:JTSectionHorizontal()
  
  ;nastavenie hladiny
  (LayerSetting)

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku RezVodorovny z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "RezVodorovny" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "RezVodorovny" "_S" (getvar "dimscale") "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky rezu:")
    )
    ;prikaz na vlozenie blocku DPP_Rez_vodorovny z DPPtools
    (progn
      (command "._-insert" "DPP_Rez_vodorovny" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Rez_vodorovny!")
    )
  )
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZlom
(defun c:JTSectionBreak()
  
  ;nastavenie hladiny
  (LayerSetting)

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku RezZlom z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "RezZlom" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "RezZlom" "_S" (* (getvar "dimscale") 1) "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky rezu:")
    )
    ;prikaz na vlozenie blocku DPP_Rez_zlom z DPPtools
    (progn
      (command "._-insert" "DPP_Rez_zlom" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Rez_zlom!")
    )
  )
    
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

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku ZarovnanyText z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "ZarovnanyText" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "ZarovnanyText" "_S" (getvar "dimscale") "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky zarovnaneho textu:")
    )
    ;prikaz na vlozenie blocku DPP_Text_zarovnany z DPPtools
    (progn
      (command "._-insert" "DPP_Text_zarovnany" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Text_zarovnany!")
    )
  )
    
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

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku TextZBodom z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "TextZBodom" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "TextZBodom" "_S" (getvar "dimscale") "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky text z bodom:")
    )
    ;prikaz na vlozenie blocku DPP_Text_uzol z DPPtools
    (progn
      (command "._-insert" "DPP_Text_uzol" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Text_uzol!")
    )
  )
  
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
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku Sklon z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "Sklon" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "Sklon" "_S" (* (getvar "dimscale") 1) "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky sklonu:")
    )
    ;prikaz na vlozenie blocku DPP_Sipka_sklonu z DPPtools
    (progn
      (command "._-insert" "DPP_Sipka_sklonu" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Sipka_sklonu!")
    )
  )
    
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

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku SymbolOsi z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "SymbolOsi" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "SymbolOsi" "_S" (* (getvar "dimscale") 1) "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky symbolu osi:")
    )
    ;prikaz na vlozenie blocku DPP_Os_oznacenie z DPPtools
    (progn
      (command "._-insert" "DPP_Os_oznacenie" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Os_oznacenie!")
   )
  )

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

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku SymbolDetailu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "SymbolDetailu" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" "SymbolDetailu" "_S" (* (getvar "dimscale") 1) "_R" 0 pause)
        )
      )
      (princ "\nUrcite bod vlozenia znacky symbolu detailu:")
    )
    ;prikaz na vlozenie blocku DPP_Detail z DPPtools
    (progn
      (command "._-insert" "DPP_Detail" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Detail!")
    )
  )
  
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

  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie znacky konca valca
    (progn
      (command "._insert" "SymbolUkoncenieValca" "_S" 1 "_R" 0 pause)
      (princ "\nUrcite bod vlozenia blocku znacky:")
    )
    ;prikaz na vlozenie blocku DPP_Prerusenie_kruhove z DPPtools
    (progn
      (command "._-insert" "DPP_Prerusenie_kruhove" "_S" 1 "_R" 0 pause)
      (princ "Vlozeny symbol DPP_Prerusenie_kruhove!")
    )
  )
    
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
        (princ "Vlozeny symbol DPP_Tabulka_materialov!")
      )
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
          (princ "Vlozeny symbol DPP_Tabulka_ohybov!")
        )
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
        (princ "Vlozeny symbol DPP_Poznamky!")
      )
    )
  )
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;vloženie bloku Ochranné pásma
(defun c:JTProtectionZone()
  
  ;nastavenie hladiny
  (LayerSetting)
  
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
        (command "._insert" "PopisVystuze" "_S" (* (getvar "dimscale") 1) "_R" 0 pause)
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
   
  ;vytvorenie premenej VyberJTOznacenieVystuze
  (initget "Vystuz Kari_siet")
  (setq VyberJTOznacenieVystuze (getkword "\nAku znacku pouzit? [Vystuz/Kari_siet] <Vystuz>: "))
  (if (null VyberJTOznacenieVystuze) (setq VyberJTOznacenieVystuze "Vystuz"))
  
  (cond
    ((= VyberJTOznacenieVystuze "Vystuz")
      ;prikaz na vlozenie blocku symbolu Popis vystuze
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "OznacenieVystuze" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
          (command "._insert" "OznacenieVystuze" "_S" (* (getvar "dimscale") 1) "_R" 0 pause)
        )
      )
    )
    ((= VyberJTOznacenieVystuze "Kari_siet")
      ;prikaz na vlozenie blocku symbolu Popis kari siete
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "OznacenieVystuzeKari" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
          (command "._insert" "OznacenieVystuzeKari" "_S" (* (getvar "dimscale") 1) "_R" 0 pause)
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

;vloženie bloku Spony vystuze
(defun c:JTRebarClip2()
  
  ;nastavenie hladiny
  (SetLayerPrefixVystuz)

  ;prikaz na vlozenie blocku vystuze
  (command "._insert" "VystuzSpona2" "_S" 1 "_R" 0 pause)
  (princ "\nUrcite bod vlozenia blocku spony vystuze:")
    
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
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