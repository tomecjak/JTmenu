;=========================================================================
; North_arrow.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Vlozenie severky podla UCS World
;-------------------------------------------------------------------------

;;---------------=={ Vlozenie severky podla UCS World }==---------------;;
;;                                                                      ;;
;;  Tento program umoznuje vlozit severu do modelu a jej automaticke    ;;
;;  natocenie na sever podla UCS World.                                 ;;
;;----------------------------------------------------------------------;;

;Podporne funkcie
;funkcia pre vytvarania hladin v modeli Nazov + farba + typ ciary + hrubka ciary
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

;funkcia pre nastavenie hladiny DP_Popis a skupiny
(defun SetLayer()
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Popis") 7 "CONTINUOUS" "DEFAULT")
  ;nastavenie hladiny pre blok pomocou GlobalnaHladinaBlokov nastavena v Setting.lsp
  (command "._layer" "s" (strcat (getenv "GlobalnaPrefixHladiny") "Popis") "")
  
  ;vytvorenie group layer filtru DP Layers  
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
;;                    Rescale symbol from milimeter                     ;;
;;----------------------------------------------------------------------;;

(defun ScaleRefactorToMeter()
  (if (= (getvar "INSUNITS") 4)
    (setq Refactor 1000)
    (setq Refactor 1)
  )
)

;;----------------------------------------------------------------------;;



;vlozenie bloku Severka
(defun c:JTNorthArrow ()
  
  ;vytvorenie premenej VytvorenieHladinyPopisu pre vyber hladiny pre vlozene bloky
  (setq VytvorenieHladinyPopisu
    (getenv "GlobalnaHladinaBlokov")
  )
  
  ;vyhodnotenie vyberu hladiny pre bloky
  (if (= VytvorenieHladinyPopisu (strcat (getenv "GlobalnaPrefixHladiny") "Popis"))
    ;vytvorenie a nastavenie hladinu na DP_Popis
    (SetLayer)
    
    (if (= VytvorenieHladinyPopisu "0")
      ;bez vytvorenia hladiny a nastavenie na hladinu 0
      (command "._layer" "s" "0" "")
      (princ)
    )
  )
  
  ;nastavenie Rescalingu
  (ScaleRefactorToMeter)
  
  ;prikaz na vlozenie blocku severky
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "Severka" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) pause)
    
      (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "Severka" "_S" (* (getvar "dimscale") 20) "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) pause)
      )
  )
  
  (princ "\nUrcite bod vlozenia znacky severky.")
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nNorth_arrow.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;