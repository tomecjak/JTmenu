;=========================================================================
; Zone_update.lsp
; Create by Jakub Tomecko
;
; Aktualizacia ochrannych pasiem v symbole ochranne pasma
;-------------------------------------------------------------------------

(defun C:JTZoneUpdate()
  
  ;vyber tabulky materialov a jej resetovanie
  (setq VyberBloku (entsel "Vyberte znacku ochranneho pasma:" ))
  (command-s "._resetblock" VyberBloku "")
  
  ;ukoncenie programu ak nieje vykres este ulozeny + hlaska
  (if (= (getvar "dwgtitled") 0)
    (progn
      (princ "\nSubor je potrebne najprv ulozit!\n")
      (exit)
    )
  )
  
  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Zone_update.dcl"))
  
  ;test existencie dialogu
  (if (not (new_dialog "Zone_update" dcl_id))
    (exit)
  )
    
  ;definovanie tlacidla aktualizovat
  (action_tile "aktualizovat"
    "(ZoneProtectionAktualizacia)(done_dialog)"
  )
  
  ;definovanie tlacidla zavriet
  (action_tile "cancel"
    "(UkoncenieZoneUpdate)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage
  (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
    ;splnena podmienka
    (setq ZoneSymbolVersion "OchrannePasmaSVK")
      ;nesplnena podmienka
      (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
      ;splnena podmienka
      (setq ZoneSymbolVersion "OchrannePasmaCZK")
      ;nesplnena podmienka
      (setq ZoneSymbolVersion "OchrannePasmaENG")
      )
  )
  
  (setq BlockTabulkaOchrannychPasiem (BlockNameToVLAName ZoneSymbolVersion))
    
  ;nacitanie udajov do blocku DPTabulkamaterialov
  (ZoneProtectionUpdate)
  
  (princ "\nMaterial uspesne aktualizovany.\n")
  
)

;nastavenie tlacidla aktualizovat
(defun ZoneProtectionAktualizacia()
  ;definovanie premenych pre vyhodnorenie
  (setq nazov_zony_01 (get_tile "nazov_zony_01"))
  (setq vzdialenost01 (get_tile "vzdialenost01"))
  (setq nazov_zony_02 (get_tile "nazov_zony_02"))
  (setq vzdialenost02 (get_tile "vzdialenost02"))
  (setq nazov_zony_03 (get_tile "nazov_zony_03"))
  (setq vzdialenost03 (get_tile "vzdialenost03"))
  (setq nazov_zony_04 (get_tile "nazov_zony_04"))
  (setq vzdialenost04 (get_tile "vzdialenost04"))
  (setq nazov_zony_05 (get_tile "nazov_zony_05"))
  (setq vzdialenost05 (get_tile "vzdialenost05"))
  (setq nazov_zony_06 (get_tile "nazov_zony_06"))
  (setq vzdialenost06 (get_tile "vzdialenost06"))
  (setq nazov_zony_07 (get_tile "nazov_zony_07"))
  (setq vzdialenost07 (get_tile "vzdialenost07"))
  (setq nazov_zony_08 (get_tile "nazov_zony_08"))
  (setq vzdialenost08 (get_tile "vzdialenost08"))
  (setq nazov_zony_09 (get_tile "nazov_zony_09"))
  (setq vzdialenost09 (get_tile "vzdialenost09"))
  (setq nazov_zony_10 (get_tile "nazov_zony_10"))
  (setq vzdialenost10 (get_tile "vzdialenost10"))
  (setq nazov_zony_11 (get_tile "nazov_zony_11"))
  (setq vzdialenost11 (get_tile "vzdialenost11"))
  (setq nazov_zony_12 (get_tile "nazov_zony_12"))
  (setq vzdialenost12 (get_tile "vzdialenost12"))
  (setq nazov_zony_13 (get_tile "nazov_zony_13"))
  (setq vzdialenost13 (get_tile "vzdialenost13"))
  (setq nazov_zony_14 (get_tile "nazov_zony_14"))
  (setq vzdialenost14 (get_tile "vzdialenost14"))
  (setq nazov_zony_15 (get_tile "nazov_zony_15"))
  (setq vzdialenost15 (get_tile "vzdialenost15"))
  (setq nazov_zony_16 (get_tile "nazov_zony_16"))
  (setq vzdialenost16 (get_tile "vzdialenost16"))
  (setq nazov_zony_17 (get_tile "nazov_zony_17"))
  (setq vzdialenost17 (get_tile "vzdialenost17"))
  (setq nazov_zony_18 (get_tile "nazov_zony_18"))
  (setq vzdialenost18 (get_tile "vzdialenost18"))
  (setq nazov_zony_19 (get_tile "nazov_zony_19"))
  (setq vzdialenost19 (get_tile "vzdialenost19"))
  (setq nazov_zony_20 (get_tile "nazov_zony_20"))
  (setq vzdialenost20 (get_tile "vzdialenost20"))
  (setq nazov_zony_21 (get_tile "nazov_zony_21"))
  (setq vzdialenost21 (get_tile "vzdialenost21"))
  (setq nazov_zony_22 (get_tile "nazov_zony_22"))
  (setq vzdialenost22 (get_tile "vzdialenost22"))
  (setq nazov_zony_23 (get_tile "nazov_zony_23"))
  (setq vzdialenost23 (get_tile "vzdialenost23"))
  (setq nazov_zony_24 (get_tile "nazov_zony_24"))
  (setq vzdialenost24 (get_tile "vzdialenost24"))
  (setq nazov_zony_25 (get_tile "nazov_zony_25"))
  (setq vzdialenost25 (get_tile "vzdialenost25"))
  (setq nazov_zony_26 (get_tile "nazov_zony_26"))
  (setq vzdialenost26 (get_tile "vzdialenost26"))
  (setq oznacit01 (get_tile "oznacit01"))
  (setq oznacit02 (get_tile "oznacit02"))
  (setq oznacit03 (get_tile "oznacit03"))
  (setq oznacit04 (get_tile "oznacit04"))
  (setq oznacit05 (get_tile "oznacit05"))
  (setq oznacit06 (get_tile "oznacit06"))
  (setq oznacit07 (get_tile "oznacit07"))
  (setq oznacit08 (get_tile "oznacit08"))
  (setq oznacit09 (get_tile "oznacit09"))
  (setq oznacit10 (get_tile "oznacit10"))
  (setq oznacit11 (get_tile "oznacit11"))
  (setq oznacit12 (get_tile "oznacit12"))
  (setq oznacit13 (get_tile "oznacit13"))
  (setq oznacit14 (get_tile "oznacit14"))
  (setq oznacit15 (get_tile "oznacit15"))
  (setq oznacit16 (get_tile "oznacit16"))
  (setq oznacit17 (get_tile "oznacit17"))
  (setq oznacit18 (get_tile "oznacit18"))
  (setq oznacit19 (get_tile "oznacit19"))
  (setq oznacit20 (get_tile "oznacit20"))
  (setq oznacit21 (get_tile "oznacit21"))
  (setq oznacit22 (get_tile "oznacit22"))
  (setq oznacit23 (get_tile "oznacit23"))
  (setq oznacit24 (get_tile "oznacit24"))
  (setq oznacit25 (get_tile "oznacit25"))
  (setq oznacit26 (get_tile "oznacit26"))
  
  ;vyhodnotenie ci je dany riadokSymboluZony zapisany
  (setq ListOfProtectionZones (list))
  (if (= oznacit01 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_01 vzdialenost01)))
  )
  (if (= oznacit02 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_02 vzdialenost02)))
  )
  (if (= oznacit03 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_03 vzdialenost03)))
  )
  (if (= oznacit04 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_04 vzdialenost04)))
  )
  (if (= oznacit05 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_05 vzdialenost05)))
  )
  (if (= oznacit06 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_06 vzdialenost06)))
  )
  (if (= oznacit07 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_07 vzdialenost07)))
  )
  (if (= oznacit08 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_08 vzdialenost08)))
  )
  (if (= oznacit09 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_09 vzdialenost09)))
  )
  (if (= oznacit10 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_10 vzdialenost10)))
  )
  (if (= oznacit11 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_11 vzdialenost11)))
  )
  (if (= oznacit12 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_12 vzdialenost12)))
  )
  (if (= oznacit13 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_13 vzdialenost13)))
  )
  (if (= oznacit14 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_14 vzdialenost14)))
  )
  (if (= oznacit15 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_15 vzdialenost15)))
  )
  (if (= oznacit16 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_16 vzdialenost16)))
  )
  (if (= oznacit17 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_17 vzdialenost17)))
  )
  (if (= oznacit18 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_18 vzdialenost18)))
  )
  (if (= oznacit19 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_19 vzdialenost19)))
  )
  (if (= oznacit20 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_20 vzdialenost20)))
  )
  (if (= oznacit21 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_21 vzdialenost21)))
  )
  (if (= oznacit22 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_22 vzdialenost22)))
  )
  (if (= oznacit23 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_23 vzdialenost23)))
  )
  (if (= oznacit24 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_24 vzdialenost24)))
  )
  (if (= oznacit25 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_25 vzdialenost25)))
  )
  (if (= oznacit26 "1")
    (setq ListOfProtectionZones (append ListOfProtectionZones (list nazov_zony_26 vzdialenost26)))
  )
  
)

