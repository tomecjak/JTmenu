;=========================================================================
; Traffic_signs.lsp
; (c) Copyright 2023 Lintang Darudjati, Edit Tomecko Jakub
;
; Kniznica blokov dopravneho znacenia
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                          Funkcie ini-edit.lsp                        ;;
;;----------------------------------------------------------------------;;

(defun ini_readentry_ocel (inifile section entry )
  (if (and (= 'STR (type section)) (/= "[" (substr section 1 1))) (setq section (strcat "[" section "]")))
  (setq section (ini_readsection inifile section))
  (cadr (assoc entry section))
)

(defun ini_writeentry_ocel (inifile section entry val / ofile ini sec)
  (if (not (findfile inifile)) (progn (setq ofile (open inifile "w")) (close ofile)))
  (if (and (= 'STR (type section)) (/= "[" (substr section 1 1))) (setq section (strcat "[" section "]")))
  (if (setq ofile (findfile inifile))
    (progn
      (setq ini  (ini_readini_ocel inifile))
      (cond
        ((setq sec (assoc section ini))
          (if (assoc entry (cdr sec))
            (setq sec (cons section (subst (list entry val) (assoc entry (cdr sec)) (cdr sec))))
            (setq sec (cons section (reverse (cons (list entry val) (reverse (cdr sec))))))
          )
          (setq ini (subst sec (assoc section ini) ini))
          (setq ofile (open ofile "w"))
          (if ofile (progn
            (mapcar
              '(lambda (x)
                (write-line (car x) ofile)
                (mapcar
                  '(lambda (x)
                    (write-line (strcat (car x) "=" (cadr x)) ofile)
                  )
                  (cdr x)
                )
                (write-line "" ofile)
              )
              ini
            )
            (close ofile)
          ))
        )
        (T
          (setq ofile (open ofile "a"))
          (if ofile
            (progn
              (write-line section ofile)
              (write-line (strcat entry "=" val) ofile)
              (close ofile)
            )
          )
        )

      )
    )
  )
)

(defun ini_readsection_ocel (inifile section / ofile line result )
  (if (and (= 'STR (type section)) (/= "[" (substr section 1 1))) (setq section (strcat "[" section "]")))
  (if (findfile inifile)
    (cdr (assoc section (ini_readini_ocel (findfile inifile))))
    (alert (STRCAT inifile "\nChyba!"))
  )
)

(defun ini_readini_ocel (inifile / ofile line section result)
  (if (findfile inifile)
    (progn
      (setq ofile (open (findfile inifile) "r"))
      (if ofile (progn
        (while (and (setq line (read-line ofile)) (/= "[" (substr line 1 1))))
        (while (and line (= "[" (substr line 1 1)))
          (setq section (list line))
          (while (and (setq line (read-line ofile)) (/= "[" (substr line 1 1)))
            (if (and (/= ";"  (substr line 1 1)) (/= "" line))
              (setq section (cons (ini_iniline_ocel line "=") section))
            )
          )
          (setq result (cons (reverse section) result))
        )
        (close ofile)
      ))
    )
    ;(alert (STRCAT inifile "\nChyba!"))
  )
    
  (reverse result)
  
)

(defun ini_iniline_ocel (line sep / line str1 str2 )
    (if (= 'STR (type line))
      (progn
        (setq str1 "" str2 "")
        (while (and (/= "" line) (/= sep (substr line 1 1)))
          (setq str1 (strcat str1  (substr line 1 1)) line (substr line 2))
        )
        (if (= sep (substr line 1 1))
          (setq str2 (substr line 2))
        )
      )
    )
  (list str1 str2)
)

(defun zStrParse_ocel ( str delimlst blank / currchar idx tempstr strlength strlist )
  (setq strlength (strlen str) idx 0 tempstr "")
  (while (< idx strlength)
    (if (member (setq currchar (substr str (setq idx (1+ idx)) 1)) delimlst)
      (progn
        (if (or blank (/= tempstr ""))(setq strlist (append strlist (list tempstr))))
        (setq tempstr "")
      )
      (setq tempstr (strcat tempstr currchar))
    )
  )
  (if (and (null blank) (= tempstr ""))
    strlist
    (append strlist (list tempstr))
  )
); Return list of string or NIL

  (defun zInitKnihOCEL ( / olderr inifile c len m topic subdir tmplist res)
        (setq olderr *ERROR*)
        (defun *ERROR* (msg)
          (setq *ERROR* olderr)
          (princ "\nKnihovna dopravneho znacenia bola ukoncena.")
          (princ)
        )
    ;(if (null wIniList)
      (if (/= (setq inifile (findfile "Traffic_signs.ini")) nil)
        (progn
          (princ "\n\tNacitanie inicializacnich suborov...")
          (setq wIniList_ocel (ini_readini_ocel inifile))
          (setq wLibTopic_ocel '())
          (setq wLibDir_ocel '())
          (setq wLibItem_ocel '())
          (foreach m wIniList_ocel
            (progn
              (setq topic (car (zStrParse_ocel (car m) '("[" "]") nil)))
              (setq wLibTopic_ocel (cons topic wLibTopic_ocel))
              (setq subdir (cadr (cadr m)))
              (setq wLibDir_ocel (cons subdir wLibDir_ocel))
              (setq tmplist '())
              (setq c 2 len (length m))
              (while (< c len)
                (setq tmplist (cons (car (nth c m)) tmplist))
                (setq c (1+ c))
              );while
              (setq tmplist (reverse tmplist))
              (setq wLibItem_ocel (cons tmplist wLibItem_ocel))
            );progn
          );foreach
          (setq wLibTopic_ocel (reverse wLibTopic_ocel))
          (setq wLibDir_ocel (reverse wLibDir_ocel))
          (setq wLibItem_ocel (reverse wLibItem_ocel))
          (setq res T)
        );progn
        (princ "\n\tKnihovna dopravneho znacenia \n\tNejde najst inicializacni subor.")
      );if
      ;(setq res T)
    ;);if
    (setq *ERROR* olderr)
    res
  );defun zInitKnihOCEL


  (if (/= (zInitKnihOCEL) nil) (progn  ;if zInitKnihOCEL ----------------->>>

;;----------------------------------------------------------------------;;
;;                        Funkcia JTTrafficSigns                        ;;
;;----------------------------------------------------------------------;;

(defun C:JTTrafficSigns (  /
            _strpart_ocel _strtrim_ocel _strltrim_ocel _strrtrim_ocel zEDS_ocel _zFixPath_ocel zMsgBox_ocel _aboutbox_ocel _a_ocel
            olderr
            
            activetopic                 ; temp active topic
            dcl_id                      ; dcl id
            setbut                      ; enable/disable buttons
            setico                      ; handling unnecessary icons
            cb_act lb_act ic_act pr_act ne_act   ; action_tile(s)
            init_items                  ; initialize items
            items                       ; items in listbox
            oldsel cursel               ; item selection
            npage page                  ; number of page and curr page (1 page per 20 item)
            count                       ; multi purpose counter
            result                      ; done dialog result
            curdir curpath              ; directory of selected item
            explod                      ; is exploded ?
        )
        (setq olderr *ERROR*)
        (defun *ERROR* (msg)
          (setq *ERROR* olderr)
          (princ "\nKnihovna dopravneho znacenia bola ukoncena.")
          (princ)
        )

; ROUTINES
; ------------------------------------------------------------------------------------------------
; LEFT/RIGHT BREAK STRING
(defun _strpart_ocel (str sym side / a newstr)
  (if (= (type str) 'STR)
     (cond
       ((= side "l")
        (setq a (substr str 2 1) newstr (substr str 1 1) str (substr str 2))
        (while (/= sym a) 
          (setq newstr (strcat newstr (substr str 1 1)) str (substr str 2) a (substr str 1 1))
        )
        (eval newstr)
       )
       ((= side "r")
        (setq a (substr str 1 1) str (substr str 2))
        (while (/= sym a) (setq a (substr str 1 1) str (substr str 2)))
       )
     )
  )
)
; ------------------------------------------------------------------------------------------------
; Trims leading and trailing spaces from strings.
(defun _strtrim_ocel (s)
  (cond
    ((/= (type s) 'str) nil)
    (t (_strltrim_ocel (_strrtrim_ocel s)))
  )
)
(defun _strltrim_ocel (s)
  (cond
    ((eq s "") s)
    ((/= " " (substr s 1 1)) s)
    (t (_strltrim_ocel (substr s 2)))
  )
)
(defun _strrtrim_ocel (s)
  (cond 
    ((eq s "") s)
    (/= " " (substr s (strlen s) 1) s)
    (t (_strrtrim_ocel (substr s 1 (1- (strlen s)))))
  )
)
; -------------------------------------------------------------------------------------------
; Encrypt / decrypt string
; Return : string
               
(defun zEDS_ocel ( instr / outstr c len)
  (setq c 1 len (strlen instr) outstr "")
  (while (<= c len)
    (setq outstr (strcat outstr (chr (- 255 (ascii (substr instr c 1))))))
    (setq c (1+ c))
  )
  outstr
)
; -------------------------------------------------------------------------------------------
; Add a "\\" at the end of path jika nggak ada
(defun zFixPath_ocel ( strpath / res)
  (if (/= (substr strpath (strlen strpath) 1) "\\") (setq strpath (strcat strpath "\\")))
  strpath
)

; -------------------------------------------------------------------------------------------
; MESSAGE / CONFIRMATION DIALOG BOX
; arg: title=dialog title, msg=message string, yesno=T->YesNo nil->Ok only, centered=T/nil

(defun zMsgBox_ocel (title msg yesno centered / makeDcl_ocel fn bkText txtList dh result)
  (defun makeDcl_ocel (fileName title textList / fh)
    (setq fh (open fileName "w"))
    (write-line "MsgBox : dialog {" fh)
    (write-line (strcat "label = \"" title "\";") fh)
    (write-line ": paragraph {" fh)
    (if centered
      (foreach item textList (write-line (strcat ": text_part {label = \"" item  "\";alignment=centered;}") fh))
      (foreach item textList (write-line (strcat ": text_part {label = \"" item  "\";}") fh))
    )
    (write-line "}" fh)
    (write-line "spacer_1;" fh)
    (if yesno
      (progn
        (write-line ": row {alignment=centered; fixed_width=true;" fh)
        (write-line ": button {key=\"BTYES\";label=\"  Ano  \";}" fh)
        (write-line ": button {key=\"BTNO\";label=\"  Ne  \";is_cancel=true;}" fh)
        (write-line "}" fh)
      )
      (write-line "ok_only;" fh)
    )
    (write-line "}" fh)
    (close fh)
  );defun
  ;;main function
  (setq fn (strcat (zFixPath_ocel (getenv "TEMP")) "$msgbox.dc$"))
  (while (wcmatch msg (strcat "*\n*"))
    (setq bkText (_strpart_ocel msg "\n" "l") msg (_strpart_ocel msg "\n" "r") txtList (cons bkText txtList))
  )
  (setq txtList (reverse (cons msg txtList)))
  (makeDcl_ocel fn title txtList)
  (setq dh (load_dialog fn))
  (if (and dh (new_dialog "MsgBox" dh))
     (progn
       (if yesno (action_tile "BTYES" "(done_dialog 1)"))
       (set_tile "message" msg) (if (= (start_dialog) 1) (setq result T) (setq result nil))
       (unload_dialog dh)
     ) ;Progn
  );If
  result
);defun zMsgBox_ocel

; ------------------------------------------------------------------------------------------------
; END OF ROUTINES
; ================================================================================================

  ; HANDLING ICONS
  (defun setico_ocel ( / sisa a dx dy slib sld)

    (setq dx (dimx_tile "0") dy (dimy_tile "0"))
    (setq sisa (rem (length items) 20))
    (if (= 0 sisa ) (setq sisa 20))
    (setq slib (nth (atoi (get_tile "cb")) wLibDir_ocel ))
    (setq curdir slib)
    (if (wcmatch slib "*`\\*")
      (setq sld (_strpart_ocel slib "\\" "r"))
      (setq sld slib)
    )
    (setq curpath (findfile (strcat slib "\\" sld ".slb")))
    (setq curpath (substr curpath 1 (- (strlen curpath)(+ (strlen ".slb")(strlen sld))) ))

    (if (= page (1- npage))
      (progn
        ; Clean icons first
        (setq a 0)
        (repeat 20
            (start_image (itoa a))
            (if (< a  sisa) (fill_image 0 0 dx dy 0) (fill_image 0 0 dx dy -15))
            (end_image)
            (setq a (1+ a))
        );;repeat
        (setq a 0)
        (repeat 20
          (start_image (itoa a))
          (if (< a  sisa)
            (progn
                (slide_image 0 0 dx dy (strcat ".\\" slib "\\" sld "(" (nth (+ a (* page 20)) items) ")"))
                (mode_tile (itoa a) 0)
            )
            (mode_tile (itoa a) 1)
          )
          (end_image)
          (setq a (1+ a))
        );;repeat
      );;progn
      (progn
        ; Clean icons first
        (setq a 0)
        (repeat 20
            (start_image (itoa a))
            (fill_image 0 0 dx dy 0)
            (end_image)
            (setq a (1+ a))
        );;repeat
        (setq a 0)
        (repeat 20
          (start_image (itoa a))
          (slide_image 0 0 dx dy (strcat ".\\" slib "\\" sld "(" (nth (+ a (* page 20)) items) ")"))
          (mode_tile (itoa a) 0)
          (end_image)
          (setq a (1+ a))
        );;repeat
      );;progn
    );;if
  )
  ; INIT PAGING
  (defun init_items_ocel ( value / a b)
    (set_tile "cb" value)
    (start_list "lb")
    (setq items (nth (atoi value) wLibItem_ocel))
    (mapcar ' add_list items)
    (end_list)
    (setq page 0)
    (mode_tile "btPrev" 1)
    (setq a (fix (/ (length items) 20)))
    (setq b (rem (length items) 20))
    (if (> b 0)(setq npage (1+ a))(setq npage a))

    (if (= npage 1)(mode_tile "btNext" 1)(mode_tile "btNext" 0))

    (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4)) ; RESET SELECTION
    (setq oldsel nil) ; RESET SELECTION
    (setico_ocel)

    ;;; (ic_act_ocel "0") ; DO INITIAL SELECTION
  )
  ; ENABLE/DISABLE BUTTONS
  (defun setbut_ocel (pg)
    (if (= pg 0)(mode_tile "btPrev" 1)(mode_tile "btPrev" 0))
    (if (= pg (1- npage))(mode_tile "btNext" 1)(mode_tile "btNext" 0))
  )
  ; LISTBOX ACT
  (defun lb_act_ocel (value / oldpg)
    (setq cursel value)
    (setq oldpg page)
    (setq page (fix (/ (atoi cursel) 20)))
    (setbut_ocel page)
    (if (/= page oldpg) (setico_ocel) (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4)))

    (mode_tile (itoa (rem (atoi cursel) 20)) 4)
    (setq oldsel cursel)
    (set_tile "error" (strcat "Soubor : " curpath (nth (atoi cursel) items ) ".dwg"))
  )
  ; ICON ACT
  (defun ic_act_ocel (key)
    (setq cursel (itoa (+ (* page 20) (atoi key))))
    (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4))
    (mode_tile (itoa (rem (atoi cursel) 20)) 4)
    (set_tile "lb" cursel)
    (setq oldsel cursel)
    (set_tile "error" (strcat "File : " curpath (nth (atoi cursel) items ) ".dwg"))
  )
  ; COMBOBOX ACT
  (defun cb_act_ocel (value)
    (set_tile "error" "")
    (setq cursel nil)
    (init_items_ocel value)
    (setq activetopic (atoi value))
  )
  ; PREVIOUS ACT
  (defun pr_act_ocel ()
    (setq page (1- page))
    (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4))
    (setq oldsel nil)
    (setbut_ocel page)
    (setico_ocel)
  )
  ; NEXT ACT
  (defun ne_act_ocel ()
    (setq page (1+ page))
    (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4))
    (setq oldsel nil)
    (setbut_ocel page)
    (setico_ocel)
  )

;;----------------------------------------------------------------------;;
;;                       Nacitania dialogoveho okna                     ;;
;;----------------------------------------------------------------------;;
  ;(_a T)
  ; LOAD DIALOG
  (setq dcl_id (load_dialog "Traffic_signs.dcl"))
  (if (not (new_dialog "lib" dcl_id) ) (exit))

  (set_tile "capt" "Knihovna dopravneho znacneia")
  (mode_tile "blockScale" 2)

  ; ASSIGN ACTION FOR TILES
  (action_tile "cb" "(cb_act_ocel $value)")
  (action_tile "lb" "(lb_act_ocel $value)")
  (action_tile "tgExp" "(setq explod (atoi $value))")
  (action_tile "btPrev" "(pr_act_ocel)")
  (action_tile "btNext" "(ne_act_ocel)")
  (action_tile "btAbt" "(_a_ocel nil)")
  (action_tile "blockScale" "(setq DimBlockScale (atof $value))")
  (setq count 0)
  (repeat 20
    (action_tile (itoa count) "(ic_act_ocel $key)")
    (setq count (1+ count))
  )

  ; SET TOPICS ( COMBOBOX )
  (start_list "cb")
  (mapcar ' add_list wLibTopic_ocel)
  (end_list)

  ; INIT DEFAULT ITEMS & SELECTION

  (init_items_ocel (itoa (setq activetopic wActiveTopic_ocel)))

  ; START
  (set_tile "capt" "Knihovna dopravneho znacenia")
  (setq result (start_dialog))
  (if (= result 1)(setq wActiveTopic_ocel activetopic))

  ; END
  (unload_dialog dcl_id)

  ; INSERT IT
  (if (and (= result 1)(not (null cursel)))
    (if (= explod 1)
      (command "_insert" (strcat "*.\\" curdir "\\" (nth (atoi cursel) items )) pause (/ DimBlockScale 1000) (/ DimBlockScale 1000) "" pause)
      (command "_insert" (strcat ".\\" curdir "\\" (nth (atoi cursel) items )) pause (/ DimBlockScale 1000) (/ DimBlockScale 1000) "" pause)
    )
  )

  (setq *ERROR* olderr)
  (princ)

);defun C:HOTB

; ================================================================================================
(setq wActiveTopic_ocel 0)
(setvar "CMDECHO" 0)
;<-----------------------if zInitKnihOCEL
));progn ;if

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTraffic_signs.lsp | " (JTmenuVersion) " | Lintang Darudjati, Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;

