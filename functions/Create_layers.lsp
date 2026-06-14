;=========================================================================
; Create_layers.lsp
; Create by Jakub Tomecko
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
;(setq RezimHladin
;  (getstring "\nKtore hladiny chcete vytvorit? [Zakladne/Vystuz/Novy stav] <Zakladne>: ")
;)
  
;(if (or (= RezimHladin "") (= RezimHladin "Z") (= RezimHladin "z"))
;  (MainLayers)
  
;  (if (or (= RezimHladin "V") (= RezimHladin "v"))
;    (RebarLayers)
    
;    (if (or (= RezimHladin "N") (= RezimHladin "n"))
;      (NewLayers)
    
;      (princ "\nNeplatny vyber.")
;    )
;  )
;)
  
;nastavenie premenej RezimHladin pre vyber vytvorenej kategorie hladin
  (initget "Zakladne Vystuz")
  (setq RezimHladin (getkword "\nKtore hladiny chcete vytvorit? [Zakladne/Vystuz] <Zakladne>: "))
  (if (null RezimHladin) (setq RezimHladin "Zakladne"))

  (cond
    ((= RezimHladin "Zakladne")
      (MainLayers)
    )
    ((= RezimHladin "Vystuz")
      (RebarLayers)
    )
  )
    
;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
(command "_.layerp")
(command "_-layer" "_filter" "_set" "All" "")
  
;hlaska po skonceni programu
(princ "\nHladiny boli vytvorene. ")
(princ)  
  
)

;;----------------------------------------------------------------------;;
;;                    Funkcia pre vytvaranie hladin                     ;;
;;----------------------------------------------------------------------;;

(defun CreateLayers (lyrname color ltype lweight / doc lays lay tc)

  (vl-load-com)

  (setq doc  (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq lays (vla-get-Layers doc))

  (if (tblsearch "LAYER" lyrname)
    (setq lay (vla-Item lays lyrname))
    (setq lay (vla-Add lays lyrname))
  )

  (vla-put-Freeze lay :vlax-false)
  (vla-put-LayerOn lay :vlax-true)
  (vla-put-Lock lay :vlax-false)

  ;; FARBA
  (cond
    ((or (null color) (and (= (type color) 'STR) (= color "")))
      (vla-put-Color lay 7)
    )

    ((and (listp color) (= (length color) 3))
      (setq tc (vlax-get-property lay 'TrueColor))
      (apply 'vla-SetRGB (cons tc color))
      (vlax-put-property lay 'TrueColor tc)
    )

    ((numberp color)
      (vla-put-Color lay color)
    )

    ((and (= (type color) 'STR) (/= color ""))
      (vla-put-Color lay (atoi color))
    )
  )

  ;; LINETYPE - musí byť načítaný
  (if (or (null ltype) (= ltype ""))
    (setq ltype "Continuous")
  )

  (if (not (tblsearch "LTYPE" ltype))
    (command "._-linetype" "_load" ltype "")
  )

  (if (tblsearch "LTYPE" ltype)
    (vla-put-Linetype lay ltype)
  )

  ;; LINEWEIGHT
  (if (null lweight)
    (vla-put-Lineweight lay acLnWtByLwDefault)
    (vla-put-Lineweight lay lweight)
  )

  (vla-put-ActiveLayer doc lay)
  lay
)

;;----------------------------------------------------------------------;;
;;                  Funkcia vytvarania hlavnych hladin                  ;;
;;----------------------------------------------------------------------;;

(defun MainLayers()
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    (progn
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Hatch") 9 "CONTINUOUS" 0.05)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Koty") 3 "CONTINUOUS" 0.09)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Nosna konstrukcia") 6 "CONTINUOUS" 0.30)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Os") 7 "DASHDOT" 0.18)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Podpis") 7 "CONTINUOUS" "DEFAULT")
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Popis") 7 "CONTINUOUS" "DEFAULT")
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vodny tok") 150 "CONTINUOUS" 0.30)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Prislusenstvo") 8 "CONTINUOUS" 0.09)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Rimsa") 2 "CONTINUOUS" 0.30)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Rozpiska") 7 "CONTINUOUS" 0.20)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Spodna stavba") 4 "CONTINUOUS" 0.30)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Teren") 13 "CONTINUOUS" 0.50)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vozovka") 1 "CONTINUOUS" 0.30)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Prefabrikaty") 5 "CONTINUOUS" 0.30)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Loziska") 20 "CONTINUOUS" 0.25)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vytycenie") 20 "CONTINUOUS" 0.25)
      (CreateLayers "Defpoints" 140 "CONTINUOUS" 0.05)
      (CreateLayers "0" 7 "CONTINUOUS" "DEFAULT")
    )
    (progn
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "TEST1") '(100 100 100) "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "TEST2") 9 "CONTINUOUS" acLnWt025)
    )
  ) 
)

;;----------------------------------------------------------------------;;
;;                  Funkcia vytvarania hladin pre vystuz                ;;
;;----------------------------------------------------------------------;;

(defun RebarLayers()
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz") 7 "CONTINUOUS" "DEFAULT")
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_06") 181 "CONTINUOUS" 0.25)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_07") 221 "CONTINUOUS" 0.25)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_08") 11 "CONTINUOUS" 0.30)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_10") 31 "CONTINUOUS" 0.35)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_12") 51 "CONTINUOUS" 0.35)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_14") 81 "CONTINUOUS" 0.40)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_16") 121 "CONTINUOUS" 0.40)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_18") 161 "CONTINUOUS" 0.50)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_20") 201 "CONTINUOUS" 0.50)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_22") 241 "CONTINUOUS" 0.53)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_25") 21 "CONTINUOUS" 0.53)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_26") 41 "CONTINUOUS" 0.53)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_28") 61 "CONTINUOUS" 0.60)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_30") 101 "CONTINUOUS" 0.60)
  (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vystuz_32") 141 "CONTINUOUS" 0.60)
  (CreateLayers "0" 7 "CONTINUOUS" "DEFAULT")
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
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