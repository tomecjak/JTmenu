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
  (command "._layer" "s" "DP_Popis" "")
  
  ;vytvorenie group layer filtru DP Layers 
  (command "_.LAYER" "_FILTER" "_Delete" "DP Layers" "")
  (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" "0,Defpoints,DP_*,NS_*" "DP Layers")
  (if (> (getvar 'CMDACTIVE) 0) (command "")) 
)

;;----------------------------------------------------------------------;;

;Vkladanie jednotlivych blokov
;vlozenie bloku Smer
(defun c:DPSmer ()
  
  ;nastavenie hladiny
  (SetLayer)

  ;prikaz na vlozenie blocku Smer
  (command "._insert" "DPSmer" "_S" 0.05 "_R" 0)
  (princ "\nUrčite bod vloženia značky smeru:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku Smer2
(defun c:DPSmer2 ()
  ;nastavenie hladiny
  (SetLayer)

  ;prikaz na vlozenie blocku Smer2
  (command "._insert" "DPSmer2" "_S" 0.05 "_R" 0)
  (princ "\nUrčite bod vloženia značky smeru:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku SmerToku
(defun c:DPSmerToku ()
  ;nastavenie hladiny
  (SetLayer)

  ;prikaz na vlozenie blocku SmerToku
  (command "._insert" "DPSmerToku" "_S" 1 "_R" 0)
  (princ "\nUrčite bod vloženia značky smeru toku:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku NazovPohladu
(defun c:DPNazovPohladu()
  ;nastavenie hladiny
  (SetLayer)

  ;prikaz na vlozenie blocku NazovPohladu
  (command "._insert" "DPNazovPohladu" "_S" 0.05 "_R" 0)
  (princ "\nUrčite bod vloženia značky pohľadu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZvisly
(defun c:DPRezZvisly()
  ;nastavenie hladiny
  (SetLayer)

  ;prikaz na vlozenie blocku RezZvisly
  (command "._insert" "DPRezZvisly" "_S" 0.05 "_R" 0)
  (princ "\nUrčite bod vloženia značky rezu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezVodorovny
(defun c:DPRezVodorovny()
  ;nastavenie hladiny
  (SetLayer)

  ;prikaz na vlozenie blocku RezVodorovny
  (command "._insert" "DPRezVodorovny" "_S" 0.05 "_R" 0)
  (princ "\nUrčite bod vloženia značky rezu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku RezZlom
(defun c:DPRezZlom()
  ;nastavenie hladiny
  (SetLayer)

  ;prikaz na vlozenie blocku RezZlom
  (command "._insert" "DPRezZlom" "_S" 1 "_R" 0)
  (princ "\nUrčite bod vloženia značky rezu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

;vloženie bloku ZarovnanyText
(defun c:DPZarovnanyText()
  ;nastavenie hladiny
  (SetLayer)

  ;prikaz na vlozenie blocku ZarovnanyText
  (command "._insert" "DPZarovnanyText" "_S" 0.05 "_R" 0)
  (princ "\nUrčite bod vloženia značky zarovnaného textu:")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\nVkladanie_blokov.lsp | beta | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;