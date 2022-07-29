;=========================================================================
; Drawing_crosses.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 1.0
;-------------------------------------------------------------------------


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
  (command "-layer" "s" "DP_Popis" "")
)

;vlozenie krizikov do vykreu
(defun c:DC ()
  (SetLayer)
  (prompt "\nUrcite bod vlozenia znacky smeru:")
  (command "_insert" "DPKriziky" "0,0" (getvar "dimscale")(getvar "dimscale") 0)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\n:: Drawing_crosses.lsp | Version 1.0 | Vyrobil: Jakub Tomecko "
        (menucmd "m=$(edtime,0,yyyy) ::")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;