;funkcia tlacidla zavriet
(defun UkoncenieZoneUpdate()
  (done_dialog)
  (princ "\nNenacitany ziaden material.\n")
  (exit)
)

;nacitanie udajov do blocku
(defun ZoneProtectionUpdate()
  ;premazanie tagov pred vlozenim udajov
  ;ochrenne pasmo 01
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_01" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_01" "")
  ;ochrenne pasmo 02
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_02" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_02" "")
  ;ochrenne pasmo 03
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_03" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_03" "")
  ;ochrenne pasmo 04
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_04" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_04" "")
  ;ochrenne pasmo 05
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_05" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_05" "")
  ;ochrenne pasmo 06
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_06" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_06" "")
  ;ochrenne pasmo 07
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_07" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_07" "")
  ;ochrenne pasmo 08
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_08" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_08" "")
  ;ochrenne pasmo 09
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_09" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_09" "")
  ;ochrenne pasmo 10
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_10" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_10" "")
  ;ochrenne pasmo 11
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_11" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_11" "")
  ;ochrenne pasmo 12
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_12" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_12" "")
  ;ochrenne pasmo 13
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_13" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_13" "")
  ;ochrenne pasmo 14
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_14" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_14" "")
  ;ochrenne pasmo 15
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_15" "")
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_15" "")
  
