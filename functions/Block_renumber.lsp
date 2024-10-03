;=========================================================================
; Block_renumber.lsp
; Create by Lee Mac from https://www.lee-mac.com
; Edit by Jakub Tomecko
;
; Automaticke cislovanie textu a blokov
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                 Dynamic Mode Positioning Controls                    ;;
;;----------------------------------------------------------------------;;

;  [ Enter ]  -  (alebo medzernik/kliknutie pravym tlacidlom) ukoncit program [Zrusit]
;  [ Click ]  -  umiestnenie objektu
;  [   <   ]  -  otocit objekt proti smeru hodinovuch rusiciek
;  [   >   ]  -  otocit objekt v smere hodinovych ruciciek
;  [   O   ]  -  zadana rotacia objektu
;  [  Tab  ]  -  otocit objekt o 90º
;  [   M   ]  -  otocenie zrkadloveho objektu
;  [   C   ]  -  zarovnej objekt podla krivky
;  [   R   ]  -  nahradit existujuci textovy retazec/retazec atributov
;  [   T   ]  -  pripinanie prirastku pocitadla
;  [   I   ]  -  prirastok retazca
;  [   B   ]  -  otocit polygonalny okrej
;  [   A   ]  -  prepnutie masky pozadia MText 

;;----------------------------------------------------------------------;;
;;                      Curve Alignment Controls                        ;;
;;----------------------------------------------------------------------;;

;  [ Enter ]  -  (alebo medzernik/kliknutie pravym tlacidlom) ukoncit program [Zrusit]
;  [ Click ]  -  umiestnenie objektu
;  [  +/-  ]  -  zvysit/znizit odsadenie objektu
;  [   O   ]  -  zadanie odsadenia objektu
;  [   P   ]  -  prepinanie kolmosti objektu
;  [   B   ]  -  otocit polygonalny okrej
;  [   A   ]  -  prepnutie masky pozadia MText 

;;----------------------------------------------------------------------;;
;;                           RuNumber program                           ;;
;;----------------------------------------------------------------------;;

(setq numincversion "3.9")

;;----------------------------------------------------------------------;;

