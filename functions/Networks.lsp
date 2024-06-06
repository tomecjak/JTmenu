;=========================================================================
; Networks.lsp
; Create by Jakub Tomecko
;
; Vytvorenie typu ciar
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                Vytvorenie jednotlivych typov ciar                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTNetworks ()

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu
  (if (not (new_dialog "Networks" dcl_id))
    (exit)
  )
  
  ;definicnia tlacicla sieteVsetkyCiaryInfo
  (action_tile "sieteVsetkyCiaryInfo"
    "(SieteVsetkyCiaryInfo)"
  )
  
  ;definicnia tlacicla sieteCiaryHranicInfo
  (action_tile "sieteCiaryHranicInfo"
    "(SieteCiaryHranicInfo)"
  )
  
  ;definicnia tlacicla sieteCiaryZvodidlaInfo
  (action_tile "sieteCiaryZvodidlaInfo"
    "(SieteCiaryZvodidlaInfo)"
  )
  
  ;definicnia tlacicla sieteCiaryVodovoduInfo
  (action_tile "sieteCiaryVodovoduInfo"
    "(SieteCiaryVodovoduInfo)"
  )
  
  ;definicnia tlacicla sieteCiaryKanalizacieInfo
  (action_tile "sieteCiaryKanalizacieInfo"
    "(SieteCiaryKanalizacieInfo)"
  )
  
  ;definicnia tlacicla sieteCiaryHrdlovehoVedeniaInfo
  (action_tile "sieteCiaryHrdlovehoVedeniaInfo"
    "(SieteCiaryHrdlovehoVedeniaInfo)"
  )
  
  ;definicnia tlacicla sieteCiaryPlynovoduInfo
  (action_tile "sieteCiaryPlynovoduInfo"
    "(SieteCiaryPlynovoduInfo)"
  )
  
  ;definicnia tlacicla sieteCiaryTepelnehoPotrubiaInfo
  (action_tile "sieteCiaryTepelnehoPotrubiaInfo"
    "(SieteCiaryTepelnehoPotrubiaInfo)"
  )
  
  ;definicnia tlacicla sieteCiarySilovehoVedeniaInfo
  (action_tile "sieteCiarySilovehoVedeniaInfo"
    "(SieteCiarySilovehoVedeniaInfo)"
  )
  
  ;definicnia tlacicla sieteCiarySlaboprudehoVedeniaInfo
  (action_tile "sieteCiarySlaboprudehoVedeniaInfo"
    "(SieteCiarySlaboprudehoVedeniaInfo)"
  )
  
  ;definicnia tlacicla sieteCiaryVodaVrstveniceInfo
  (action_tile "sieteCiaryVodaVrstveniceInfo"
    "(SieteCiaryVodaVrstveniceInfo)"
  )
  
  ;definicia tlacidla oznacit vsetko
  (action_tile "tlacidloOznacitVsetko"
    "(OznacitVsetkoFunkcia)"
  )
  
    ;definicia tlacidla odznacit vsetko
  (action_tile "tlacidloOdznacitVsetko"
    "(OdznacitVsetkoFunkcia)"
  )
  
  ;definovanie tlacidla cancel
  (action_tile "cancel"
    "(UkoncenieNetworks)"
  )
  
  ;definovanie tlacidla nacitat
  (action_tile "nacitat"
    "(NacitanieHodnotPoloziek)(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
   
  ;nacitanie vsetkych ciar
  (if (= sieteVsetkyCiary "1")
    (VsetkyCiary)
  )
  
  ;nacitanie ciar hranic
  (if (= sieteCiaryHranic "1")
    (CiaryHranic)
  )
  
  ;nacitanie ciar hranic
  (if (= sieteCiaryZvodidla "1")
    (CiaryZvodidla)
  )
  
  ;nacitanie ciar vodovodu
  (if (= sieteCiaryVodovodu "1")
    (CiaryVodovod)
  )
  
  ;nacitanie ciar kanalizacie
  (if (= sieteCiaryKanalizacie "1")
    (CiaryKanalizacie)
  )
  
  ;nacitanie ciar hrdloveho vedenia
  (if (= sieteCiaryHrdlovehoVedenia "1")
    (CiaryHrdloveVedenie)
  )
  
  ;nacitanie ciar plynovodu
  (if (= sieteCiaryPlynovodu "1")
    (CiaryPlynovodu)
  )
  
  ;nacitanie ciar tepelneho potrubia
  (if (= sieteCiaryTepelnehoPotrubia "1")
    (CiaryTeplenePotrubie)
  )
  
  ;nacitanie ciar siloveho vedenia
  (if (= sieteCiarySilovehoVedenia  "1")
    (CiarySilovehoVedenia)
  )
  
  ;nacitanie ciar slaboprudeho vedenia
  (if (= sieteCiarySlaboprudehoVedenia "1")
    (CiarySlaboprudovehoVedenia)
  )
  
  ;nacitanie ciar voda a vrstvenice
  (if (= sieteCiaryVodaVrstvenice "1")
    (CiaryVodaVrstvenice)
  )
  
  ;regeneracia vykresu
  (vla-Regen (vla-get-activedocument (vlax-get-acad-object)) acAllViewports)

  ;ukoncovacia hlaska funkcie
  (princ "Vsetky ciary boli uspesne nacitane.")
  
  (princ)
  
)

