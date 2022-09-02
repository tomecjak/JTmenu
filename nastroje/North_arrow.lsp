;=========================================================================
; North_arrow.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
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
  (CreateLayers "DP_Popis" 7 "CONTINUOUS" "DEFAULT")
  (command "._layer" "s" "DP_Popis" "")
  
  ;vytvorenie group layer filtru DP Layers  
  (command "_.LAYER" "_FILTER" "_Delete" "DP Layers" "")
  (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" "0,Defpoints,DP_*,NS_*" "DP Layers")
  (if (> (getvar 'CMDACTIVE) 0) (command "")) 
)

;-------------------------------------------------------------------------

;vlozenie bloku Severka
(defun c:NorthArrow ()
  
  ;nastavenie hladiny
  (SetLayer)
  
  ;prikaz na vlozenie blocku severky
  (command "._insert" "DPSeverka" "_S" (getvar "dimscale") "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) )
  (princ "\nUrčite bod vloženia značky severky.")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\nNorth_arrow.lsp | beta | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;