(defun c:JTReNumber

    (
        /
        *error*
        _alignment
        _attachment
        _blocks
        _layers
        _scalevars
        _styles
        a
        acspc
        alignment
        arr-end
        arr-qty
        arr-qty#
        arr-rot
        arr-rot#
        arr-typ
        arr-typ-fun
        arr-use
        arr-use-fun
        att-nme
        attachment
        attrib
        attribs
        b
        blk-nme
        blk-scl
        blk-scl-fun
        blk-scl#
        block
        blocks
        bor
        bor-enc
        bor-enc-fun
        bor-lay
        bor-rot
        bor-shp
        bor-shp-fun
        bor-sid
        bor-sid#
        bor-typ
        bor-typ-fun
        cfgfname
        create-bor
        create-obj
        dclflag
        dclfname
        dclid
        deg
        dyn-flg
        elst
        ent
        file
        fix-ed1
        fix-ed1#
        fix-ed2
        fix-ed2#
        g1
        g2
        gr
        i
        inc-sec
        inc-str
        mid-str
        mode_color
        mode_image
        msg
        msk-col
        msk-off
        msk-off#
        msk-trn
        msk-trn-fun
        msk-use
        msk-use-fun
        mtw
        mtx-bak
        nm
        oba
        obj
        obj-typ
        obj-typ-fun
        off-ed1
        off-ed1#
        p1
        p2
        pre-str
        prop
        pt
        r1
        savepath
        scalevars
        scl-pop
        scl-var
        ss
        string
        style
        suf-str
        symb
        symlist
        table
        tile
        tmp
        tog-cnt
        txt-aln
        txt-bst
        txt-lay
        txt-rot
        txt-sty
        txt-sty-fun
        txt-sze
        txt-sze#
        v1
        vallst
        varlst
        x
        xa
    )

    (defun *error* ( msg )
        (if
            (and
                (= 1 dclflag)
                (= 'str (type cfgfname))
                symlist
            )
            (numinc:writeconfig cfgfname (mapcar 'eval (mapcar 'car symlist)))
        )
        (if
            (and
                (= 'vla-object (type numinc:wshobject))
                (not (vlax-object-released-p numinc:wshobject))
            )
            (progn
                (vlax-release-object numinc:wshobject)
                (setq numinc:wshobject nil)
            )
        )
        (if
            (and
                (= 'ename (type mtw))
                (entget mtw)
            )
            (entdel mtw)
        )
        (if (= "1" dyn-flg)
            (foreach obj (list obj bor)
                (if (and (= 'vla-object (type obj))
                         (not (vlax-erased-p obj))
                         (vlax-write-enabled-p obj)
                    )
                    (vla-delete obj)
                )
            )
        )
        (mapcar 'setvar varlst vallst)
        (if (= 'file (type file))
            (close file)
        )
        (if (< 0 dclid)
            (unload_dialog dclid)
        )
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nNumInc " numincversion " error: " msg))
        )
        (princ)
    )

    (setq varlst '(dimzin modemacro)
          vallst  (mapcar 'getvar varlst)
    )

    (cond
        (   (= 4 (logand 4 (cdr (assoc 70 (tblsearch "layer" (getvar 'clayer))))))
            (princ "\nAktualna vrstva je uzamknuta.")
        )
        (   (not (vl-file-directory-p (setq savepath (numinc:getsavepath))))
            (numinc:popup "Cesta ulozenia je neplatna" 16
                (princ
                    (strcat
                        "Nasledujuca cesta neexistuje alebo je neplatna:\n\n"
                        savepath
                    )
                )
            )
        )
        (   (progn
                (setq dclfname (strcat savepath "\\LMAC_NumInc_V" (vl-string-translate "." "-" numincversion) ".dcl")
                      cfgfname (strcat savepath "\\LMAC_NumInc_V" (vl-string-translate "." "-" numincversion) ".cfg")
                )
                (not (numinc:writedcl dclfname))
            )
            (numinc:popup "Subor DCL sa nepodarilo zapisat" 16
                (princ
                    (strcat
                        "Subor DCL pozadovany touto aplikaciou nebolo mozne zapisat do nasledujuceho umiestnenia:\n\n"
                        dclfname
                        "\n\nUistite sa, ze mate opravnenie na zapis do tohto adresara."
                    )
                )
            )
        )
        (   (<= (setq dclID (load_dialog dclfname)) 0)
            (numinc:popup "Subor DCL sa nepodarilo nacitat" 16
                (princ
                    (strcat
                        "Nasledujuci subor DCL sa nepodarilo nacitat:\n\n"
                        dclfname
                        "\n\nSkontrolujte integritu tohto suboru."
                    )
                )
            )
        )
        (   t
            (setq symlist
                (list
                    (cons 'arr-use "0")
                    (cons 'arr-qty "5")
                    (cons 'arr-typ "arr-aln")
                    (cons 'arr-rot "0.0")
                    (cons 'arr-end nil)
                    (cons 'crv-per (/ pi 2.0))
                    (cons 'crv-off 0.0)
                    (cons 'txt-rot 0.0)
                    (cons 'bor-rot nil)
                    (cons 'tog-cnt t)
                    (cons 'dyn-flg "1")
                    (cons 'pre-str  "")
                    (cons 'mid-str "1")
                    (cons 'suf-str  "")
                    (cons 'inc-str "1")
                    (cons 'inc-sec 2)
                    (cons 'obj-typ "obj-txt")
                    (cons 'blk-nme "")
                    (cons 'att-nme "")
                    (cons 'blk-scl "1")
                    (cons 'scl-var "0")
                    (cons 'scl-pop "DIMSCALE")
                    (cons 'bor-enc "0")
                    (cons 'bor-shp "0")
                    (cons 'bor-sid "6")
                    (cons 'bor-lay (getvar 'clayer))
                    (cons 'bor-typ "bor-off")
                    (cons 'off-ed1 "1.0")
                    (cons 'fix-ed1 "1.0")
                    (cons 'fix-ed2 "1.0")
                    (cons 'txt-lay (getvar 'clayer))
                    (cons 'txt-sty (getvar 'textstyle))
                    (cons 'txt-aln "Middle-Center")
                    (cons 'txt-bst "1")
                    (cons 'txt-sze
                        (rtos
                            (if
                                (zerop
                                    (cdr
                                        (assoc 40
                                            (setq style
                                                (tblsearch "style" (getvar 'textstyle))
                                            )
                                        )
                                    )
                                )
                                (cdr (assoc 42 style))
                                (cdr (assoc 40 style))
                            )
                        )
                    )
                    (cons 'msk-use "0")
                    (cons 'msk-off "1.5")
                    (cons 'msk-trn "0")
                    (cons 'msk-col '((62 . 1)))
                )
            )
            (if (null (findfile cfgfname))
                (numinc:writeconfig cfgfname (mapcar 'cdr symlist))
            )
            (numinc:readconfig cfgfname (mapcar 'car symlist))
            (foreach x SymList
                (if (null (boundp (car x)))
                    (set (car x) (cdr x))
                )
            )

            (setq _layers (numinc:gettableitems "layer")
                  _styles (numinc:gettableitems "style")
                  _blocks (numinc:getblockdata)
            )

            (setq Alignment
                (list
                    (cons "Left"          acAlignmentLeft)
                    (cons "Center"        acAlignmentCenter)
                    (cons "Right"         acAlignmentRight)
                    (cons "Middle"        acAlignmentMiddle)
                    (cons "Top-Left"      acAlignmentTopLeft)
                    (cons "Top-Center"    acAlignmentTopCenter)
                    (cons "Top-Right"     acAlignmentTopRight)
                    (cons "Middle-Left"   acAlignmentMiddleLeft)
                    (cons "Middle-Center" acAlignmentMiddleCenter)
                    (cons "Middle-Right"  acAlignmentMiddleRight)
                    (cons "Bottom-Left"   acAlignmentBottomLeft)
                    (cons "Bottom-Center" acAlignmentBottomCenter)
                    (cons "Bottom-Right"  acAlignmentBottomRight)
                )
            )

            (setq Attachment
                (list
                    (cons "Top-Left"      acAttachmentPointTopLeft)
                    (cons "Top-Center"    acAttachmentPointTopCenter)
                    (cons "Top-Right"     acAttachmentPointTopRight)
                    (cons "Middle-Left"   acAttachmentPointMiddleLeft)
                    (cons "Middle-Center" acAttachmentPointMiddleCenter)
                    (cons "Middle-Right"  acAttachmentPointMiddleRight)
                    (cons "Bottom-Left"   acAttachmentPointBottomLeft)
                    (cons "Bottom-Center" acAttachmentPointBottomCenter)
                    (cons "Bottom-Right"  acAttachmentPointBottomRight)
                )
            )

            (setq _Alignment  (mapcar 'car Alignment))
            (setq _Attachment (mapcar 'car Attachment))

            (setq ScaleVars
                (vl-remove-if 'null
                    (mapcar
                        (function
                            (lambda ( var / value )
                                (if
                                    (and
                                        (setq value (getvar var))
                                        (< 0.0 value)
                                    )
                                    (if (= "CANNOSCALEVALUE" (strcase var))
                                        (cons var (rtos (/ 1.0 value)))
                                        (cons var (rtos value))
                                    )
                                )
                            )
                        )
                        (acad_strlsort
                           '(
                                "CANNOSCALEVALUE"
                                "CELTSCALE"
                                "DIMLFAC"
                                "DIMSCALE"
                                "DIMTFAC"
                                "DIMTXT"
                                "HPSCALE"
                                "LTSCALE"
                                "MLEADERSCALE"
                                "MSOLESCALE"
                                "TEXTSIZE"
                            )
                        )
                    )
                )
            )
            (setq _ScaleVars (mapcar 'car ScaleVars))

            (
                (lambda ( / i j x y )
                    (repeat (setq i 20)
                        (setq j 1)
                        (repeat 20
                            (setq x (cons j x)
                                  y (cons i y)
                                  j (1+ j)
                            )
                        )
                        (setq i (1- i))
                    )
                    (setq mode_image
                        (eval
                            (list 'lambda '( key mode )
                                (list 'cond
                                   '(   (= 1 mode)
                                        (start_image key)
                                        (fill_image 0 0 (dimx_tile key) (dimy_tile key) -15)
                                        (end_image)
                                        (mode_tile key mode)
                                    )
                                    (list 't
                                       '(start_image key)
                                       '(fill_image 0 0 (dimx_tile key) (dimy_tile key) -15)
                                        (list 'mapcar ''vector_image (list 'quote x) (list 'quote y) (list 'quote x) (list 'quote y)
                                           '(cond
                                                (   (member key '("scl-pik" "arr-pik" "txt-pik" "msk-pik"))
                                                   '(
                                                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 095 096 096 096 096 096 096 096 096 095 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 096 254 254 254 254 254 254 254 254 096 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 096 063 063 -15 063 063 063 063 063 096 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 096 063 -15 250 -15 063 063 063 063 096 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 096 -15 250 250 -15 063 063 063 063 096 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 254 250 -15 250 -15 063 063 063 063 096 -15 -15 -15 -15
                                                        254 254 254 254 254 254 250 -15 -15 250 -15 063 063 063 063 096 254 254 254 254
                                                        254 254 254 254 254 250 -15 -15 -15 250 -15 063 063 063 063 096 254 254 254 254
                                                        254 254 254 254 250 -15 -15 -15 -15 250 -15 063 063 063 063 096 254 254 254 254
                                                        254 254 254 250 250 250 -15 -15 -15 250 -15 063 063 063 063 096 254 254 254 254
                                                        254 254 254 254 254 250 -15 250 -15 250 -15 063 063 063 063 096 254 254 254 254
                                                        254 254 254 254 254 250 -15 250 250 250 -15 063 063 063 063 096 254 254 254 254
                                                        254 254 254 254 250 -15 250 254 254 250 254 096 096 096 096 095 254 254 254 254
                                                        254 254 254 254 250 -15 250 254 254 254 254 254 254 254 254 254 254 254 254 254
                                                        254 254 254 254 254 250 254 254 254 254 254 254 254 254 254 254 254 254 254 254
                                                        254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254
                                                        -15 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 -15
                                                    )
                                                )
                                                (
                                                   '(
                                                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 095 096 096 096 096 096 095 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 096 063 063 063 063 063 096 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 096 254 254 063 063 063 096 -15 -15 -15 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 253 250 254 063 063 063 096 254 008 254 -15 -15 -15
                                                        -15 -15 -15 -15 -15 -15 -15 250 250 254 063 063 063 096 -15 252 251 254 -15 -15
                                                        -15 -15 -15 -15 -15 -15 250 -15 250 254 063 063 063 096 -15 254 252 008 -15 -15
                                                        254 254 254 254 254 250 -15 -15 250 253 096 096 096 095 -15 254 254 149 254 254
                                                        254 254 254 254 250 -15 -15 -15 250 -15 254 -15 -15 -15 -15 254 254 149 254 254
                                                        254 254 254 250 -15 -15 -15 -15 250 -15 008 253 -15 -15 -15 -15 253 008 254 254
                                                        254 254 250 250 250 -15 -15 -15 250 254 254 251 253 -15 -15 253 251 254 254 254
                                                        254 254 254 254 250 -15 250 -15 250 254 254 254 008 149 149 008 254 254 254 254
                                                        254 254 254 254 250 -15 250 250 250 254 254 254 254 254 254 254 254 254 254 254
                                                        254 254 254 250 -15 250 254 254 250 254 254 254 254 254 254 254 254 254 254 254
                                                        254 254 254 250 -15 250 254 254 254 254 254 254 254 254 254 254 254 254 254 254
                                                        254 254 254 254 250 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254
                                                        254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254
                                                        -15 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 -15
                                                    )
                                                )
                                            )
                                        )
                                       '(end_image)
                                       '(mode_tile key mode)
                                    )
                                )
                               'mode
                            )
                        )
                    )
                )
            )

            (setq mode_color
                (lambda ( key col )
                    (start_image key)
                    (fill_image 0 0 (dimx_tile key) (dimy_tile key) col)
                    (end_image)
                    (if
                        (or
                            (=   0 col)
                            (= -15 col)
                        )
                        (mode_tile key 1)
                        (mode_tile key 0)
                    )
                )
            )
            
            (while (not (member dclflag '(1 0)))
                (cond
                    (   (not (new_dialog "numinc" dclID))
                        (numinc:popup "Dialog NumInc sa nepodarilo nacitat" 16
                            (princ
                                (strcat
                                    "Dialogove okno ReNumber sa nepodarilo nacitat. "
                                    "Subor DCL pozadovany aplikaciou sa nachadza v nasledujucom umiestneni:\n\n"
                                    dclfname
                                    "\n\nSkontrolujte integritu tohto suboru."
                                )
                            )
                        )
                    )
                    (   (eval (read (vl-list->string '(40 110 117 109 105 110 99 58 109 105 115 99 41))))

                        ;;----------------------------------------------------------------------;;
                        ;;                    Horny dialog [Top of Dialog]                      ;;
                        ;;----------------------------------------------------------------------;;                     
                     
                        
                     
                        (set_tile "dyn-flg" dyn-flg)
                        (action_tile "dyn-flg" "(setq dyn-flg $value)")

                        ;;----------------------------------------------------------------------;;
                        ;; Panele formatu prirastku hore vlavo [Top-Left Increment Format Panel];;
                        ;;----------------------------------------------------------------------;;                     

                        (foreach symb '(pre-str mid-str suf-str inc-str)
                            (setq tile (strcase (vl-symbol-name symb) t))
                            (set_tile tile (eval symb))
                            (action_tile tile (strcat "(setq " tile " $value)"))
                        )

                        (
                            (lambda ( / bit )
                                (setq bit 1)
                                (foreach tile '("inc-pre" "inc-mid" "inc-suf")
                                    (if (= bit (logand bit inc-sec))
                                        (set_tile tile "1")
                                    )
                                    (action_tile tile (strcat "(setq inc-sec (boole (if (eq \"1\" $value) 7 4) " (itoa bit) " inc-sec))"))
                                    (setq bit (lsh bit 1))
                                )
                            )
                        )
               
                        ;;----------------------------------------------------------------------;;
                        ;;          Pravy panel formatovania [Right Formatting Panel]           ;;
                        ;;----------------------------------------------------------------------;;                     
                     
                        (numinc:makelist "txt-lay" _layers)
                     
                        (set_tile "txt-lay"
                            (itoa
                                (cond
                                    (   (vl-position txt-lay _layers))
                                    (   (vl-position (setq txt-lay (getvar 'clayer)) _layers))
                                )
                            )
                        )
                        (action_tile "txt-lay" "(setq txt-lay (nth (atoi $value) _layers))")

                        ;;----------------------------------------------------------------------;;

                        (numinc:MakeList "txt-sty" _styles)
                     
                        (set_tile "txt-sty"
                            (itoa
                                (cond
                                    (   (vl-position txt-sty _styles))
                                    (   (vl-position (setq txt-sty (getvar 'textstyle)) _styles))
                                )
                            )
                        )
                        (
                            (setq txt-sty-fun
                                (lambda ( style / tmp )
                                    (if (zerop (setq tmp (cdr (assoc 40 (tblsearch "style" style)))))
                                        (progn
                                            (set_tile  "txt-bst" (setq txt-bst "0"))
                                            (mode_tile "txt-bst"   1)
                                            (mode_tile "txt-sze"   0)
                                        )
                                        (progn
                                            (mode_tile "txt-bst" 0)
                                            (if (= "1" txt-bst)
                                                (set_tile "txt-sze" (setq txt-sze (rtos tmp)))
                                            )
                                        )
                                    )
                                )
                            )
                            txt-sty
                        )
                        (action_tile "txt-sty" "(txt-sty-fun (setq txt-sty (nth (atoi $value) _styles)))")
                     
                        ;;----------------------------------------------------------------------;;
                     
                        (numinc:MakeList "txt-aln" (if (= "obj-mtx" obj-typ) _Attachment _Alignment))

                        (set_tile "txt-aln"
                            (itoa
                                (cond
                                    (   (vl-position txt-aln (if (= "obj-mtx" obj-typ) _Attachment _Alignment))
                                    )
                                    (   (setq txt-aln
                                            (car
                                                (if (= "obj-mtx" obj-typ)
                                                    _Attachment
                                                    _Alignment
                                                )
                                            )
                                        )
                                        0
                                    )
                                )
                            )
                        )

                        (action_tile "txt-aln"
                            (vl-prin1-to-string
                                (quote
                                    (setq txt-aln
                                        (nth (atoi $value)
                                            (if (= "obj-mtx" obj-typ)
                                                _Attachment
                                                _Alignment
                                            )
                                        )
                                    )
                                )
                            )
                        )

                        ;;----------------------------------------------------------------------;;

                        (set_tile    "txt-sze" txt-sze)
                        (action_tile "txt-sze" "(setq txt-sze $value)")

                        (if (= "1" txt-bst)
                            (if (zerop (setq tmp (cdr (assoc 40 (tblsearch "style" txt-sty)))))
                                (progn
                                    (set_tile  "txt-bst" (setq txt-bst "0"))
                                    (mode_tile "txt-bst" 1)
                                )
                                (progn
                                    (set_tile "txt-bst" txt-bst)
                                    (set_tile "txt-sze" (setq txt-sze (rtos tmp)))
                                )
                            )
                        )
                        (mode_tile  "txt-sze" (atoi txt-bst))
                        (mode_image "txt-pik" (atoi txt-bst))
                     
                        (action_tile "txt-bst"
                            (vl-prin1-to-string
                                (quote
                                    (progn
                                        (mode_tile  "txt-sze" (atoi (setq txt-bst $value)))
                                        (mode_image "txt-pik" (atoi txt-bst))
                                        (if (= "1" $value)
                                            (set_tile "txt-sze" (rtos (cdr (assoc 40 (tblsearch "style" txt-sty)))))
                                        )
                                    )
                                )
                            )
                        )

                        (action_tile "txt-pik" "(done_dialog 4)")

                        ;;----------------------------------------------------------------------;;

                        (set_tile "msk-trn" msk-trn)
                        (
                            (setq msk-trn-fun
                                (lambda ( value )
                                    (if (= "1" value)
                                        (mode_color "msk-col" 0)
                                        (mode_color "msk-col" (cdr (assoc 62 msk-col)))
                                    )
                                )
                            )
                            msk-trn
                        )
                        (action_tile "msk-trn" "(msk-trn-fun (setq msk-trn $value))")
                        (action_tile "msk-col"
                            (vl-prin1-to-string
                               '(
                                    (lambda ( / tmp )
                                        (if
                                            (setq tmp
                                                (acad_truecolordlg
                                                    (vl-some
                                                        (function
                                                            (lambda ( x ) (assoc x msk-col))
                                                        )
                                                       '(430 420 62)
                                                    )
                                                    nil
                                                )
                                            )
                                            (mode_color "msk-col" (cdr (assoc 62 (setq msk-col tmp))))
                                        )
                                    )
                                )
                            )
                        )

                        ;;----------------------------------------------------------------------;;

                        (set_tile "msk-off" msk-off)
                        (action_tile "msk-off" "(setq msk-off $value)")

                        (action_tile "msk-pik" "(done_dialog 7)")

                        ;;----------------------------------------------------------------------;;

                        (set_tile "msk-use" msk-use)
                        (
                            (setq msk-use-fun
                                (lambda ( value )
                                    (if (= "1" value)
                                        (progn
                                            (mode_tile  "msk-off" 0)
                                            (mode_image "msk-pik" 0)
                                            (mode_tile  "msk-trn" 0)
                                            (msk-trn-fun msk-trn)
                                        )
                                        (progn
                                            (mode_tile  "msk-off" 1)
                                            (mode_image "msk-pik" 1)
                                            (mode_tile  "msk-trn" 1)
                                            (mode_color "msk-col" -15)
                                        )
                                    )      
                                )
                            )
                            msk-use
                        )
                        (action_tile "msk-use" "(msk-use-fun (setq msk-use $value))")

                        ;;----------------------------------------------------------------------;;
                        ;;         Panel spodneho laveho pola [Bottom-Left Array Panel]         ;;
                        ;;----------------------------------------------------------------------;;                     

                        (set_tile "bor-enc" bor-enc)
                        (
                            (setq bor-enc-fun
                                (lambda ( value )
                                    (if (= "1" value)
                                        (progn
                                            (mode_tile "bor-shp" 0)
                                            (if (= "3" bor-shp) (mode_tile "bor-sid" 0))
                                            (mode_tile "bor-lay" 0)
                                            (mode_tile "bor-off" 0)
                                            (mode_tile "bor-fix" 0)
                                            (mode_tile "bor-pik" 0)
                                            (mode_tile "bor-ltx" 0)
                                            (if (= "bor-off" bor-typ)
                                                (progn
                                                    (mode_tile "off-ed1" 0)
                                                    (mode_tile "fix-ed1" 1)
                                                    (mode_tile "fix-txt" 1)
                                                    (mode_tile "fix-ed2" 1)
                                                )
                                                (progn
                                                    (mode_tile "off-ed1" 1)
                                                    (mode_tile "fix-ed1" 0)
                                                    (if (member bor-shp '("1" "2"))
                                                        (progn
                                                            (mode_tile "fix-txt" 0)
                                                            (mode_tile "fix-ed2" 0)
                                                        )
                                                        (progn
                                                            (mode_tile "fix-txt" 1)
                                                            (mode_tile "fix-ed2" 1)
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                        (foreach tile
                                           '(
                                                "bor-shp" "bor-sid" "bor-lay"
                                                "bor-off" "bor-fix" "off-ed1"
                                                "fix-ed1" "fix-ed2" "bor-pik"
                                                "fix-txt" "bor-ltx"
                                            )
                                            (mode_tile tile 1)
                                        )
                                    )
                                )
                            )
                            bor-enc
                        )
                        (action_tile "bor-enc" "(bor-enc-fun (setq bor-enc $value))")

                        ;;----------------------------------------------------------------------;;

                        (numinc:makelist "bor-shp" '("Circle" "Rectangle" "Slot" "Polygon"))

                        (set_tile "bor-shp" bor-shp)
                        (
                            (setq bor-shp-fun
                                (lambda ( value )
                                    (if (= "bor-fix" bor-typ)
                                        (mapcar 'mode_tile '("bor-sid" "fix-txt" "fix-ed2")
                                            (cond
                                                (   (= value "0")
                                                   '(1 1 1)
                                                )
                                                (   (member value '("1" "2"))
                                                   '(1 0 0)
                                                )
                                                (  '(0 1 1)
                                                )
                                            )
                                        )
                                        (mapcar 'mode_tile '("bor-sid" "fix-txt" "fix-ed2")
                                            (cond
                                                (   (member value '("0" "1" "2"))
                                                   '(1 1 1)
                                                )
                                                (  '(0 1 1)
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                            bor-shp
                        )
                        (action_tile "bor-shp" "(bor-shp-fun (setq bor-shp $value))")

                        ;;----------------------------------------------------------------------;;

                        (set_tile "bor-sid" bor-sid)
                        (action_tile "bor-sid" "(setq bor-sid $value)")

                        ;;----------------------------------------------------------------------;;

                        (numinc:makelist "bor-lay" _layers)
                     
                        (set_tile "bor-lay"
                            (itoa
                                (cond
                                    (   (vl-position bor-lay _layers))
                                    (   (vl-position (setq bor-lay (getvar 'clayer)) _layers))
                                )
                            )
                        )
                        (action_tile "bor-lay" "(setq bor-lay (nth (atoi $value) _layers))")

                        ;;----------------------------------------------------------------------;;

                        (set_tile bor-typ "1")
                        (
                            (setq bor-typ-fun
                                (lambda ( typ )
                                    (if (= "1" bor-enc)
                                        (if (= "bor-off" typ)
                                            (mapcar 'mode_tile '("off-ed1" "fix-ed1" "fix-ed2" "fix-txt") '(0 1 1 1))
                                            (progn
                                                (mode_tile "off-ed1" 1)
                                                (mode_tile "fix-ed1" 0)
                                                (if (member bor-shp '("1" "2"))
                                                    (progn
                                                        (mode_tile "fix-ed2" 0)
                                                        (mode_tile "fix-txt" 0)
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                            bor-typ
                        )
                        (action_tile "bor-off" "(bor-typ-fun (setq bor-typ $key))")
                        (action_tile "bor-fix" "(bor-typ-fun (setq bor-typ $key))")

                        ;;----------------------------------------------------------------------;;

                        (foreach symb '(off-ed1 fix-ed1 fix-ed2)
                            (setq tile (strcase (vl-symbol-name symb) t))
                            (set_tile tile (eval symb))
                            (action_tile tile (strcat "(setq " tile " $value)"))
                        )

                        (action_tile "bor-pik" "(done_dialog 3)")

                        ;;----------------------------------------------------------------------;;
                        ;;      Panel spodneho stredneho pola [Bottom-Middle Array Panel]       ;;
                        ;;----------------------------------------------------------------------;;                     
                     
                        (set_tile "arr-use" arr-use)
                        (
                            (setq arr-use-fun
                                (lambda ( value )
                                    (if (= "1" value)
                                        (progn
                                            (foreach tile
                                               '(
                                                    "arr-qty"
                                                    "arr-aln"
                                                    "arr-per"
                                                    "arr-oth"
                                                )
                                                (mode_tile tile 0)
                                            )
                                            (if (= "arr-oth" arr-typ)
                                                (progn
                                                    (mode_tile  "arr-rot" 0)
                                                    (mode_image "arr-pik" 0)
                                                )
                                                (progn
                                                    (mode_tile  "arr-rot" 1)
                                                    (mode_image "arr-pik" 1)
                                                )
                                            )
                                        )
                                        (progn
                                            (foreach tile
                                               '(
                                                    "arr-qty"
                                                    "arr-aln"
                                                    "arr-per"
                                                    "arr-oth"
                                                    "arr-rot"
                                                )
                                                (mode_tile tile 1)
                                            )
                                            (mode_image "arr-pik" 1)
                                        )
                                    )
                                )
                            )
                            arr-use
                        )
                        (action_tile "arr-use" "(arr-use-fun (setq arr-use $value))")

                        ;;----------------------------------------------------------------------;;
                     
                        (set_tile "arr-qty" arr-qty)
                        (action_tile "arr-qty" "(setq arr-qty $value)")

                        ;;----------------------------------------------------------------------;;

                        (set_tile arr-typ "1")
                        (
                            (setq arr-typ-fun
                                (lambda ( typ )
                                    (foreach tile '("arr-aln" "arr-per" "arr-oth")
                                        (if (/= typ tile)
                                            (set_tile tile "0")
                                        )
                                    )
                                    (if (= "arr-oth" arr-typ)
                                        (progn
                                            (mode_tile  "arr-rot" 0)
                                            (mode_image "arr-pik" 0)
                                        )
                                        (progn
                                            (mode_tile  "arr-rot" 1)
                                            (mode_image "arr-pik" 1)
                                        )
                                    )
                                )
                            )
                            arr-typ
                        )
                     
                        (foreach tile
                           '(
                                "arr-aln"
                                "arr-per"
                                "arr-oth"
                            )
                            (action_tile tile "(arr-typ-fun (setq arr-typ $key))")
                        )

                        ;;----------------------------------------------------------------------;;

                        (set_tile "arr-rot" arr-rot)
                        (action_tile "arr-rot" "(setq arr-rot $value)")

                        ;;----------------------------------------------------------------------;;

                        (action_tile "arr-pik" "(done_dialog 5)")

                        ;;----------------------------------------------------------------------;;
                        ;;            Sekcia mierky blocku [Block Scale Section]                ;;
                        ;;----------------------------------------------------------------------;;                     

                        (set_tile "blk-scl" blk-scl)
                        (action_tile "blk-scl" "(setq blk-scl $value)")

                        (numinc:makelist "scl-pop" _ScaleVars)
                        (set_tile "scl-pop"
                            (itoa
                                (cond
                                    (   (vl-position scl-pop _ScaleVars)
                                    )
                                    (   (setq scl-pop (car _ScaleVars))
                                        0
                                    )
                                )
                            )
                        )                                            

                        (
                            (setq blk-scl-fun
                                (lambda ( value )
                                    (if (= "1" value)
                                        (progn
                                            (mode_tile  "blk-scl" 1)
                                            (mode_tile  "scl-pop" 0)
                                            (mode_image "scl-pik" 1)
                                            (set_tile "blk-scl" (setq blk-scl (cdr (assoc scl-pop ScaleVars))))
                                        )
                                        (progn
                                            (mode_tile  "blk-scl" 0)
                                            (mode_tile  "scl-pop" 1)
                                            (mode_image "scl-pik" 0)
                                        )
                                    )
                                )
                            )
                            scl-var
                        )
                        (action_tile "scl-var" "(blk-scl-fun (setq scl-var $value))")

                        (action_tile "scl-pop"
                            (vl-prin1-to-string
                               '(set_tile "blk-scl"
                                    (setq blk-scl
                                        (cdr
                                            (assoc
                                                (setq scl-pop (nth (atoi $value) _ScaleVars))
                                                ScaleVars
                                            )
                                        )
                                    ) 
                                )
                            )
                        )

                        (action_tile "scl-pik" "(done_dialog 6)")

                        ;;----------------------------------------------------------------------;;
                        ;;                     Top-Center Object Type Panel                     ;;
                        ;;----------------------------------------------------------------------;;                     

                        (if (and (= "obj-blk" obj-typ) (null _blocks))
                            (setq obj-typ "obj-txt")
                        )
                        (set_tile obj-typ "1")
                     
                        (
                            (setq obj-typ-fun
                                (lambda ( typ )
                                    (if (= typ "obj-blk")
                                        (progn
                                            (set_tile "lay-txt" "Block Layer: ")
                                            (foreach pair
                                               '(
                                                    ("blk-nme" 0)
                                                    ("blk-txt" 0)
                                                    ;("blk-pik" 0) image tile
                                                    ("att-txt" 0)
                                                    ("att-nme" 0)
                                                    ;("blk-scl" 0) set by blk-scl-fun
                                                    ;("scl-pik" 0) image tile
                                                    ("scl-var" 0)
                                                    ;("scl-pop" 0) set by blk-scl-fun
                                                    ("sty-txt" 1)
                                                    ("txt-sty" 1)
                                                    ("aln-txt" 1)
                                                    ("txt-aln" 1)
                                                    ("txt-bst" 1)
                                                    ("txt-sze" 1)
                                                    ("bor-enc" 1)
                                                    ("bor-shp" 1)
                                                    ("bor-sid" 1)
                                                    ("bor-ltx" 1)
                                                    ("bor-lay" 1)
                                                    ("bor-off" 1)
                                                    ("bor-fix" 1)
                                                    ("off-ed1" 1)
                                                    ("fix-ed1" 1)
                                                    ("fix-ed2" 1)
                                                    ("bor-pik" 1)
                                                    ("msk-use" 1)
                                                    ("msk-off" 1)
                                                    ;("msk-pik" 1) image tile
                                                    ("msk-trn" 1)
                                                    ;("msk-col" 1) color tile
                                                )
                                                (apply 'mode_tile pair)
                                            )
                                            (mode_image "blk-pik" 0)
                                            (mode_image "msk-pik" 1)
                                            (mode_color "msk-col" -15)
                                            ;(mode_image "scl-pik" 0)
                                            (blk-scl-fun scl-var)
                                        )
                                        (progn
                                            (set_tile "lay-txt" "Text Layer: ")
                                            (foreach pair
                                               '(
                                                    ("blk-txt" 1)
                                                    ("blk-nme" 1)
                                                    ;("blk-pik" 1) image tile
                                                    ("att-txt" 1)
                                                    ("att-nme" 1)
                                                    ("blk-scl" 1)
                                                    ;("scl-pik" 1) image tile
                                                    ("scl-var" 1)
                                                    ("scl-pop" 1)
                                                    ("sty-txt" 0)
                                                    ("txt-sty" 0)
                                                    ("aln-txt" 0)
                                                    ("txt-aln" 0)
                                                    ("bor-enc" 0)
                                                )
                                                (apply 'mode_tile pair)
                                            )
                                            (mode_image "blk-pik" 1)
                                            (mode_image "scl-pik" 1)
                                            (bor-enc-fun bor-enc)
                                            (txt-sty-fun txt-sty)
                                            (numinc:makelist "txt-aln" (if (= "obj-mtx" obj-typ) _Attachment _Alignment))
                                            (set_tile "txt-aln"
                                                (itoa
                                                    (cond
                                                        (   (vl-position txt-aln (if (= "obj-mtx" obj-typ) _Attachment _Alignment))
                                                        )
                                                        (   (setq txt-aln
                                                                (car
                                                                    (if (= "obj-mtx" obj-typ)
                                                                        _Attachment
                                                                        _Alignment
                                                                    )
                                                                )
                                                            )
                                                            0
                                                        )
                                                    )
                                                )
                                            )
                                            (if (= "obj-mtx" typ)
                                                (progn
                                                    (mode_tile "msk-use" 0)
                                                    (msk-use-fun msk-use)
                                                )
                                                (progn
                                                    (msk-use-fun "0")
                                                    (mode_tile "msk-use" 1)
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                            obj-typ
                        )

                        (foreach tile
                           '(
                                "obj-txt"
                                "obj-mtx"
                                "obj-blk"
                            )
                            (action_tile tile "(obj-typ-fun (setq obj-typ $key))")
                        )
                     
                        (if _blocks
                            (progn
                                (numinc:makelist "blk-nme" (setq blocks (mapcar 'car _blocks)))
                                (set_tile "blk-nme"
                                    (setq block
                                        (itoa
                                            (cond
                                                (   (vl-position blk-nme blocks))
                                                (   (setq blk-nme (car blocks))
                                                    0
                                                )
                                            )
                                        )
                                    )
                                )
                                (numinc:makelist "att-nme" (setq attribs (cdr (nth (atoi block) _blocks))))
                                (set_tile "att-nme"
                                    (setq attrib
                                        (itoa
                                            (cond
                                                (   (vl-position att-nme attribs))
                                                (   (setq att-nme (car attribs))
                                                    0
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                            (mode_tile "obj-blk" 1)
                        )

                        (action_tile "blk-nme"
                            (vl-prin1-to-string
                                (quote
                                    (progn
                                        (setq blk-itm (nth (atoi (setq block $value)) _blocks)
                                              blk-nme (car blk-itm)
                                        )
                                        (numinc:makelist "att-nme" (setq attribs (cdr blk-itm)))
                                        (set_tile "att-nme"
                                            (setq attrib
                                                (itoa
                                                    (cond
                                                        (   (vl-position att-nme attribs))
                                                        (   (setq att-nme (car attribs))
                                                            0
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )

                        (action_tile "blk-pik" "(done_dialog 2)")
                        (action_tile "att-nme" "(setq attrib $value att-nme (nth (atoi $value) attribs))")
                     
                        ;;----------------------------------------------------------------------;;
                        ;;                   Zaklad dialogu [Base of Dialog]                    ;;
                        ;;----------------------------------------------------------------------;;                     

                        (action_tile "about" "(numinc:about dclid)")

                        (action_tile "accept"
                            (vl-prin1-to-string
                                (quote
                                    (progn
                                        (if (= "" inc-str)
                                            (setq inc-str "0")
                                        )
                                        (if (= "" txt-sze)
                                            (setq txt-sze (rtos (getvar 'textsize)))
                                        )
                                        (cond
                                            (   (and
                                                    (/= "obj-blk" obj-typ)
                                                    (= "1" bor-enc)
                                                    (= "bor-off" bor-typ)
                                                    (not (setq off-ed1# (distof off-ed1)))
                                                )
                                                (numinc:popup "Upozornenie" 48 "Posun okraja musi byt ciselny.")
                                                (mode_tile "off-ed1" 2)
                                            )
                                            (   (and
                                                    (/= "obj-blk" obj-typ)
                                                    (= "1" bor-enc)
                                                    (= "bor-off" bor-typ)
                                                    (< off-ed1# 1.0)
                                                )
                                                (numinc:popup "Upozornenie" 48 "Faktor posunu okraja musi byt vacsi alebo rovny jednej.")
                                                (mode_tile "off-ed1" 2)
                                            )
                                            (   (and
                                                    (/= "obj-blk" obj-typ)
                                                    (= "1" bor-enc)
                                                    (= "bor-fix" bor-typ)
                                                    (or (not (setq fix-ed1# (distof fix-ed1)))
                                                        (and
                                                            (member bor-shp '("1" "2"))
                                                            (not (setq fix-ed2# (distof fix-ed2)))
                                                        )
                                                    )
                                                )
                                                (numinc:popup "Upozornenie" 48 "Velkost okraja musi byt ciselna.")
                                                (mode_tile "fix-ed1" 2)
                                            )
                                            (   (and
                                                    (/= "obj-blk" obj-typ)
                                                    (= "1" bor-enc)
                                                    (= "bor-fix" bor-typ)
                                                    (or (<= fix-ed1# 0.0)
                                                        (and
                                                            (member bor-shp '("1" "2"))
                                                            (<= fix-ed2# 0.0)
                                                        )
                                                    )
                                                )
                                                (numinc:popup "Upozornenie" 48 "Velkost okraja musi byt vacsia ako nula.")
                                                (mode_tile "fix-ed1" 2)
                                            )
                                            (   (and
                                                    (= "1" arr-use)
                                                    (< (setq arr-qty# (atoi arr-qty)) 1)
                                                )
                                                (numinc:popup "Upozornenie" 48 "Pocet poloziek v poli musi byt vacsi alebo rovny jednej.")
                                                (mode_tile "arr-qty" 2)
                                            )
                                            (   (and
                                                    (= "1" arr-use)
                                                    (= "arr-oth" arr-typ)
                                                    (not (setq arr-rot# (angtof arr-rot)))
                                                )
                                                (numinc:popup "Upozornenie" 48 "Rotacia pola objektov musi byt ciselna.")
                                                (mode_tile "arr-rot" 2)
                                            )
                                            (   (and
                                                    (= "obj-mtx" obj-typ)
                                                    (= "1" msk-use)
                                                    (not (setq msk-off# (distof msk-off)))
                                                )
                                                (numinc:popup "Upozornenie" 48 "Faktor posunu masky pozadia musi byt ciselny.")
                                                (mode_tile "msk-off" 2)
                                            )
                                            (   (and
                                                    (= "obj-mtx" obj-typ)
                                                    (= "1" msk-use)
                                                    (or (< 5.0 msk-off#)
                                                        (< msk-off# 1.0)
                                                    )
                                                )
                                                (numinc:popup "Upozornenie" 48 "Faktor posunu masky pozadia musi byt medzi 1 a 5.")
                                                (mode_tile "msk-off" 2)
                                            )
                                            (   (and
                                                    (= "obj-blk" obj-typ)
                                                    (not (setq blk-scl# (distof blk-scl)))
                                                )
                                                (numinc:popup "Upozornenie" 48 "Mierka blocku musi byt ciselna.")
                                                (mode_tile "blk-scl" 2)
                                            )
                                            (   (and
                                                    (= "obj-blk" obj-typ)
                                                    (<= blk-scl# 0.0)
                                                )
                                                (numinc:popup "Upozornenie" 48 "Mierka blocku musi byt vacsia ako nula.")
                                                (mode_tile "blk-scl" 2)
                                            )
                                            (   (not (distof inc-str 2))
                                                (numinc:popup "Upozornenie" 48 "Prirastok muso byt ciselny.")
                                                (mode_tile "inc-str" 2)
                                            )
                                            (   (and
                                                    (/= "obj-blk" obj-typ)
                                                    (not (setq txt-sze# (distof txt-sze)))
                                                )
                                                (numinc:popup "Upozornenie" 48 "Vyska textu musi byt ciselna.")
                                                (if (= "0" txt-bst)
                                                    (mode_tile "txt-sze" 2)
                                                )
                                            )
                                            (   (and
                                                    (/= "obj-blk" obj-typ)
                                                    (<= txt-sze# 0.0)
                                                )
                                                (numinc:Popup "Upozornenie" 48 "Vyska textu musi byt vacsia ako nula.")
                                                (if (= "0" txt-bst)
                                                    (mode_tile "txt-sze" 2)
                                                )
                                            )
                                            (   (and
                                                    (/= "obj-blk" obj-typ)
                                                    (= "1" bor-enc)
                                                    (= "3" bor-shp)
                                                    (< (setq bor-sid# (atoi bor-sid)) 3)
                                                )
                                                (numinc:popup "Upozornenie" 48 "Pocet stran polygonu musi byt ciselny\na vacsi ako 2.")
                                                (mode_tile "bor-sid" 2)
                                            )
                                            (   t
                                                (done_dialog 1)
                                            )
                                        )
                                    )
                                )
                            )
                        )

                        (setq dclflag (start_dialog))
                    )
                )
                (cond
                    (   (= 2 dclflag)
                        (while
                            (progn (setvar 'errno 0) (setq ent (car (entsel "\nVyberte block: ")))
                                (cond
                                    (   (= 7 (getvar 'errno))
                                        (princ "\nChyba, skuste znovu.")
                                    )
                                    (   (= 'ename (type ent))
                                        (if
                                            (and
                                                (= "INSERT" (cdr (assoc 0 (setq elst (entget ent)))))
                                                (= 1 (cdr (assoc 66 elst)))
                                            )
                                            (progn
                                                (setq blk-nme
                                                    (if (vlax-property-available-p (setq obj (vlax-ename->vla-object ent)) 'effectivename)
                                                        (vla-get-effectivename obj)
                                                        (vla-get-name obj)
                                                    )
                                                )
                                                nil
                                            )
                                            (princ "\nProsim vyberte block.")
                                        )
                                    )
                                )
                            )
                        )
                    )
                    (   (= 3 dclflag)
                        (cond
                            (   (= "bor-off" bor-typ)
                                (while
                                    (and
                                        (progn
                                            (initget 6)
                                            (setq tmp
                                                (getdist
                                                    (strcat "\nZadajte faktor odsadenia okraja <" off-ed1 ">: ")
                                                )
                                            )
                                        )
                                        (< tmp 1.0)
                                    )
                                    (princ "\nZadajte hodnotu vacsiu alebo ruvnu jednej.")
                                )
                                (if tmp
                                    (setq off-ed1 (rtos tmp))
                                )
                            )
                            (   t
                                (cond
                                    (   (member bor-shp '("0" "3"))
                                        (setq fix-ed1
                                            (cond
                                                (   (setq tmp
                                                        (getdist
                                                            (strcat "\nZadajte polomer okraja <" fix-ed1 ">: ")
                                                        )
                                                    )
                                                    (rtos tmp)
                                                )
                                                (   fix-ed1   )
                                            )
                                        )
                                    )
                                    (   t
                                        (if
                                            (and
                                                (setq p1 (getpoint "\nZadajte prvy bod: "))
                                                (setq p2 (getcorner p1 "\nZadajte opacny roh: "))
                                            )
                                            (setq fix-ed1 (rtos (abs (- (car  p2) (car  p1))))
                                                  fix-ed2 (rtos (abs (- (cadr p2) (cadr p1))))
                                            )
                                        )
                                    )
                                )
                            )  
                        )
                    )
                    (   (= 4 dclflag)
                        (initget 6)
                        (setq txt-sze
                            (cond
                                (   (setq tmp
                                        (getdist
                                            (strcat "\nZadajte velkost textu <" txt-sze ">: ")
                                        )
                                    )
                                    (rtos tmp)
                                )
                                (   txt-sze   )
                            )
                        )
                    )
                    (   (= 5 dclflag)
                        (setq arr-rot
                            (cond
                                (   (setq tmp
                                        (getangle
                                            (strcat "\nZadajte uhol objektu <" arr-rot ">: ")
                                        )
                                    )
                                    (angtos tmp)
                                )
                                (   arr-rot   )
                            )
                        )
                    )
                    (   (= 6 dclflag)
                        (initget 6)
                        (setq blk-scl
                            (cond
                                (   (setq tmp
                                        (getdist
                                            (strcat "\nZadajte mierku blocku <" blk-scl ">: ")
                                        )
                                    )
                                    (rtos tmp)
                                )
                                (   blk-scl   )
                            )
                        )
                    )
                    (   (= 7 dclflag)
                        (while
                            (and
                                (progn
                                    (initget 6)
                                    (setq tmp
                                        (getdist
                                            (strcat "\nZadajte faktor odsadenia masky pozadia <" msk-off ">: ")
                                        )
                                    )
                                )
                                (or
                                    (< 5.0 tmp)
                                    (< tmp 1.0)
                                )
                            )
                            (princ "\nZadajte hodnotu medzi 1 a 5.")
                        )
                        (if tmp
                            (setq msk-off (rtos tmp))
                        )
                    )
                )
            )
            (if (= 1 dclflag)
                (progn
                    (if
                        (setq ss
                            (ssget "_X"
                                (list '(0 . "ACAD_TABLE")
                                    (if (= 1 (getvar 'cvport))
                                        (cons 410 (getvar 'ctab))
                                       '(410 . "Model")
                                    )
                                )
                            )
                        )
                        (repeat (setq i (sslength ss))
                            (setq table (cons (vlax-ename->vla-object (ssname ss (setq i (1- i)))) table))
                        )
                    )
                    (setq acspc (vlax-get-property (numinc:acdoc) (if (= 1 (getvar 'cvport)) 'paperspace 'modelspace))
                          nm    (trans '(0.0 0.0 1.0) 1 0 t)
                          xa    (angle '(0.0 0.0 0.0) (trans (getvar 'ucsxdir) 0 nm t))
                    )
                    (if (/= "obj-blk" obj-typ)
                        (progn
                            (if (numinc:annotative-p txt-sty)
                                (setq txt-sze# (/ txt-sze# (cond ((getvar 'cannoscalevalue)) (1.0))))
                            )
                            (setq oba (cdr (assoc 50 (tblsearch "style" txt-sty))))
                        )
                    )
                    (setq symb
                        (mapcar 'cdr
                            (vl-remove-if
                                (function
                                    (lambda ( pair )
                                        (zerop (logand (car pair) inc-sec))
                                    )
                                )
                               '(
                                    (1 . pre-str)
                                    (2 . mid-str)
                                    (4 . suf-str)
                                )
                            )
                        )
                    )
                    
                    (setq prop
                        (if
                            (and
                                (= "obj-txt" obj-typ)
                                (/= "Left" txt-aln)
                            )
                            'textalignmentpoint
                            'insertionpoint
                        )
                    )

                    (if (= "1" msk-use)
                        (setq mtx-bak :vlax-true)
                        (setq mtx-bak :vlax-false)
                    )
                    
                    (setq create-obj
                        (cond
                            (   (= "obj-txt" obj-typ)
                                (lambda ( point string / obj )
                                    (setq point (vlax-3D-point (trans point 1 0))
                                            obj (vla-addtext acspc string point txt-sze#)
                                    )
                                    (vla-put-stylename obj txt-sty)
                                    (vla-put-layer     obj txt-lay)
                                    (vla-put-alignment obj (cdr (assoc txt-aln Alignment)))
                                    (if (= "Left" txt-aln)
                                        (vla-put-insertionpoint     obj point)
                                        (vla-put-textalignmentpoint obj point)
                                    )
                                    (vla-put-obliqueangle obj oba)
                                    (vla-put-rotation     obj (+ xa txt-rot))
                                    obj
                                )
                            )
                            (   (= "obj-mtx" obj-typ)
                                (lambda ( point string / obj )
                                    (setq point (vlax-3D-point (trans point 1 0)))
                                    (setq obj
                                        (vla-addmtext acspc point
                                            (numinc:mtextwidth string txt-sty txt-sze#)
                                            string
                                        )
                                    )
                                    (vla-put-stylename obj txt-sty)
                                    (vla-put-layer     obj txt-lay)
                                    (vla-put-height    obj txt-sze#)
                                    (vla-put-attachmentpoint obj (cdr (assoc txt-aln Attachment)))
                                    (vla-put-insertionpoint  obj point)
                                    (vla-put-rotation  obj txt-rot)

                                    (if (= "1" msk-use)
                                        (entmod
                                            (append
                                                (vl-remove-if
                                                    (function
                                                        (lambda ( pair )
                                                            (member (car pair) '(45 63 90 421 431 441))
                                                        )
                                                    )
                                                    (entget (vlax-vla-object->ename obj))
                                                )
                                                (if (= "1" msk-trn)
                                                   '((90 . 3))
                                                   '((90 . 1))
                                                )
                                                (if (= "1" msk-trn)
                                                   '((63 . 256))
                                                    (mapcar '(lambda ( x ) (cons (1+ (car x)) (cdr x))) msk-col)
                                                )
                                                (list
                                                    (cons 45 msk-off#)
                                                   '(441 . 0)
                                                )
                                            )
                                        )
                                    )
                                    
                                    (vla-put-backgroundfill obj mtx-bak)
                                    obj
                                )
                            )
                            (   (= "obj-blk" obj-typ)
                                (lambda ( point string / obj )
                                    (setq point (vlax-3D-point (trans point 1 0))
                                          obj   (vla-insertblock acspc point blk-nme blk-scl# blk-scl# blk-scl# (+ xa txt-rot))
                                    )
                                    (vl-some
                                        (function
                                            (lambda ( attrib )
                                                (if (= (strcase (vla-get-tagstring attrib)) att-nme)
                                                    (null (vla-put-textstring attrib string))
                                                )
                                            )
                                        )
                                        (vlax-invoke obj 'getattributes)
                                    )
                                    (vla-put-layer obj txt-lay)
                                    obj
                                )
                            )
                        )
                    )

                    (if
                        (and
                            (/= "obj-blk" obj-typ)
                            (= "1" bor-enc)
                            (= "bor-off" bor-typ)
                            off-ed1#
                        )                       
                        (setq off-ed1# (* txt-sze# (1- off-ed1#)))
                    )

                    (setq create-bor
                        (lambda ( obj prop / bor )
                            (setq bor
                                (vlax-ename->vla-object
                                    (numinc:createtextborder
                                        (vlax-vla-object->ename obj) bor-shp
                                        (cond (off-ed1#) (0.0)) fix-ed1# fix-ed2# bor-sid#
                                    )
                                )
                            )
                            (vla-put-layer bor bor-lay)
                            (if (and (= "3" bor-shp) bor-rot)
                                (vla-rotate bor (vlax-3D-point (numinc:polygoncentroid bor)) (/ pi bor-sid#))
                            )
                            bor
                        )
                    )
                    
                    (cond
                        (   (= "1" arr-use)
                            (if (setq p1 (getpoint "\nZadajte zakladny bod pola: "))
                                (progn
                                    (while
                                        (progn
                                            (if arr-end
                                                (progn
                                                    (initget "Medzery")
                                                    (setq p2 (getpoint "\nZadajte koncovu bod pola [Medzery]: " p1))
                                                )
                                                (progn
                                                    (initget "Koncovy bod")
                                                    (setq p2 (getpoint "\nZadajte vektor rozstupu pola [Koncovy bod]: " p1))
                                                )
                                            )
                                            (cond
                                                (   (null p2)
                                                    nil
                                                )
                                                (   (= "Koncovy bod" p2)
                                                    (setq arr-end t)
                                                )
                                                (   (= "Medzery" p2)
                                                    (setq arr-end nil)
                                                    t
                                                )
                                                (   (and
                                                        (listp p2)
                                                        (equal p1 p2 1e-8)
                                                    )
                                                    (princ "\nBody musia byt odlisne.")
                                                )
                                            )
                                        )
                                    )
                                    (if (and arr-end (< 1 arr-qty#))
                                        (setq v1 (mapcar '(lambda ( a b ) (/ (- a b) (float (1- arr-qty#)))) p2 p1))
                                        (setq v1 (mapcar '- p2 p1))
                                    )
                                    (cond
                                        (   (= "arr-aln" arr-typ)
                                            (setq r1 (numinc:makereadable (angle p1 p2)))
                                        )
                                        (   (= "arr-per" arr-typ)
                                            (setq r1 (numinc:makereadable (+ (angle p1 p2) (/ pi 2.0))))
                                        )
                                        (   (setq r1 arr-rot#)   )
                                    )
                                    (if (/= "obj-mtx" obj-typ)
                                        (setq r1 (+ r1 xa))
                                    )
                                    (repeat arr-qty#
                                        (setq obj (create-obj p1 (strcat pre-str mid-str suf-str)))
                                        (vla-put-rotation obj r1)
                                        (if
                                            (and
                                                (/= "obj-blk" obj-typ)
                                                (= "1" bor-enc)
                                            )
                                            (create-bor obj prop)
                                        )
                                        (numinc:increment symb inc-str)
                                        (setq p1 (mapcar '+ p1 v1))
                                    )
                                )
                            )        
                        )
                        (   (= "1" dyn-flg)
                            (while (/= 5 (car (setq gr (grread t 13 0)))))
                            (setq obj (create-obj (cadr gr) (strcat pre-str mid-str suf-str)))

                            (if
                                (and
                                    (/= "obj-blk" obj-typ)
                                    (= "1" bor-enc)
                                )
                                (setq bor (create-bor obj prop))
                            )
                         
                            (princ
                                (setq msg
                                    (strcat
                                        "\n[C]urve Aligned, [R]eplace, R[o]tate CCW[<] / CW[>], [T]oggle Count, [I]ncrement\n"
                                        (if
                                            (and
                                                (/= "obj-blk" obj-typ)
                                                (= "1" bor-enc)
                                                (= "3" bor-shp)
                                            )
                                            "Rotate [B]order, " ""
                                        )
                                        "[Tab] = Rotate 90" (chr 186)
                                        ", [M]irror Rotation"
                                        (if (= "obj-mtx" obj-typ) ", B[a]ckground Mask" "")
                                        " <Exit>"
                                    )
                                )
                            )
                            (setvar 'modemacro
                                (strcat "Rotation: "
                                    (rtos (rem (+ 360.0 (* 180.0 (/ txt-rot pi))) 360) 2 2) (chr 186)
                                )
                            )
                            (while
                                (progn
                                    (setq gr (grread t 15 0)
                                          g1 (car  gr)
                                          g2 (cadr gr)
                                    )
                                    (cond
                                        (   (member g1 '(3 5))
                                            (setq p1 (vlax-3D-point (trans g2 1 0)))
                                            (if bor
                                                (vla-move bor (vlax-get-property obj prop) p1)
                                            )
                                            (vlax-put-property obj prop p1)

                                            (if (= 3 g1)
                                                (progn
                                                    (if (and table (numinc:textincell table p1 (strcat pre-str mid-str suf-str)))
                                                        (progn
                                                            (vla-delete obj)
                                                            (if bor (vla-delete bor))
                                                        )
                                                    )
                                                    (if tog-cnt (numinc:increment symb inc-str))
                                                    (setq obj (create-obj g2 (strcat pre-str mid-str suf-str)))

                                                    (if
                                                        (and
                                                            (/= "obj-blk" obj-typ)
                                                            (= "1" bor-enc)
                                                        )
                                                        (setq bor (create-bor obj prop))
                                                    )
                                                    (redraw)
                                                )
                                            )
                                            t
                                        )
                                        (   (= 25 g1)
                                            (vla-delete obj)
                                            (if bor (vla-delete bor))
                                            nil
                                        )
                                        (   (= 2 g1)
                                            (cond
                                                (   (member g2 '(67 99))  ;; C/c

                                                    (vla-delete obj)
                                                    (if bor (vla-delete bor))
                                                 
                                                    (while
                                                        (setq ent
                                                            (numinc:selectif "\nVyberte krivku <exit>: "
                                                                (function
                                                                    (lambda ( x )
                                                                        (not
                                                                            (vl-catch-all-error-p
                                                                                (vl-catch-all-apply 'vlax-curve-getendparam (list x))
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                entsel
                                                            )
                                                        )
                                                        (if (numinc:aligntocurve
                                                                (setq obj (create-obj (cadr ent) (strcat pre-str mid-str suf-str)))
                                                                prop
                                                                (car ent)
                                                                (if
                                                                    (and
                                                                        (/= "obj-blk" obj-typ)
                                                                        (= "1" bor-enc)
                                                                    )
                                                                    (setq bor (create-bor obj prop))
                                                                )
                                                            )
                                                            (if tog-cnt (numinc:increment symb inc-str))
                                                            (progn
                                                                (vla-delete obj)
                                                                (if bor (vla-delete bor))
                                                            )
                                                        )
                                                    )

                                                    (setq obj (create-obj (cadr (grread t 13 0)) (strcat pre-str mid-str suf-str)))
                                                    (if
                                                        (and
                                                            (/= "obj-blk" obj-typ)
                                                            (= "1" bor-enc)
                                                        )
                                                        (setq bor (create-bor obj prop))
                                                    )
                                                    (princ msg)
                                                )
                                                (   (member g2 '(44 46 60 62))  ;; </>
                                                    (if (member g2 '(44 60))
                                                        (setq deg (/ pi  180.0))
                                                        (setq deg (/ pi -180.0))
                                                    )
                                                    (setvar 'modemacro
                                                        (strcat "Rotacia: "
                                                            (rtos
                                                                (rem
                                                                    (+ 360.0
                                                                        (* 180.0
                                                                            (/ (setq txt-rot (+ txt-rot deg)) pi)
                                                                        )
                                                                    )
                                                                    360
                                                                )
                                                                2 2
                                                            )
                                                            (chr 186)
                                                        )
                                                    )
                                                    (vla-put-rotation obj (+ (vla-get-rotation obj) deg))
                                                    (if bor
                                                        (vla-rotate bor (vlax-get-property obj prop) deg)
                                                    )
                                                    t
                                                )
                                                (   (member g2 '(79 111))  ;; O/o
                                                    (setq txt-rot
                                                        (cond
                                                            (
                                                                (getangle
                                                                    (strcat "\nZadajte "
                                                                        (cdr
                                                                            (assoc obj-typ
                                                                               '(
                                                                                    ("obj-txt" . "text")
                                                                                    ("obj-mtx" . "mtext")
                                                                                    ("obj-blk" . "block")
                                                                                )
                                                                            )
                                                                        )
                                                                        " rotaciu <" (angtos txt-rot) ">: "
                                                                    )
                                                                )
                                                            )
                                                            (   txt-rot   )
                                                        )
                                                    )
                                                    (setvar 'modemacro
                                                        (strcat "Rotacia: "
                                                            (rtos
                                                                (rem
                                                                    (+ 360.0 (* 180.0 (/ txt-rot pi)))
                                                                    360
                                                                )
                                                                2 2
                                                            )
                                                            (chr 186)
                                                        )
                                                    )
                                                    (if bor
                                                        (vla-rotate bor (vlax-get-property obj prop)
                                                            (- txt-rot
                                                                (if (= "obj-mtx" obj-typ)
                                                                    (vla-get-rotation obj)
                                                                    (- (vla-get-rotation obj) xa)
                                                                )
                                                            )
                                                        )
                                                    )
                                                    (vla-put-rotation obj
                                                        ((lambda ( a ) (if (= "obj-mtx" obj-typ) a (+ a xa))) txt-rot)
                                                    )
                                                    (princ msg)
                                                )
                                                (   (member g2 '(84 116))  ;; T/t
                                                    (if (setq tog-cnt (not tog-cnt))
                                                        (princ "\n<Pocitadlo je povolene>")
                                                        (princ "\n<Pocitadlo je zakazane>")
                                                    )
                                                    (princ msg)
                                                )
                                                (   (member g2 '(73 105)) ;; I/i

                                                    (vla-delete obj)
                                                    (if bor (vla-delete bor))
                                                 
                                                    (numinc:increment symb inc-str)

                                                    (setq obj (create-obj (cadr (grread t 13 0)) (strcat pre-str mid-str suf-str)))
                                                    (if
                                                        (and
                                                            (/= "obj-blk" obj-typ)
                                                            (= "1" bor-enc)
                                                        )
                                                        (setq bor (create-bor obj prop))
                                                    )
                                                    t
                                                )
                                                (   (member g2 '(66 98))  ;; B/b
                                                    (if
                                                        (and
                                                            (/= "obj-blk" obj-typ)
                                                            (= "1" bor-enc)
                                                            (= "3" bor-shp)
                                                            bor
                                                        )
                                                        (progn
                                                            (setq bor-rot (not bor-rot))
                                                            (vla-rotate bor
                                                                (vlax-3D-point (numinc:PolygonCentroid bor))
                                                                (/ pi bor-sid#)
                                                            )
                                                        )
                                                        (princ (strcat "\nNeplatne stlacenie klavesy." msg))
                                                    )
                                                    t
                                                )
                                                (   (= g2 9)  ;; Tab
                                                    (setq txt-rot (rem (+ pi pi txt-rot) (+ pi pi)))
                                                 
                                                    (if
                                                        (vl-some
                                                            (function
                                                                (lambda ( x )
                                                                    (equal txt-rot x 1e-6)
                                                                )
                                                            )
                                                            (list (* pi 0.0) (* pi 0.5) (* pi 1.0) (* pi 1.5))
                                                        )
                                                        (setq txt-rot (rem (+ txt-rot (/ pi 2.0)) (+ pi pi)))
                                                        (setq txt-rot (numinc:roundto txt-rot (/ pi 2.0)))
                                                    )
                                                    (setvar 'modemacro
                                                        (strcat "Rotacia: "
                                                            (rtos
                                                                (rem
                                                                    (+ 360.0 (* 180.0 (/ txt-rot pi)))
                                                                    360
                                                                )
                                                                2 2
                                                            )
                                                            (chr 186)
                                                        )
                                                    )
                                                    (if bor
                                                        (vla-rotate bor (vlax-get-property obj prop)
                                                            (- txt-rot
                                                                (if (= "obj-mtx" obj-typ)
                                                                    (vla-get-rotation obj)
                                                                    (- (vla-get-rotation obj) xa)
                                                                )
                                                            )
                                                        )
                                                    )
                                                    (vla-put-rotation obj
                                                        ((lambda ( a ) (if (= "obj-mtx" obj-typ) a (+ a xa))) txt-rot)
                                                    )
                                                    t
                                                )
                                                (   (member g2 '(77 109))  ;; M/m
                                                    (setq txt-rot (rem (+ pi pi (* -1.0 txt-rot)) (+ pi pi)))

                                                    (setvar 'modemacro
                                                        (strcat "Rotacia: "
                                                            (rtos
                                                                (rem
                                                                    (+ 360.0 (* 180.0 (/ txt-rot pi)))
                                                                    360
                                                                )
                                                                2 2
                                                            )
                                                            (chr 186)
                                                        )
                                                    )
                                                 
                                                    (if bor
                                                        (vla-rotate bor (vlax-get-property obj prop)
                                                            (- txt-rot
                                                                (if (= "obj-mtx" obj-typ)
                                                                    (vla-get-rotation obj)
                                                                    (- (vla-get-rotation obj) xa)
                                                                )
                                                            )
                                                        )
                                                    )
                                                    (vla-put-rotation obj
                                                        ((lambda ( a ) (if (= "obj-mtx" obj-typ) a (+ a xa))) txt-rot)
                                                    )
                                                    t
                                                )
                                                (   (member g2 '(82 114))  ;; R/r

                                                    (vla-delete obj)
                                                    (if bor (vla-delete bor))

                                                    (while (numinc:replace (strcat pre-str mid-str suf-str))
                                                        (if tog-cnt
                                                            (numinc:increment symb inc-str)
                                                        )
                                                    )
                                                 
                                                    (setq obj (create-obj (cadr (grread t 13 0)) (strcat pre-str mid-str suf-str)))
                                                    (if
                                                        (and
                                                            (/= "obj-blk" obj-typ)
                                                            (= "1" bor-enc)
                                                        )
                                                        (setq bor (create-bor obj prop))
                                                    )
                                                    (princ msg)
                                                )
                                                (   (member g2 '(65 97))  ;; A/a

                                                    (if (= "obj-mtx" obj-typ)
                                                        (progn
                                                            (vlax-put obj 'backgroundfill
                                                                (setq mtx-bak (~ (vlax-get obj 'backgroundfill)))
                                                            )
                                                            (if (zerop mtx-bak)
                                                                (princ "\n<Maska pozadia vypnuta>")
                                                                (princ "\n<Maska pozadia zapnuta>")
                                                            )
                                                        )
                                                        (princ "\nNeplatne stlacenie klavesy.")
                                                    )
                                                    (princ msg)
                                                )
                                                (   (member g2 '(13 32))  ;; Enter/Space
                                                 
                                                    (vla-delete obj)
                                                    (if bor (vla-delete bor))      
                                                    nil
                                                )
                                                (   (princ (strcat "\nNeplatne stlacenie klavesy." msg))   )
                                            )
                                        )
                                        (   t
                                            (vla-delete obj)
                                            (if bor (vla-delete bor))
                                            nil
                                        )
                                    )
                                )
                            )
                        )
                        (   t
                            (setq msg
                                (strcat
                                    "\nPick Point or [C]urve Aligned, [R]eplace, R[o]tation, [T]oggle Count, [I]ncrement\n"
                                    (if
                                        (and
                                            (/= "obj-blk" obj-typ)
                                            (= "1" bor-enc)
                                            (= "3" bor-shp)
                                        )
                                        "Rotate [B]order, " ""
                                    )
                                    "[Ro]tate 90" (chr 186) ", [M]irror Rotation"
                                    (if (= "obj-mtx" obj-typ) ", B[a]ckground Mask" "")
                                    " <Exit>: "
                                )
                            )

                            (setvar 'modemacro
                                (strcat "Rotacia: "
                                    (rtos (rem (+ 360.0 (* 180.0 (/ txt-rot pi))) 360) 2 2) (chr 186)
                                )
                            )
                         
                            (while
                                (progn
                                    (initget
                                        (strcat
                                            "Curve Replace rOtation Toggle Increment ROtate"
                                            (if
                                                (and
                                                    (/= "obj-blk" obj-typ)
                                                    (= "1" bor-enc)
                                                    (= "3" bor-shp)
                                                )
                                                " Border" ""
                                            )
                                            " Mirror"
                                            (if (= "obj-mtx" obj-typ) " bAckground" "")
                                        )
                                    )
                                    (setq pt (getpoint msg))
                                    (cond
                                        (   (null pt)
                                            nil
                                        )
                                        (   (listp pt)
                                            (if
                                                (null
                                                    (and table
                                                        (numinc:textincell table
                                                            (vlax-3D-point (trans pt 1 0)) (strcat pre-str mid-str suf-str)
                                                        )
                                                    )
                                                )
                                                (progn
                                                    (setq obj (create-obj pt (strcat pre-str mid-str suf-str)))
                                                    (if
                                                        (and
                                                            (/= "obj-blk" obj-typ)
                                                            (= "1" bor-enc)
                                                        )
                                                        (setq bor (create-bor obj prop))
                                                    )
                                                )
                                            )
                                            (if tog-cnt (numinc:increment symb inc-str))
                                            (princ "\n--------------------")
                                            t
                                        )
                                        (   (= "Curve" pt)
                                                  
                                            (while
                                                (setq ent
                                                    (numinc:selectif "\nVyberte krivku <exit>: "
                                                        (function
                                                            (lambda ( x )
                                                                (not
                                                                    (vl-catch-all-error-p
                                                                        (vl-catch-all-apply 'vlax-curve-getendparam (list x))
                                                                    )
                                                                )
                                                            )
                                                        )
                                                        entsel
                                                    )
                                                )
                                                (if (numinc:aligntocurve
                                                        (setq obj (create-obj (cadr ent) (strcat pre-str mid-str suf-str))) prop (car ent)
                                                        (if
                                                            (and
                                                                (/= "obj-blk" obj-typ)
                                                                (= "1" bor-enc)
                                                            )
                                                            (setq bor (create-bor obj prop))
                                                        )
                                                    )
                                                    (if tog-cnt (numinc:increment symb inc-str))
                                                    (progn
                                                        (vla-delete obj)
                                                        (if bor (vla-delete bor))
                                                    )
                                                )
                                            )
                                            t
                                        )
                                        (   (= "Replace" pt)

                                            (while (numinc:replace (strcat pre-str mid-str suf-str))
                                                (if tog-cnt
                                                    (numinc:increment symb inc-str)
                                                )
                                            )
                                            t
                                        )
                                        (   (= "rOtation" pt)
                                         
                                            (setq txt-rot
                                                (cond
                                                    (
                                                        (getangle
                                                            (strcat "\nZadajte "
                                                                (cdr
                                                                    (assoc obj-typ
                                                                       '(
                                                                            ("obj-txt" . "text")
                                                                            ("obj-mtx" . "mtext")
                                                                            ("obj-blk" . "block")
                                                                        )
                                                                    )
                                                                )
                                                                " rotaciu <" (angtos txt-rot) ">: "
                                                            )
                                                        )
                                                    )
                                                    (   txt-rot   )
                                                )
                                            )
                                            (setvar 'modemacro
                                                (strcat "Rotacia: "
                                                    (rtos
                                                        (rem
                                                            (+ 360.0 (* 180.0 (/ txt-rot pi)))
                                                            360
                                                        )
                                                        2 2
                                                    )
                                                    (chr 186)
                                                )
                                            )
                                            t
                                        )
                                        (   (= "Prepinca" pt)
                                            (if (setq tog-cnt (not tog-cnt))
                                                (princ "\n<Pocitadlo je zapnute>")
                                                (princ "\n<Pocitadlo je vypnute>")
                                            )
                                            t
                                        )
                                        (   (= "Prirastok" pt)
                                            (numinc:increment symb inc-str)
                                            t
                                        )
                                        (   (= "Okraj" pt)
                                            (princ "\n<Rotacia okraja>")
                                            (setq bor-rot (not bor-rot))
                                            t
                                        )
                                        (   (= "ROtate" pt)
                                            (setq txt-rot (rem (+ pi pi txt-rot) (+ pi pi)))
                                            (if
                                                (vl-some
                                                    (function
                                                        (lambda ( x )
                                                            (equal txt-rot x 1e-6)
                                                        )
                                                    )
                                                    (list (* pi 0.0) (* pi 0.5) (* pi 1.0) (* pi 1.5))
                                                )
                                                (setq txt-rot (rem (+ txt-rot (/ pi 2.0)) (+ pi pi)))
                                                (setq txt-rot (numinc:roundto txt-rot (/ pi 2.0)))
                                            )
                                            (princ
                                                (strcat "\n"
                                                    (setvar 'modemacro
                                                        (strcat "Rotacia: "
                                                            (rtos
                                                                (rem
                                                                    (+ 360.0 (* 180.0 (/ txt-rot pi)))
                                                                    360
                                                                )
                                                                2 2
                                                            )
                                                            (chr 186)
                                                        )
                                                    )
                                                )
                                            )
                                            t
                                        )
                                        (   (= "Zrkadlie" pt)
                                            (setq txt-rot (rem (+ pi pi (* -1.0 txt-rot)) (+ pi pi)))
                                            (princ
                                                (strcat "\n"
                                                    (setvar 'modemacro
                                                        (strcat "Rotacia: "
                                                            (rtos
                                                                (rem
                                                                    (+ 360.0 (* 180.0 (/ txt-rot pi)))
                                                                    360
                                                                )
                                                                2 2
                                                            )
                                                            (chr 186)
                                                        )
                                                    )
                                                )
                                            )
                                            t
                                        )
                                        (   (= "bAckground" pt)
                                            (if (zerop (setq mtx-bak (~ mtx-bak)))
                                                (princ "\n<Maska pozadia je vypnuta>")
                                                (princ "\n<Maska pozadia je zapnuta>")
                                            )
                                            t
                                        )
                                    )
                                )
                            )
                        )
                    )
                    (numinc:writeconfig cfgfname (mapcar 'eval (mapcar 'car symlist)))
                )
                (princ "\n*Zrusene*")
            )
        )
    )
    (if (< 0 dclid)
        (setq dclid (unload_dialog dclid))
    )
    (if
        (and
            (= 'vla-object (type numinc:wshobject))
            (not (vlax-object-released-p numinc:wshobject))
        )
        (progn
            (vlax-release-object numinc:wshobject)
            (setq numinc:wshobject nil)
        )
    )
    (mapcar 'setvar varlst vallst)
    (princ)
)

;;----------------------------------------------------------------------;;

(defun numinc:selectif ( msg pred func / ent )
    (setq pred (eval pred))
    (while
        (progn (setvar 'errno 0) (setq ent (func msg))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nChyba, skuste znovu.")
                )
                (   (= 'ename (type (car ent)))
                    (if (and pred (null (pred (car ent))))
                        (princ "\nBol vybrany neplatny objekt.")
                    )
                )
            )
        )
    )
    ent
)

;;----------------------------------------------------------------------;;

(defun numinc:replace ( str / aid enx fun obj obl par rtn sel tmp )
    (while
        (progn
            (setvar 'errno 0)
            (setq sel (nentsel "\nVyberte anotaciu, ktoru chcete nahradit <exit>: "))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nChyba, skuste znovu.")
                )
                (   (null sel)
                    (setq rtn nil)
                )
                (   (progn
                        (setq enx (entget (car  sel))
                              par (cadddr sel)
                        )
                        (cond
                            (   (= "ATTRIB" (cdr (assoc 0 enx)))
                                (setq obl (list (vlax-ename->vla-object (car sel)))
                                      fun vla-put-textstring
                                )
                            )
                            (   (and  par (wcmatch (cdr (assoc 0 (entget (car par)))) "*DIMENSION"))
                                (setq obl (list (vlax-ename->vla-object (car par)))
                                      fun vla-put-textoverride
                                )
                            )
                            (   (wcmatch  (cdr (assoc 0 enx)) "TEXT,MTEXT")
                                (setq obl (list (vlax-ename->vla-object (car sel)))
                                      fun vla-put-textstring
                                )
                            )
                            (   (= "MULTILEADER" (cdr (assoc 0 enx)))
                                (setq obl (list (vlax-ename->vla-object (car sel))))
                                (cond
                                    (   (= acblockcontent (vla-get-contenttype (car obl)))
                                        (vlax-for sub
                                            (vla-item
                                                (vla-get-blocks (numinc:acdoc))
                                                (vla-get-contentblockname (car obl))
                                            )
                                            (if (= "AcDbAttributeDefinition" (vla-get-objectname sub))
                                                (progn
                                                    (setq tmp (cons sub tmp))
                                                    (if (vlax-property-available-p sub 'objectid32)
                                                        (setq aid (cons (vla-get-objectid32 sub) aid))
                                                        (setq aid (cons (vla-get-objectid   sub) aid))
                                                    )
                                                )
                                            )
                                        )
                                        (setq tmp (reverse tmp)
                                              aid (reverse aid)
                                        )
                                        (if
                                            (or (not (cdr aid))
                                                (setq aid
                                                    (mapcar '(lambda ( n ) (nth n aid))
                                                        (numinc:listbox "Vyberte atribut(y), ktory chcete nahradit" (mapcar 'vla-get-tagstring tmp))
                                                    )
                                                )
                                            )
                                            (if (vlax-method-applicable-p (car obl) 'setblockattributevalue32)
                                                (setq fun (lambda ( obj idx str ) (vla-setblockattributevalue32 obj idx str)))
                                                (setq fun (lambda ( obj idx str ) (vla-setblockattributevalue   obj idx str)))
                                            )
                                            t
                                        )
                                    )
                                    (   (= acmtextcontent (vla-get-contenttype (car obl)))
                                        (setq fun vla-put-textstring)
                                    )
                                    (   (princ "\nVybrany multileader nema ziadnu anotaciu."))
                                )
                            )
                            (   (and par
                                    (= "INSERT" (cdr (assoc 0 (entget (last par)))))
                                    (setq obl (vlax-invoke (vlax-ename->vla-object (last par)) 'getattributes))
                                )
                                (if
                                    (or (not (cdr obl))
                                        (setq obl
                                            (mapcar '(lambda ( n ) (nth n obl))
                                                (numinc:listbox "Vyberte atribut(y), ktory chcete nahradit" (mapcar 'vla-get-tagstring obl))
                                            )
                                        )
                                    )
                                    (setq fun vla-put-textstring)
                                    t
                                )
                            )
                            (   (princ "\nBol vybrany neplatny objekt."))
                        )
                        (not (and obl fun))
                    )
                    t
                )
                (   (vl-some '(lambda ( x ) (not (vlax-write-enabled-p x))) obl)
                    (if (cdr obl)
                        (princ "\nJeden alebo viacero vybranych objektov je na uzamknutej vrstve alebo je chraneny proti zapisu.")
                        (princ "\nVybrany objekt je na uzamknutej vrstve alebo je chraneny proti zapisu.")
                    )
                )
                (   (setq rtn t)
                    (if aid
                        (foreach idx aid (fun (car obl) idx str))
                        (foreach obj obl (fun obj str))
                    )
                    (if par (entupd (last par)))
                    nil
                )
            )
        )
    )
    rtn
)

;;----------------------------------------------------------------------;;

(defun numinc:annotative-p ( sty )
    (and
        (setq sty (tblobjname "style" sty))
        (setq sty (cadr (assoc -3 (entget sty '("AcadAnnotative")))))
        (= 1 (cdr (assoc 1070 (reverse sty))))
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:getblockdata ( / a b c )
    (while (setq a (tblnext "block" (null a)))
        (if
            (and
                (null (wcmatch (cdr (assoc 02 a)) "`**,*|*"))
                (= 2 (logand 2 (cdr (assoc 70 a))))
                (setq c
                    (
                        (lambda ( c / d e )
                            (while (setq c (entnext c))
                                (if (= "ATTDEF" (cdr (assoc 0 (setq d (entget c)))))
                                    (setq e (cons (strcase (cdr (assoc 2 d))) e))
                                )
                            )
                            (vl-sort e '<)
                        )
                        (tblobjname "block" (cdr (assoc 2 a)))
                    )
                )
            )
            (setq b (cons (cons (cdr (assoc 2 a)) c) b))
        )
    )
    (vl-sort b '(lambda ( a b ) (< (car a) (car b))))
)

;;----------------------------------------------------------------------;;

(defun numinc:gettableitems ( table / a b )
    (while (setq a (tblnext table (null a)))
        (if
            (not
                (or (wcmatch (cdr (assoc 2 a)) "`**,*|*")
                    (and (= "layer" (strcase table t))
                         (= 4 (logand 4 (cdr (assoc 70 a))))
                    )
                )
            )
            (setq b (cons (cdr (assoc 2 a)) b))
        )
    )
    (acad_strlsort b)
)

;;----------------------------------------------------------------------;;

(defun numinc:roundto ( a b )
    (* b (fix (/ (+ a (* b (if (minusp a) -0.5 0.5))) b)))
)

;;----------------------------------------------------------------------;;

(defun numinc:listbox ( msg lst / rtn )
    (cond
        (   (or (null dclid) (not (new_dialog "listbox" dclid)))
            (numinc:popup "Dialogove okno sa nepodarilo nacitat" 16
                (princ
                    (strcat
                        "Nepodarilo sa nacitat dialogove okno so zoznamom sady prirastkovych cisel. "
                        "Subor DCL pozadovany aplikaciou sa nachadza v nasledujucom umiestneni:\n\n"
                        dclfname
                        "\n\nSkontrolujte integritu tohto suboru."
                    )
                )
            )
            (princ)
        )
        (   t
            (set_tile "dcl" msg)

            (start_list "lst")
            (foreach itm lst (add_list itm))
            (end_list)

            (setq rtn (set_tile "lst" "0"))
            (action_tile "lst"  "(setq rtn $value)")
         
            (setq rtn
                (if (= 1 (start_dialog))
                    (read (strcat "(" rtn ")"))
                )
            )
        )
    )
    rtn
)

;;----------------------------------------------------------------------;;

(defun numinc:about ( id / _dialogtext _displaybitmap i j x y )

    (defun _dialogtext ( key str )
        (set_tile key str)
        (start_image key)
        (vector_image 0 (1- (dimy_tile key)) (dimx_tile key) (1- (dimy_tile key)) 0)
        (end_image)
    )

    (cond
        (   (not (new_dialog "about" id))
            (numinc:popup "Dialogove okno sa nepodarilo nacitat" 16
                (princ
                    (strcat
                        "Dialogove okno ReNumber sa nepodarilo nacitat "
                        "Subor DCL pozadovany aplikaciou sa nachadza v nasledujucom umiestneni:\n\n"
                        dclfname
                        "\n\nSkontrolujte integritu tohto suboru."
                    )
                )
            )
            (princ)
        )
        (   t
            (repeat (setq i 32)
                (setq j 1)
                (repeat 32
                    (setq x (cons j x)
                          y (cons i y)
                          j (1+ j)
                    )
                )
                (setq i (1- i))
            )
            (foreach pair
               '(
                    ;("title1" "Incremental Numbering Suite")
                    ("title2" "Ovladanie umiestnenia")
                    ("title3" "Ovladacie prvky zarovnania kriviek")
                )
                (apply '_dialogtext pair)
            )

            (setq _displaybitmap
                (eval
                    (list 'lambda '( key lst )
                       '(start_image key)
                       '(fill_image 0 0 (dimx_tile key) (dimy_tile key) -15)
                        (list 'mapcar ''vector_image (quote x) (quote y) (quote x) (quote y) 'lst)
                       '(end_image)
                    )
                )
            )

            (_displaybitmap "info1"
               '(
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15 008 -15 008 -15 008 -15 008 -15 008 -15 008 -15 008 -15 008 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 -15 008 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 008 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 009 008 -15 008 -15 008 -15 008 -15 008 -15 008 -15 008 -15 008 -15 008 -15 254 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 009 253 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 254 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 253 254 253 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 253 254 -15 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 253 254 254 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 253 009 254 009 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 253 253 254 009 009 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 253 253 254 009 009 009 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 253 253 254 254 254 254 009 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 253 253 254 254 254 254 254 254 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 253 253 254 254 254 254 254 254 254 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 252 252 252 252 008 254 254 254 254 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 254 009 009 253 253 254 009 252 254 254 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 254 254 252 009 254 252 252 252 009 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 254 252 254 254 252 009 252 252 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 253 253 254 253 009 254 254 252 252 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 008 254 254 252 254 -15 -15 254 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 253 252 252 253 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 254 254 009 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                )
            )

            (_displaybitmap "info2"
               '(
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 251 251 251 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 251 251 251 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 251 251 251 253 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 009 252 008 253 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 254 252 008 253 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 254 252 008 253 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 254 252 008 253 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 254 009 009 151 151 151 151 151 151 009 009 252 251 251 251 008 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 254 009 143 143 153 153 145 145 145 145 145 153 153 143 251 252 254 254 252 008 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 254 143 143 153 145 145 153 153 253 009 009 009 253 253 153 145 251 254 009 009 254 251 -15 -15 -15 -15 -15 -15 -15 -15
                    -15 143 153 135 145 153 253 009 009 254 254 254 254 254 254 254 009 009 251 254 009 009 254 251 254 -15 -15 -15 -15 -15 -15 -15
                    -15 135 135 153 253 009 254 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 251 252 254 254 252 251 253 -15 -15 -15 -15 -15 -15 -15
                    254 135 253 009 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 251 251 251 251 252 008 253 -15 -15 -15 -15 -15 -15
                    -15 254 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 254 253 153 143 009 252 008 253 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 153 153 143 009 252 008 253 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 009 135 143 254 254 252 008 253 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 145 143 254 254 254 252 251 251 251 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 153 153 009 -15 254 254 251 251 251 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 143 153 143 -15 -15 254 251 251 251 254
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 253 153 143 -15 -15 -15 254 009 254 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 009 135 143 -15 -15 -15 -15 254 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 153 153 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 135 153 254 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 135 153 254 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 135 153 254 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 135 153 254 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 135 153 254 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 135 153 254 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 135 153 254 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 135 135 254 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 254 -15 -15 -15 -15 -15 -15 -15
                    -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                )
            )

            (start_image "title1")
            (fill_image 0 0 (dimx_tile "title1") (dimy_tile "title1") -15)
            (foreach l
               '(
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 163 163 163 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 176 176 175 -15
                        -15 163 175 176 176 176 166 165 009 -15 -15 -15 -15 175 175 175 -15 -15 -15 -15 -15 165 175 175 163 -15 -15 -15 176 176 175 -15
                        166 176 176 175 175 177 176 176 176 163 -15 -15 -15 175 176 175 -15 -15 -15 -15 253 166 176 176 163 -15 -15 -15 176 176 175 -15
                        166 253 -15 -15 -15 -15 254 175 176 176 253 -15 -15 175 176 175 -15 -15 -15 253 176 176 176 176 163 -15 -15 -15 176 176 175 -15
                        254 -15 -15 -15 -15 -15 -15 -15 175 176 166 -15 -15 175 176 175 -15 -15 165 176 176 165 176 176 163 -15 -15 -15 176 176 175 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 163 176 176 -15 -15 175 176 175 -15 165 176 176 163 -15 176 176 163 -15 -15 -15 176 176 175 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 165 176 166 -15 -15 175 176 177 177 176 176 253 -15 -15 176 176 163 -15 -15 -15 176 176 175 -15
                        177 254 -15 -15 -15 -15 -15 163 176 176 163 -15 -15 175 176 176 176 166 253 -15 -15 -15 176 176 163 -15 -15 -15 176 176 175 -15
                        176 176 175 163 163 163 166 176 176 177 -15 -15 -15 175 176 176 166 254 -15 -15 -15 -15 176 176 163 -15 -15 -15 176 176 175 -15
                        009 175 176 176 176 176 176 166 163 -15 -15 -15 -15 166 176 176 253 -15 -15 -15 -15 254 176 176 175 -15 -15 254 176 176 166 -15
                        -15 -15 -15 009 009 009 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        175 175 175 163 -15 -15 166 175 175 175 175 175 175 175 175 175 -15 -15 -15 253 175 175 175 175 175 175 175 175 175 254 -15 -15
                        176 176 176 163 -15 -15 166 175 175 175 175 175 175 166 176 175 -15 -15 163 176 176 177 175 175 175 175 166 176 176 -15 -15 163
                        176 176 176 163 -15 -15 -15 -15 -15 -15 -15 -15 -15 175 176 175 -15 -15 176 176 163 -15 -15 -15 -15 -15 163 176 176 -15 -15 253
                        177 176 176 163 -15 -15 -15 -15 253 009 009 009 009 177 176 175 -15 -15 166 176 177 253 009 009 009 009 165 176 176 -15 -15 -15
                        254 176 176 163 -15 -15 -15 -15 175 176 176 176 176 176 176 175 -15 -15 254 166 176 176 176 176 176 176 176 176 176 -15 -15 -15
                        -15 176 176 163 -15 -15 -15 -15 253 009 009 009 009 177 176 175 -15 -15 -15 -15 253 176 176 177 009 009 165 176 176 -15 -15 -15
                        -15 176 176 163 -15 -15 -15 -15 -15 -15 -15 -15 -15 175 176 175 -15 -15 -15 254 166 176 166 -15 -15 -15 163 176 176 -15 -15 254
                        -15 176 176 163 -15 009 163 163 163 163 163 163 163 166 176 175 -15 -15 -15 166 176 166 254 -15 -15 -15 163 176 176 -15 -15 175
                        254 176 176 175 -15 009 176 176 176 176 176 176 176 176 176 166 -15 009 166 176 176 165 -15 -15 -15 -15 175 176 176 254 -15 -15
                        -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 165 175 175 163 -15 -15 166 175 175 175 175 175 175 175 175 175 -15 -15 253 175 175 175 254 -15 -15 -15 -15 254
                        -15 -15 -15 253 166 176 176 163 -15 -15 166 175 175 175 175 175 175 166 176 175 -15 -15 009 176 176 176 009 -15 -15 -15 -15 009
                        -15 -15 253 176 176 176 176 163 -15 -15 -15 -15 -15 -15 -15 -15 -15 175 176 175 -15 -15 009 176 176 176 166 -15 -15 -15 -15 166
                        -15 165 176 176 165 176 176 163 -15 -15 -15 -15 253 009 009 009 009 177 176 175 -15 -15 009 176 176 177 176 163 -15 -15 163 176
                        165 176 176 163 -15 176 176 163 -15 -15 -15 -15 175 176 176 176 176 176 176 175 -15 -15 009 176 176 253 166 176 009 009 176 176
                        176 176 253 -15 -15 176 176 163 -15 -15 -15 -15 253 009 009 009 009 177 176 175 -15 -15 009 176 176 009 009 176 166 166 176 163
                        166 253 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 -15 -15 -15 -15 175 176 175 -15 -15 009 176 176 009 -15 163 176 176 177 -15
                        254 -15 -15 -15 -15 176 176 163 -15 009 163 163 163 163 163 163 163 166 176 175 -15 -15 009 176 176 009 -15 -15 166 176 254 -15
                        -15 -15 -15 -15 254 176 176 175 -15 009 176 176 176 176 176 176 176 176 176 166 -15 -15 163 176 176 163 -15 -15 009 163 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        175 175 254 -15 -15 -15 -15 -15 253 175 175 175 -15 -15 -15 -15 166 175 175 175 175 175 175 175 175 175 163 -15 175 175 175 -15
                        176 176 -15 -15 -15 -15 -15 -15 163 176 176 166 -15 -15 -15 -15 166 175 175 175 176 176 166 175 175 175 163 -15 175 176 175 -15
                        176 176 -15 -15 -15 -15 -15 -15 166 176 176 176 163 -15 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 175 176 175 -15
                        176 176 -15 -15 -15 -15 -15 175 176 176 163 176 166 254 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 175 176 175 -15
                        176 176 -15 -15 -15 -15 009 176 176 165 -15 165 176 175 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 175 176 175 -15
                        176 176 -15 -15 -15 -15 166 176 176 163 163 163 176 176 009 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 175 176 177 177
                        176 176 -15 -15 -15 163 176 176 177 175 175 175 177 176 166 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 175 176 176 176
                        176 176 -15 -15 254 176 176 175 -15 -15 -15 -15 -15 177 176 163 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 175 176 176 166
                        176 176 254 254 177 176 176 165 -15 -15 -15 -15 -15 175 176 166 009 -15 -15 254 176 176 175 -15 -15 -15 -15 -15 166 176 176 253
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 253 163 163 163 -15 -15 -15 -15 -15 -15 253 163 163 163 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 009 176 176 163 -15 -15 -15 -15 -15 -15 175 176 176 176 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        175 163 -15 -15 009 176 176 163 -15 -15 -15 -15 -15 177 176 176 176 176 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 163 -15 -15 009 176 176 163 -15 -15 -15 254 177 176 176 176 176 176 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 163 -15 -15 009 176 176 163 -15 -15 254 166 176 176 163 175 176 176 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 163 -15 -15 009 176 176 163 -15 009 166 176 176 253 -15 175 176 176 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 163 -15 -15 009 176 176 163 253 176 176 166 009 -15 -15 175 176 176 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 163 -15 -15 009 176 176 177 176 176 166 254 -15 -15 -15 175 176 176 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 163 -15 -15 009 176 176 176 176 177 254 -15 -15 -15 -15 175 176 176 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 254 -15 -15 009 176 176 176 177 -15 -15 -15 -15 -15 -15 175 176 176 -15 -15 -15 -15 -15 -15 163 163 163 163 163 163 163 175
                        253 -15 -15 -15 163 176 176 176 -15 -15 -15 -15 -15 -15 -15 166 176 176 254 -15 -15 -15 -15 -15 163 176 176 176 176 176 176 176
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        175 175 175 175 163 -15 -15 163 175 175 175 -15 -15 -15 -15 -15 253 175 175 175 253 -15 -15 175 175 175 -15 -15 -15 -15 254 175
                        175 175 176 176 163 -15 -15 163 176 176 166 -15 -15 -15 -15 -15 163 176 176 176 009 -15 -15 175 176 175 -15 -15 -15 -15 -15 176
                        -15 -15 176 176 163 -15 -15 163 176 176 176 175 -15 -15 -15 254 176 176 176 176 009 -15 -15 175 176 175 -15 -15 -15 -15 -15 176
                        163 163 176 176 163 -15 -15 163 176 176 177 176 253 -15 -15 177 176 177 176 176 009 -15 -15 175 176 175 -15 -15 -15 -15 -15 176
                        176 176 176 176 163 -15 -15 163 176 176 254 176 166 -15 163 176 166 253 176 176 009 -15 -15 175 176 175 -15 -15 -15 -15 -15 176
                        -15 -15 176 176 163 -15 -15 163 176 176 -15 163 176 177 176 176 009 009 176 176 009 -15 -15 175 176 175 -15 -15 -15 -15 -15 176
                        -15 -15 176 176 163 -15 -15 163 176 176 -15 -15 177 176 176 163 -15 009 176 176 009 -15 -15 175 176 166 -15 -15 -15 -15 009 176
                        163 163 176 176 163 -15 -15 163 176 176 -15 -15 254 176 166 -15 -15 009 176 176 009 -15 -15 253 176 176 166 163 163 165 166 176
                        176 176 176 176 175 -15 -15 175 176 176 254 -15 -15 163 009 -15 -15 163 176 176 163 -15 -15 -15 163 166 176 176 176 176 176 177
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 009 009 009 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 009 165 175 175 175 175 175 175 175 175 253 -15 009 177 175 175 175 175 175 175 175 175 163 -15 -15 -15 163 175 175 175 175
                        253 176 176 166 175 175 175 175 177 176 176 009 -15 009 177 175 175 175 175 175 175 176 176 163 -15 -15 175 176 176 175 175 175
                        175 176 177 -15 -15 -15 -15 -15 009 176 176 009 -15 -15 -15 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 176 176 163 -15 -15 -15
                        165 176 166 253 009 009 009 009 163 176 176 009 -15 -15 -15 -15 163 009 009 009 009 176 176 163 -15 -15 165 176 166 163 163 163
                        -15 175 176 176 176 176 176 176 176 176 176 009 -15 -15 -15 -15 176 176 176 176 176 176 176 163 -15 -15 009 166 176 176 176 176
                        -15 -15 254 166 176 166 253 009 163 176 176 009 -15 -15 -15 -15 163 009 009 009 009 176 176 163 -15 254 176 176 165 -15 -15 -15
                        -15 -15 177 176 176 254 -15 -15 009 176 176 009 -15 -15 -15 -15 -15 -15 -15 -15 -15 176 176 163 -15 009 176 176 253 -15 -15 -15
                        -15 175 176 176 253 -15 -15 -15 009 176 176 009 -15 163 163 163 163 163 163 163 163 176 176 163 -15 -15 166 176 166 163 163 163
                        175 176 176 177 -15 -15 -15 -15 163 176 176 163 -15 163 176 176 176 176 176 176 176 176 176 175 -15 -15 254 165 166 176 176 176
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        009 163 175 166 176 176 177 165 254 -15 -15 -15 -15 175 175 175 -15 -15 -15 -15 -15 165 175 175 163 -15 -15 163 175 175 254 -15
                        175 176 176 177 175 175 176 176 176 253 -15 -15 -15 175 176 175 -15 -15 -15 -15 253 166 176 176 163 -15 -15 163 176 176 -15 -15
                        254 165 254 -15 -15 -15 -15 165 176 176 253 -15 -15 175 176 175 -15 -15 -15 253 176 176 176 176 163 -15 -15 163 176 176 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 175 176 177 -15 -15 175 176 175 -15 -15 165 176 176 165 176 176 163 -15 -15 163 176 176 -15 -15
                        175 175 175 175 175 -15 -15 -15 163 176 176 -15 -15 175 176 175 -15 165 176 176 163 -15 176 176 163 -15 -15 163 176 176 -15 -15
                        176 166 175 175 175 -15 -15 -15 165 176 166 -15 -15 175 176 177 177 176 176 253 -15 -15 176 176 163 -15 -15 163 176 176 -15 -15
                        176 163 -15 -15 -15 -15 -15 253 176 176 163 -15 -15 175 176 176 176 166 253 -15 -15 -15 176 176 163 -15 -15 163 176 176 -15 -15
                        176 176 175 163 163 163 177 176 176 177 -15 -15 -15 175 176 176 166 254 -15 -15 -15 -15 176 176 163 -15 -15 163 176 176 -15 -15
                        253 175 176 176 176 176 176 166 163 -15 -15 -15 -15 166 176 176 253 -15 -15 -15 -15 254 176 176 175 -15 -15 175 176 176 254 254
                        -15 -15 -15 254 009 009 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 163 165 175 175 175 163 009 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 165 166 176 176 176 176 176 176 176 176 175 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        175 175 254 -15 -15 -15 -15 175 175 175 -15 -15 009 176 166 163 254 -15 -15 254 163 176 176 163 -15 -15 -15 -15 -15 -15 -15 -15
                        176 176 -15 -15 -15 -15 -15 175 176 175 -15 -15 -15 163 -15 -15 -15 -15 -15 -15 -15 176 176 175 -15 -15 -15 -15 -15 -15 -15 -15
                        176 176 -15 -15 -15 -15 -15 175 176 175 -15 -15 -15 -15 -15 009 163 163 163 175 166 176 176 165 -15 -15 -15 -15 -15 -15 -15 -15
                        176 176 -15 -15 -15 -15 -15 175 176 175 -15 -15 -15 165 176 176 176 176 176 176 176 176 177 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        176 176 -15 -15 -15 -15 -15 175 176 175 -15 -15 165 176 176 176 166 175 175 163 163 009 -15 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 176 -15 -15 -15 -15 -15 175 176 175 -15 -15 176 176 166 254 -15 -15 -15 -15 -15 -15 254 -15 -15 -15 -15 -15 -15 -15 -15 163
                        176 176 009 -15 -15 -15 -15 166 176 175 -15 -15 166 176 166 -15 -15 -15 -15 -15 -15 009 177 253 -15 -15 -15 -15 -15 -15 -15 163
                        176 176 166 165 163 163 166 176 176 253 -15 -15 253 176 176 166 165 163 163 165 166 176 176 166 -15 -15 -15 -15 -15 -15 -15 175
                        253 177 176 176 176 176 176 166 163 -15 -15 -15 -15 009 175 176 176 176 176 176 176 175 163 254 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 009 009 009 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 254 009 009 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                    (
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 166 175 175 175 175 175 175 175 175 175 -15 -15 166 175 175 175 175 175 175 175 175 175 163 254 175 175 163 -15 -15 163
                        -15 -15 166 175 175 175 175 175 175 166 176 175 -15 -15 166 175 175 175 176 176 166 175 175 175 163 -15 176 176 163 -15 -15 163
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 175 176 175 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 176 176 163 -15 -15 163
                        -15 -15 -15 -15 253 009 009 009 009 177 176 175 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 176 176 163 -15 -15 163
                        -15 -15 -15 -15 175 176 176 176 176 176 176 175 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 176 176 163 -15 -15 163
                        -15 -15 -15 -15 253 009 009 009 009 177 176 175 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 176 176 163 -15 -15 163
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 175 176 175 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 176 176 163 -15 -15 163
                        -15 009 163 163 163 163 163 163 163 166 176 175 -15 -15 -15 -15 -15 -15 176 176 163 -15 -15 -15 -15 -15 176 176 163 -15 -15 254
                        -15 009 176 176 176 176 176 176 176 176 176 166 -15 -15 -15 -15 -15 254 176 176 175 -15 -15 -15 -15 254 176 176 175 -15 -15 -15
                        -15 254 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                        -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                    )
                )                
                (mapcar 'vector_image x y x y l)
                (setq x (mapcar '(lambda ( a ) (+ a 32)) x))
            )
            (end_image)
            (start_dialog)
        )
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:fixdir ( dir )
    (vl-string-right-trim "\\" (vl-string-translate "/" "\\" dir))
)

;;----------------------------------------------------------------------;;

(defun numinc:getsavepath ( / tmp )
    (cond      
        (   (setq tmp (getvar 'roamablerootprefix))
            (strcat (numinc:fixdir tmp) "\\Support")
        )
        (   (setq tmp (findfile "acad.pat"))
            (numinc:fixdir (vl-filename-directory tmp))
        )
        (   (numinc:fixdir (vl-filename-directory (vl-filename-mktemp))))
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:writedcl ( dcl / file )
    (cond
        (   (findfile dcl))
        (   (setq file (open dcl "w"))
            (foreach line
               '(
                    "//------------=={ Incremental Numbering Suite }==-------------//"
                    "//                                                            //"
                    "//  NumInc.dcl dialog definition file to be used in           //"
                    "//  conjunction with NumInc.lsp                               //"
                    "//------------------------------------------------------------//"
                    "//  Author: Lee Mac, Copyright © 2014 - www.lee-mac.com       //"
                    "//------------------------------------------------------------//"
                    ""
                    "//  --=={ Sub-Assembly Definitions }==--"
                    ""
                    "edit : edit_box"
                    "{"
                    "    edit_width = 5.0;"
                    "    alignment = centered;"
                    "    fixed_width = true;"
                    "    allow_accept = true;"
                    "}"
                    ""
                    "but1 : button"
                    "{"
                    "    width = 12.0;"
                    "    fixed_width = true;"
                    "    alignment = centered;"
                    "}"
                    ""
                    "but2 : button"
                    "{"
                    "    width = 19.5;"
                    "    fixed_width = true;"
                    "    alignment = centered;"
                    "}"
                    ""
                    "but3 : button"
                    "{"
                    "    width = 15.0;"
                    "    fixed_width = true;"
                    "    alignment = centered;"
                    "    fixed_height = true;"
                    "    height = 2.2;"
                    "}"
                    ""
                    "rad1 : radio_button"
                    "{"
                    "    alignment = centered;"
                    "}"
                    ""
                    "txt1 : text"
                    "{"
                    "    alignment = centered;"
                    "    fixed_width = false;"
                    "}"
                    ""
                    "txt2 : text"
                    "{"
                    "    alignment = centered;"
                    "    fixed_width = true;"
                    "    width = 8.8;"
                    "}"
                    ""
                    "txt3 : text"
                    "{"
                    "    alignment = left;"
                    "    fixed_width = false;"
                    "}"
                    ""
                    "btxt : image"
                    "{"
                    "    fixed_width = true;"
                    "    height = 1.2;"
                    "    fixed_height = true;"
                    "    color = dialog_background;"
                    "}"
                    ""
                    "ctxt : text"
                    "{"
                    "    width = 30;"
                    "    fixed_width = true;"
                    "    alignment = centered;"
                    "}"
                    ""
                    "pop1 : popup_list"
                    "{"
                    "    width = 31;"
                    "    fixed_width = true;"
                    "}"
                    ""
                    "spc1 : spacer"
                    "{"
                    "    height = 0.1;"
                    "    fixed_height = true;"
                    "    width = 0.1;"
                    "    fixed_width = true;"
                    "}"
                    ""
                    "imgbox : image_button"
                    "{"
                    "    alignment = centered;"
                    "    height = 1.5;"
                    "    aspect_ratio = 1;"
                    "    fixed_width = true;"
                    "    fixed_height = true;"
                    "    color = 1;"
                    "}"
                    ""
                    "img20b : image_button"
                    "{"
                    "    fixed_width = true;"
                    "    fixed_height = true; "
                    "    width = 3.5;"
                    "    aspect_ratio = 1.0; "
                    "}"
                    ""
                    "img32 : image"
                    "{"
                    "    fixed_width = true;"
                    "    fixed_height = true;"
                    "    width = 5.5;"
                    "    aspect_ratio = 1.0;"
                    "}"
                    ""
                    "img320 : image"
                    "{"
                    "    fixed_width = true;"
                    "    fixed_height = true;"
                    "    width = 53.5;"
                    "    aspect_ratio = 0.1;"
                    "}"
                    ""
                    "//pick : button"
                    "//{"
                    "//    label = \">>\";"
                    "//    fixed_width = true;"
                    "//    fixed_height = true;"
                    "//    alignment = left;"
                    "//}"
                    ""
                    "listbox : dialog"
                    "{"
                    "    key = \"dcl\";"
                    "    spacer;"
                    "    : list_box"
                    "    {"
                    "        key = \"lst\";"
                    "        multiple_select = true;"
                    "        width = 50;"
                    "        height = 15;"
                    "        fixed_width = true;"
                    "        fixed_height = true;"
                    "    }"
                    "    spacer;"
                    "    ok_cancel;"
                    "}"
                    ""
                    "//------------------------------------------------------------//"
                    "//                    Main Dialog Definition                  //"
                    "//------------------------------------------------------------//"
                    ""
                    "numinc : dialog"
                    "{"
                    "    key = \"dcl\";"
                    "    initial_focus = \"pre-str\";"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        : column"
                    "        {"
                    "            : toggle"
                    "            {"
                    "                alignment = left;"
                    "                key = \"dyn-flg\";"
                    "                label = \"Text nasleduje kurzor\";"
                    "            }"
                    "        }"
                    "        : column"
                    "        {"
                    "            : text"
                    "            {"
                    "                label = \"Lee Mac, prelozil Jakub Tomecko\";"
                    "                key = \"aut\";"
                    "                alignment = right;"
                    "            }"
                    "        }"
                    "    }"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        : column"
                    "        {"
                    "            : boxed_column"
                    "            {"
                    "                label = \"ReNumber format\";"
                    "                width = 37;"
                    "                fixed_width = true;"
                    "                : row"
                    "                {"
                    "                    alignment = centered;"
                    "                    fixed_width = true;"
                    "                    : column"
                    "                    {"
                    "                        : edit { key =  \"pre-str\"; }"
                    "                        : txt2 { label = \"Prefix\"; }"
                    "                    }"
                    "                    : column"
                    "                    {"
                    "                        : edit { key =  \"mid-str\"; }"
                    "                        : txt2 { label = \"Cislo\"; }"
                    "                    }"
                    "                    : column"
                    "                    {"
                    "                        : edit { key =  \"suf-str\"; }"
                    "                        : txt2 { label = \"Suffix\"; }"
                    "                    }"
                    "                }       "
                    "                spacer;"
                    "                : edit { label = \"Krok prirastku: \"; key = \"inc-str\"; }"
                    "                spacer;"
                    "                : boxed_column"
                    "                {"
                    "                    label = \"Sekcia prirastku\";"
                    "                    : row"
                    "                    {"
                    "                        alignment = centered;"
                    "                        fixed_width = true;"
                    "                        : toggle { label = \"Prefix\"; key = \"inc-pre\"; }"
                    "                        : toggle { label = \"Cislo\"; key = \"inc-mid\"; }"
                    "                        : toggle { label = \"Suffix\"; key = \"inc-suf\"; }"
                    "                    }"
                    "                    spacer;"
                    "                }"
                    "                spacer;"
                    "            }"
                    "            : boxed_column"
                    "            {"
                    "                label = \"Nastavenie okraja\";"
                    "                spacer;"
                    "                : toggle { key = \"bor-enc\"; label = \"Text ohranicit: \"; }"
                    "                : row"
                    "                {"
                    "                    : popup_list { key = \"bor-shp\"; width = 18; fixed_width = true;  }"
                    "                    : column"
                    "                    {"
                    "                        spc1;"
                    "                        : edit_box"
                    "                        {"
                    "                            edit_width = 5;"
                    "                            fixed_width = true;"
                    "                            key = \"bor-sid\";"
                    "                            label = \"Strany:\";"
                    "                            allow_accept = true;"
                    "                        }"
                    "                        spc1;"
                    "                    }"
                    "                }"
                    "                : text { label = \"Hladina: \"; key = \"bor-ltx\"; }"
                    "                : popup_list { key = \"bor-lay\"; }"
                    "                spacer;"
                    "                : boxed_column"
                    "                {"
                    "                    label = \"Velkost okraja\";"
                    "                    : row"
                    "                    {"
                    "                        fixed_width = true;"
                    "                        alignment = centered;"
                    "                        : radio_column"
                    "                        {"
                    "                            : radio_button { key = \"bor-off\"; label = \"  Offset:\"; }"
                    "                            : radio_button { key = \"bor-fix\"; label = \"   Fixed:\"; }"
                    "                        }"
                    "                        : column"
                    "                        {"
                    "                            : edit { key = \"off-ed1\" ; }"
                    "                            : edit { key = \"fix-ed1\" ; }"
                    "                        }"
                    "                        : column"
                    "                        {"
                    "                            fixed_width = true;"
                    "                            spacer_1;"
                    "                            : text { label = \" x\"; key = \"fix-txt\"; }"
                    "                        }"
                    "                        : column"
                    "                        {"
                    "                            spacer_1;"
                    "                            : edit { key = \"fix-ed2\"; }"
                    "                        }"
                    "                    }"
                    "                    : row"
                    "                    {"
                    "                        fixed_width = true;"
                    "                        alignment = centered;"
                    "                        : spacer"
                    "                        {"
                    "                            height = 0.1;"
                    "                            fixed_height = true;"
                    "                            width = 11;"
                    "                            fixed_width = true;"
                    "                        }"
                    "                        : but2 { key = \"bor-pik\"; label = \">>\"; }"
                    "                    }"
                    "                    spacer;"
                    "                }"
                    "                spacer;"
                    "            }"
                    "        }"
                    "        : column"
                    "        {"
                    "            alignment = top;"
                    "            : boxed_column"
                    "            {"
                    "                label = \"Objekt\";"
                    "                width = 37;"
                    "                fixed_width = true;"
                    "                fixed_height = true;"
                    "                : radio_row"
                    "                {"
                    "                    alignment = centered;"
                    "                    fixed_width = true;"
                    "                    : rad1 { label = \"Text\";  key = \"obj-txt\"; }"
                    "                    : rad1 { label = \"MText\"; key = \"obj-mtx\"; }"
                    "                    : rad1 { label = \"Block\"; key = \"obj-blk\"; }"
                    "                }"
                    "                : text { label = \"Block:\"; key = \"blk-txt\"; }"
                    "                : row"
                    "                {"
                    "                    fixed_width = true;"
                    "                    : pop1 { key = \"blk-nme\"; }"
                    "                    //: pick { key = \"blk-pik\"; }"
                    "                    : column"
                    "                    {"
                    "                        spc1;"
                    "                        : img20b { key = \"blk-pik\"; alignment = top; }"
                    "                    }"
                    "                }"
                    "                spacer;"
                    "                : text { label = \"Atribut:\"; key = \"att-txt\"; }"
                    "                : popup_list { key = \"att-nme\"; }"
                    "                spacer;"
                    "                : boxed_column"
                    "                {"
                    "                    label = \"Mierka blocku\";"
                    "                    : row"
                    "                    {"
                    "                        fixed_width = true; alignment = centered;"
                    "                        : edit { label = \"Mierka:\"; key = \"blk-scl\"; }"
                    "                        : column"
                    "                        {"
                    "                            spc1;"
                    "                            : img20b { key = \"scl-pik\"; alignment = top; }"
                    "                        }"
                    "                        //: pick { key = \"scl-pik\"; }"
                    "                    }"
                    "                    spacer;"
                    "                    : toggle { key = \"scl-var\"; label = \"Pouzit systemovu premennu:\"; }"
                    "                    : popup_list { key = \"scl-pop\"; }"
                    "                    spacer;"
                    "                }"
                    "                spacer;"
                    "            }"
                    "            : boxed_column"
                    "            {"
                    "                label = \"Nastavenie pola\";"
                    "                width = 37;"
                    "                fixed_width = true;"
                    "                : row"
                    "                {"
                    "                    fixed_width = true;"
                    "                    : toggle { label = \"Vytvorenie pola\"; key = \"arr-use\"; }"
                    "                    : edit { label = \"Polozky:\"; key = \"arr-qty\"; }"
                    "                }"
                    "                spacer;"
                    "                : boxed_column"
                    "                {"
                    "                    label = \"Rotacia objektu\";"
                    "                    : row"
                    "                    {"
                    "                        : radio_button { key = \"arr-aln\"; label = \"Zarovnane\"; }"
                    "                        : radio_button { key = \"arr-per\"; label = \"Kolmy\"; }"
                    "                    }"
                    "                    : row"
                    "                    {"
                    "                        fixed_width = true;"
                    "                        : radio_button { key = \"arr-oth\"; label = \"Ostatne:\"; }"
                    "                        : edit { key = \"arr-rot\"; }"
                    "                        : column"
                    "                        {"
                    "                            spc1;"
                    "                            : img20b { key = \"arr-pik\"; alignment = top; }"
                    "                        }"
                    "                        //: pick { key = \"arr-pik\"; }"
                    "                    }"
                    "                    spacer;"
                    "                }"
                    "                spacer;"
                    "            }"
                    "        }"
                    "        : column"
                    "        { "
                    "            : boxed_column"
                    "            {"
                    "                label = \"Formatovanie\";"
                    "                : text { label = \"Hladina textu: \"; key = \"lay-txt\"; }"
                    "                : popup_list { key = \"txt-lay\"; }"
                    "                spacer;"
                    "                : text { label = \"Styl textu \"; key = \"sty-txt\"; }"
                    "                : popup_list { key = \"txt-sty\"; }"
                    "                spacer;"
                    "                : text { label = \"Zarovnanie textu:\"; key = \"aln-txt\"; }"
                    "                : popup_list { key = \"txt-aln\"; }"
                    "                spacer;"
                    "                : boxed_column"
                    "                {"
                    "                    label = \"Vyska textu\";"
                    "                    : row"
                    "                    {"
                    "                        fixed_width = true;"
                    "                        alignment = centered;"
                    "                        : toggle { key = \"txt-bst\"; label = \"Podla stylu\"; }"
                    "                        : edit { key = \"txt-sze\"; }"
                    "                        : column"
                    "                        {"
                    "                            spc1;"
                    "                            : img20b { key = \"txt-pik\"; alignment = top; }"
                    "                        }"
                    "                        //: pick { key = \"txt-pik\"; }"
                    "                    }"
                    "                    spacer;"
                    "                }"
                    "                spacer;"
                    "                : boxed_column"
                    "                {"
                    "                    label = \"Maska pozadia\";"
                    "                    width = 37;"
                    "                    fixed_width = true;"
                    "                    fixed_height = true;"
                    "                    : toggle { label = \"Pozit masku pozadia\"; key = \"msk-use\"; }"
                    "                    spacer;"
                    "                    : boxed_column"
                    "                    {"
                    "                        label = \"Odsadenia masky\";"
                    "                        : row"
                    "                        {"
                    "                            alignment = centered;"
                    "                            fixed_width = true;"
                    "                            : edit { label = \"Faktor odsadenia:\"; key = \"msk-off\"; }"
                    "                            : column"
                    "                            {"
                    "                                spc1;"
                    "                                : img20b { key = \"msk-pik\"; alignment = top; }"
                    "                            }"
                    "                            //: pick { key = \"msk-pik\"; }"
                    "                        }"
                    "                        spacer;"
                    "                    }"
                    "                    : boxed_column"
                    "                    {"
                    "                        label = \"Farba vyplne\";"
                    "                        : row"
                    "                        {"
                    "                            alignment = centered;"
                    "                            fixed_width = true;"
                    "                            : toggle { key = \"msk-trn\"; label = \"Transparentnost\"; }"
                    "                            : imgbox { key = \"msk-col\"; }"
                    "                        }"
                    "                        spacer;"
                    "                    }"
                    "                    spacer;"
                    "                }"
                    "                spacer;"
                    "            }"
                    "        }"
                    "    }"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = centered;"
                    "        spacer;"
                    "        : but1 { key = \"about\";  label = \"Napoveda\"; }"
                    "        spacer_1;"
                    "        : but3 { key = \"accept\"; label = \"OK\"; is_default = true; }"
                    "        spacer_1;"
                    "        : but1 { key = \"cancel\"; label = \"Zrusit\"; is_cancel = true; }"
                    "        spacer;"
                    "    }"
                    "    spacer;"
                    "}"
                    ""
                    "//------------------------------------------------------------//"
                    "//                  'About' Dialog Definition                 //"
                    "//------------------------------------------------------------//"
                    ""
                    "about : dialog"
                    "{"
                    "    label = \"Napoveda\";"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = left;"
                    "        spacer;"
                    "        : img32 { key = \"info1\"; }"
                    "        : btxt  { width = 21.5; key = \"title2\"; alignment = centered; }"
                    "    }"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = centered;"
                    "        spacer;"
                    "        : column"
                    "        {"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "        }"
                    "        : column"
                    "        {"
                    "            : txt1 { label = \"Enter\" ; }"
                    "            : txt1 { label = \"Click\" ; }"
                    "            : txt1 { label = \"<\"     ; }"
                    "            : txt1 { label = \">\"     ; }"
                    "            : txt1 { label = \"O\"     ; }"
                    "            : txt1 { label = \"Tab\"   ; }"
                    "            : txt1 { label = \"M\"     ; }"
                    "            : txt1 { label = \"C\"     ; }"
                    "            : txt1 { label = \"R\"     ; }"
                    "            : txt1 { label = \"T\"     ; }"
                    "            : txt1 { label = \"I\"     ; }"
                    "            : txt1 { label = \"B\"     ; }"
                    "            : txt1 { label = \"A\"     ; }"
                    "        }"
                    "        : column"
                    "        {"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "        }"
                    "        spacer;"
                    "        : column"
                    "        {"
                    "            : txt3 { label = \"(alebo medzernik/kliknutie pravym tlacidlom) ukoncit program [Zrusit]\"    ; }"
                    "            : txt3 { label = \"umiestnenie objektu\"                           ; }"
                    "            : txt3 { label = \"otocit objekt proti smeru hodinovuch rusiciek\"        ; }"
                    "            : txt3 { label = \"otocit objekt v smere hodinovych ruciciek\"                ; }"
                    "            : txt3 { label = \"zadana rotacia objektu\"                ; }"
                    "            : txt3 { label = \"otocit objekt o 90 stupnov\"            ; }"
                    "            : txt3 { label = \"otocenie zrkadloveho objektu\"                 ; }"
                    "            : txt3 { label = \"zarovnej objekt podla krivky\"                  ; }"
                    "            : txt3 { label = \"nahradit existujuci textovy retazec/retazec atributov\" ; }"
                    "            : txt3 { label = \"pripinanie prirastku pocitadla\"               ; }"
                    "            : txt3 { label = \"prirastok retazca\"                       ; }"
                    "            : txt3 { label = \"otocit polygonalny okrej\"                ; }"
                    "            : txt3 { label = \"prepnutie masky pozadia MText \"           ; }"
                    "        }"
                    "    }"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = left;"
                    "        spacer;"
                    "        : img32 { key = \"info2\"; }"
                    "        : btxt  { width = 28; key = \"title3\"; alignment = centered; }"
                    "    }"
                    "    spacer;"
                    "    : row"
                    "    {"
                    "        fixed_width = true;"
                    "        alignment = centered;"
                    "        spacer;"
                    "        : column"
                    "        {"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "            : txt1 { label = \"[\"     ; }"
                    "        }"
                    "        : column"
                    "        {"
                    "            : txt1 { label = \"Enter\" ; }"
                    "            : txt1 { label = \"Click\" ; }"
                    "            : txt1 { label = \"+/-\"   ; }"
                    "            : txt1 { label = \"O\"     ; }"
                    "            : txt1 { label = \"P\"     ; }"
                    "            : txt1 { label = \"B\"     ; }"
                    "            : txt1 { label = \"A\"     ; }"
                    "        }"
                    "        : column"
                    "        {"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "            : txt1 { label = \"]\"     ; }"
                    "        }"
                    "        spacer;"
                    "        : column"
                    "        {"
                    "            : txt3 { label = \"(alebo medzernik/kliknutie pravym tlacidlom) ukoncit program [Zrusit]\"  ; }"
                    "            : txt3 { label = \"umiestnenie objektu\"                           ; }"
                    "            : txt3 { label = \"zvysit/znizit odsadenie objektu\"        ; }"
                    "            : txt3 { label = \"zadanie odsadenia objektu\"                  ; }"
                    "            : txt3 { label = \"prepinanie kolmosti objektu\"         ; }"
                    "            : txt3 { label = \"otocit polygonalny okrej\"                ; }"
                    "            : txt3 { label = \"prepnutie masky pozadia MText\"           ; }"
                    "        }"
                    "    }"
                    "    spacer_1;"
                    "    ok_only;"
                    "}"
                    ""
                    "//------------------------------------------------------------//"
                    "//                 End of Dialog Definition                   //"
                    "//------------------------------------------------------------//"
                )
                (write-line line file)
            )
            (setq file (close file))
            (while (not (findfile dcl)))
            dcl
        )
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:misc ( )
    (mapcar 'set_tile (mapcar 'vl-list->string '((100 99 108) (97 117 116)))
        (list
            (strcat
                (vl-list->string 
                   '(
                      82 101 78 117 109 98 101 114
                    )
                )
            )
            (strcat
                (vl-list->string
                   '(
                      76 101 101 32 77 97 99 44 32 74 97 107 117 98 32 84 111 109 101 99 107 111 
                    )
                )
            )
        )
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:tostring ( arg / dim )
    (cond
        (   (= 'int (type arg))
            (itoa arg)
        )
        (   (= 'real (type arg))
            (setq dim (getvar 'dimzin))
            (setvar 'dimzin 8)
            (setq arg (rtos arg 2 15))
            (setvar 'dimzin dim)
            arg
        )
        (   (vl-prin1-to-string arg))
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:writeconfig ( name lst / file )
    (if (setq file (open name "w"))
        (progn
            (foreach x lst (write-line (numinc:tostring x) file))
            (setq file (close file))
            t
        )
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:readconfig ( name lst / file line )
    (if
        (and
            (setq name (findfile name))
            (setq file (open name "r"))
        )
        (progn
            (foreach x lst
                (if (setq line (read-line file))
                    (set x (read line))
                )
            )
            (setq file (close file))
            t
        )
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:popup ( title flags msg / err )
    (setq err (vl-catch-all-apply 'vlax-invoke-method (list (numinc:wsh) 'popup msg 0 title flags)))
    (if (null (vl-catch-all-error-p err))
        err
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:wsh nil
    (cond (numinc:wshobject) ((setq numinc:wshobject (vlax-create-object "wscript.shell"))))
)

;;----------------------------------------------------------------------;;

(defun numinc:makelist ( key lst )
    (start_list key)
    (foreach x lst (add_list x))
    (end_list)
)

;;----------------------------------------------------------------------;;

(defun numinc:textincell ( lst pnt str / data dir )
    (setq dir (vlax-3D-point (trans (getvar 'viewdir) 1 0)))
    (if
        (setq data
            (vl-some
                (function
                    (lambda ( table / row col )
                        (if (= :vlax-true (vla-hittest table pnt dir 'row 'col))
                            (list table row col)
                        )
                    )
                )
                lst
            )
        )
        (not (apply 'vla-settext (append data (list str))))
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:increment ( lst inc )
    (foreach sym lst
        (if (distof (eval sym) 2)
            (set sym (numinc:incrementnumba (eval sym) inc))
            (set sym (numinc:incrementalpha (eval sym) (fix (abs (distof inc)))))
        )
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:incrementnumba ( str inc / _rtos _decimalplaces incd maxd num slen strd )

    (defun _rtos ( real prec / dimzin result )
        (setq dimzin (getvar 'dimzin))
        (setvar 'dimzin 0)
        (setq result (rtos real 2 prec))
        (setvar 'dimzin dimzin)
        result
    )

    (defun _decimalplaces ( string / pos )
        (if (setq pos (vl-string-position 46 string))
            (- (strlen string) pos 1)
            0
        )
    )
    
    (setq num (+ (distof str) (distof inc)))

    (if (minusp (distof str))
        (setq str (substr str 2))
    )
    (if (minusp (distof inc))
        (setq inc (substr inc 2))
    )
    (setq incd (_decimalplaces inc)
          strd (_decimalplaces str)
          maxd (max incd strd)
          slen (strlen str)
    )
    (cond
        (   (and (< 0 strd) (< 0 incd))
            (setq slen (+ (- slen strd) maxd))
        )
        (   (and (= 0 strd) (< 0 incd))
            (setq slen (+ incd slen 1))
        )
    )
    (setq str (_rtos num maxd))
    (if (minusp num)
        (setq str (substr str 2))
    )
    (while (< (strlen str) slen)
        (setq str (strcat "0" str))
    )
    (if (minusp num)
        (strcat "-" str)
        str
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:incrementalpha ( str inc / _incrementalpha a )

    (defun _incrementalpha ( a b / c d e )
        (cond
            (   (cond
                    (   (< 47 (setq c (car a)) 58)
                        (setq d 48
                              e 10
                        )
                    )
                    (   (< 64 c 91)
                        (setq d 65
                              e 26
                        )
                    )
                    (   (< 96 c 123)
                        (setq d 97
                              e 26
                        )
                    )
                )
                (setq c (+ (- c d) b)
                      b (/ c e)
                )
                (cons (+ d (rem c e))
                    (if (zerop b)
                        (cdr a)
                        (if (cdr a)
                            (_incrementalpha (cdr  a) b)
                            (_incrementalpha (list d) (if (= 10 e) b (1- b)))
                        )
                    )
                )
            )
            (   (cons c
                    (if (cdr a)
                        (_incrementalpha (cdr a) b)
                        (_incrementalpha (list 65) (1- b))
                    )
                )
            )
        )
    )

    (vl-list->string
        (reverse
            (if (setq a (reverse (vl-string->list str)))
                (_incrementalpha a inc)
                (_incrementalpha '(65) (1- inc))
            )
        )
    )
)

;;----------------------------------------------------------------------;;
        
(defun numinc:aligntocurve ( obj prp ent bor / a1 fac fl g1 g2 gr ll msg mtx p1 ur xa )
    
    (setq fac
        (if (= "AcDbBlockReference" (vla-get-objectname obj))
            (progn
                (vla-getboundingbox obj 'll 'ur)
                (/
                    (-
                        (cadr (vlax-safearray->list ur))
                        (cadr (vlax-safearray->list ll))
                    )
                    2.0
                )
            )
            (vla-get-height obj)
        )
    )
    
    (setq msg
        (princ
            (strcat
                "\nClick to Align <Exit>: [+/-] for [O]ffset, [P]erpendicular"
                (if (and bor (= "3" bor-shp)) ", Rotate [B]order" "")
                (if (setq mtx (= "AcDbMText" (vla-get-objectname obj)))
                    ", B[a]ckground Mask"
                    ""
                )
            )
        )
    )

    (setq xa
        (angle '(0.0 0.0 0.0)
            (trans
                (getvar 'ucsxdir) 0
                (trans '(0.0 0.0 1.0) 1 0 t)
            )
        )
    )
    
    (while
        (progn
            (setq gr (grread t 15 0)
                  g1 (car  gr)
                  g2 (cadr gr)
            )
            (cond
                (   (member g1 '(5 3))
                    (setq p1 (vlax-curve-getclosestpointto ent (setq g2 (trans g2 1 0)))
                          a1 (angle p1 g2)
                          p1 (vlax-3D-point (polar p1 a1 (* fac crv-off)))
                          a1 (numinc:makereadable (+ a1 crv-per))
                    )
                    (if bor
                        (vla-move bor (vlax-get-property obj prp) p1)
                    )
                    (vlax-put-property obj prp p1)
                    (if bor
                        (vla-rotate bor p1
                            (- a1
                                (if mtx
                                    (+ (vla-get-rotation obj) xa)
                                    (vla-get-rotation obj)
                                )
                            )
                        )
                    )
                    (vla-put-rotation obj ((lambda ( a ) (if mtx (- a xa) a)) a1))
                    (null (setq fl (= g1 3)))
                )
                (   (= 25 g1)
                    nil
                )
                (   (= 02 g1)
                    (cond
                        (   (member g2 '(80 112))  ;; P/p
                            (setq crv-per (- (/ pi 2.0) crv-per))
                        )
                        (   (member g2 '(45 95))   ;; -
                            (setq crv-off (- crv-off 0.1))
                        )
                        (   (member g2 '(43 61))   ;; +
                            (setq crv-off (+ crv-off 0.1))
                        )
                        (   (member g2 '(13 32))   ;; Enter/Space
                            nil
                        )
                        (   (member g2 '(79 111))  ;; O/o
                            (setq crv-off
                                (/
                                    (cond
                                        (   (getdist (strcat "\nZadajte odsadenia <" (rtos (* fac crv-off)) ">: ")))
                                        (   (* fac crv-off))
                                    )
                                    fac
                                )
                            )
                            (princ msg)
                        )
                        (   (and (member g2 '(65 97)) mtx)  ;; A/a
                            (vlax-put obj 'backgroundfill
                                (setq mtx-bak (~ (vlax-get obj 'backgroundfill)))
                            )
                            (if (zerop mtx-bak)
                                (princ "\n<Maska pozadia vypnuta>")
                                (princ "\n<Maska pozadia zapnuta>")
                            )
                            (princ msg)
                        )
                        (   (member g2 '(66 98))  ;; B/b
                            (if (and bor (= "3" bor-shp))
                                (progn
                                    (setq bor-rot (not bor-rot))
                                    (vla-rotate bor
                                        (vlax-3D-point (numinc:polygoncentroid bor))
                                        (/ pi bor-sid#)
                                    )
                                )
                                (princ (strcat "\nNeplatne stlacenie klavesy." msg))
                            )
                            t
                        )
                        (   (princ (strcat "\nNeplatne stlacenie klavesy." msg)))
                    )
                )
            )
        )
    )
    (redraw)
    fl  
)

;;----------------------------------------------------------------------;;

(defun numinc:mtextwidth ( str sty hgt / box mtw )
    (cond
        (   (setq mtw
                (entmakex
                    (list
                       '(000 . "MTEXT")
                       '(100 . "AcDbEntity")
                       '(100 . "AcDbMText")
                       '(10 0.0 0.0 0.0)
                        (cons 01 str)
                        (cons 07 sty)
                        (cons 40 hgt)
                    )
                )
            )
            (setq box (numinc:gettextbox (entget mtw) 0.0))
            (entdel mtw)
            (* 1.01 (- (caadr box) (caar box)))
        )
        (   (   (lambda ( box ) (if box (* 1.01 (- (caadr box) (caar box)))))
                (textbox
                    (list
                        (cons 01 str)
                        (cons 40 hgt)
                        (cons 07 sty)
                    )
                )
            )
        )
        (   0.0   )
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:makereadable ( a )
    (   (lambda ( a )
            (if (and (< (* pi 0.5) a) (<= a (* pi 1.5)))
                (numinc:makereadable (+ a pi))
                a
            )
        )
        (rem (+ a pi pi) (+ pi pi))
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:polygoncentroid ( obj / _group )

    (defun _group ( lst )
        (if lst
            (cons (list (car lst) (cadr lst)) (_group (cddr lst)))
        )
    )
    (
        (lambda ( lst )
            (
                (lambda ( len )
                    (mapcar '/ (apply 'mapcar (cons '+ lst)) (list len len))
                )
                (length lst)
            )              
        )
        (_group (vlax-get obj 'coordinates))
    )
)

;;----------------------------------------------------------------------;;

(defun numinc:createtextborder ( ent typ off fx1 fx2 sid / cen enx i inc lst mat pts rad rot vec )
    (setq enx (entget ent))
    (cond
        (   (setq lst (numinc:gettextbox enx off))
            (setq cen (mapcar '(lambda ( a b ) (/ (+ a b) 2.0)) (car lst) (caddr lst))
                  rot (if (= "MTEXT" (cdr (assoc 0 enx)))
                          (angle '(0. 0. 0.) (trans (cdr (assoc 11 enx)) 0 (cdr (assoc 210 enx))))
                          (cdr (assoc 50 enx))
                      )
            )
            (cond
                (   (= "0" typ) ;; Circle
                    (entmakex
                        (list
                           '(0 . "CIRCLE")
                            (cons  010 cen)
                            (cons  040 (cond ( fx1 ) ((distance cen (car lst)))))
                            (assoc 210 enx)
                        )
                    )
                )
                (   (member typ '("1" "2")) ;; Rectangle / Slot
                    (if (and fx1 fx2)
                        (progn
                            (setq fx1 (/ fx1 2.0)
                                  fx2 (/ fx2 2.0)
                            )
                            (setq mat
                                (list
                                    (list (cos rot) (- (sin rot)) 0.0)
                                    (list (sin rot)    (cos rot)  0.0)
                                    (list   0.0           0.0     1.0)
                                )
                            )
                            (setq vec (mapcar '- cen (mxv mat cen)))
                            (setq lst
                                (list
                                    (list (- (car cen) fx1) (- (cadr cen) fx2) (caddr cen))
                                    (list (+ (car cen) fx1) (- (cadr cen) fx2) (caddr cen))
                                    (list (+ (car cen) fx1) (+ (cadr cen) fx2) (caddr cen))
                                    (list (- (car cen) fx1) (+ (cadr cen) fx2) (caddr cen))
                                )
                            )
                            (entmakex
                                (append
                                   '(
                                        (000 . "LWPOLYLINE")
                                        (100 . "AcDbEntity")
                                        (100 . "AcDbPolyline")
                                        (090 . 4)
                                        (070 . 1)
                                    )
                                    (list (cons 38 (caddar lst)))
                                    (apply 'append
                                        (mapcar
                                            (function
                                                (lambda ( a b )
                                                    (list
                                                        (cons 10 (mapcar '+ (mxv mat a) vec))
                                                        (cons 42 b)
                                                    )
                                                )
                                            )
                                            lst (if (= "1" typ) '(0.0 0.0 0.0 0.0) '(0.0 1.0 0.0 1.0))
                                        )
                                    )
                                    (list (assoc 210 enx))
                                )
                            )
                        )
                        (entmakex
                            (append
                               '(
                                    (000 . "LWPOLYLINE")
                                    (100 . "AcDbEntity")
                                    (100 . "AcDbPolyline")
                                    (090 . 4)
                                    (070 . 1)
                                )
                                (list (cons 38 (caddar lst)))
                                (apply 'append
                                    (mapcar
                                        (function
                                            (lambda ( a b ) (list (cons 10 a) (cons 42 b)))
                                        )
                                        lst (if (= "1" typ) '(0.0 0.0 0.0 0.0) '(0.0 1.0 0.0 1.0))
                                    )
                                )
                                (list (assoc 210 enx))
                            )
                        )
                    )
                )
                (   t ;; Polygon
                    (setq inc (/ (+ pi pi) sid)
                          rad (cond ( fx1 ) ((/ (distance cen (car lst)) (cos (/ inc 2.0)))))
                            i -1
                    )
                    (if (= 1 (logand 1 sid)) (setq rot (+ rot (/ pi 2.))))
                    (repeat sid
                        (setq pts
                            (cons
                                (cons 10
                                    (polar cen (+ rot (* (setq i (1+ i)) inc)) rad)
                                )
                                pts
                            )
                        )
                    )
                    (entmakex
                        (append
                            (list
                               '(000 . "LWPOLYLINE")
                               '(100 . "AcDbEntity")
                               '(100 . "AcDbPolyline")
                                (cons 90 (length pts))
                               '(070 . 1)
                            )
                            (list (cons 38 (caddar lst)))
                            (reverse pts)
                            (list (assoc 210 enx))
                        )
                    )
                )
            )
        )
    )
)

;;----------------------------------------------------------------------;;

;; The following function is based on code by gile
 
(defun numinc:gettextbox ( enx off / b h j l m n o p r w )
    (if
        (setq l
            (cond
                (   (= "TEXT" (cdr (assoc 0 enx)))
                    (setq b (cdr (assoc 10 enx))
                          r (cdr (assoc 50 enx))
                          l (textbox enx)
                    )
                    (list
                        (list (- (caar  l) off) (- (cadar  l) off))
                        (list (+ (caadr l) off) (- (cadar  l) off))
                        (list (+ (caadr l) off) (+ (cadadr l) off))
                        (list (- (caar  l) off) (+ (cadadr l) off))
                    )
                )
                (   (= "MTEXT" (cdr (assoc 0 enx)))
                    (setq n (cdr (assoc 210 enx))
                          b (trans  (cdr (assoc 10 enx)) 0 n)
                          r (angle '(0.0 0.0 0.0) (trans (cdr (assoc 11 enx)) 0 n))
                          w (cdr (assoc 42 enx))
                          h (cdr (assoc 43 enx))
                          j (cdr (assoc 71 enx))
                          o (list
                                (cond
                                    ((member j '(2 5 8)) (/ w -2.0))
                                    ((member j '(3 6 9)) (- w))
                                    (0.0)
                                )
                                (cond
                                    ((member j '(1 2 3)) (- h))
                                    ((member j '(4 5 6)) (/ h -2.0))
                                    (0.0)
                                )
                            )
                    )
                    (list
                        (list (- (car o)   off) (- (cadr o)   off))
                        (list (+ (car o) w off) (- (cadr o)   off))
                        (list (+ (car o) w off) (+ (cadr o) h off))
                        (list (- (car o)   off) (+ (cadr o) h off))
                    )
                )
            )
        )
        (   (lambda ( m ) (mapcar '(lambda ( p ) (mapcar '+ (mxv m p) b)) l))
            (list
                (list (cos r) (sin (- r)) 0.0)
                (list (sin r) (cos r)     0.0)
               '(0.0 0.0 1.0)
            )
        )
    )
)

;;----------------------------------------------------------------------;;

;; Matrix x Vector - Vladimir Nesterovsky

(defun mxv ( m v )
    (mapcar (function (lambda ( r ) (apply '+ (mapcar '* r v)))) m)
)

;;----------------------------------------------------------------------;;

(defun numinc:acdoc nil
    (eval (list 'defun 'numinc:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (numinc:acdoc)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nBlock_renumber.lsp | " (JTmenuVersion) " | Lee Mac, prelozil: Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;