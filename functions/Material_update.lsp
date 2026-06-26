;=========================================================================
; Material_update.lsp
; Create by Jakub Tomecko
;
; Aktualizacia materialov v tabulke DPTabulkaMaterialov
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                  Hlavná funkcia Material Update                      ;;
;;----------------------------------------------------------------------;;

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
  (setq TypTabulkyList (list "Beton" "Vystuz" "Ocel"))
  
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
  
  ;nastavenie aktivnosti checkboxu na tabulku
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;aktivovane
    (mode_tile "hranataTabulka" 0)
    ;deaktivovane
    (mode_tile "hranataTabulka" 1)
  )

  
  ;podmienka ak neexistuje subor MaterialData.dat
  (if (= (open CestaMaterialData "r") nil)
    ;nastavenie oznamovacej hlasky
    (set_tile "status" "Data nenacitane.")
    (progn
      ;nastavenie oznamovacej hlasky
      (set_tile "status" "Data nacitane.")
      ;nacitanie udajov zo suboru MaterialData.dat
      (setq file (open CestaMaterialData "r"))
      (set_tile "konstrukcia01" (read-line file))
      (set_tile "material01" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia02" (read-line file))
      (set_tile "material02" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia03" (read-line file))
      (set_tile "material03" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia04" (read-line file))
      (set_tile "material04" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia05" (read-line file))
      (set_tile "material05" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia06" (read-line file))
      (set_tile "material06" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia07" (read-line file))
      (set_tile "material07" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia08" (read-line file))
      (set_tile "material08" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia09" (read-line file))
      (set_tile "material09" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia10" (read-line file))
      (set_tile "material10" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia11" (read-line file))
      (set_tile "material11" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia12" (read-line file))
      (set_tile "material12" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia13" (read-line file))
      (set_tile "material13" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia14" (read-line file))
      (set_tile "material14" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia15" (read-line file))
      (set_tile "material15" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia16" (read-line file))
      (set_tile "material16" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia17" (read-line file))
      (set_tile "material17" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia18" (read-line file))
      (set_tile "material18" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia19" (read-line file))
      (set_tile "material19" (read-line file))
      (set_tile "vystuz" (read-line file))
      (set_tile "konstrukcia20" (read-line file))
      (set_tile "material20" (read-line file))
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
  
  ;definovanie tlacidla napoveda Beton
  (action_tile "napovedaBeton"
    "(NapovedaConcrete)"
  )
  
    ;definovanie tlacidla napoveda Ocel
  (action_tile "napovedaOcel"
    "(NapovedaSteel)"
  )
  
  ;definovanie tlacidla ulozit
  (action_tile "ulozit"
    "(UlozitMaterialData)"
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
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage a DPP_Tools
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku tabulky materialov z JTMenu
    (progn
      (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
        ;splnena podmienka
        (setq TabulkaMaterialovVersion "TabulkaMaterialovSVK")
          ;nesplnena podmienka
          (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
          ;splnena podmienka
          (setq TabulkaMaterialovVersion "TabulkaMaterialovCZK")
          ;nesplnena podmienka
          (setq TabulkaMaterialovVersion "TabulkaMaterialovENG")
          )
      )
    )
    ;prikaz na vlozenie blocku tabulky materialov z DPP_Tools
    (setq TabulkaMaterialovVersion "DPP_Tabulka_materialov")
  )
  
  (setq BlockTabulkaMaterialov (BlockNameToVLAName TabulkaMaterialovVersion))
  
  ;nastavenie typu tabulky (beton/ocel, okruhla/hranata) 
  (NastavenieTypuTabulky)
  
  ;nastavenie vysky tabulky
  (VyskaTabulky)
  
  ;nacitanie udajov do blocku DPTabulkamaterialov
  (TabulkaMaterialovUpdate)
  
  (princ "\nMaterial uspesne aktualizovany.\n")
  
)

;;----------------------------------------------------------------------;;
;;                  Funkcia tlacidla oznacit vsetko                     ;;
;;----------------------------------------------------------------------;;

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
  (set_tile "oznacit11" "1")
  (set_tile "oznacit12" "1")
  (set_tile "oznacit13" "1")
  (set_tile "oznacit14" "1")
  (set_tile "oznacit15" "1")
  (set_tile "oznacit16" "1")
  (set_tile "oznacit17" "1")
  (set_tile "oznacit18" "1")
  (set_tile "oznacit19" "1")
  (set_tile "oznacit20" "1")
)

;;----------------------------------------------------------------------;;
;;                  Funkcia tlacidla odznacit vsetko                    ;;
;;----------------------------------------------------------------------;;

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
  (set_tile "oznacit11" "0")
  (set_tile "oznacit12" "0")
  (set_tile "oznacit13" "0")
  (set_tile "oznacit14" "0")
  (set_tile "oznacit15" "0")
  (set_tile "oznacit16" "0")
  (set_tile "oznacit17" "0")
  (set_tile "oznacit18" "0")
  (set_tile "oznacit19" "0")
  (set_tile "oznacit20" "0")
)

;;----------------------------------------------------------------------;;
;;                  Funkcia tlacidla vymazat vsetko                     ;;
;;----------------------------------------------------------------------;;

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
  (set_tile "konstrukcia11" "")
  (set_tile "konstrukcia12" "")
  (set_tile "konstrukcia13" "")
  (set_tile "konstrukcia14" "")
  (set_tile "konstrukcia15" "")
  (set_tile "konstrukcia16" "")
  (set_tile "konstrukcia17" "")
  (set_tile "konstrukcia18" "")
  (set_tile "konstrukcia19" "")
  (set_tile "konstrukcia20" "")
  (set_tile "material01" "")
  (set_tile "material02" "")
  (set_tile "material03" "")
  (set_tile "material04" "")
  (set_tile "material05" "")
  (set_tile "material06" "")
  (set_tile "material07" "")
  (set_tile "material08" "")
  (set_tile "material09" "")
  (set_tile "material10" "")
  (set_tile "material11" "")
  (set_tile "material12" "")
  (set_tile "material13" "")
  (set_tile "material14" "")
  (set_tile "material15" "")
  (set_tile "material16" "")
  (set_tile "material17" "")
  (set_tile "material18" "")
  (set_tile "material19" "")
  (set_tile "material20" "")
)


;;----------------------------------------------------------------------;;
;;                  Funkcia tlacidla napoveda Beton                     ;;
;;----------------------------------------------------------------------;;


(defun NapovedaConcrete()

  ;nacitanie dialogoveho okna
  (setq dcl_id1 (load_dialog "Material_update.dcl"))
  
  ;test existencie dialu NapovedaConcrete
  (if (not (new_dialog "NapovedaMaterialBeton" dcl_id1))
    (exit)
  )
  
  ;definicia tlacidla zatvorit napovedu
  (action_tile "zatvoritNapoveduBeton"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id1)
)

;;----------------------------------------------------------------------;;
;;                   Funkcia tlacidla napoveda Ocel                     ;;
;;----------------------------------------------------------------------;;


(defun NapovedaSteel()

  ;nacitanie dialogoveho okna
  (setq dcl_id2 (load_dialog "Material_update.dcl"))
  
  ;test existencie dialu NapovedaSteel
  (if (not (new_dialog "NapovedaMaterialOcel" dcl_id2))
    (exit)
  )
  
  ;definicia tlacidla zatvorit napovedu
  (action_tile "zatvoritNapoveduOcel"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id2)
)

;;----------------------------------------------------------------------;;
;;                       Funkcia tlacidla ulozit                        ;;
;;----------------------------------------------------------------------;;

(defun UlozitMaterialData()
  ;definovanie premenych
  (setq konstrukcia01 (get_tile "konstrukcia01"))
  (setq material01 (get_tile "material01"))
  (setq konstrukcia02 (get_tile "konstrukcia02"))
  (setq material02 (get_tile "material02"))
  (setq konstrukcia03 (get_tile "konstrukcia03"))
  (setq material03 (get_tile "material03"))
  (setq konstrukcia04 (get_tile "konstrukcia04"))
  (setq material04 (get_tile "material04"))
  (setq konstrukcia05 (get_tile "konstrukcia05"))
  (setq material05 (get_tile "material05"))
  (setq konstrukcia06 (get_tile "konstrukcia06"))
  (setq material06 (get_tile "material06"))
  (setq konstrukcia07 (get_tile "konstrukcia07"))
  (setq material07 (get_tile "material07"))
  (setq konstrukcia08 (get_tile "konstrukcia08"))
  (setq material08 (get_tile "material08"))
  (setq konstrukcia09 (get_tile "konstrukcia09"))
  (setq material09 (get_tile "material09"))
  (setq konstrukcia10 (get_tile "konstrukcia10"))
  (setq material10 (get_tile "material10"))
  (setq konstrukcia11 (get_tile "konstrukcia11"))
  (setq material11 (get_tile "material11"))
  (setq konstrukcia12 (get_tile "konstrukcia12"))
  (setq material12 (get_tile "material12"))
  (setq konstrukcia13 (get_tile "konstrukcia13"))
  (setq material13 (get_tile "material13"))
  (setq konstrukcia14 (get_tile "konstrukcia14"))
  (setq material14 (get_tile "material14"))
  (setq konstrukcia15 (get_tile "konstrukcia15"))
  (setq material15 (get_tile "material15"))
  (setq konstrukcia16 (get_tile "konstrukcia16"))
  (setq material16 (get_tile "material16"))
  (setq konstrukcia17 (get_tile "konstrukcia17"))
  (setq material17 (get_tile "material17"))
  (setq konstrukcia18 (get_tile "konstrukcia18"))
  (setq material18 (get_tile "material18"))
  (setq konstrukcia19 (get_tile "konstrukcia19"))
  (setq material19 (get_tile "material19"))
  (setq konstrukcia20 (get_tile "konstrukcia20"))
  (setq material20 (get_tile "material20"))
  (setq vystuz (get_tile "vystuz"))
  
  ;ulozenie udajov do suboru MaterialData.dat
  (setq file (open CestaMaterialData "w"))
  (write-line konstrukcia01 file)
  (write-line material01 file)
  (write-line vystuz file)
  (write-line konstrukcia02 file)
  (write-line material02 file)
  (write-line vystuz file)
  (write-line konstrukcia03 file)
  (write-line material03 file)
  (write-line vystuz file)
  (write-line konstrukcia04 file)
  (write-line material04 file)
  (write-line vystuz file)
  (write-line konstrukcia05 file)
  (write-line material05 file)
  (write-line vystuz file)
  (write-line konstrukcia06 file)
  (write-line material06 file)
  (write-line vystuz file)
  (write-line konstrukcia07 file)
  (write-line material07 file)
  (write-line vystuz file)
  (write-line konstrukcia08 file)
  (write-line material08 file)
  (write-line vystuz file)
  (write-line konstrukcia09 file)
  (write-line material09 file)
  (write-line vystuz file)
  (write-line konstrukcia10 file)
  (write-line material10 file)
  (write-line vystuz file)
  (write-line konstrukcia11 file)
  (write-line material11 file)
  (write-line vystuz file)
  (write-line konstrukcia12 file)
  (write-line material12 file)
  (write-line vystuz file)
  (write-line konstrukcia13 file)
  (write-line material13 file)
  (write-line vystuz file)
  (write-line konstrukcia14 file)
  (write-line material14 file)
  (write-line vystuz file)
  (write-line konstrukcia15 file)
  (write-line material15 file)
  (write-line vystuz file)
  (write-line konstrukcia16 file)
  (write-line material16 file)
  (write-line vystuz file)
  (write-line konstrukcia17 file)
  (write-line material17 file)
  (write-line vystuz file)
  (write-line konstrukcia18 file)
  (write-line material18 file)
  (write-line vystuz file)
  (write-line konstrukcia19 file)
  (write-line material19 file)
  (write-line vystuz file)
  (write-line konstrukcia20 file)
  (write-line material20 file)
  (write-line vystuz file)
  (close file)
  
  ;nastavenie oznamovacej hlasky
  (set_tile "status" "Data ulozene.")
)

;;----------------------------------------------------------------------;;
;;                   Funkcia tlacidla aktualizovat                      ;;
;;----------------------------------------------------------------------;;

;nastavenie tlacidla aktualizovat
(defun ConcreteAktualizacia()
  ;definovanie premenych pre vyhodnorenie
  (setq konstrukcia01 (get_tile "konstrukcia01"))
  (setq material01 (get_tile "material01"))
  (setq konstrukcia02 (get_tile "konstrukcia02"))
  (setq material02 (get_tile "material02"))
  (setq konstrukcia03 (get_tile "konstrukcia03"))
  (setq material03 (get_tile "material03"))
  (setq konstrukcia04 (get_tile "konstrukcia04"))
  (setq material04 (get_tile "material04"))
  (setq konstrukcia05 (get_tile "konstrukcia05"))
  (setq material05 (get_tile "material05"))
  (setq konstrukcia06 (get_tile "konstrukcia06"))
  (setq material06 (get_tile "material06"))
  (setq konstrukcia07 (get_tile "konstrukcia07"))
  (setq material07 (get_tile "material07"))
  (setq konstrukcia08 (get_tile "konstrukcia08"))
  (setq material08 (get_tile "material08"))
  (setq konstrukcia09 (get_tile "konstrukcia09"))
  (setq material09 (get_tile "material09"))
  (setq konstrukcia10 (get_tile "konstrukcia10"))
  (setq material10 (get_tile "material10"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia11 (get_tile "konstrukcia11"))
  (setq material11 (get_tile "material11"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia12 (get_tile "konstrukcia12"))
  (setq material12 (get_tile "material12"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia13 (get_tile "konstrukcia13"))
  (setq material13 (get_tile "material13"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia14 (get_tile "konstrukcia14"))
  (setq material14 (get_tile "material14"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia15 (get_tile "konstrukcia15"))
  (setq material15 (get_tile "material15"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia16 (get_tile "konstrukcia16"))
  (setq material16 (get_tile "material16"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia17 (get_tile "konstrukcia17"))
  (setq material17 (get_tile "material17"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia18 (get_tile "konstrukcia18"))
  (setq material18 (get_tile "material18"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia19 (get_tile "konstrukcia19"))
  (setq material19 (get_tile "material19"))
  (setq vystuz (get_tile "vystuz"))
  (setq konstrukcia20 (get_tile "konstrukcia20"))
  (setq material20 (get_tile "material20"))
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
  
  ;vyhodnotenie ci je dany riadok zapisany
  (setq ListOfMaterials (list))
  (if (= oznacit01 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia01 material01 vystuz)))
  )
  (if (= oznacit02 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia02 material02 vystuz)))
  )
  (if (= oznacit03 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia03 material03 vystuz)))
  )
  (if (= oznacit04 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia04 material04 vystuz)))
  )
  (if (= oznacit05 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia05 material05 vystuz)))
  )
  (if (= oznacit06 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia06 material06 vystuz)))
  )
  (if (= oznacit07 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia07 material07 vystuz)))
  )
  (if (= oznacit08 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia08 material08 vystuz)))
  )
  (if (= oznacit09 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia09 material09 vystuz)))
  )
  (if (= oznacit10 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia10 material10 vystuz)))
  )
  (if (= oznacit11 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia11 material11 vystuz)))
  )
  (if (= oznacit12 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia12 material12 vystuz)))
  )
  (if (= oznacit13 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia13 material13 vystuz)))
  )
  (if (= oznacit14 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia14 material14 vystuz)))
  )
  (if (= oznacit15 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia15 material15 vystuz)))
  )
  (if (= oznacit16 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia16 material16 vystuz)))
  )
  (if (= oznacit17 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia17 material17 vystuz)))
  )
  (if (= oznacit18 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia18 material18 vystuz)))
  )
  (if (= oznacit19 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia19 material19 vystuz)))
  )
  (if (= oznacit20 "1")
    (setq ListOfMaterials (append ListOfMaterials (list konstrukcia20 material20 vystuz)))
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

;;----------------------------------------------------------------------;;
;;                      Funkcia tlacidla zavriet                        ;;
;;----------------------------------------------------------------------;;

(defun UkoncenieConcreteUpdate()
  (done_dialog)
  (princ "\nNenacitany ziaden material.\n")
  (exit)
)

;;----------------------------------------------------------------------;;
;;                Funkcia nacitavanie udajov do bloku                   ;;
;;----------------------------------------------------------------------;;

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

;;----------------------------------------------------------------------;;
;;                   Funkcia vysky tabulky materialov                   ;;
;;----------------------------------------------------------------------;;

(defun VyskaTabulky()
  (Setdynpropvalue BlockTabulkaMaterialov "VYSKA_TAB_O" VyskaTabulkyMaterialov)
  (Setdynpropvalue BlockTabulkaMaterialov "VYSKA_TAB_H" VyskaTabulkyMaterialov)
)

;;----------------------------------------------------------------------;;
;;                   Funkcia nastavenia typu tabulky                    ;;
;;----------------------------------------------------------------------;;

(defun NastavenieTypuTabulky()
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na nastavenie tabulky podla JTmenu
    (progn
      ;vyhodnotenie tabulky - beton + okruhle rohy
      (if (and (= VyberTypTabulky "0") (= VyberHranataTabulka "0"))
        (SetVisibilityState BlockTabulkaMaterialov "TAB_BETON_OKRUHLE")
      )
      ;vyhodnotenie tabulky - beton + hranate rohy
      (if (and (= VyberTypTabulky "0") (= VyberHranataTabulka "1"))
        (SetVisibilityState BlockTabulkaMaterialov "TAB_BETON_HRANATE")
      )
      ;vyhodnotenie tabulky - vystuz + okruhle rohy
      (if (and (= VyberTypTabulky "1") (= VyberHranataTabulka "0"))
        (SetVisibilityState BlockTabulkaMaterialov "TAB_VYSTUZ_OKRUHLE")
      )
      ;vyhodnotenie tabulky - vystuz + hranate rohy
      (if (and (= VyberTypTabulky "1") (= VyberHranataTabulka "1"))
        (SetVisibilityState BlockTabulkaMaterialov "TAB_VYSTUZ_HRANATE")
      )
      ;vyhodnotenie tabulky - ocel + okruhle rohy
      (if (and (= VyberTypTabulky "2") (= VyberHranataTabulka "0"))
        (SetVisibilityState BlockTabulkaMaterialov "TAB_OCEL_OKRUHLE")
      )
      ;vyhodnotenie tabulky - ocel + hranate rohy
      (if (and (= VyberTypTabulky "2") (= VyberHranataTabulka "1"))
        (SetVisibilityState BlockTabulkaMaterialov "TAB_OCEL_HRANATE")
      )
    )
    ;prikaz na nastavenie tabulky podla DPPtools
    (progn
      ;vyhodnotenie tabulky - beton
      (if (= VyberTypTabulky "0")
        (SetVisibilityState BlockTabulkaMaterialov "Beton")
      )
      ;vyhodnotenie tabulky - vystuz
      (if (= VyberTypTabulky "1")
        (SetVisibilityState BlockTabulkaMaterialov "Vystuz")
      )
      ;vyhodnotenie tabulky - ocel
      (if (= VyberTypTabulky "2")
        (SetVisibilityState BlockTabulkaMaterialov "Ocel")
      )
    )
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
;;                 Vedlajsia funkcia napoveda Betonu                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTConcreteHelp()
  (NapovedaConcrete)
)

;;----------------------------------------------------------------------;;
;;                  Vedlajsia funkcia napoveda Ocel                     ;;
;;----------------------------------------------------------------------;;

(defun c:JTSteelHelp()
  (NapovedaSteel)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
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