;funkcia tlacidla sieteVsetkyCiaryInfo
(defun SieteVsetkyCiaryInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id1 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteVsetkyCiaryInfo
  (if (not (new_dialog "SieteVsetkyCiaryInfo" dcl_id1))
    (exit)
  )
  
  ;definicia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id1)

)

;funkcia tlacidla sieteCiaryHranicInfo
(defun SieteCiaryHranicInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id2 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiaryHranicInfo
  (if (not (new_dialog "SieteCiaryHranicInfo" dcl_id2))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id2)

)

;funkcia tlacidla sieteCiaryZvodidlaInfo
(defun SieteCiaryZvodidlaInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id3 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiaryZvodidlaInfo
  (if (not (new_dialog "SieteCiaryZvodidlaInfo" dcl_id3))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id3)

)

;funkcia tlacidla sieteCiaryVodovoduInfo
(defun SieteCiaryVodovoduInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id4 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiaryVodovoduInfo
  (if (not (new_dialog "SieteCiaryVodovoduInfo" dcl_id4))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id4)

)

;funkcia tlacidla sieteCiaryKanalizacieInfo
(defun SieteCiaryKanalizacieInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id5 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiaryKanalizacieInfo
  (if (not (new_dialog "SieteCiaryKanalizacieInfo" dcl_id5))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id5)

)

;funkcia tlacidla sieteCiaryHrdlovehoVedeniaInfo
(defun SieteCiaryHrdlovehoVedeniaInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id6 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiaryHrdlovehoVedeniaInfo
  (if (not (new_dialog "SieteCiaryHrdlovehoVedeniaInfo" dcl_id6))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id6)

)

;funkcia tlacidla SieteCiaryPlynovoduInfo
(defun SieteCiaryPlynovoduInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id7 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiaryPlynovoduInfo
  (if (not (new_dialog "SieteCiaryPlynovoduInfo" dcl_id7))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id7)

)

;funkcia tlacidla sieteCiaryTepelnehoPotrubiaInfo
(defun SieteCiaryTepelnehoPotrubiaInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id8 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiaryTepelnehoPotrubiaInfo
  (if (not (new_dialog "SieteCiaryTepelnehoPotrubiaInfo" dcl_id8))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id8)

)

;funkcia tlacidla SieteCiarySilovehoVedeniaInfo
(defun SieteCiarySilovehoVedeniaInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id9 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiarySilovehoVedeniaInfo
  (if (not (new_dialog "SieteCiarySilovehoVedeniaInfo" dcl_id9))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id9)

)

;funkcia tlacidla SieteCiarySlaboprudehoVedenia
(defun SieteCiarySlaboprudehoVedeniaInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id10 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiarySlaboprudehoVedeniaInfo
  (if (not (new_dialog "SieteCiarySlaboprudehoVedeniaInfo" dcl_id10))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id10)

)

