;=========================================================================
; Drawing_crosses.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
;
; Vlozenie krizikov vykresu do layoutu
;-------------------------------------------------------------------------

;;-------------=={ Vlozenie krizikov vykresu do layoutu }==-------------;;
;;                                                                      ;;
;;  Tento program umoznuje vlozit kriziky vykresu do layautu autocadu   ;;
;;  Zdrojovy blok sa taha z priecinku "bloky". Pri vlozeni blocku sa    ;;
;;  automaticky vytvori hladina, ktora sa zaradi do skupiny hladin      ;;
;;  s nazvom "DP Layers".                                               ;;
;;----------------------------------------------------------------------;;

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
  
  ;vytvorenie group layer filtru DP Layers 
  (command "_.LAYER" "_FILTER" "_Delete" "DP Layers" "")
  (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" "0,Defpoints,DP_*,NS_*" "DP Layers")
  (if (> (getvar 'CMDACTIVE) 0) (command "")) 
)

;vlozenie krizikov do vykreu
(defun c:DC ()
  
  ;nastavenie hladiny
  (SetLayer)
  
  ;prikaz na vlozenie blocku krizikov
  (command "_insert" "DPKriziky" "0,0" (getvar "dimscale")(getvar "dimscale") 0)
  
  ;hlaska po skonceni programu
  (princ "\nKrížiky výkresu boli vložené. ")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\Drawing_crosses.lsp | beta | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;