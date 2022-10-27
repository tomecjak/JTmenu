;=========================================================================
; Networks.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Vytvorenie typu ciar
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                Vytvorenie jednotlivych typov ciar                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTCiary ()

  ;vytvorenie premenej VyberCiary
  (setq VyberCiary
    (getstring "\nAky typ ciar chete nacitat? [Vsetky/0 Hranice/1 Zvodidla/2 Vodovod/3 Kanalizacia/4 Hrdlove vedenie/5 Plynovod/6 Tepelne potrubie/7 Elektricke vedenie/8 Slaboprudove vedenie/9 Voda a vrstvenice] <Vsetky>: ")
  )
    
  ;vyhodnotenie vyberu ciary
  (if (or (= VyberCiary "") (= VyberCiary "V") (= VyberCiary "v"))
    ;vsetky ciary
    (VsetkyCiary)
    
    (if (or (= VyberCiary "0"))
      ;ciary hranic
      (CiaryHranic)
      
      (if (or (= VyberCiary "1"))
        ;ciery zvodidiel a zabradlia
        (CiaryZvodidla)
        
        (if (or (= VyberCiary "2"))
          ;ciary vodovodu
          (CiaryVodovod)
          
          (if (or (= VyberCiary "3"))
            ;ciary kanalizacie
            (CiaryKanalizacie)
            
            (if (or (= VyberCiary "4"))
              ;ciary hrdloveho vedenia
              (CiaryHrdloveVedenie)
              
              (if (or (= VyberCiary "5"))
                ;ciary plynovodu
                (CiaryPlynovodu)
                
                (if (or (= VyberCiary "6"))
                  ;ciary tepelneho potrubia
                  (CiaryTeplenePotrubie)
                  
                  (if (or (= VyberCiary "7"))
                    ;ciary elektrickeho vedenia
                    (CiarySilovehoVedenia)
                    
                    (if (or (= VyberCiary "8"))
                      ;ciary slaboprudoveho vedenia
                      (CiarySlaboprudovehoVedenia)
                      
                      (if (or (= VyberCiary "9"))
                        ;ciary vody a vrstvenice
                        (CiaryVodaVrstvenice)
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
  
  ;regeneracia vsetkych objektov v autocade
  (setq thisdrawing 
       (vla-get-activedocument 
               (vlax-get-acad-object)))

  (vla-Regen thisdrawing acAllViewports)
  
  (princ)
  
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

  (setq listCiaryVodovod (list "616A" "616B" "616C" "617A" "617B" "617C"))

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