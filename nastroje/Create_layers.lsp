;=========================================================================
; Create_layers.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
;
; Vytvorenie DP hladin
;-------------------------------------------------------------------------

;;--------------------=={ Vytvorenie DP hladin }==----------------------;;
;;                                                                      ;;
;;  Tento program umoznuje vytvorit hladiny s prefixom DP_. Je mozne    ;;
;;  vytvorit tri typu hladin: zakaldne, vystuz alebo novy stav. Hladiny ;;
;;  sa automaticky zaradia do vytvorenej skupiny hladin "DP Layers".    ;;
;;----------------------------------------------------------------------;;

(defun c:CL ()
  
;definovanie chybovej hlasky v programe
(defun *error* (errmsg)
  (princ)
  (princ "\nProgram Create_layers.lsp sa ukončil. ")
  (terpri)
  (prompt errmsg)
  (princ)
)
  
;nastavenie premenej RezimHladin pre vyberr vytvorenej kategorie hladin
(setq RezimHladin
  (getstring "\nKtoré hladiny chcete vytvoriť? [Zakladne/Vystuz/Novy stav] <Zakladne>: ")
)
  
(if (or (= RezimHladin "") (= RezimHladin "Z") (= RezimHladin "z"))
(MainLayers)
  
  (if (or (= RezimHladin "V") (= RezimHladin "v"))
  (RebarLayers)
    
    (if (or (= RezimHladin "N") (= RezimHladin "n"))
     (NewLayers)
    
    (princ "\nNeplatný výber.")
    )
  )
)
  
;vytvorenie group layer filtru DP Layers  
(command "_.LAYER" "_FILTER" "_Delete" "DP Layers" "")
(if (> (getvar 'CMDACTIVE) 0) (command ""))
(command "_.LAYER" "_FILTER" "_New" "_Group" "All" "0,Defpoints,DP_*,NS_*" "DP Layers")
(if (> (getvar 'CMDACTIVE) 0) (command "")) 
  
;hlaska po skonceni programu
(princ "\nHladiny boli vytvorené. ")
(princ)  
  
)

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

;vytvorenie hlavných hladnín do modelu
(defun MainLayers()
  (CreateLayers "DP_Hatch" 9 "CONTINUOUS" 0.05)
  (CreateLayers "DP_Koty" 3 "CONTINUOUS" 0.09)
  (CreateLayers "DP_Nosná konštrukcia" 6 "CONTINUOUS" 0.30)
  (CreateLayers "DP_Os" 7 "DASHDOT" 0.18)
  (CreateLayers "DP_Podpis" 7 "CONTINUOUS" "DEFAULT")
  (CreateLayers "DP_Popis" 7 "CONTINUOUS" "DEFAULT")
  (CreateLayers "DP_Vodný tok" 150 "CONTINUOUS" 0.30)
  (CreateLayers "DP_Príslušenstvo" 8 "CONTINUOUS" 0.09)
  (CreateLayers "DP_Rímsa" 2 "CONTINUOUS" 0.30)
  (CreateLayers "DP_Rozpiska" 7 "CONTINUOUS" 0.20)
  (CreateLayers "DP_Spodná stavba" 4 "CONTINUOUS" 0.30)
  (CreateLayers "DP_Terén" 13 "CONTINUOUS" 0.50)
  (CreateLayers "DP_Vozovka" 1 "CONTINUOUS" 0.30)
  (CreateLayers "Defpoints" 140 "CONTINUOUS" 0.05)
  (CreateLayers "DP_Prefabrikáty" 5 "CONTINUOUS" 0.30)
  (CreateLayers "DP_Ložiská" 20 "CONTINUOUS" 0.25)
)

;vytvorenie hladín pre výstuž do modelu
(defun RebarLayers()
  (CreateLayers "DP_Výstuž_06" 181 "CONTINUOUS" 0.25)
  (CreateLayers "DP_Výstuž_07" 221 "CONTINUOUS" 0.25)
  (CreateLayers "DP_Výstuž_08" 11 "CONTINUOUS" 0.30)
  (CreateLayers "DP_Výstuž_10" 31 "CONTINUOUS" 0.35)
  (CreateLayers "DP_Výstuž_12" 51 "CONTINUOUS" 0.35)
  (CreateLayers "DP_Výstuž_14" 81 "CONTINUOUS" 0.40)
  (CreateLayers "DP_Výstuž_16" 121 "CONTINUOUS" 0.40)
  (CreateLayers "DP_Výstuž_18" 161 "CONTINUOUS" 0.50)
  (CreateLayers "DP_Výstuž_20" 201 "CONTINUOUS" 0.50)
  (CreateLayers "DP_Výstuž_22" 241 "CONTINUOUS" 0.53)
  (CreateLayers "DP_Výstuž_25" 21 "CONTINUOUS" 0.53)
  (CreateLayers "DP_Výstuž_26" 41 "CONTINUOUS" 0.53)
  (CreateLayers "DP_Výstuž_28" 61 "CONTINUOUS" 0.60)
  (CreateLayers "DP_Výstuž_30" 101 "CONTINUOUS" 0.60)
  (CreateLayers "DP_Výstuž_32" 141 "CONTINUOUS" 0.60)
)

;vytvorenie hladín pre nový stav do modelu
(defun NewLayers()
  (CreateLayers "NS_Hatch" 10 "CONTINUOUS" 0.05)
  (CreateLayers "NS_Koty" 10 "CONTINUOUS" 0.09)
  (CreateLayers "NS_Nosná konštrukcia" 10 "CONTINUOUS" 0.30)
  (CreateLayers "NS_Os" 10 "DASHDOT" 0.18)
  (CreateLayers "NS_Popis" 10 "CONTINUOUS" "DEFAULT")
  (CreateLayers "NS_Vodný tok" 10 "CONTINUOUS" 0.30)
  (CreateLayers "NS_Príslušenstvo" 10 "CONTINUOUS" 0.09)
  (CreateLayers "NS_Rímsa" 10 "CONTINUOUS" 0.30)
  (CreateLayers "NS_Spodná stavba" 10 "CONTINUOUS" 0.30)
  (CreateLayers "NS_Terén" 10 "CONTINUOUS" 0.50)
  (CreateLayers "NS_Vozovka" 10 "CONTINUOUS" 0.30)
  (CreateLayers "NS_Prefabrikáty" 10 "CONTINUOUS" 0.30)
  (CreateLayers "NS_Ložiská" 10 "CONTINUOUS" 0.25)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\nCreate_layers.lsp | beta | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;