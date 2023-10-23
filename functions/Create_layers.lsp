;=========================================================================
; Create_layers.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Vytvorenie DP hladin
;-------------------------------------------------------------------------

;;--------------------=={ Vytvorenie DP hladin }==----------------------;;
;;                                                                      ;;
;;  Tento program umoznuje vytvorit hladiny s prefixom DP_. Je mozne    ;;
;;  vytvorit tri typu hladin: zakaldne, vystuz alebo novy stav. Hladiny ;;
;;  sa automaticky zaradia do vytvorenej skupiny hladin "DP Layers".    ;;
;;----------------------------------------------------------------------;;

(defun c:JTCreateLayers ()
  
;definovanie chybovej hlasky v programe
(defun *error* (errmsg)
  (princ)
  (princ "\nProgram Create_layers.lsp sa ukoncil. ")
  (terpri)
  (prompt errmsg)
  (princ)
)
  
;nastavenie premenej RezimHladin pre vyberr vytvorenej kategorie hladin
(setq RezimHladin
  (getstring "\nKtore hladiny chcete vytvorit? [Zakladne/Vystuz/Novy stav] <Zakladne>: ")
)
  
(if (or (= RezimHladin "") (= RezimHladin "Z") (= RezimHladin "z"))
  (MainLayers)
  
  (if (or (= RezimHladin "V") (= RezimHladin "v"))
    (RebarLayers)
    
    (if (or (= RezimHladin "N") (= RezimHladin "n"))
      (NewLayers)
    
      (princ "\nNeplatny vyber.")
    )
  )
)
  
;vytvorenie group layer filtru DP Layers  
(setq GroupPrefix (strcat (getenv "GlobalnaPrefixHladiny") "*,0,Defpoints," (getenv "GlobalnaPrefixHladinyNew") "*"))
(command "_.LAYER" "_FILTER" "_Delete" (strcat (getenv "GlobalnaPrefixHladiny") "Layers") "")
  (if (> (getvar 'CMDACTIVE) 0) (command ""))
(command "_.LAYER" "_FILTER" "_New" "_Group" "All" GroupPrefix (strcat (getenv "GlobalnaPrefixHladiny") "Layers"))
  (if (> (getvar 'CMDACTIVE) 0) (command ""))
  
;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
(command "_.layerp")
(command "_-layer" "_filter" "_set" "All" "")
  
;hlaska po skonceni programu
(princ "\nHladiny boli vytvorene. ")
(princ)  
  
)

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

;vytvorenie hlavnych hladnin do modelu
(defun MainLayers()
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Hatch") 9 "CONTINUOUS" 0.05)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Koty") 3 "CONTINUOUS" 0.09)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Nosna konstrukcia") 6 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Os") 7 "DASHDOT" 0.18)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Podpis") 7 "CONTINUOUS" "DEFAULT")
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Popis") 7 "CONTINUOUS" "DEFAULT")
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vodny tok") 150 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Prislusenstvo") 8 "CONTINUOUS" 0.09)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Rimsa") 2 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Rozpiska") 7 "CONTINUOUS" 0.20)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Spodna stavba") 4 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Teren") 13 "CONTINUOUS" 0.50)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vozovka") 1 "CONTINUOUS" 0.30)
  (CreateLayers "Defpoints" 140 "CONTINUOUS" 0.05)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Prefabrikaty") 5 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Loziska") 20 "CONTINUOUS" 0.25)
  (CreateLayers "0" 7 "CONTINUOUS" "DEFAULT")
)

;vytvorenie hladin pre vystuz do modelu
(defun RebarLayers()
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz") 7 "CONTINUOUS" "DEFAULT")
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_06") 181 "CONTINUOUS" 0.25)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_07") 221 "CONTINUOUS" 0.25)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_08") 11 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_10") 31 "CONTINUOUS" 0.35)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_12") 51 "CONTINUOUS" 0.35)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_14") 81 "CONTINUOUS" 0.40)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_16") 121 "CONTINUOUS" 0.40)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_18") 161 "CONTINUOUS" 0.50)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_20") 201 "CONTINUOUS" 0.50)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_22") 241 "CONTINUOUS" 0.53)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_25") 21 "CONTINUOUS" 0.53)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_26") 41 "CONTINUOUS" 0.53)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_28") 61 "CONTINUOUS" 0.60)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_30") 101 "CONTINUOUS" 0.60)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_32") 141 "CONTINUOUS" 0.60)
  (CreateLayers "0" 7 "CONTINUOUS" "DEFAULT")
)

;vytvorenie hladin pre novy stav do modelu
(defun NewLayers()
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Hatch") 10 "CONTINUOUS" 0.05)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Koty") 10 "CONTINUOUS" 0.09)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Nosna konstrukcia") 10 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Os") 10 "DASHDOT" 0.18)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Popis") 10 "CONTINUOUS" "DEFAULT")
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Vodny tok") 10 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Prislusenstvo") 10 "CONTINUOUS" 0.09)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Rimsa") 10 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Spodna stavba") 10 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Teren") 10 "CONTINUOUS" 0.50)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Vozovka") 10 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Prefabrikaty") 10 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladinyNew") "Loziska") 10 "CONTINUOUS" 0.25)
  (CreateLayers "0" 7 "CONTINUOUS" "DEFAULT")
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nCreate_layers.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;