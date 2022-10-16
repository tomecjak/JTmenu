;=========================================================================
; Vkladanie_blokov.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
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
;;                     Nastavenie hladiny DP_Popis                      ;;
;;----------------------------------------------------------------------;;
(defun SetLayerDPPopis()
  (CreateLayers "DP_Popis" 7 "CONTINUOUS" "DEFAULT")
  (command "._layer" "s" "DP_Popis" "")
  
  ;vytvorenie group layer filtru DP Layers 
  (command "_.LAYER" "_FILTER" "_Delete" "DP Layers" "")
  (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" "0,Defpoints,DP_*,NS_*" "DP Layers")
  (if (> (getvar 'CMDACTIVE) 0) (command "")) 
)

;;----------------------------------------------------------------------;;
;;                    Nastavenie hladiny DP_Vystuz                      ;;
;;----------------------------------------------------------------------;;
(defun SetLayerDPVystuz()
  (CreateLayers "DP_Vystuz" 7 "CONTINUOUS" "DEFAULT")
  (command "._layer" "s" "DP_Vystuz" "")
  
  ;vytvorenie group layer filtru DP Layers 
  (command "_.LAYER" "_FILTER" "_Delete" "DP Layers" "")
  (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" "0,Defpoints,DP_*,NS_*" "DP Layers")
  (if (> (getvar 'CMDACTIVE) 0) (command "")) 
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
  (if (= VytvorenieHladinyPopisu "DP_Popis")
    ;vytvorenie a nastavenie hladinu na DP_Popis
    (SetLayerDPPopis)
  
    (if (= VytvorenieHladinyPopisu "0")
    ;bez vytvorenia hladiny a nastavenie na hladinu 0
    (command "._layer" "s" "0" "")
    (princ)
    )
  )
)

;;----------------------------------------------------------------------;;
;;                             Bloky do Modelu                          ;;
;;----------------------------------------------------------------------;;

;vlozenie bloku Smer
(defun c:DPSmer ()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku Smer
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPSmer" "_S" 0.05 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPSmer" "_S" (getvar "dimscale") "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky smeru:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Smer2
(defun c:DPSmer2 ()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku Smer2
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPSmer2" "_S" 0.05 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPSmer2" "_S" (getvar "dimscale") "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky smeru:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku SmerToku
(defun c:DPSmerToku ()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku SmerToku
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPSmerToku" "_S" 1 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPSmerToku" "_S" (* (getvar "dimscale") 20) "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky smeru toku:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku NazovPohladu
(defun c:DPNazovPohladu()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku NazovPohladu
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPNazovPohladu" "_S" 0.05 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPNazovPohladu" "_S" (getvar "dimscale") "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky pohladu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZvisly
(defun c:DPRezZvisly()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku RezZvisly
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPRezZvisly" "_S" 0.05 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPRezZvisly" "_S" (getvar "dimscale") "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky rezu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezVodorovny
(defun c:DPRezVodorovny()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku RezVodorovny
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPRezVodorovny" "_S" 0.05 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPRezVodorovny" "_S" (getvar "dimscale") "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky rezu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZlom
(defun c:DPRezZlom()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku RezZlom
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPRezZlom" "_S" 1 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPRezZlom" "_S" (* (getvar "dimscale") 20) "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky rezu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku ZarovnanyText
(defun c:DPZarovnanyText()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku ZarovnanyText
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPZarovnanyText" "_S" 0.05 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPZarovnanyText" "_S" (getvar "dimscale") "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky zarovnaneho textu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Sklon
(defun c:DPSklon()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku ZarovnanyText
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPSklon" "_S" 1 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPSklon" "_S" (* (getvar "dimscale") 20) "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky sklonu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Sklon
(defun c:DPSymbolOsi()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku SymbolOsi
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "DPSymbolOsi" "_S" 1.5 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "DPSymbolOsi" "_S" (* (getvar "dimscale") 30) "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia znacky symbolu osi:")
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                           Bloky do Layoutu                           ;;
;;----------------------------------------------------------------------;;

;vloženie bloku Tabuľku materiálov
(defun c:DPTabMaterialov()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie funkcnosti prikazu len v Layoute
  (cond
    ((/= 1 (getvar 'cvport))
      (princ "\nPrikaz nie je dostupny v modelovom priestore.")
      (princ)
    )

    (
      ;prikaz na vlozenie blocku DPTabulkaMaterialov
      (command "._insert" "DPTabulkaMaterialov" "_S" 1 "_R" 0)
      (princ "\nUrcite bod vlozenia tabulky materialov:")
      (princ)
    )
  )
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Tabuľku ohybov
(defun c:DPTabOhybov()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie funkcnosti prikazu len v Layoute
  (cond
    ((/= 1 (getvar 'cvport))
      (princ "\nPrikaz nie je dostupny v modelovom priestore.")
      (princ)
    )

    (
      ;prikaz na vlozenie blocku DPTabulkaOhybov  
      (command "._insert" "DPTabulkaOhybov" "_S" 1 "_R" 0)
      (princ "\nUrcite bod vlozenia tabulky ohybov:")
      (princ)
    )
  )
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Poznámok
(defun c:DPPoznamka()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;nastavenie funkcnosti prikazu len v Layoute
  (cond
    ((/= 1 (getvar 'cvport))
      (princ "\nPrikaz nie je dostupny v modelovom priestore.")
      (princ)
    )

    (
      ;prikaz na vlozenie blocku DPPoznamka 
      (command "._insert" "DPPoznamka" "_S" 1 "_R" 0)
      (princ "\nUrcite bod vlozenia poznamky:")
      (princ)
    )
  )
  
)

;;----------------------------------------------------------------------;;
;;                      Bloky pre vystužovanie                          ;;
;;----------------------------------------------------------------------;;


;vloženie bloku Vystuz
(defun c:JTPopisVystuze()
  
  ;nastavenie hladiny
  (LayerSetting)

  ;prikaz na vlozenie blocku vystuze
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "JTPopisVystuze" "_S" 1 "_R" 0)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "JTPopisVystuze" "_S" (* (getvar "dimscale") 20) "_R" 0)
    )
  )
  
  (princ "\nUrcite bod vlozenia blocku vystuze:")
  (princ)
  
)

;;----------------------------------------------------------------------;;


;vloženie bloku Popisu vystuze
(defun c:JTOznacenieVystuze()
  
  ;nastavenie hladiny
  (LayerSetting)
  
  ;vytvrenie premenej VyberJTOznacenieVystuze pre vyber pouzivaneho UCS
  (setq VyberJTOznacenieVystuze
    (getstring "\nAku znacku pouzit? [Vystus/Kari siet] <Vystuz>: ")
  )
  
  ;vyhodnotenie vyberu UCS pred prikazom
  (if (or (= VyberJTOznacenieVystuze "") (= VyberJTOznacenieVystuze "V") (= VyberJTOznacenieVystuze "v")) 
      ;prikaz na vlozenie blocku symbolu Popis vystuze
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
        (command "._insert" "JTOznacenieVystuze" "_S" 1 "_R" 0)
      (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "JTOznacenieVystuze" "_S" (* (getvar "dimscale") 20) "_R" 0)
      )
    )
    
    (if (or (= VyberJTOznacenieVystuze "K") (= VyberJTOznacenieVystuze "k"))
        ;prikaz na vlozenie blocku symbolu Popis kari siete
        (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "JTOznacenieVystuzeKari" "_S" 1 "_R" 0)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
          (command "._insert" "JTOznacenieVystuzeKari" "_S" (* (getvar "dimscale") 20) "_R" 0)
        )
        )     
    )
  )
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Vystuz
(defun c:JTVystuz()
  
  ;nastavenie hladiny
  (SetLayerDPVystuz)

  ;prikaz na vlozenie blocku vystuze
  (command "._insert" "JTVystuz" "_S" 1 "_R" 0)
  (princ "\nUrcite bod vlozenia blocku vystuze:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nVkladanie_blokov.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;