;=========================================================================
; Batch_editor.lsp
; (c) Copyright 2012 Lee Mac
; Prelozil Jakub Tomecko
; Verzia: 1.4
;
; Hromadna uprava atributov
;-------------------------------------------------------------------------

;;---------------------=={  Hromadna uprava atributov  }==-----------------------;;
;;                                                                               ;;
;;  --------------------------------------------                                 ;;
;;  Popis programu                                                               ;;
;;  --------------------------------------------                                 ;;
;;                                                                               ;;
;;  Tento program umoznuje uzivatelovi upravovat hodnoty viacerych atributov     ;;
;;  nachadzajucich sa vo viacerych pripravenych blokoch na viacerych vykresoch.  ;;
;;                                                                               ;;
;;  Po spusteni programu pomocou prikazu "BAtte" (Davkovy editor atributov)      ;;
;;  na prikazovom riadku sa pouzivatelovi zobrazi prva z dvoch obrazoviek        ;;
;;  dialogoveho rozhrania: prva obrazovka na zadavanie udajov atributov,         ;;
;;  druha pre vyber vykresy (dwg).                                               ;;
;;                                                                               ;;
;;  --------------------------------                                             ;;
;;  Zadavanie udajov atributu                                                    ;;
;;  --------------------------------                                             ;;
;;                                                                               ;;
;;  V hornej casti obrazovky s� tri editacne polia, do ktorych moze pouzivatel   ;;
;;  zadat nazov bloku, znacku atributu a novu hodnotu pre takyto atribut.        ;;
;;  Pole "Nazov bloku" urcije blok, v ktorom sa nachadza atribut, ktory sa ma    ;;
;;  upravit. Toto pole nerozlisuje velke a male pismena a moze pouzivat zastupne ;;
;;  znaky na priradenie viacerych blokov obsahujucich rovnaku znacku atributu.   ;;
;;  Napriklad, ak zadate nazov bloku "*BLOCK" (bez uvodzoviek), bude sa zhodovat ;;
;;  so vsetkymi blokmi, ktorych nazov bloku konci na "BLOCK", alebo s akoukolvek ;;
;;  variaciou malych a velkych pismen tohto vzoru. Pole "Atribut tag" urcuje     ;;
;;  nazov tagu atributu, ktory sa ma upravit. Toto pole tiez nerozlisuje velke   ;;
;;  a male pismena a podla obmedzeni tykajucich sa nazvov znaciek atributov,     ;;
;;  nemoze obsahov medzery. Nakoniec pole "Hodnota" urcije novy obsah atributu.  ;;
;;  Pre toto pole neexistuju ziadne obmedzenia a moze zostat prasne, ak sa ma    ;;
;;  hodnota atributu odstranit. Po zadani nazvu bloku, znacky atributu a hodnoty ;;
;;  mozno polozku pridat do zoznamu poloziek, ktore sa maju upravit, kliknutim   ;;
;;  na tlacidlo "Pridat polozku" alebo stlacenim klavesy "enter" v poli na       ;;
;;  upravu hodnoty.                                                              ;;
;;                                                                               ;;
;;  --------------------------------                                             ;;
;;  Zvysovanie hodnot atributov                                                  ;;
;;  --------------------------------                                             ;;
;;                                                                               ;;
;;  Editor tiez umoznuje pouzivatelovi automaticky zvysovat hodnoty atributov    ;;
;;  alebo casti hodnot atributov napriec vykresmi, ked ich program spracovava.   ;;
;;  Tato funkcie moze byt uzitocna najma tam, kde ide o atributy zobrazujuce     ;;
;;  cisla vykresov. Ak chcete zvysit hodnotu atributu napriec vykresmi, uzavrite ;;
;;  ciselnu cast atributu znackami "<#" a "#>"                                   ;;
;;                                                                               ;;
;;  Napriklad:                                                                   ;;
;;  ---------------------                                                        ;;
;;                                                                               ;;
;;  Hodnota atributu zadana do programu (bez uvodzoviek):                        ;;
;;                                                                               ;;
;;      "DWG <#1#> z 100"                                                        ;;
;;                                                                               ;;
;;  Hodnota atributu v 1. spracovanom vykrese:  "DWG 1 of 100"                   ;;
;;  Hodnota atributu v 2. spracovanom vykrese:  "DWG 2 of 100"                   ;;
;;  Hodnota atributu v 3. spracovanom vykrese:  "DWG 3 of 100"                   ;;
;;                   ...                            ...                          ;;
;;                                                                               ;;
;;  --------------------------------                                             ;;
;;  Vyber blokov                                                                 ;;
;;  --------------------------------                                             ;;
;;                                                                               ;;
;;  Polozky atributov mozno do zoznamu pridat aj vyberom blokov s atributmi      ;;
;;  z aktivneho vykresu, Po kliknuti na tlacidlo "Vybrat bloky" v hlavnom        ;;
;;  dialogovom okne sa pouzivatelovi zobrazi vyzva na vyber priradenych blokov.  ;;
;;  Hodnoty vsetkych atributov v ramci kazdeho bloku vo vybere sa potom zobrazia ;;
;;  v predchadzajucom dialogovom rozhrani, ktore umoznuje pouzivatelo vybrat,    ;;
;;  ktore polozky z vyberu sa maju pridat do zoznamu poloziek, ktore ma program  ;;
;;  upravit. Duplicitne polozky (t.j. tam, kde sa kombinacia bloku a stitku      ;;
;;  objavi viaciak vo vyber), budu z vyberu odstranene a pouzivatel bude tiez    ;;
;;  informovany o konflikte poloziek, to znamena, ked vybrane kombinacie blokov  ;;
;;  a znaciek z vyberu bloku uz existuju v zozname udajov hlavneho atributu.     ;;
;;  Ak sa pouzivatel rozhodne pokracovat po tejto vyzve, tieto vybrane polozyk   ;;
;;  nahradia polozky, ktore sa uz nachadzaju v hlavnom zozname.
;;                                                                               ;;
;;  --------------------------------                                             ;;
;;  Zoznam udajov o atributoch                                                   ;;
;;  --------------------------------                                             ;;
;;                                                                               ;;
;;  Panel so zoznamom zobrazuje zoznam atributov, ktore ma progrma upravit.      ;;
;;  Polozky v tomto zozname je mozne upravit dvojitym kliknutim na ne. Viacere   ;;
;;  polozky je mozne zo zoznamu odstranit tak, ze ich vyberieme a klikneme na    ;;
;;  tlacidlo "Odstranit polozku". Alebo mozeme cely zoznam odstranit kliknutim   ;;
;;  na tlacidlo "Vymazat". Zoznam udajov atributov je mozne exportovat do CSV    ;;
;;  alebo textoveho suboru (TXT) kliknutim na tlacidlo "Ulozit do suboru"        ;;
;;  a vytvorenim vhodneho suboru ulozeneho na pozadovane miesto pomocou          ;;
;;  dialogoveho okna, ktore sa nasledne zobrazi. Podobne udaje atribitov sa      ;;
;;  nacitavaju z CSV alebo textoveho suboru kliknutim na tlacidlo "Nacitat zo    ;;
;;  suboru" a vyberom suboru zo zobrazenho dialogoveho okna.
;;                                                                               ;;
;;  --------------------------------                                             ;;
;;  Vyber vykresov                                                               ;;
;;  --------------------------------                                             ;;
;;                                                                               ;;
;;  Druha obrazovka dialogu je venovana vyberu vykresov, ktore ma program        ;;
;;  spracovat. Tu si pouzivatel moze vybret adresar bud pomocou tlacidla         ;;
;;  "Prehladvat" v hornej casti dialogoveho okna, alebo zadanim cesty            ;;
;;  k priecinku di pola "Priecinok", potom pokracuje v prehladavani suborov      ;;
;;  a priecinkov v tomto adresati z laveho panala zoznamu. Strukturu priecinkov  ;;
;;  je mozne prechdzat z laveho panela so zoznamom dvojitym kliknutim na uvedeny ;;
;;  priecinok alebo na symbol nadradeneho priecinka (".."). Subory vykresov je   ;;
;;  mozne pridat do panela zo zoznamom vpravo dvojitym kliknutim na subor alebo  ;;
;;  vyberom viacerych suborov a kliknutim na tlacidlo "Pridat subory". Podobne   ;;
;;  je mozne subory odstranit z praveho panela zoznamu. Po zadani udajov         ;;
;;  o atributoch a vybere niekolkych vykresov na spracovanie moze pouzivatel     ;;
;;  kliknut na tlacidlo "Spustit" a upravit uvedene atributy v kazdom            ;;
;;  z vybranych vekresov.                                                        ;;
;;                                                                               ;;
;;  --------------------------------------------                                 ;;
;;  Rady a tipy!                                                                 ;;
;;  --------------------------------------------                                 ;;
;;                                                                               ;;
;;  Ked sa dialogove okno prvykrat zobrazi, pole "Nazov bloku" bude aktivne.     ;;
;;  Pouzivatel potom moze preponat medzi polami "Nazov bloku", "Znacka atributu" ;;
;;  a "Hodnota atributu" stlacenim klavesy "enter" a nakoniec pridat polozku do  ;;
;;  zoznamu stlacenim klavesy "enter" v poli "Hodnota".                          ;;
;;                                                                               ;;
;;  Subory vykresov je mozne pridavat a odstranovat do laveho a praveho panela   ;;
;;  so zoznamom dvojitym kliknutim na subor.
;;                                                                               ;;
;;-------------------------------------------------------------------------------;;