;|   (setq riadokSymboluZony 0)
  (setq zaznamUdajov 0)
  (while (< riadokSymboluZony 15)
    (setq nazovSietePoradie strcat("NAZ_SIETE_0" "1"))
    (BlockTagEditor BlockTabulkaOchrannychPasiem nazovSietePoradie (nth zaznamUdajov ListOfProtectionZones))
    (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_01" (nth (+ zaznamUdajov 1) ListOfProtectionZones))
    (setq riadokSymboluZony (+ riadokSymboluZony 1))
    (setq zaznamUdajov (+ zaznamUdajov 2))
  ) |;
  
  ;nacitanie udajov
  ;ochranne pasmo 01
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_01" (nth 0 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_01" (nth 1 ListOfProtectionZones))
  ;ochranne pasmo 02
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_02" (nth 2 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_02" (nth 3 ListOfProtectionZones))
  ;ochranne pasmo 03
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_03" (nth 4 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_03" (nth 5 ListOfProtectionZones))
  ;ochranne pasmo 04
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_04" (nth 6 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_04" (nth 7 ListOfProtectionZones))
  ;ochranne pasmo 05
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_05" (nth 8 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_05" (nth 9 ListOfProtectionZones))
  ;ochranne pasmo 06
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_06" (nth 10 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_06" (nth 11 ListOfProtectionZones))
  ;ochranne pasmo 07
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_07" (nth 12 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_07" (nth 13 ListOfProtectionZones))
  ;ochranne pasmo 08
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_08" (nth 14 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_08" (nth 15 ListOfProtectionZones))
  ;ochranne pasmo 09
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_09" (nth 16 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_09" (nth 17 ListOfProtectionZones))
  ;ochranne pasmo 10
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_10" (nth 18 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_10" (nth 19 ListOfProtectionZones))
  ;ochranne pasmo 11
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_11" (nth 20 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_11" (nth 21 ListOfProtectionZones))
  ;ochranne pasmo 12
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_12" (nth 22 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_12" (nth 23 ListOfProtectionZones))
  ;ochranne pasmo 13
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_13" (nth 24 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_13" (nth 25 ListOfProtectionZones))
  ;ochranne pasmo 14
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_14" (nth 26 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_14" (nth 27 ListOfProtectionZones))
  ;ochranne pasmo 15
  (BlockTagEditor BlockTabulkaOchrannychPasiem "NAZ_SIETE_15" (nth 28 ListOfProtectionZones))
  (BlockTagEditor BlockTabulkaOchrannychPasiem "VZDIALENOST_15" (nth 29 ListOfProtectionZones))

 
)

