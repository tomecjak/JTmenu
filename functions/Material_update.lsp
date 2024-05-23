;=========================================================================
; Material_update.lsp
; Create by Jakub Tomecko
;
; Aktualizacia materialov v tabulke DPTabulkaMaterialov
;-------------------------------------------------------------------------

(defun C:JTMaterialUpdate()
  
  ;vyber tabulky materialov a jej resetovanie
  (setq VyberBloku (entsel "Vyberte tabulku materialov:" ))
  (command-s "._resetblock" VyberBloku "")
  
  ;ukoncenie programu ak nieje vykres este ulozeny + hlaska
  (if (= (getvar "dwgtitled") 0)
    (progn
      (princ "\nSubor je potrebne najprv ulozit!\n")
      (exit)
    )
  )

  ;nastavenie cesty do korenoveho adresara vykresu
  (setq CestaPlnaSuboru (findfile (getvar "dwgname")))
  (setq CestaNazovSuboru (getvar "dwgname"))
  (setq CestaSkratenaSuboru (substr CestaPlnaSuboru 1 (- (strlen CestaPlnaSuboru) (strlen CestaNazovSuboru))))
  (setq CestaMaterialData (strcat CestaSkratenaSuboru "MaterialData.dat"))

  ;definovanie listu typu tabulky
  (setq TypTabulkyList (list "Beton" "Ocel"))
  
  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Material_update.dcl"))
  
  ;test existencie dialogu
  (if (not (new_dialog "Material_update" dcl_id))
    (exit)
  )
  
  ;spustenie a naplnenie listu formatok
  (start_list "typTabulky")
  (mapcar 'add_list TypTabulkyList)
  (end_list)
  
  ;podmienka ak neexistuje subor MaterialData.dat
  (if (= (open CestaMaterialData "r") nil)
    ;nastavenie oznamovacej hlasky
    (set_tile "status" "Data nenacitane.")
    (progn
      ;nastavenie oznamovacej hlasky
      (set_tile "status" "Data uspesne nacitane.")
      ;nacitanie udajov zo suboru MaterialData.dat
      (setq file (open CestaMaterialData "r"))
      (set_tile "konstrukcia01" (read-line file))
      (set_tile "beton01" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia02" (read-line file))
      (set_tile "beton02" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia03" (read-line file))
      (set_tile "beton03" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia04" (read-line file))
      (set_tile "beton04" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia05" (read-line file))
      (set_tile "beton05" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia06" (read-line file))
      (set_tile "beton06" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia07" (read-line file))
      (set_tile "beton07" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia08" (read-line file))
      (set_tile "beton08" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia09" (read-line file))
      (set_tile "beton09" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia10" (read-line file))
      (set_tile "beton10" (read-line file))
      (set_tile "vystuz" (read-line file))
      (close file)
    )
  )
  
  ;definovanie tlacidla oznacit vsetko
  (action_tile "oznacitVsetko"
    "(OznacitVsetkoFunkcia)"
  )
  
  ;definovanie tlacidla odznacit vsetko
  (action_tile "odznacitVsetko"
    "(OdznacitVsetkoFunkcia)"
  )
  
  ;definovanie tlacidla odznacit vsetko
  (action_tile "vymazatVsetko"
    "(VymazatVsetkoFunkcia)"
  )
  
  ;definovanie tlacidla napoveda
  (action_tile "napoveda"
    "(NapovedaConcrete)"
  )
  
  ;definovanie tlacidla ulozit
  (action_tile "ulozit"
    "(UlozitConcreteData)"
  )
  
  ;definovanie tlacidla aktualizovat
  (action_tile "aktualizovat"
    "(ConcreteAktualizacia)(done_dialog)"
  )
  
  ;definovanie tlacidla zavriet
  (action_tile "cancel"
    "(UkoncenieConcreteUpdate)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
  
  (setq BlockTabulkaMaterialov (BlockNameToVLAName "TabulkaMaterialov"))
  
  ;nastavenie typu tabulky (beton/ocel, okruhla/hranata) 
  (NastavenieTypuTabulky)
  
  ;nastavenie vysky tabulky
  (VyskaTabulky)
  
  ;nacitanie udajov do blocku DPTabulkamaterialov
  (TabulkaMaterialovUpdate)
  
  (princ "\nMaterial uspesne aktualizovany.\n")
  
)

;funkcia tlacidla oznacit vsetko
(defun OznacitVsetkoFunkcia()
  (set_tile "oznacit01" "1")
  (set_tile "oznacit02" "1")
  (set_tile "oznacit03" "1")
  (set_tile "oznacit04" "1")
  (set_tile "oznacit05" "1")
  (set_tile "oznacit06" "1")
  (set_tile "oznacit07" "1")
  (set_tile "oznacit08" "1")
  (set_tile "oznacit09" "1")
  (set_tile "oznacit10" "1")
)

;funkcia tlacidla odznacit vsetko
(defun OdznacitVsetkoFunkcia()
  (set_tile "oznacit01" "0")
  (set_tile "oznacit02" "0")
  (set_tile "oznacit03" "0")
  (set_tile "oznacit04" "0")
  (set_tile "oznacit05" "0")
  (set_tile "oznacit06" "0")
  (set_tile "oznacit07" "0")
  (set_tile "oznacit08" "0")
  (set_tile "oznacit09" "0")
  (set_tile "oznacit10" "0")
)

;funkcia tlacidla vymazat vsetko
(defun VymazatVsetkoFunkcia()
  (set_tile "konstrukcia01" "")
  (set_tile "konstrukcia02" "")
  (set_tile "konstrukcia03" "")
  (set_tile "konstrukcia04" "")
  (set_tile "konstrukcia05" "")
  (set_tile "konstrukcia06" "")
  (set_tile "konstrukcia07" "")
  (set_tile "konstrukcia08" "")
  (set_tile "konstrukcia09" "")
  (set_tile "konstrukcia10" "")
  (set_tile "beton01" "")
  (set_tile "beton02" "")
  (set_tile "beton03" "")
  (set_tile "beton04" "")
  (set_tile "beton05" "")
  (set_tile "beton06" "")
  (set_tile "beton07" "")
  (set_tile "beton08" "")
  (set_tile "beton09" "")
  (set_tile "beton10" "")
)

;funkcia tlacidla napoveda
(defun NapovedaConcrete()

  ;nacitanie dialogoveho okna
  (setq dcl_id1 (load_dialog "Material_update.dcl"))
  
  ;test existencie dialu NapovedaConcrete
  (if (not (new_dialog "NapovedaMaterial" dcl_id1))
    (exit)
  )
  
  ;definicia tlacidla zatvorit napovedu
  (action_tile "zatvoritNapovedu"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id1)
)

;funkcia pre tlacidlo Ulozit
(defun UlozitConcreteData()
  ;definovanie premenych
  (setq konstrukcia01 (get_tile "konstrukcia01"))
  (setq beton01 (get_tile "beton01"))
  (setq konstrukcia02 (get_tile "konstrukcia02"))
  (setq beton02 (get_tile "beton02"))
  (setq konstrukcia03 (get_tile "konstrukcia03"))
  (setq beton03 (get_tile "beton03"))
  (setq konstrukcia04 (get_tile "konstrukcia04"))
  (setq beton04 (get_tile "beton04"))
  (setq konstrukcia05 (get_tile "konstrukcia05"))
  (setq beton05 (get_tile "beton05"))
  (setq konstrukcia06 (get_tile "konstrukcia06"))
  (setq beton06 (get_tile "beton06"))
  (setq konstrukcia07 (get_tile "konstrukcia07"))
  (setq beton07 (get_tile "beton07"))
  (setq konstrukcia08 (get_tile "konstrukcia08"))
  (setq beton08 (get_tile "beton08"))
  (setq konstrukcia09 (get_tile "konstrukcia09"))
  (setq beton09 (get_tile "beton09"))
  (setq konstrukcia10 (get_tile "konstrukcia10"))
  (setq beton10 (get_tile "beton10"))
  (setq vystuz (get_tile "vystuz"))
  
  ;lozenie udajov do suboru MaterialData.dat
  (setq file (open CestaMaterialData "w"))
  (write-line konstrukcia01 file)
  (write-line beton01 file)
  (write-line vystuz file)
  (write-line konstrukcia02 file)
  (write-line beton02 file)
  (write-line vystuz file)
  (write-line konstrukcia03 file)
  (write-line beton03 file)
  (write-line vystuz file)
  (write-line konstrukcia04 file)
  (write-line beton04 file)
  (write-line vystuz file)
  (write-line konstrukcia05 file)
  (write-line beton05 file)
  (write-line vystuz file)
  (write-line konstrukcia06 file)
  (write-line beton06 file)
  (write-line vystuz file)
  (write-line konstrukcia07 file)
  (write-line beton07 file)
  (write-line vystuz file)
  (write-line konstrukcia08 file)
  (write-line beton08 file)
  (write-line vystuz file)
  (write-line konstrukcia09 file)
  (write-line beton09 file)
  (write-line vystuz file)
  (write-line konstrukcia10 file)
  (write-line beton10 file)
  (write-line vystuz file)
  (close file)
  
  ;nastavenie oznamovacej hlasky
  (set_tile "status" "Data uspesne ulozene.")
)

;nastavenie tlacidla aktualizovat
(defun ConcreteAktualizacia()
  ;definovanie premenych pre vyhodnorenie
  (setq konstrukcia01 (get_tile "konstrukcia01"))
  (setq beton01 (get_tile "beton01"))
  (setq konstrukcia02 (get_tile "konstrukcia02"))
  (setq beton02 (get_tile "beton02"))
  (setq konstrukcia03 (get_tile "konstrukcia03"))
  (setq beton03 (get_tile "beton03"))
  (setq konstrukcia04 (get_tile "konstrukcia04"))
  (setq beton04 (get_tile "beton04"))
  (setq konstrukcia05 (get_tile "konstrukcia05"))
  (setq beton05 (get_tile "beton05"))
  (setq konstrukcia06 (get_tile "konstrukcia06"))
  (setq beton06 (get_tile "beton06"))
  (setq konstrukcia07 (get_tile "konstrukcia07"))
  (setq beton07 (get_tile "beton07"))
  (setq konstrukcia08 (get_tile "konstrukcia08"))
  (setq beton08 (get_tile "beton08"))
  (setq konstrukcia09 (get_tile "konstrukcia09"))
  (setq beton09 (get_tile "beton09"))
  (setq konstrukcia10 (get_tile "konstrukcia10"))
  (setq beton10 (get_tile "beton10"))
  (setq vystuz (get_tile "vystuz"))
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
  
  ;vyhodnotenie ci je dany riadok zapisany
  (setq ListOfMaterials (list))
  (if (= oznacit01 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia01 beton01 vystuz)))
  )
  (if (= oznacit02 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia02 beton02 vystuz)))
  )
  (if (= oznacit03 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia03 beton03 vystuz)))
  )
  (if (= oznacit04 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia04 beton04 vystuz)))
  )
  (if (= oznacit05 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia05 beton05 vystuz)))
  )
  (if (= oznacit06 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia06 beton06 vystuz)))
  )
  (if (= oznacit07 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia07 beton07 vystuz)))
  )
  (if (= oznacit08 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia08 beton08 vystuz)))
  )
  (if (= oznacit09 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia09 beton09 vystuz)))
  )
  (if (= oznacit10 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia10 beton10 vystuz)))
  )
  
  ;zistenie dlzky zoznamy
  (setq NumberOfItems (/ (length ListOfMaterials) 3))
  
  ;ziskanie vysky tabulky materialov
  (setq VyskaTabulkyMaterialov (+ 10.5 (* 6.5 NumberOfItems)))
  
  ;ziskanie udajov o type tabulky
  (setq VyberTypTabulky (get_tile "typTabulky"))
  
  ;ziskanie udaju ci je tabulka hranata
  (setq VyberHranataTabulka (get_tile "hranataTabulka"))

)