(setq BAtteVersion "1.4")

;;-------------------------------------------------------------------------------;;

(defun c:BAtte

    (
        /
        *error*
        _validate

        *wsh*
        base
        block
        blocks-p
        cfg
        cfgfname
        data
        dclfname
        dclid
        dclstatus
        dcltitle
        dir
        dirdata
        file
        filelist
        files
        lspfname
        result
        savepath
        scrfname
        tag
        value
    )

    (defun *error* ( msg )
        (if (and (= 'vla-object (type *wsh*)) (not (vlax-object-released-p *wsh*)))
            (vlax-release-object *wsh*)
        )
        (if (= 'file (type file))
            (close file)
        )
        (if (< 0 dclID)
            (unload_dialog dclID)
        )
        (if (not (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*"))
            (princ (strcat "\nChyba: " msg))
        )
        (princ)
    )
    
    (cond
        (   (not (vl-file-directory-p (setq savepath (BAtte:GetSavePath))))
            (BAtte:Popup (BAtte:WSH) "Pozor" 16 "Cesta ulozenia nie je platna.")
        )
        (   (progn
                (setq base (strcat savepath "\\LMAC_BAtte_V" (vl-string-translate "." "-" BAtteVersion)))
                (foreach pair
                   '(
                        (dclfname . ".dcl")
                        (lspfname . ".lsp")
                        (cfgfname . ".cfg")
                        (scrfname . ".scr")
                    )
                    (set (car pair) (strcat base (cdr pair)))
                )
                (setq dcltitle (strcat "Batch Attribute Editor V" BAtteVersion))
                (not (BAtte:WriteDCL dclfname))
            )
            (BAtte:Popup
                (BAtte:WSH)
                "Pozor" 16
                (strcat
                    "Subor definicie dialogu (DCL) sa nepodarilo zapisat.\n\n"
                    "Uistite sa, ze mate povolenie na zapis do nasledujuceho adresara:\n\n"
                    savepath
                )
            )
        )
        (   (not (BAtte:WriteLSP lspfname))
            (BAtte:Popup
                (BAtte:WSH)
                "Pozor" 16
                (strcat
                    "Subot LISP Utilities File sa nepodarilo zapisat.\n\n"
                    "Uistite sa, ze mate povolenie na zapis do nasledujuceho adresara:\n\n"
                    savepath
                )
            )
        )
        (   (<= (setq dclID (load_dialog dclfname)) 0)
            (BAtte:Popup
                (BAtte:WSH)
                "Pozor" 16
                (strcat
                    "Nepodarilo sa nacitat nasledujuci subor DLC:\n\n"
                    dclfname
                    "\n\nSubor bud neexistuje, alebo obsahuje chybu."
                )
            )
        )
        (   t
            (if (setq cfg (BAtte:ReadConfig cfgfname))
                (setq data   (car   cfg)
                      dir    (cadr  cfg)
                      result (caddr cfg)
                )
            )

            (setq blocks-p
                (and
                    (ssget "_X"
                        (list
                           '(0 . "INSERT")
                           '(66 . 1)
                            (cons 410
                                (if (= 1 (getvar 'CVPORT))
                                    (getvar 'CTAB)
                                    "Model"
                                )
                            )
                        )
                    )
                )
            )

            (while (not (member dclStatus '(1 0)))
                (cond
                    (
                        (or
                            (null dclStatus)
                            (= 3  dclStatus)
                        )
                        (cond
                            (   (not (new_dialog "batte1" dclID))
                                (BAtte:Popup
                                    (BAtte:WSH)
                                    "Pozor" 16
                                    (strcat
                                        "Dialogove okno programu sa nepodarilo nacitat.\n\n"
                                        "Zodpovedajuci subor DLC sa nachadza na nasledujucom umiestneni:\n\n"
                                        dclfname
                                        "\n\nTento subor obsahuje chybu, kontaktujte autora programu."
                                    )
                                )
                                (setq dclStatus 0)
                            )
                            (   t
                                (set_tile "dcltitle" dcltitle)

                                ;;-------------------------------------------------------------------------------;;
                                ;;                             Attribute Data Screen                             ;;
                                ;;-------------------------------------------------------------------------------;;

                                ;;-------------------------------------------------------------------------------;;
                                ;; Initial Setup                                                                 ;;
                                ;;-------------------------------------------------------------------------------;;

                                (if data
                                    (progn
                                        (setq data (BAtte:UpdateAttributeData "list" data))
                                        (mode_tile "clear"   0)
                                        (mode_tile "save"    0)
                                    )
                                    (progn
                                        (mode_tile "clear"   1)
                                        (mode_tile "save"    1)
                                    )
                                )
                                (mode_tile "delitem" 1)
                                (mapcar 'BAtte:AddList '("h1" "h2" "h3") '(("\tBlock") ("\tTag") ("\tValue")))

                                (if blocks-p
                                    (mode_tile "select" 0)
                                    (mode_tile "select" 1)
                                )

                                ;;-------------------------------------------------------------------------------;;

                                (setq _validate
                                    (lambda ( / tmp )
                                        (cond
                                            (   (or (null block) (eq "" block))
                                                (BAtte:Popup
                                                    (BAtte:WSH)
                                                    "Informacia" 48
                                                    (strcat
                                                        "Prosim vlozte nazov bloku.\n\n"
                                                        "Poznamka: V nazvoch blokov sa nerozlisuju velke a male pismena a mozu pouzivat zastupne znaky"
                                                        " na priradenie viacerych blokov obsahujucich rovnaky atribut tagu."
                                                    )
                                                )
                                                (mode_tile "block" 2)
                                            )
                                            (   (or (null tag) (eq "" tag))
                                                (BAtte:Popup
                                                    (BAtte:WSH)
                                                    "Informacie" 48
                                                    (strcat
                                                        "Prosim vlozte atribut tagu.\n\n"
                                                        "Poznamka: Tagy atributov nerozlisuju velke a male pismena a nemoze obsahovat medzery."
                                                    )
                                                )
                                                (mode_tile "tag" 2)
                                            )
                                            (   (vl-string-position 32 tag)
                                                (BAtte:Popup (BAtte:WSH) "Informacia" 48 "Atribut tagu nemoze obsahovat medzeru.")
                                                (mode_tile "tag" 2)
                                            )
                                            (   (setq tmp
                                                    (vl-some
                                                        (function
                                                            (lambda ( item )
                                                                (if
                                                                    (and
                                                                        (eq (car  item) (strcase block))
                                                                        (eq (cadr item) (strcase   tag))
                                                                    )
                                                                    item
                                                                )
                                                            )
                                                        )
                                                        data
                                                    )
                                                )
                                                (BAtte:Popup
                                                    (BAtte:WSH)
                                                    "Duplicita polozky"
                                                    48
                                                    (strcat
                                                        "Atribut tagu '"
                                                        (cadr tmp)
                                                        "' v ramci bloku '"
                                                        (car  tmp)
                                                        "' sa uz objavuje v zozname, ktory sa ma nastavit na hodnotu \""
                                                        (caddr tmp)
                                                        "\""
                                                    )
                                                )
                                                (mode_tile "block" 2)
                                            )
                                            (   t
                                                (if (null value)
                                                    (setq value "")
                                                )
                                                (setq data (BAtte:UpdateAttributeData "list" (cons (list (strcase block) (strcase tag) value) data))
                                                      block nil
                                                      tag   nil
                                                      value nil
                                                )
                                                (foreach tile '("block" "tag" "value")
                                                    (set_tile tile "")
                                                )
                                                (mode_tile "delitem" 1)
                                                (mode_tile "clear"   0)
                                                (mode_tile "save"    0)
                                                (mode_tile "block"   2)                                    
                                            )
                                        )
                                    )
                                )

                                ;;-------------------------------------------------------------------------------;;
                                ;; Top Buttons                                                                   ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "block"
                                    (vl-prin1-to-string
                                       '(progn
                                            (setq block $value)
                                            (if (= 1 $reason) (mode_tile "tag" 2))
                                        )
                                    )
                                )

                                (action_tile "tag"
                                    (vl-prin1-to-string
                                       '(progn
                                            (setq tag $value)
                                            (if (= 1 $reason) (mode_tile "value" 2))
                                        )
                                    )
                                )
                             
                                (action_tile "value"
                                    (vl-prin1-to-string
                                       '(progn
                                            (setq value $value)
                                            (if (= 1 $reason) (_validate))
                                        )
                                    )
                                )

                                ;;-------------------------------------------------------------------------------;;
                                ;; List Box Panel                                                                ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "list"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / item tmp )
                                                (mode_tile "delitem" 0)
                                                (if (= 4 $reason)
                                                    (progn
                                                        (setq item (nth (atoi $value) data)
                                                              tmp  data
                                                              data (BAtte:UpdateAttributeData "list" (BAtte:EditItem dclID item data))
                                                        )
                                                        (set_tile "list" "")
                                                        (set_tile "list"
                                                            (if (equal tmp data) ; Cancel pressed
                                                                $value
                                                                (itoa
                                                                    (vl-position
                                                                        (car (vl-remove-if '(lambda ( x ) (member x tmp)) data))
                                                                        data
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

                                ;;-------------------------------------------------------------------------------;;
                                ;; Add / Select / Remove Buttons                                                 ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "additem" "(_validate)")

                                (action_tile "select" "(done_dialog 4)")

                                (action_tile "delitem"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / items )
                                                (if (setq items (read (strcat "(" (get_tile "list") ")")))
                                                    (setq data  (BAtte:UpdateAttributeData "list" (BAtte:RemoveItems items data)))
                                                )
                                                (mode_tile "delitem" 1)
                                                (if (null data)
                                                    (progn
                                                        (mode_tile "clear" 1)
                                                        (mode_tile "save"  1)
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )

                                ;;-------------------------------------------------------------------------------;;
                                ;; Bottom Buttons                                                                ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "load"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / tmp )
                                                (if (setq tmp  (BAtte:LoadFromFile))
                                                    (progn
                                                        (setq data (BAtte:UpdateAttributeData "list" tmp))
                                                        (mode_tile "clear"   0)
                                                        (mode_tile "save"    0)
                                                        (mode_tile "block"   2)
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )

                                (action_tile "clear"
                                    (vl-prin1-to-string
                                       '(progn
                                            (setq data (BAtte:UpdateAttributeData "list" nil))
                                            (mode_tile "delitem" 1)
                                            (mode_tile "clear"   1)
                                            (mode_tile "save"    1)
                                        )
                                    )
                                )

                                (action_tile "save" "(BAtte:SaveToFile data)")

                                ;;-------------------------------------------------------------------------------;;
                                ;; Base of Dialog                                                                ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "accept"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / removed )
                                                (cond
                                                    (   (null data)
                                                        (BAtte:Popup
                                                            (BAtte:WSH)
                                                            "Informacia" 64
                                                            (strcat
                                                                "Nenasli sa ziadne udaje o atributoch.\n\n"
                                                                "Zadajte nazov bloku, atribut tagu a novu hodnotu atributu"
                                                                " v prislusnych poliach v hornej casti dialogoveho okna.\n\n"
                                                                "Kliknutim na  'Pridat polozku' pridate zadane udaje do zoznamu atributov, ktore sa maju aktualizovat."
                                                            )
                                                        )
                                                    )
                                                    (   (done_dialog 2)   )
                                                )
                                            )
                                        )
                                    )
                                )

                                (setq dclStatus (start_dialog))
                            )
                        )
                    )
                    (   (= 2 dclStatus)
                        (cond
                            (   (not (new_dialog "batte2" dclID))
                                (BAtte:Popup
                                    (BAtte:WSH)
                                    "Pozor" 16
                                    (strcat
                                        "Dialogove okno programu sa nepodarilo nacitat.\n\n"
                                        "Zodpovedajuci subor DLC sa nachdza na nasledujucom umiestneni:\n\n"
                                        dclfname
                                        "\n\nTento subor obsahuje chybu, kontaktujte autora programu."
                                    )
                                )
                                (setq dclStatus 0)
                            )
                            (   t
                                (set_tile "dcltitle" dcltitle)

                                ;;-------------------------------------------------------------------------------;;
                                ;;                                Drawings Panel                                 ;;
                                ;;-------------------------------------------------------------------------------;;

                                ;;-------------------------------------------------------------------------------;;
                                ;; Initial Setup                                                                 ;;
                                ;;-------------------------------------------------------------------------------;;

                                (set_tile "directory"
                                    (setq dir
                                        (BAtte:FixDir
                                            (if (or
                                                    (null dir)
                                                    (null (vl-file-directory-p (BAtte:FixDir dir)))
                                                 )
                                                 (getvar 'DWGPREFIX)
                                                 dir
                                            )
                                        )
                                    )
                                )
                                (setq files  (BAtte:UpdateFileList dir result)
                                      result (BAtte:UpdateSelected dir result)
                                )
                                (mode_tile "add" 1)
                                (mode_tile "del" 1)

                                ;;-------------------------------------------------------------------------------;;
                                ;; Top Items                                                                     ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "browse"
                                    (vl-prin1-to-string
                                       '(if (setq tmp    (BAtte:BrowseForFolder "" nil 512))
                                            (setq files  (BAtte:UpdateFileList (set_tile "directory" (setq dir tmp)) result)
                                                  result (BAtte:UpdateSelected dir result)
                                            )                              
                                        )
                                    )
                                )

                                (action_tile "directory"
                                    (vl-prin1-to-string
                                       '(if (= 1 $reason)
                                            (setq files  (BAtte:UpdateFileList (set_tile "directory" (setq dir (BAtte:FixDir $value))) result)
                                                  result (BAtte:UpdateSelected dir result)
                                            )
                                        )
                                    )
                                )

                                ;;-------------------------------------------------------------------------------;;
                                ;; File List Box Panels                                                          ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "box1"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / items tmp )
                                                (setq items
                                                    (mapcar
                                                        (function
                                                            (lambda ( n ) (nth n files))
                                                        )
                                                        (read (strcat "(" $value ")"))
                                                    )
                                                )
                                                (if (= 4 $reason)
                                                    (progn
                                                        (cond
                                                            (   (equal '("..") items)
                                                                (setq files  (BAtte:UpdateFileList (set_tile "directory" (setq dir (BAtte:UpDir dir))) result)
                                                                      result (BAtte:UpdateSelected dir result)
                                                                )
                                                            )
                                                            (   (and
                                                                    (null (vl-filename-extension (car items)))
                                                                    (vl-file-directory-p (setq tmp (BAtte:CheckRedirect (strcat dir "\\" (car items)))))
                                                                )
                                                                (setq files  (BAtte:UpdateFileList (set_tile "directory" (setq dir tmp)) result)
                                                                      result (BAtte:UpdateSelected dir result)
                                                                )
                                                            )
                                                            (   t                                     
                                                                (setq result (BAtte:UpdateSelected dir (BAtte:filesort (append result (mapcar '(lambda ( file ) (strcat dir "\\" file)) items))))
                                                                      files  (BAtte:UpdateFileList dir result)
                                                                )
                                                            )
                                                        )
                                                        (mode_tile "add" 1)
                                                    )
                                                    (if (vl-some 'vl-filename-extension items)
                                                        (mode_tile "add" 0)
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )

                                (action_tile "box2"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / items )
                                                (setq items
                                                    (mapcar
                                                        (function
                                                            (lambda ( n ) (nth n result))
                                                        )
                                                        (read (strcat "(" $value ")"))
                                                    )
                                                )
                                                (if (= 4 $reason)
                                                    (setq result (BAtte:UpdateSelected dir (vl-remove (car items) result))
                                                          files  (BAtte:UpdateFileList dir result)
                                                    )
                                                    (mode_tile "del" 0)
                                                )
                                            )
                                        )
                                    )
                                )

                                ;;-------------------------------------------------------------------------------;;
                                ;; Add/Remove Buttons                                                            ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "add"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / items )
                                                (if (setq items
                                                        (vl-remove-if-not 'vl-filename-extension
                                                            (mapcar
                                                                (function
                                                                    (lambda ( n ) (nth n files))
                                                                )
                                                                (read (strcat "(" (get_tile "box1") ")"))
                                                            )
                                                        )
                                                    )
                                                    (setq result (BAtte:UpdateSelected dir (BAtte:filesort (append result (mapcar '(lambda ( file ) (strcat dir "\\" file)) items))))
                                                          files  (BAtte:UpdateFileList dir result)
                                                    )
                                                )
                                                (mode_tile "add" 1)
                                                (mode_tile "del" 1)
                                            )
                                        )
                                    )
                                )

                                (action_tile "del"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / items )
                                                (if (setq items
                                                        (mapcar
                                                            (function
                                                                (lambda ( n ) (nth n result))
                                                            )
                                                            (read (strcat "(" (get_tile "box2") ")"))
                                                        )
                                                    )
                                                    (setq result (BAtte:UpdateSelected dir (vl-remove-if (function (lambda ( file ) (member file items))) result))
                                                          files  (BAtte:UpdateFileList dir result)
                                                    )
                                                )
                                                (mode_tile "add" 1)
                                                (mode_tile "del" 1)
                                            )
                                        )
                                    )
                                )

                                ;;-------------------------------------------------------------------------------;;
                                ;; Base of Dialog                                                                ;;
                                ;;-------------------------------------------------------------------------------;;

                                (action_tile "back" "(done_dialog 3)")

                                (action_tile "accept"
                                    (vl-prin1-to-string
                                       '(
                                            (lambda ( / removed )
                                                (cond
                                                    (   (null result)
                                                        (BAtte:Popup
                                                            (BAtte:WSH)
                                                            "Informacia" 64
                                                            (strcat
                                                                "Ziaden vybraty vykres.\n\n"
                                                                "Prejdi do adresara pomocou laveho panela so zoznamom, tlacidlom 'Prehladvat' alebo pomocou"
                                                                " specifikovanim adresara v edita?nom poli 'Priecinok' a stlacenim 'Enter'.\n\n"
                                                                "Vyberte subory z adresara dvojitym kliknutim na subor alebo vyberom skupiny"
                                                                " suborov a kliknite na tlacidlo 'Pridat Subory'."
                                                            )
                                                        )
                                                    )
                                                    (   (null
                                                            (setq filelist
                                                                (vl-remove-if
                                                                    (function
                                                                        (lambda ( file / dwl )
                                                                            (if
                                                                                (and
                                                                                    (setq dwl (findfile (strcat (substr file 1 (- (strlen file) 3)) "dwl")))
                                                                                    (null (vl-file-delete dwl))
                                                                                )
                                                                                (setq removed
                                                                                    (cons
                                                                                        (strcat
                                                                                            (vl-filename-base file) ".dwg\t"
                                                                                            (
                                                                                                (lambda ( / tmp usr )
                                                                                                    (if (setq tmp (open dwl "r"))
                                                                                                        (progn
                                                                                                            (setq usr (read-line tmp)
                                                                                                                  tmp (close tmp)
                                                                                                            )
                                                                                                            usr
                                                                                                        )
                                                                                                        "<Unknown>"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                        removed
                                                                                    )
                                                                                )
                                                                            )           
                                                                        )
                                                                    )
                                                                    result
                                                                )
                                                            )
                                                        )
                                                        (BAtte:Popup
                                                            (BAtte:WSH)
                                                            "Vsetky subory sa pouzivaju" 48
                                                            (strcat
                                                                "Vsetky vybrane subory sa momentalne pouzivaju a nie je mozne ich spracovat:\n\n"
                                                                "Filename\t\t\tOpen By\n"
                                                                (BAtte:lst->str (reverse removed) "\n")
                                                            )                                                
                                                        )
                                                    )
                                                    (   removed
                                                        (if
                                                            (= 6
                                                                (BAtte:Popup
                                                                    (BAtte:WSH)
                                                                    "Pouzivane subory" (+ 32 4)
                                                                    (strcat
                                                                        "Nasledujuce subory sa pouzivaju a nebudu spracovanie:\n\n"
                                                                        "Filename\t\tOpen By\n"
                                                                        (BAtte:lst->str (reverse removed) "\n")
                                                                        "\n\nPokracovat?"
                                                                    )
                                                                )
                                                            )
                                                            (done_dialog 1)
                                                        )
                                                    )
                                                    (   (done_dialog 1)   )
                                                )
                                            )
                                        )
                                    )
                                )

                                (setq dclStatus (start_dialog))
                            )
                        )
                    )
                    (   (= 4 dclStatus)
                        (setq data (BAtte:SelectBlocks dclID data))

                        (setq dclStatus 3)
                    )
                )
            )

            ;;-------------------------------------------------------------------------------;;

            (if (= 1 dclStatus)
                (progn
                    (BAtte:WriteConfig cfgfname data dir result)

                    (if (setq file (open scrfname "w"))
                        (progn
                            (foreach name filelist
                                (write-line
                                    (strcat
                                        "_.open \"" name "\" "
                                        "(load " (vl-prin1-to-string lspfname) " nil) "
                                        "(if (and BAtte:SetAttributes (vl-bb-ref 'BAtte:data)) (BAtte:SetAttributes (vl-bb-ref 'BAtte:data))) "
                                        "(if (vl-bb-ref 'BAtte:dwgcounter) (vl-bb-set 'BAtte:dwgcounter (1+ (vl-bb-ref 'BAtte:dwgcounter)))) "
                                        "_.qsave _.close"
                                    )
                                    file
                                )
                            )
                            (setq file (close file))
                            (vl-bb-set 'BAtte:data (BAtte:ConvertDataList data))
                            (vl-bb-set 'BAtte:dwgcounter 0)

                            (if
                                (and
                                    dclID
                                    (< 0 dclID)
                                )
                                (setq dclID (unload_dialog dclID))
                            )
                            (if
                                (and
                                    *wsh*
                                    (eq 'VLA-OBJECT (type *wsh*))
                                    (not (vlax-object-released-p *wsh*))
                                )
                                (progn
                                    (vlax-release-object *wsh*)
                                    (setq *wsh* nil)
                                )
                            )
                            (vl-cmdf "_.script" scrfname)
                        )
                        (BAtte:Popup
                            (BAtte:WSH)
                            "Pozor" 16
                            (strcat
                                "Subor skriptu sa nepodatilo ziskat.\n\n"
                                "Uistite sa, ze mate povolenie na zapis do nasledujuceho adresara:\n\n"
                                savepath
                            )
                        )
                    )
                )
                (princ "\n*Cancel*")
            )
        )
    )
    (if (< 0 dclID)
        (setq dclID (unload_dialog dclID))
    )
    (if (and
            (= 'vla-object (type *wsh*))
            (not (vlax-object-released-p *wsh*))
        )
        (vlax-release-object *wsh*)
    )
    (princ)
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:AddQuotes ( str / pos )
    (cond
        (   (wcmatch str "*[`,\"]*")
            (setq pos 0)    
            (while (setq pos (vl-string-position 34 str pos))
                (setq str (vl-string-subst "\"\"" "\"" str pos)
                      pos (+ pos 2)
                )
            )
            (strcat "\"" str "\"")
        )
        (   str   )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:ReplaceQuotes ( str / pos )
    (setq pos 0)
    (while (setq pos (vl-string-search  "\"\"" str pos))
        (setq str (vl-string-subst "\"" "\"\"" str pos)
              pos (1+ pos)
        )
    )
    str
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:lst->str ( lst del )
    (if (cdr lst)
        (strcat (car lst) del (BAtte:lst->str (cdr lst) del))
        (car lst)
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:str->lst ( str del / pos )
    (if (setq pos (vl-string-search del str))
        (cons (substr str 1 pos) (BAtte:str->lst (substr str (+ pos 1 (strlen del))) del))
        (list str)
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:lst->csv ( lst )
    (if (cdr lst)
        (strcat (BAtte:AddQuotes (car lst)) "," (BAtte:lst->csv (cdr lst)))
        (BAtte:AddQuotes (car lst))
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:csv->lst ( str pos / s )
    (cond
        (   (null (setq pos (vl-string-position 44 str pos)))
            (if (wcmatch str "\"*\"")
                (list (BAtte:ReplaceQuotes (substr str 2 (- (strlen str) 2))))
                (list str)
            )
        )
        (   (wcmatch (setq s (substr str 1 pos)) "\"*\"")
            (cons
                (BAtte:ReplaceQuotes (substr str 2 (- pos 2)))
                (BAtte:csv->lst (substr str (+ pos 2)) 0)
            )
        )
        (   (wcmatch s "\"*[~\"]")
            (BAtte:csv->lst str (+ pos 2))
        )
        (   (cons s (BAtte:csv->lst (substr str (+ pos 2)) 0)))
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:ReadConfig ( name / data dir file files line )
    (if
        (and
            (setq name (findfile name))
            (setq file (open name "r"))
        )
        (progn
            (while
                (and
                    (setq line (read-line file))
                    (not (eq "" line))
                )
                (setq data (cons (BAtte:str->lst line "\t") data))
            )
            (setq dir (read-line file))
            (while (setq line (read-line file))
                (setq files (cons line files))
            )
            (setq file (close file))
            (list
                (reverse data)
                dir
                (reverse (vl-remove-if-not 'findfile files))
            )                
        )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:WriteConfig ( name data dir files / file )
    (if
        (and
            data dir files
            (setq file (open name "w"))
        )
        (progn
            (foreach item data
                (write-line (BAtte:lst->str item "\t") file)
            )
            (write-line ""  file)
            (write-line dir file)
            (foreach item files
                (write-line item file)
            )
            (setq file (close file))
            t
        )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:WriteLSP ( fname / file )
    (cond
        (   (findfile fname)
        )
        (   (setq file (open fname "w"))
            (foreach line
               '(
                    ";;--------------------=={ Set Attributes }==------------------;;"
                    ";;                                                            ;;"
                    ";;  Sets the values of all attributes found in the supplied   ;;"
                    ";;  association list to their associated values.              ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Author: Lee Mac, Copyright � 2012 - www.lee-mac.com       ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Arguments:                                                ;;"
                    ";;  data - List of ((\"Block\" (\"Tag\" . \"Value\") .. ) .. )      ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Returns:  -None-                                          ;;"
                    ";;------------------------------------------------------------;;"
                    ""
                    "(defun BAtte:SetAttributes ( data / i l n o p q s v x )"
                    "    (if"
                    "        (setq s"
                    "            (ssget \"_X\""
                    "                (list"
                    "                   '(0 . \"INSERT\")"
                    "                   '(66 . 1)"
                    "                    (cons 2 (strcat \"`*U*,\" (BAtte:lst->str (mapcar 'car data) \",\")))"
                    "                )"
                    "            )"
                    "        )"
                    "        (repeat (setq i (sslength s))"
                    "            (setq o (vlax-ename->vla-object (ssname s (setq i (1- i))))"
                    "                  n (strcase (BAtte:EffectiveName o))"
                    "            )"
                    "            (if"
                    "                (setq l"
                    "                    (vl-some"
                    "                        (function"
                    "                            (lambda ( x )"
                    "                                (if (wcmatch n (strcase (car x)))"
                    "                                    (cdr x)"
                    "                                )"
                    "                            )"
                    "                        )"
                    "                        data"
                    "                    )"
                    "                )"
                    "                (foreach a (vlax-invoke o 'getattributes)"
                    "                    (cond"
                    "                        (   (null (setq v (cdr (assoc (strcase (vla-get-tagstring a)) l))))"
                    "                        )"
                    "                        (   (and"
                    "                                (wcmatch v \"*<`#*`#>*\")"
                    "                                (vl-bb-ref 'BAtte:dwgcounter)"
                    "                                (setq p (vl-string-search \"<#\" v)"
                    "                                      q (vl-string-search \"#>\" v)"
                    "                                )"
                    "                                (member (type (setq x (read (substr v (+ p 3) (- q p 2))))) '(int real))"
                    "                            )"
                    "                            (vla-put-textstring a"
                    "                                (strcat"
                    "                                    (substr v 1 p)"
                    "                                    (vl-princ-to-string (+ x (vl-bb-ref 'BAtte:dwgcounter)))"
                    "                                    (substr v (+ q 3))"
                    "                                )"
                    "                            )"
                    "                        )"
                    "                        (   t"
                    "                            (vla-put-textstring a v)"
                    "                        )"
                    "                    )"
                    "                )"
                    "            )"
                    "        )"
                    "    )"
                    "    (princ)"
                    ")"
                    ""
                    ";;-------------------=={ List to String }==-------------------;;"
                    ";;                                                            ;;"
                    ";;  Constructs a string from a list of strings separating     ;;"
                    ";;  each element by a specified delimiter                     ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Author: Lee Mac, Copyright � 2012 - www.lee-mac.com       ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Arguments:                                                ;;"
                    ";;  lst - a list of strings to process                        ;;"
                    ";;  del - delimiter by which to separate each list element    ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Returns:  String containing each string in the list       ;;"
                    ";;------------------------------------------------------------;;"
                    ""
                    "(defun BAtte:lst->str ( lst del )"
                    "    (if (cdr lst)"
                    "        (strcat (car lst) del (BAtte:lst->str (cdr lst) del))"
                    "        (car lst)"
                    "    )"
                    ")"
                    ""
                    ";;----------------=={ Effective Block Name }==----------------;;"
                    ";;                                                            ;;"
                    ";;  Returns the effective name of a block.                    ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Author: Lee Mac, Copyright � 2012 - www.lee-mac.com       ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Arguments:                                                ;;"
                    ";;  obj - VLA Block Reference Object                          ;;"
                    ";;------------------------------------------------------------;;"
                    ";;  Returns:  True block name as per the block definition     ;;"
                    ";;------------------------------------------------------------;;"
                    ""
                    "(defun BAtte:EffectiveName ( obj )"
                    "    (if (vlax-property-available-p obj 'effectivename)"
                    "        (vla-get-effectivename obj)"
                    "        (vla-get-name obj)"
                    "    )"
                    ")"
                    ""
                    "(vl-load-com) (princ)"
                    ""
                    ";;------------------------------------------------------------;;"
                    ";;                         End of File                        ;;"
                    ";;------------------------------------------------------------;;"
                )
                (write-line line file)
            )
            (setq file (close file))
            (while (not (findfile fname)))
            fname
        )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:WriteDCL ( fname / file )
    (cond
        (   (findfile fname)
        )
        (   (setq file (open fname "w"))
            (foreach line
               '(
                    "//---------------=={ Batch Attribute Editor }==---------------//"
                    "//                                                            //"
                    "//  BAtte.dcl dialog definition file to be used in            //"
                    "//  conjunction with BAtte.lsp                                //"
                    "//------------------------------------------------------------//"
                    "//  Author: Lee Mac, Copyright � 2012 - www.lee-mac.com       //"
                    "//------------------------------------------------------------//"
                    ""
                    "//------------------------------------------------------------//"
                    "//                  Sub-Assembly Definitions                  //"
                    "//------------------------------------------------------------//"
                    ""
                    "head : list_box"
                    "{"
                    "    is_enabled = false;"
                    "    fixed_height = true;"
                    "    fixed_width = true;"
                    "    height = 2;"
                    "    vertical_margin = none;"
                    "    horizontal_margin = none;"
                    "}"
                    ""
                    "txt : text     { vertical_margin = none; }"
                    "edt : edit_box { vertical_margin = 0.1; edit_limit = 1024; }"
                    ""
                    "but1 : button"
                    "{"
                    "    fixed_width = true;"
                    "    fixed_height = true;"
                    "    width = 20;"
                    "    height = 1.8;"
                    "    alignment = centered;"
                    "}"
                    ""
                    "but2 : button"
                    "{"
                    "    fixed_width = true;"
                    "    fixed_height = true;"
                    "    width = 15;"
                    "    height = 1.8;"
                    "}"
                    ""
                    "but3 : button"
                    "{"
                    "    fixed_width = true;"
                    "    fixed_height = true;"
                    "    width = 18;"
                    "    height = 2.2;"
                    "}"
                    ""
                    "dwgbox : list_box"
                    "{"
                    "    width = 40;"
                    "    height = 24;"
                    "    fixed_width = true;"
                    "    fixed_height = true;"
                    "    alignment = centered;"
                    "    multiple_select = true;"
                    "    vertical_margin = none;"
                    "    tab_truncate = true;"
                    "}"
                    ""
                    "tagbox : list_box"
                    "{"
                    "    width = 80;"
                    "    height = 19;"
                    "    fixed_height = true;"
                    "    fixed_width = true;"
                    "    tabs = \"22 44\";"
                    "    vertical_margin = none;"
                    "    horizontal_margin = none;"
                    "    multiple_select = true;"
                    "    tab_truncate = true;"
                    "}"
                    ""
                    "editbox : edit_box"
                    "{"
                    "    width = 65;"
                    "    fixed_width = true;"
                    "    edit_limit = 1024;"
                    "}"
                    ""
                    "edittxt : text"
                    "{"
                    "    alignment = right;"
                    "}"
                    ""
                    "spacer0 : spacer"
                    "{"
                    "    width = 0.1;"
                    "    height = 0.1;"
                    "    fixed_width = true;"
                    "    fixed_height = true;"
                    "}"
                    ""
                    "//------------------------------------------------------------//"
                    "//                    Edit Dialog Definition                  //"
                    "//------------------------------------------------------------//"
                    ""
                    "edit : dialog"
                    "{"
                    "    initial_focus = \"block\";"
                    "    label = \"Edit Item\";"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        : column"
                    "        {"
                    "            spacer0;"
                    "            : edittxt { label = \"Block:\"; }"
                    "            spacer0;"
                    "        }"
                    "        : editbox { key = \"block\"; }"
                    "    }"
                    "    : row"
                    "    {"
                    "        : column"
                    "        {"
                    "            spacer0;"
                    "            : edittxt { label = \"Tag:\"; }"
                    "            spacer0;"
                    "        }"
                    "        : editbox { key = \"tag\"; }"
                    "    }"
                    "    : row"
                    "    {"
                    "        : column"
                    "        {"
                    "            spacer0;"
                    "            : edittxt { label = \"Value:\"; }"
                    "            spacer0;"
                    "        }"
                    "        : editbox { key = \"value\"; }"
                    "    }"
                    "    spacer_1;"
                    "    ok_cancel;"
                    "}"
                    ""
                    "//------------------------------------------------------------//"
                    "//                Block Selection Dialog Definition           //"
                    "//------------------------------------------------------------//"
                    ""
                    "select : dialog"
                    "{"
                    "    label = \"Select Items to Add\";"
                    "    spacer_1;"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = left;"
                    "        spacer;"
                    "        : text { label = \"Select items to add to the attribute data list:\"; }"
                    "    }"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        spacer;"
                    "        : head { key = \"h1\"; width = 22; tabs = \"8\"; }"
                    "        : head { key = \"h2\"; width = 22; tabs = \"8\"; }"
                    "        : head { key = \"h3\"; width = 36; tabs = \"15\";}"
                    "        spacer;"
                    "    }"
                    "    : row"
                    "    {"
                    "        spacer;"
                    "        : tagbox { key = \"list\"; }"
                    "        spacer;"
                    "    }"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = left;"
                    "        spacer;"
                    "        : toggle { label = \"Select All\"; key = \"all\"; }"
                    "    }"
                    "    ok_cancel;"
                    "}"
                    ""
                    "//------------------------------------------------------------//"
                    "//                    Main Dialog Definition                  //"
                    "//------------------------------------------------------------//"
                    ""
                    "//------------------------------------------------------------//"
                    "//                          Screen 1                          //"
                    "//------------------------------------------------------------//"
                    ""
                    "batte1 : dialog"
                    "{"
                    "    initial_focus = \"block\";"
                    "    key = \"dcltitle\";"
                    "    spacer;"
                    "    : text { alignment = right; label = \"Copyright (c) Lee Mac 2012  -  www.lee-mac.com\"; }"
                    "    : boxed_column"
                    "    {"
                    "        label = \"Attribute Data\";"
                    "        : column"
                    "        {"
                    "            : row"
                    "            {"
                    "                : column"
                    "                {"
                    "                    : txt { label = \"Block Name\"; }"
                    "                    : edt { key = \"block\"; }"
                    "                }"
                    "                : column"
                    "                {"
                    "                    : txt { label = \"Attribute Tag\"; }"
                    "                    : edt { key = \"tag\"; }"
                    "                }"
                    "                : column"
                    "                {"
                    "                    : txt { label = \"Attribute Value\"; }"
                    "                    : edt { key = \"value\"; }"
                    "                }"
                    "            }"
                    "            spacer;"
                    "        }"
                    "        spacer;"
                    "        : row"
                    "        {"
                    "            fixed_width = true;"
                    "            alignment = centered;"
                    "            : but1 { key = \"additem\"; label = \"&Add Item\"; mnemonic = \"A\"; }"
                    "            spacer;"
                    "            : but2 { key = \"select\";  label = \"Select &Blocks...\"; mnemonic = \"B\"; }"
                    "            spacer;"
                    "            : but1 { key = \"delitem\"; label = \"&Remove Item\"; mnemonic = \"R\"; }"
                    "        }"
                    "        spacer;"
                    "        : row"
                    "        {"
                    "            fixed_width = true;"
                    "            alignment = left;"
                    "            spacer;"
                    "            : text { label = \"Double-click to edit item\"; }"
                    "        }"
                    "        : row"
                    "        {"
                    "            spacer;"
                    "            : head { key = \"h1\"; width = 22; tabs = \"8\"; }"
                    "            : head { key = \"h2\"; width = 22; tabs = \"8\"; }"
                    "            : head { key = \"h3\"; width = 36; tabs = \"15\";}"
                    "            spacer;"
                    "        }"
                    "        : row"
                    "        {"
                    "            spacer;"
                    "            : tagbox { key = \"list\"; }"
                    "            spacer;"
                    "        }"
                    "        : row"
                    "        {"
                    "            fixed_width = true;"
                    "            alignment = centered;"
                    "            : but1 { key = \"load\"; label = \"&Load from File\"; mnemonic = \"L\"; }"
                    "            spacer;"
                    "            : but2 { key = \"clear\"; label = \"&Clear\"; mnemonic = \"C\"; }"
                    "            spacer;"
                    "            : but1 { key = \"save\"; label = \"&Save to File\"; mnemonic = \"S\"; }"
                    "        }"
                    "        spacer;"
                    "    }"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = centered;"
                    "        : but3 { key = \"accept\"; is_default = true; label = \"&Next\"; mnemonic = \"N\"; }"
                    "        spacer_1;"
                    "        : but3 { key = \"cancel\"; is_cancel = true; label = \"&Exit\"; mnemonic = \"E\"; }"
                    "    }"
                    "}"
                    ""
                    "//------------------------------------------------------------//"
                    "//                          Screen 2                          //"
                    "//------------------------------------------------------------//"
                    ""
                    "batte2 : dialog"
                    "{"
                    "    key = \"dcltitle\";"
                    "    spacer;"
                    "    : text { alignment = right; label = \"Copyright (c) Lee Mac 2012  -  www.lee-mac.com\"; }"
                    "    : boxed_column"
                    "    {"
                    "        label = \"Drawings to Process\";"
                    "        : column"
                    "        {"
                    "            : txt { label = \"Folder\"; }"
                    "            : row"
                    "            {"
                    "                : edt { key = \"directory\"; }"
                    "                : button { key = \"browse\"; label = \"&Browse\"; mnemonic = \"B\"; fixed_width = true; }"
                    "            }"
                    "        }"
                    "        spacer_1;"
                    "        : row"
                    "        {"
                    "            : column"
                    "            {"
                    "                fixed_width = true;"
                    "        	      alignment = centered;"
                    "                : dwgbox { key = \"box1\"; }"
                    "                : but1   { key = \"add\" ; label = \"&Add Files\"; mnemonic = \"A\"; }"
                    "                spacer;"
                    "            }"
                    "            : column"
                    "            {"
                    "                fixed_width = true;"
                    "        	      alignment = centered;"
                    "                : dwgbox { key = \"box2\"; }"
                    "                : but1   { key = \"del\" ; label = \"Remove &Files\"; mnemonic = \"F\"; }"
                    "                spacer;"
                    "            }"
                    "        }"
                    "    }"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = centered;"
                    "        : but3 { key = \"back\"; label = \"Ba&ck\"; mnemonic = \"c\"; }"
                    "        spacer_1;"
                    "        : but3 { key = \"accept\"; is_default = true; label = \"&Run\"; mnemonic = \"R\"; }"
                    "        spacer_1;"
                    "        : but3 { key = \"cancel\"; is_cancel = true; label = \"&Exit\"; mnemonic = \"E\"; }"
                    "    }"
                    "}"
                    ""
                    "//------------------------------------------------------------//"
                    "//                         End of File                        //"
                    "//------------------------------------------------------------//"
                )
                (write-line line file)
            )
            (setq file (close file))
            (while (not (findfile fname)))
            fname
        )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:GetSavePath ( / tmp )
    (cond      
        (   (setq tmp (getvar 'ROAMABLEROOTPREFIX))
            (strcat (vl-string-right-trim "\\" (vl-string-translate "/" "\\" tmp)) "\\Support")
        )
        (   (setq tmp (findfile "ACAD.pat"))
            (vl-string-right-trim "\\" (vl-string-translate "/" "\\" (vl-filename-directory tmp)))
        )
        (   (vl-string-right-trim "\\" (vl-filename-directory (vl-filename-mktemp))))
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:WSH nil
    (cond
        (   *wsh*   )
        (   (setq *wsh* (vlax-create-object "WScript.Shell")   )
        )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:Popup ( wsh title flags msg / err )
    (setq err (vl-catch-all-apply 'vlax-invoke-method (list wsh 'popup msg 0 title flags)))
    (if (null (vl-catch-all-error-p err))
        err
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:AddList ( key lst )
    (start_list key)
    (foreach x lst (add_list x))
    (end_list)
    lst
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:CheckRedirect ( dir / itm pos )
    (cond
        (   (vl-directory-files dir)
            dir
        )
        (   (and
                (eq
                    (strcase (getenv "UserProfile"))
                    (strcase (substr dir 1 (setq pos (vl-string-position 92 dir nil t))))
                )
                (setq itm
                    (cdr
                        (assoc (substr (strcase dir t) (+ pos 2))
                           '(
                                ("my documents" . "Documents")
                                ("my pictures"  . "Pictures")
                                ("my videos"    . "Videos")
                                ("my music"     . "Music")
                            )
                        )
                    )
                )
                (vl-file-directory-p (setq itm (strcat (substr dir 1 pos) "\\" itm)))
            )
            itm
        )
        (   dir   )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:GetFiles ( dir files )
    (vl-remove-if
        (function (lambda ( file ) (member (strcat dir "\\" file) files)))
        (cond
            (   (cdr (assoc dir dirdata))   )
            (   (cdar
                    (setq dirdata
                        (cons
                            (cons dir
                                (append
                                    (BAtte:filesort (vl-remove "." (vl-directory-files dir nil -1)))
                                    (BAtte:filesort (vl-directory-files dir "*.dwg" 1))
                                )
                            )
                            dirdata
                        )
                    )
                )
            )
        )
    )
)

;;-------------------------------------------------------------------------------;;

;; The following sorting function is adapted from code originally authored by ElpanovEvgeniy
;; Ref: http://www.theswamp.org/index.php?topic=41463.msg465729#msg465729

(defun BAtte:filesort ( l )
    (mapcar (function (lambda ( a ) (nth a l)))
        (vl-sort-i (mapcar 'strcase l)
            (function
                (lambda ( a b / i )
                    (cond
                        (   (= ".." a)
                            t
                        )
                        (   (= ".." b)
                            nil
                        )
                        (   (zerop (setq i (vl-string-mismatch a b)))
                            (if (and
                                    (< 47 (ascii a) 58)
                                    (< 47 (ascii b) 58)
                                )
                                (< (atoi a) (atoi b))
                                (< a b)
                            )
                        )
                        (   (= i (strlen a))
                            t
                        )
                        (   (= i (strlen b))
                            nil
                        )
                        (   (and
                                (< 47 (vl-string-elt a i) 58)
                                (< 47 (vl-string-elt b i) 58)
                            )
                            (< (atoi (substr a (1+ i))) (atoi (substr b (1+ i))))
                        )
                        (   (< 47 (vl-string-elt a (1- i)) 58)
                            (< (atoi (substr a i)) (atoi (substr b i)))
                        )
                        (   (< a b))
                    )
                )
            )
        )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:BrowseForFolder ( msg dir flag / err shell fold self path )
    (setq err
        (vl-catch-all-apply
            (function
                (lambda ( / acapp hwnd )
                    (if (setq acapp (vlax-get-acad-object)
                              shell (vla-getinterfaceobject acapp "Shell.Application")
                              hwnd  (vl-catch-all-apply 'vla-get-hwnd (list acapp))
                              fold  (vlax-invoke-method shell 'BrowseForFolder (if (vl-catch-all-error-p hwnd) 0 hwnd) msg flag dir)
                        )
                        (setq self (vlax-get-property fold 'self)
                              path (vlax-get-property self 'path)
                              path (vl-string-right-trim "\\" (vl-string-translate "/" "\\" path))
                        )
                    )
                )
            )
        )
    )
    (if self  (vlax-release-object  self))
    (if fold  (vlax-release-object  fold))
    (if shell (vlax-release-object shell))
    (if (vl-catch-all-error-p err)
        (prompt (vl-catch-all-error-message err))
        path
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:Full->Relative ( dir path / p q )
    (setq dir (vl-string-right-trim "\\" dir))
    (cond
        (   (and
                (setq p (vl-string-position 58  dir))
                (setq q (vl-string-position 58 path))
                (not (eq (strcase (substr dir 1 p)) (strcase (substr path 1 q))))
            )
            path
        )
        (   (and
                (setq p (vl-string-position 92  dir))
                (setq q (vl-string-position 92 path))
                (eq (strcase (substr dir 1 p)) (strcase (substr path 1 q)))
            )
            (BAtte:Full->Relative (substr dir (+ 2 p)) (substr path (+ 2 q)))
        )
        (   (and
                (setq q (vl-string-position 92 path))
                (eq (strcase dir) (strcase (substr path 1 q)))
            )
            (strcat ".\\" (substr path (+ 2 q)))
        )
        (   (eq "" dir)
            path
        )
        (   (setq p (vl-string-position 92 dir))
            (BAtte:Full->Relative (substr dir (+ 2 p)) (strcat "..\\" path))
        )
        (   (BAtte:Full->Relative "" (strcat "..\\" path)))
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:UpdateFileList ( dir files )
    (BAtte:AddList "box1" (BAtte:GetFiles dir files))
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:UpdateSelected ( dir files )
    (BAtte:AddList "box2" (mapcar (function (lambda ( file ) (BAtte:Full->Relative dir file))) files))
    files
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:UpdateAttributeData ( key data )
    (start_list key)
    (foreach item
        (setq data
            (vl-sort data
                (function
                    (lambda ( a b )
                        (cond
                            (   (eq
                                    (car a)
                                    (car b)
                                )
                                (< (cadr a) (cadr b))
                            )
                            (   t
                                (<
                                    (car a)
                                    (car b)
                                )
                            )
                        )
                    )
                )
            )
        )
        (add_list (BAtte:lst->str item "\t"))
    )
    (end_list)
    data
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:UpDir ( dir )
    (substr dir 1 (vl-string-position 92 dir nil t))
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:FixDir ( dir )
    (vl-string-right-trim "\\" (vl-string-translate "/" "\\" dir))
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:RemoveItems ( items lst / i )
    (setq i -1)
    (vl-remove-if '(lambda ( x ) (vl-position (setq i (1+ i)) items)) lst)
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:SelectBlocks ( id lst / _ssget blk ent idx inc itm sel )

    (defun _ssget ( msg filter / sel )
        (setvar 'NOMUTT 1)
        (princ msg)
        (setq sel (vl-catch-all-apply 'ssget (list filter)))
        (setvar 'NOMUTT 0)
        (if (and sel (null (vl-catch-all-error-p sel)))
            sel
        )
    )

    (cond
        (   (null
                (setq sel
                    (_ssget "\nVyberte bloky: "
                        (list
                           '(0 . "INSERT")
                           '(66 . 1)
                            (cons 410
                                (if (= 1 (getvar 'CVPORT))
                                    (getvar 'CTAB)
                                    "Model"
                                )
                            )
                        )
                    )
                )
            )
        )
        (   (progn
                (repeat (setq inc (sslength sel))
                    (setq ent (ssname sel (setq inc (1- inc)))
                          blk (strcase (BAtte:EffectiveName ent))
                    )
                    (setq itm
                        (append
                            (mapcar
                                (function
                                    (lambda ( att )
                                        (list
                                            blk
                                            (strcase (vla-get-tagstring att))
                                            (vla-get-textstring att)
                                        )
                                    )
                                )
                                (vlax-invoke (vlax-ename->vla-object ent) 'getattributes)
                            )
                            itm
                        )
                    )
                )
                (and
                    (cadr (setq itm (BAtte:RemoveAttribDuplicates itm)))
                    (/= 6
                        (BAtte:Popup
                            (BAtte:WSH)
                            "Nasli sa duplicitne polozky" (+ 32 4)
                            (strcat
                                "Vo vybere blokov sa naslo mnoho duplicitnych poloziek.\n\n"
                                "Duplicitne polozky vznikaju, ked sa rovnaka kombinacia bloku a tagu objavi v zozname viac ako raz.\n\n"
                                "Nasledujuce duplicitne polozky boli odstranene zo zoznamu:\n\n"
                                (BAtte:lst->str (cadr itm) "\n")
                                "\n\nPokracovat?"
                            )
                        )
                    )
                )
            )
        )
        (   (progn
                (setq itm (car itm))
                (null (new_dialog "select" id))
            )
            (BAtte:Popup
                (BAtte:WSH)
                "Pozot" 16
                (strcat
                    "Dialogove okno vyberu blokov sa nepodarilo nacitat.\n\n"
                    "Zodpovedajuci subor DLC sa nachadza na nesledujucom umiestneni:\n\n"
                    dclfname
                    "\n\nTento subor obdahuje chybu, kontaktujte autora programu."
                )
            )
        )
        (   t
            (mapcar 'BAtte:AddList '("h1" "h2" "h3") '(("\tBlock") ("\tTag") ("\tValue")))

            (setq itm (BAtte:UpdateAttributeData "list" itm))

            (action_tile "list"
                (vl-prin1-to-string
                   '(
                        (lambda ( )
                            (setq idx $value)
                            (if (= (length (read (strcat "(" idx ")"))) (length itm))
                                (set_tile "all" "1")
                                (set_tile "all" "0")
                            )
                        )
                    )
                )
            )

            (action_tile "all"
                (vl-prin1-to-string
                   '(
                        (lambda ( / i l )
                            (if (eq "1" $value)
                                (set_tile "list"
                                    (setq idx
                                        (vl-string-trim "()"
                                            (vl-princ-to-string
                                                (repeat (setq i (length itm))
                                                    (setq l (cons (itoa (setq i (1- i))) l))
                                                )
                                            )
                                        )
                                    )
                                )
                                (progn
                                    (set_tile "list" "")
                                    (setq idx nil)
                                )
                            )
                        )
                    )
                )
            )

            (action_tile "accept"
                (vl-prin1-to-string
                   '(
                        (lambda ( / dupes items tmp )
                            (cond
                                (   (or (null idx) (eq "" idx))
                                    (if
                                        (= 6
                                            (BAtte:Popup
                                                (BAtte:WSH)
                                                "Nie su vybrate ziadne polozky" (+ 32 4)
                                                (strcat
                                                    "Neboli vybrate ziadne polozky na priradenie do zoznamu udajov atributov.\n\n"
                                                    "Pokracovat do hlavneho dialogu?"
                                                )
                                            )
                                        )
                                        (done_dialog 1)
                                    )
                                )
                                (   (progn
                                        (setq items
                                            (mapcar
                                                (function
                                                    (lambda ( n ) (nth n itm))
                                                )
                                                (read (strcat "(" idx ")"))
                                            )
                                        )
                                        (setq tmp
                                            (append
                                                (mapcar
                                                    (function
                                                        (lambda ( item1 )
                                                            (cond
                                                                (
                                                                    (vl-some
                                                                        (function
                                                                            (lambda ( item2 )
                                                                                (if
                                                                                    (and
                                                                                        (eq (car  item1) (car  item2))
                                                                                        (eq (cadr item1) (cadr item2))
                                                                                    )
                                                                                    (progn
                                                                                        (setq dupes (cons (BAtte:lst->str item2 "\t") dupes)
                                                                                              items (vl-remove item2 items)
                                                                                        )
                                                                                        item2
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                        items
                                                                    )
                                                                )
                                                                (   item1   )
                                                            )
                                                        )
                                                    )
                                                    lst
                                                )
                                                items
                                            )
                                        )
                                        (setq dupes (reverse dupes))
                                    )
                                    (if
                                        (= 6
                                            (BAtte:Popup
                                                (BAtte:WSH)
                                                "Zrazka polozky" (+ 32 4)
                                                (strcat
                                                    "Kombinacia bloku & tagu pre nasledujuce vybrate polozky sa uz zobrazuje v "
                                                    "zozname atributnych udajov:\n\n"
                                                    (BAtte:lst->str dupes "\n")
                                                    "\n\nAk budete pokracovat, vyssie uveden� polozky nahradia polozky, ktore su uz v zozname."
                                                    "\n\nPokracovat"
                                                )
                                            )
                                        )
                                        (progn
                                            (setq lst tmp)
                                            (done_dialog 1)
                                        )
                                    )
                                )
                                (   t
                                    (setq lst tmp)
                                    (done_dialog 1)
                                )                                    
                            )
                        )
                    )
                )
            )                    
         
            (start_dialog)
        )
    )
    lst
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:EditItem ( id item lst / _validate block tag value )
    (setq _validate
        (lambda ( / tmp )
            (cond
                (   (or (null block) (eq "" block))
                    (BAtte:Popup
                        (BAtte:WSH)
                        "Information" 48
                        (strcat
                            "Please Enter a Block Name.\n\n"
                            "Note: Block names are not case-sensitive and may use wildcard patterns"
                            " to match multiple blocks containing the same attribute tag."
                        )
                    )
                    (mode_tile "block" 2)
                )
                (   (or (null tag) (eq "" tag))
                    (BAtte:Popup
                        (BAtte:WSH)
                        "Information" 48
                        (strcat
                            "Please Enter an Attribute Tag.\n\n"
                            "Note: Attribute tags are not case-sensitive and cannot contain spaces."
                        )
                    )
                    (mode_tile "tag" 2)
                )
                (   (vl-string-position 32 tag)
                    (BAtte:Popup (BAtte:WSH) "Information" 48 "Attribute tag cannot contain spaces.")
                    (mode_tile "tag" 2)
                )
                (   (setq tmp
                        (vl-some
                            (function
                                (lambda ( item )
                                    (if
                                        (and
                                            (eq (car  item) (strcase block))
                                            (eq (cadr item) (strcase   tag))
                                        )
                                        item
                                    )
                                )
                            )
                            (vl-remove item lst)
                        )
                    )
                    (BAtte:Popup
                        (BAtte:WSH)
                        "Item Clash"
                        48
                        (strcat
                            "The attribute tag '"
                            (cadr tmp)
                            "' within block '"
                            (car  tmp)
                            "' already appears in the list to be set to value \""
                            (caddr tmp)
                            "\""
                        )
                    )
                    (mode_tile "block" 2)
                )
                (   t
                    (if (null value)
                        (setq value "")
                    )
                    (done_dialog 1)
                )
            )
        )
    )
    (cond
        (   (null (new_dialog "edit" id))
            (BAtte:Popup
                (BAtte:WSH)
                "Warning" 16
                (strcat
                    "The Edit Item dialog could not be loaded.\n\n"
                    "The corresponding DCL file resides at the following location:\n\n"
                    dclfname
                    "\n\nThis file contains an error, please contact the program author."
                )
            )
        )
        (   t
            (mapcar
                (function
                    (lambda ( _tile _value )
                        (set (read _tile) (set_tile _tile _value))
                    )
                )
               '("block" "tag" "value") item
            )
         
            (action_tile "block"
                (vl-prin1-to-string
                   '(progn
                        (setq block $value)
                        (if (= 1 $reason) (mode_tile "tag" 2))
                    )
                )
            )

            (action_tile "tag"
                (vl-prin1-to-string
                   '(progn
                        (setq tag $value)
                        (if (= 1 $reason) (mode_tile "value" 2))
                    )
                )
            )
         
            (action_tile "value"
                (vl-prin1-to-string
                   '(progn
                        (setq value $value)
                        (if (= 1 $reason) (_validate))
                    )
                )
            )
         
            (action_tile "accept" "(_validate)")
         
            (if (= 1 (start_dialog))
                (setq lst (subst (list (strcase block) (strcase tag) value) item lst))
            )
        )
    )
    lst
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:SaveToFile ( data / file name )    
    (cond
        (   (null data)
            nil
        )
        (   (null (setq name (getfiled "Create Output File" "" "csv;txt" 1)))
            nil
        )
        (   (null (setq file (open name "w")))
            (BAtte:Popup
                (BAtte:WSH)
                "Unable to Write to File" 16
                (strcat
                    "The following file could not be opened for writing:\n\n"
                    name
                    "\n\nPlease ensure that you have write permission for the selected directory."
                )
            )
            nil
        )
        (   t         
            (if (eq ".TXT" (strcase (vl-filename-extension name)))
                (foreach item data
                    (write-line (BAtte:lst->str item "\t") file)
                )
                (foreach item data
                    (write-line (BAtte:lst->csv item) file)
                )
            )
            (setq file (close file))
            (BAtte:Popup
                (BAtte:WSH)
                "Save Successful" 64
                (strcat
                    "Attribute data was successfully written to the following location:\n\n"
                    name
                )
            )
            t
        )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:LoadFromFile ( / data file line name removed )
    (cond
        (   (null (setq name (getfiled "Select File to Load" "" "csv;txt" 16)))
            nil
        )
        (   (null (setq file (open name "r")))
            (BAtte:Popup
                (BAtte:WSH)
                "Unable to Read File" 16
                (strcat
                    "The following file could not be opened for reading:\n\n"
                    name
                    "\n\nPlease ensure that you have read permission for the above file."
                )
            )
            nil
        )
        (   t
            (if (eq ".TXT" (strcase (vl-filename-extension name)))
                (while (setq line (read-line file))
                    (setq data
                        (cons
                            (BAtte:str->lst line "\t")
                            data
                        )
                    )
                )
                (while (setq line (read-line file))
                    (setq data
                        (cons
                            (BAtte:csv->lst line 0)
                            data
                        )
                    )
                )
            )
            (setq file (close file))
            (cond
                (   (null (setq data (reverse data)))
                    (BAtte:Popup
                        (BAtte:WSH)
                        "File Empty" 48
                        "The selected file contained no data."
                    )
                    nil
                )
                (   (null
                        (setq data
                            (apply 'append
                                (mapcar
                                    (function
                                        (lambda ( item )
                                            (if
                                                (or
                                                    (< (length item) 2)
                                                    (eq "" (car  item))
                                                    (eq "" (cadr item))
                                                    (vl-string-position 32 (cadr item))
                                                )
                                                (progn
                                                    (setq removed
                                                        (cons
                                                            (BAtte:lst->str item "\t")
                                                            removed
                                                        )
                                                    )
                                                    nil
                                                )
                                                (list
                                                    (list
                                                        (strcase (car  item))
                                                        (strcase (cadr item))
                                                        (cond ( (caddr item) ) ( "" ))
                                                    )
                                                )
                                            )                                                        
                                        )
                                    )
                                    data
                                )
                            )
                        )
                    )
                    (BAtte:Popup
                        (BAtte:WSH)
                        "Incorrect File Format" 48
                        (strcat
                            "The data in the selected file is not in the format required by this program.\n\n"
                            "The file should have three columns for Block, Tag and Value data."
                            " If using a Text File, the columns should be tab delimited.\n\n"
                            "The Attribute Tag data cannot contain spaces."
                        )
                    )
                    nil
                )
                (   (progn
                        (setq tmp (BAtte:RemoveAttribDuplicates data))
                        (setq removed (reverse removed))
                    )
                    (if
                        (= 6
                            (BAtte:Popup
                                (BAtte:WSH)
                                "Items Removed" (+ 32 4)
                                (strcat
                                    "A number of items in the selected file are not in the format required by this program.\n\n"
                                    "The following items have been removed from the list because either the block or tag values are missing"
                                    " or the tag value contains spaces:\n\n"
                                    (BAtte:lst->str removed "\n")
                                    "\n\nContinue?"
                                )
                            )
                        )
                        (if (cadr tmp)
                            (if
                                (= 6
                                    (BAtte:Popup
                                        (BAtte:WSH)
                                        "Duplicate Items Found" (+ 32 4)
                                        (strcat
                                            "A number of duplicate items were found in the selected file. Duplicate items arise when"
                                            " the same block and tag combination appear more than once in the list.\n\n"
                                            "The following duplicate items have been removed from the list:\n\n"
                                            (BAtte:lst->str (cadr tmp) "\n")
                                            "\n\nContinue?"
                                        )
                                    )
                                )
                                (car tmp)
                            )
                            data
                        )
                    )
                )
                (   (cadr tmp)
                    (if
                        (= 6
                            (BAtte:Popup
                                (BAtte:WSH)
                                "Duplicate Items Found" (+ 32 4)
                                (strcat
                                    "A number of duplicate items were found in the selected file. Duplicate items arise when"
                                    " the same block and tag combination appear more than once in the list.\n\n"
                                    "The following duplicate items have been removed from the list:\n\n"
                                    (BAtte:lst->str (cadr tmp) "\n")
                                    "\n\nContinue?"
                                )
                            )
                        )
                        (car tmp)
                    )
                )                 
                (   data   )
            )
        )
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:EffectiveName ( blockentity / obj )
    (if (vlax-property-available-p (setq obj (vlax-ename->vla-object blockentity)) 'effectivename)
        (vla-get-effectivename obj)
        (vla-get-name obj)
    )
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:RemoveAttribDuplicates ( lst / dup ret )
    (while lst
        (setq ret (cons (car lst) ret))
        (setq lst
            (vl-remove-if
                (function
                    (lambda ( x )
                        (if
                            (and
                                (eq (caar  lst) (car  x))
                                (eq (cadar lst) (cadr x))
                            )
                            (setq dup (cons (BAtte:lst->str x "\t") dup))
                        )
                    )
                )
                (cdr lst)
            )
        )
    )
    (list (reverse ret) (reverse dup))
)

;;-------------------------------------------------------------------------------;;

(defun BAtte:ConvertDataList ( lst / ass result )
    (while lst
        (if (setq ass (assoc (caar lst) result))
            (setq result
                (subst
                    (cons
                        (car ass)
                        (cons (cons (cadar lst) (caddar lst)) (cdr ass))
                    )
                    ass
                    result
                )
            )
            (setq result
                (cons
                    (list (caar lst) (cons (cadar lst) (caddar lst)))
                    result
                )
            )
        )
        (setq lst (cdr lst))
    )
    result
)

;;-------------------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\n:: BAtte.lsp | Version "
        BAtteVersion
        " | � Lee Mac "
        (menucmd "m=$(edtime,$(getvar,DATE),YYYY)")
        " www.lee-mac.com ::"
        "\n:: Type \"BAtte\" to Invoke ::"
    )
)
(princ)

;;-------------------------------------------------------------------------------;;
;;                                 End of File                                   ;;
;;-------------------------------------------------------------------------------;;