;;----------------------------------------------------------------------;;
;;       Pomocna funkcia pre vkladanie udajov do tagov blokov           ;;
;;----------------------------------------------------------------------;;

(defun BlockTagEditor ( blk tag val )
    (setq tag (strcase tag))
    (vl-some
       '(lambda ( att )
            (if (= tag (strcase (vla-get-tagstring att)))
                (progn (vla-put-textstring att val) val)
            )
        )
        (vlax-invoke blk 'getattributes)
    )
)

;;----------------------------------------------------------------------;;
;;       Pomocna funkcia pre vkladanie udajov do value blokov           ;;
;;----------------------------------------------------------------------;;

(defun Setdynpropvalue ( BlockVLAName ValueName NewValue )
    (setq ValueName (strcase ValueName))
    (vl-some
       '(lambda ( x )
            (if (= ValueName (strcase (vla-get-propertyname x)))
                (progn
                    (vla-put-value x (vlax-make-variant NewValue (vlax-variant-type (vla-get-value x))))
                    (cond (NewValue) (t))
                )
            )
        )
        (vlax-invoke BlockVLAName 'getdynamicblockproperties)
    )
)

;;----------------------------------------------------------------------;;
;;       Pomocne funkcie pre zmenu stavu hide dynamickeho bloku         ;;
;;----------------------------------------------------------------------;;

(defun Getdynpropallowedvalues ( blk prp )
    (setq prp (strcase prp))
    (vl-some '(lambda ( x ) (if (= prp (strcase (vla-get-propertyname x))) (vlax-get x 'allowedvalues)))
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)

(defun Getvisibilityparametername ( blk / vis )  
    (if
        (and
            (vlax-property-available-p blk 'effectivename)
            (setq blk
                (vla-item
                    (vla-get-blocks (vla-get-document blk))
                    (vla-get-effectivename blk)
                )
            )
            (= :vlax-true (vla-get-isdynamicblock blk))
            (= :vlax-true (vla-get-hasextensiondictionary blk))
            (setq vis
                (vl-some
                   '(lambda ( pair )
                        (if
                            (and
                                (= 360 (car pair))
                                (= "BLOCKVISIBILITYPARAMETER" (cdr (assoc 0 (entget (cdr pair)))))
                            )
                            (cdr pair)
                        )
                    )
                    (dictsearch
                        (vlax-vla-object->ename (vla-getextensiondictionary blk))
                        "ACAD_ENHANCEDBLOCK"
                    )
                )
            )
        )
        (cdr (assoc 301 (entget vis)))
    )
)

(defun SetVisibilityState ( blk val / vis )
    (if
        (and
            (setq vis (Getvisibilityparametername blk))
            (member (strcase val) (mapcar 'strcase (Getdynpropallowedvalues blk vis)))
        )
        (Setdynpropvalue blk vis val)
    )
)

;;----------------------------------------------------------------------;;
;;           Pomocna funkcia pre zmenu blocku na VLA objekt             ;;
;;----------------------------------------------------------------------;;

(defun BlockNameToVLAName (BlockToVLA / ssBN)
  (if (setq ssBN (ssget "_X" (list '(0 . "INSERT") (cons 2 BlockToVLA))))
    (vlax-ename->vla-object (ssname ssBN 0)))
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nZone_update.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;

