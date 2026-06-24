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

;;----------------------------------------------------------------------;;
;;                   Hlavna funkcia vytvarania hladin                   ;;
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
  
  ;hlaska po skonceni programu
  (princ "\nHladiny boli vytvorene. ")
  (princ)  
    
)

;;----------------------------------------------------------------------;;
;;                    Funkcia pre vytvaranie hladin                     ;;
;;----------------------------------------------------------------------;;

(defun CreateLayers (lyrname Color ltype lweight / doc lays lay tc)

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

  (cond
    ((or (null Color) (= Color ""))
      (vla-put-Color lay 7)
    )

    ((and (listp Color) (= (length Color) 3))
      (setq tc (vla-get-TrueColor lay))
      (apply 'vla-SetRGB (cons tc Color))
      (vla-put-TrueColor lay tc)
    )

    ((numberp Color)
      (vla-put-Color lay Color)
    )

    ((and (eq (type Color) 'STR) (/= Color ""))
      (vla-put-Color lay (atoi Color))
    )
  )

  (vla-put-Linetype lay
    (if (or (null ltype) (= ltype ""))
      "Continuous"
      ltype
    )
  )

  (if (or (null lweight) (= lweight ""))
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
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Hatch") 9 "CONTINUOUS" acLnWt005)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Koty") 3 "CONTINUOUS" acLnWt009)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Nosna konstrukcia") 6 "CONTINUOUS" acLnWt030)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Os") 7 "DASHDOT" acLnWt018)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Podpis") 7 "CONTINUOUS" "DEFAULT")
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Popis") 7 "CONTINUOUS" "DEFAULT")
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vodny tok") 150 "CONTINUOUS" acLnWt030)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Prislusenstvo") 8 "CONTINUOUS" acLnWt009)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Rimsa") 2 "CONTINUOUS" acLnWt030)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Rozpiska") 7 "CONTINUOUS" acLnWt020)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Spodna stavba") 4 "CONTINUOUS" acLnWt030)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Teren") 13 "CONTINUOUS" acLnWt050)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vozovka") 1 "CONTINUOUS" acLnWt030)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Prefabrikaty") 5 "CONTINUOUS" acLnWt030)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Loziska") 20 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "Vytycenie") 20 "CONTINUOUS" acLnWt025)
      (CreateLayers "Defpoints" 140 "CONTINUOUS" acLnWt005)
      (CreateLayers "0" 7 "CONTINUOUS" acLnWtByLwDefault)
    )
    (progn
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "ODVODNENIE") '(0 127 255) "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "ZELEN") '(0 165 0) "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "VODNY TOK") '(127 159 255) "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "TEREN EXISTUJUCI") '(165 82 82) "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "VOZOVKA") 1 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "RIMSA") 2 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "KOTY") 3 "CONTINUOUS" acLnWt013)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "SPODNA STAVBA") 4 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "NOSNA KONSTRUKCIA") 6 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "OS") 7 "DASHDOT" acLnWt013)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "POPIS") 7 "CONTINUOUS" acLnWt013)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "ROZPISKA") 7 "CONTINUOUS" acLnWtByLwDefault)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "PRISLUSENSTVO") 8 "CONTINUOUS" acLnWt013)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "HATCH") 9 "CONTINUOUS" acLnWt013)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "LOZISKA") 20 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "TEREN") 23 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "VYTYCENIE") 30 "CONTINUOUS" acLnWt013)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "GEOLOGIA") 33 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "OCELOVA KONSTRUKCIA") 41 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "PRECHODOVA DOSKA") 70 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "OPORNY MUR") 123 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "PROTIHLUKOVA STENA") 143 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "UPRAVA POD MOSTOM") 193 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "ZABRADLIE") 232 "CONTINUOUS" acLnWt025)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "PODKLADNY BETON") 235 "CONTINUOUS" acLnWt013)
      (CreateLayers (strcat (getenv "GlobalnaPrefixHladiny") (getenv "GlobalnaPrefixHladinySeparator") "ZVODIDLO") 251 "CONTINUOUS" acLnWt025)
      (CreateLayers "Defpoints" 140 "CONTINUOUS" acLnWt025)
      (CreateLayers "0" 7 "CONTINUOUS" acLnWtByLwDefault)
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