;funkcia tlacidla sieteCiaryVodaVrstveniceInfo
(defun SieteCiaryVodaVrstveniceInfo ()
  
  ;nacitanie dialogoveho okna
  (setq dcl_id11 (load_dialog "Networks.dcl"))
  
  ;test existencie dialogu SieteCiaryVodaVrstveniceInfo
  (if (not (new_dialog "SieteCiaryVodaVrstveniceInfo" dcl_id11))
    (exit)
  )
  
  ;definicnia tlacidla zatvorit info
  (action_tile "zatvoritInfo"
    "(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id11)

)

;funkcia tlacidla oznacit vsetko
(defun OznacitVsetkoFunkcia ()
  (set_tile "sieteCiaryHranic" "1")
  (set_tile "sieteCiaryZvodidla" "1")
  (set_tile "sieteCiaryVodovodu" "1")
  (set_tile "sieteCiaryKanalizacie" "1")
  (set_tile "sieteCiaryHrdlovehoVedenia" "1")
  (set_tile "sieteCiaryPlynovodu" "1")
  (set_tile "sieteCiaryTepelnehoPotrubia" "1")
  (set_tile "sieteCiarySilovehoVedenia" "1")
  (set_tile "sieteCiarySlaboprudehoVedenia" "1")
  (set_tile "sieteCiaryVodaVrstvenice" "1")  
)

;funkcia tlacidla odznacit vsetko
(defun OdznacitVsetkoFunkcia ()
  (set_tile "sieteCiaryHranic" "0")
  (set_tile "sieteCiaryZvodidla" "0")
  (set_tile "sieteCiaryVodovodu" "0")
  (set_tile "sieteCiaryKanalizacie" "0")
  (set_tile "sieteCiaryHrdlovehoVedenia" "0")
  (set_tile "sieteCiaryPlynovodu" "0")
  (set_tile "sieteCiaryTepelnehoPotrubia" "0")
  (set_tile "sieteCiarySilovehoVedenia" "0")
  (set_tile "sieteCiarySlaboprudehoVedenia" "0")
  (set_tile "sieteCiaryVodaVrstvenice" "0")  
)

;funkcia tlacidla nacitat
(defun NacitanieHodnotPoloziek ()
  (setq sieteVsetkyCiary (get_tile "sieteVsetkyCiary"))
  (setq sieteCiaryHranic (get_tile "sieteCiaryHranic"))
  (setq sieteCiaryZvodidla (get_tile "sieteCiaryZvodidla"))
  (setq sieteCiaryVodovodu (get_tile "sieteCiaryVodovodu"))
  (setq sieteCiaryKanalizacie (get_tile "sieteCiaryKanalizacie"))
  (setq sieteCiaryHrdlovehoVedenia (get_tile "sieteCiaryHrdlovehoVedenia"))
  (setq sieteCiaryPlynovodu (get_tile "sieteCiaryPlynovodu"))
  (setq sieteCiaryTepelnehoPotrubia (get_tile "sieteCiaryTepelnehoPotrubia"))
  (setq sieteCiarySilovehoVedenia (get_tile "sieteCiarySilovehoVedenia"))
  (setq sieteCiarySlaboprudehoVedenia (get_tile "sieteCiarySlaboprudehoVedenia"))
  (setq sieteCiaryVodaVrstvenice (get_tile "sieteCiaryVodaVrstvenice"))
)

;funkcia pre nacitanie vsetkych ciar
(defun VsetkyCiary()

  (setq listVsetkyCiary (list "201" "203" "204" "205" "206" "207L" "207R" "208" "209" "210L" "210R" "211" "211L" "211R" "212L" "212R" "213" "213L" "213R" "214L" "214R" "215" "215L" "215R" "216L" "216R" "217" "217L" "217R" "218" "220" "221" "222" "223" "224" "225" "226" "227" "422L" "422R" "423" "501A" "501B" "502" "521" "522" "523A" "523B" "523C" "529AL" "529AR" "529B" "530" "605" "606" "607" "610" "611" "612" "615A" "615B" "615C" "616A" "616B" "616C" "617A" "617B" "617C" "623A" "623B" "623C" "624A" "624B" "624C" "625A" "625B" "625C" "626A" "626B" "626C" "627A" "627B" "627C" "628A" "628B" "628C" "629A" "629B" "629C" "630A" "630B" "630C" "630D" "630E" "630F" "631A" "631B" "631C" "631D" "631E" "631F" "632A" "632B" "632C" "633A" "633B" "633C" "634A" "634B" "634C" "635A" "635B" "635C" "636A" "636B" "636C" "637A" "637B" "637C" "651A" "651B" "651C" "652A" "652B" "652C" "653A" "653B" "653C" "654A" "654B" "654C" "655A" "655B" "655C" "659A" "659B" "659C" "660A" "660B" "660C" "660D" "660E" "661A" "661B" "661C" "662A" "662B" "662C" "663A" "663B" "663C" "664A" "664B" "664C" "670A" "670B" "670C" "670D" "670E" "671A" "671B" "671C" "672A" "672B" "672C" "673A" "673B" "673C" "674A" "674B" "674C" "680A" "680B" "680C" "802" "807" "901" "902" "903" "904" "905A" "905B" "906" "909"))

  (setvar "expert" 3)
    (foreach i listVsetkyCiary
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar hranic
(defun CiaryHranic()

  (setq listCiaryHranic (list "201" "203" "204" "205" "206" "207L" "207R" "208" "209" "210L" "210R" "211" "211L" "211R" "212L" "212R" "213" "213L" "213R" "214L" "214R" "215" "215L" "215R" "216L" "216R" "217" "217L" "217R" "218" "220" "221" "222" "223" "224" "225" "226" "227"))

  (setvar "expert" 3)
    (foreach i listCiaryHranic
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar zvodidiel a zabradlia
(defun CiaryZvodidla()

  (setq listCiaryZvodidla (list "529AL" "529AR" "529B" "530" "612"))

  (setvar "expert" 3)
    (foreach i listCiaryZvodidla
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar vodovod
(defun CiaryVodovod()

  (setq listCiaryVodovod (list "615A" "615B" "615C" "616A" "616B" "616C" "617A" "617B" "617C"))

  (setvar "expert" 3)
    (foreach i listCiaryVodovod
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar kanalizacie
(defun CiaryKanalizacie()

  (setq listCiaryKanalizacie (list "623A" "623B" "623C" "624A" "624B" "624C" "625A" "625B" "625C" "626A" "626B" "626C" "627A" "627B" "627C" "628A" "628B" "628C" "629A" "629B" "629C"))

  (setvar "expert" 3)
    (foreach i listCiaryKanalizacie
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar hrdloveho vedenia
(defun CiaryHrdloveVedenie()

  (setq listCiaryHrdloveVedenie (list "630A" "630B" "630C" "630D" "630E" "630F" "631A" "631B" "631C" "631D" "631E" "631F"))

  (setvar "expert" 3)
    (foreach i listCiaryHrdloveVedenie
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar plynovodu
(defun CiaryPlynovodu()

  (setq listCiaryPlynovodu (list "632A" "632B" "632C" "633A" "633B" "633C" "634A" "634B" "634C" "635A" "635B" "635C" "636A" "636B" "636C" "637A" "637B" "637C"))

  (setvar "expert" 3)
    (foreach i listCiaryPlynovodu
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar tepelne potrubie
(defun CiaryTeplenePotrubie()

  (setq listCiaryTeplenePotrubie (list "651A" "651B" "651C" "652A" "652B" "652C" "653A" "653B" "653C" "654A" "654B" "654C" "655A" "655B" "655C"))

  (setvar "expert" 3)
    (foreach i listCiaryTeplenePotrubie
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar siloveho vedenia
(defun CiarySilovehoVedenia()

  (setq listCiarySilovehoVedenia (list "659A" "659B" "659C" "660A" "660B" "660C" "660D" "660E" "661A" "661B" "661C" "662A" "662B" "662C"))

  (setvar "expert" 3)
    (foreach i listCiarySilovehoVedenia
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciar slaboprudove vedenie
(defun CiarySlaboprudovehoVedenia()

  (setq listCiarySlaboprudovehoVedenia (list "663A" "663B" "663C" "664A" "664B" "664C" "670A" "670B" "670C" "670D" "670E" "671A" "671B" "671C" "672A" "672B" "672C" "673A" "673B" "673C"))

  (setvar "expert" 3)
    (foreach i listCiarySlaboprudovehoVedenia
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia pre nacitanie ciary voda a vrstvenice
(defun CiaryVodaVrstvenice()

  (setq listCiaryVodaVrstvenice (list "802" "807" "901" "902" "903" "904" "905A" "905B" "906" "909"))

  (setvar "expert" 3)
    (foreach i listCiaryVodaVrstvenice
      (command "-linetype" "load" i "Linetypes.lin" "")
    )
  (setvar "expert" 0)

)

;funkcia tlacidla zavriet
(defun UkoncenieNetworks()
  (done_dialog)
  (princ "\nNenacitane ziadne ciary.\n")
  (exit)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nNetworks.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;