;funkcia tlacidla zavriet
(defun UkoncenieConcreteUpdate()
  (done_dialog)
  (princ "\nNenacitany ziaden material.\n")
  (exit)
)

;nacitanie udajov do blocku
(defun TabulkaMaterialovUpdate()
  ;premazanie tagov pred vlozenim udajov
  ;konstrukcia 01
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_01" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_01" "")
  ;konstrukcia 02
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_02" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_02" "")
  ;konstrukcia 03
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_03" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_03" "")
  ;konstrukcia 04
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_04" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_04" "")
  ;konstrukcia 05
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_05" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_05" "")
  ;konstrukcia 06
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_06" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_06" "")
  ;konstrukcia 07
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_07" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_07" "")
  ;konstrukcia 08
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_08" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_08" "")
  ;konstrukcia 09
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_09" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_09" "")
  ;konstrukcia 10
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_10" "")
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_10" "")
  
  ;vyhodnotenie druhu tabulky
  (if (= VyberTypTabulky "1")
    (setq NasobisRiadku 1)
    (setq NasobisRiadku 0)
  )
 
  ;nacitanie udajov
  ;konstrukcia 01
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_01" (nth 0 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_01" (nth (+ 1 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 02
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_02" (nth 3 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_02" (nth (+ 4 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 03
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_03" (nth 6 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_03" (nth (+ 7 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 04
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_04" (nth 9 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_04" (nth (+ 10 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 05
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_05" (nth 12 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_05" (nth (+ 13 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 06
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_06" (nth 15 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_06" (nth (+ 16 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 07
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_07" (nth 18 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_07" (nth (+ 19 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 08
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_08" (nth 21 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_08" (nth (+ 22 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 09
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_09" (nth 24 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_09" (nth (                                                                                                                                                                                                       + 25 NasobisRiadku) ListOfMaterials))
  ;konstrukcia 10
  (BlockTagEditor BlockTabulkaMaterialov "KONSTRUKCIA_10" (nth 27 ListOfMaterials))
  (BlockTagEditor BlockTabulkaMaterialov "MATERIAL_10" (nth (+ 28 NasobisRiadku) ListOfMaterials))
 
)

;vyska tabulky materialov
(defun VyskaTabulky()
  (Setdynpropvalue BlockTabulkaMaterialov "VYSKA_TAB_O" VyskaTabulkyMaterialov)
  (Setdynpropvalue BlockTabulkaMaterialov "VYSKA_TAB_H" VyskaTabulkyMaterialov)
)

;nastavenie hranatej tabulky
(defun NastavenieTypuTabulky()
  ;vyhodnotenie tabulky - beton + okruhle rohy
  (if (and (= VyberTypTabulky "0") (= VyberHranataTabulka "0"))
    (SetVisibilityState BlockTabulkaMaterialov "TAB_BETON_OKRUHLE")
  )
  ;vyhodnotenie tabulky - beton + hranate rohy
  (if (and (= VyberTypTabulky "0") (= VyberHranataTabulka "1"))
    (SetVisibilityState BlockTabulkaMaterialov "TAB_BETON_HRANATE")
  )
  ;vyhodnotenie tabulky - ocel + okruhle rohy
  (if (and (= VyberTypTabulky "1") (= VyberHranataTabulka "0"))
    (SetVisibilityState BlockTabulkaMaterialov "TAB_OCEL_OKRUHLE")
  )
  ;vyhodnotenie tabulky - ocel + hranate rohy
  (if (and (= VyberTypTabulky "1") (= VyberHranataTabulka "1"))
    (SetVisibilityState BlockTabulkaMaterialov "TAB_OCEL_HRANATE")
  )
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
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nMaterial_update.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;

