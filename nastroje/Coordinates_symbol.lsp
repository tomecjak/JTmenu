;=========================================================================
; Coordinates_symbol.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
;
; Vlozenie blocku suradnic
;-------------------------------------------------------------------------

;;------------------=={ Vlozenie blocku suradnic }==--------------------;;
;;                                                                      ;;
;;  Tento program umoznuje vlozit block suradnic do autocadu. Suradnice ;;
;;  su autmaticky priradene a aktualizovane podla UCS World. Zdrojovy   ;;
;;  blok sa taha z priecinku "bloky". Pri vlozeni blocku sa automaticky ;;
;;  vytvori hladina, ktora sa zaradi do skupiny hladin                  ;;
;;  s nazvom "DP Layers".                                               ;;
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

;funkcia pre nastavenie hladiny DP_Popis
(defun SetLayer()
  (CreateLayers "DP_Popis" 7 "CONTINUOUS" "DEFAULT")
  ;nastavenie hladiny pre blok pomocou GlobalnaHladinaBlokov nastavena v Setting.lsp
  (command "._layer" "s" "DP_Popis" "")
  
  ;vytvorenie group layer filtru DP Layers  
  (command "_.LAYER" "_FILTER" "_Delete" "DP Layers" "")
  (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" "0,Defpoints,DP_*,NS_*" "DP Layers")
  (if (> (getvar 'CMDACTIVE) 0) (command "")) 
)

;-------------------------------------------------------------------------

;vlozenie bloku Suradnice
(defun c:Coordinates ()
  
  ;vytvorenie premenej VytvorenieHladinyPopisu pre vyber hladiny pre vlozene bloky
  (setq VytvorenieHladinyPopisu
    (getenv "GlobalnaHladinaBlokov")
  )
  
  ;vyhodnotenie vyberu hladiny pre bloky
  (if (= VytvorenieHladinyPopisu "DP_Popis")
    ;vytvorenie a nastavenie hladinu na DP_Popis
    (SetLayer)
  
    (if (= VytvorenieHladinyPopisu "0")
    ;bez vytvorenia hladiny a nastavenie na hladinu 0
    (command "._layer" "s" "0" "")
    (princ)
    )
  )
  
  ;prikaz na vlozenie blocku suradnic
  (command "._insert" "DPSuradnice" "_S" (getvar "dimscale") "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) )
  (princ "\nUrčite bod vloženia značky súradníc.")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nAuto_block_break.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;