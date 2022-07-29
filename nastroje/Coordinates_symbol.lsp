;=========================================================================
; Coordinates_symbol.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.1
;-------------------------------------------------------------------------

;Podpoerné funkcie
;funkcia pre vytvárania hladín v modeli Názov + farba + typ čiary + hrúbka čiary
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
  (command "._layer" "s" "DP_Popis" "")
)

;-------------------------------------------------------------------------

;vloženie bloku Súradnice
(defun c:Coordinates ()
  (SetLayer)
  (prompt "\nUrcite bod vlozenia znacky smeru:")
  (command "._insert" "DPSuradnice" "_S" (getvar "dimscale") "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) )
)