; HOTBLOCK.LSP - Created By Lintang Darudjati
; A block catalog, make dwgs are ready to insert anytime ini_readentry_ZDZ
; World-scope variable : 
;            wIniList
;            wLibTopic ;stringlist ->group
;            wLibDir ;stringlist   ->subdir
;            wLibItem ;list of stringlist ->slides and dwgs
;            wActiveTopic

;============================================================================================
; INI-EDIT.LSP     INI_WRITEENTRY INI_READENTRY INI_READSECTION INI_READINI INI_INILINE
;============================================================================================
;;; (("[NEWSECTION]" ("NEWVALUE" "100") ("NEXTVALUE" "SAMPLE")) ("[NEXTSECTION]" ("INIPATH" "C:\\TEST.INI")))


(defun ini_readentry_ZDZ (inifile section entry )
(if (and (= 'STR (type section)) (/= "[" (substr section 1 1))) (setq section (strcat "[" section "]")))
(setq section (ini_readsection inifile section))
(cadr (assoc entry section))
)

(defun ini_writeentry_ZDZ (inifile section entry val / ofile ini sec)
(if (not (findfile inifile)) (progn (setq ofile (open inifile "w")) (close ofile)))
(if (and (= 'STR (type section)) (/= "[" (substr section 1 1))) (setq section (strcat "[" section "]")))
(if (setq ofile (findfile inifile))
  (progn
    (setq ini  (ini_readini_ZDZ inifile))
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


(defun ini_readsection_ZDZ (inifile section / ofile line result )
(if (and (= 'STR (type section)) (/= "[" (substr section 1 1))) (setq section (strcat "[" section "]")))
(if (findfile inifile)
  (cdr (assoc section (ini_readini_ZDZ (findfile inifile))))
  (alert (STRCAT inifile "\nChyba!"))
)
)



(defun ini_readini_ZDZ (inifile / ofile line section result)
(if (findfile inifile)
  (progn
    (setq ofile (open (findfile inifile) "r"))
    (if ofile (progn
      (while (and (setq line (read-line ofile)) (/= "[" (substr line 1 1))))
      (while (and line (= "[" (substr line 1 1)))
        (setq section (list line))
        (while (and (setq line (read-line ofile)) (/= "[" (substr line 1 1)))
          (if (and (/= ";"  (substr line 1 1)) (/= "" line))
            (setq section (cons (ini_iniline_ZDZ line "=") section))
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

(defun ini_iniline_ZDZ (line sep / line str1 str2 )
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
; ================================================================================================
; END OF INI-EDIT.LSP
; ================================================================================================
; -------------------------------------------------------------------------------------------
; MEM-PARSE STRING DENGAN PEMISAH CHARACTER-CHARACTER TERTENTU
; str       : input string
; delimlst  : list of delimiter chars. =  '("/" ":" "\\")
; blank     : allow blank fields
;   T=("abc" "" "def" "" "ghi"), NIL=("abc" "def" "ghi")

(defun zStrParse_ZDZ ( str delimlst blank / currchar idx tempstr strlength strlist )
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

; ================================================================================================
  ; INIT INI FILE
; ================================================================================================
  (defun zInitKnihZDZ ( / olderr inifile c len m topic subdir tmplist res)
        (setq olderr *ERROR*)
        (defun *ERROR* (msg)
          (setq *ERROR* olderr)
          (princ "\nKnihovna dopravneho znacenia bola ukoncena.")
          (princ)
        )
    ;(if (null wIniList)
      (if (/= (setq inifile (findfile "KnihZDZ.INI")) nil)
        (progn
          (princ "\n\tNacitavam subor ...")
          (setq wIniList_ZDZ (ini_readini_ZDZ inifile))
          (setq wLibTopic_ZDZ '())
          (setq wLibDir_ZDZ '())
          (setq wLibItem_ZDZ '())
          (foreach m wIniList_ZDZ
            (progn
              (setq topic (car (zStrParse_ZDZ (car m) '("[" "]") nil)))
              (setq wLibTopic_ZDZ (cons topic wLibTopic_ZDZ))
              (setq subdir (cadr (cadr m)))
              (setq wLibDir_ZDZ (cons subdir wLibDir_ZDZ))
              (setq tmplist '())
              (setq c 2 len (length m))
              (while (< c len)
                (setq tmplist (cons (car (nth c m)) tmplist))
                (setq c (1+ c))
              );while
              (setq tmplist (reverse tmplist))
              (setq wLibItem_ZDZ (cons tmplist wLibItem_ZDZ))
            );progn
          );foreach
          (setq wLibTopic_ZDZ (reverse wLibTopic_ZDZ))
          (setq wLibDir_ZDZ (reverse wLibDir_ZDZ))
          (setq wLibItem_ZDZ (reverse wLibItem_ZDZ))
          (setq res T)
        );progn
        (princ "\n\tKnihovna dopravneho znacenia [HotBlocks v1.2] - Created by Lintang Darudjati\n\tNeda sa najst subor.")
      );if
      ;(setq res T)
    ;);if
    (setq *ERROR* olderr)
    res
  );defun zInitKnihZDZ
; -------------------------------------------------------------------------------------------

  (if (/= (zInitKnihZDZ) nil) (progn  ;if zInitKnihZDZ ----------------->>>

; ================================================================================================

(defun C:JTKNIHDZD (  /
            _strpart_ZDZ _strtrim_ZDZ _strltrim_ZDZ _strrtrim_ZDZ zEDS_ZDZ _zFixPath_ZDZ zMsgBox_ZDZ _aboutbox_ZDZ _a_ZDZ
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
          (princ "\nKnihovna dopravneho znacenia bola ukoncena")
          (princ)
        )

; ROUTINES
; ------------------------------------------------------------------------------------------------
; LEFT/RIGHT BREAK STRING
(defun _strpart_ZDZ (str sym side / a newstr)
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
(defun _strtrim_ZDZ (s)
  (cond
    ((/= (type s) 'str) nil)
    (t (_strltrim_ZDZ (_strrtrim_ZDZ s)))
  )
)
(defun _strltrim_ZDZ (s)
  (cond
    ((eq s "") s)
    ((/= " " (substr s 1 1)) s)
    (t (_strltrim_ZDZ (substr s 2)))
  )
)
(defun _strrtrim_ZDZ (s)
  (cond 
    ((eq s "") s)
    (/= " " (substr s (strlen s) 1) s)
    (t (_strrtrim_ZDZ (substr s 1 (1- (strlen s)))))
  )
)
; -------------------------------------------------------------------------------------------
; Encrypt / decrypt string
; Return : string
               
(defun zEDS_ZDZ ( instr / outstr c len)
  (setq c 1 len (strlen instr) outstr "")
  (while (<= c len)
    (setq outstr (strcat outstr (chr (- 255 (ascii (substr instr c 1))))))
    (setq c (1+ c))
  )
  outstr
)
; -------------------------------------------------------------------------------------------
; Add a "\\" at the end of path jika nggak ada
(defun zFixPath_ZDZ ( strpath / res)
  (if (/= (substr strpath (strlen strpath) 1) "\\") (setq strpath (strcat strpath "\\")))
  strpath
)

; ------------------------------------------------------------------------------------------------
; END OF ROUTINES
; ================================================================================================

  ; HANDLING ICONS
  (defun setico_ZDZ ( / sisa a dx dy slib sld)

    (setq dx (dimx_tile "0") dy (dimy_tile "0"))
    (setq sisa (rem (length items) 20))
    (if (= 0 sisa ) (setq sisa 20))
    (setq slib (nth (atoi (get_tile "cb")) wLibDir_ZDZ ))
    (setq curdir slib)
    (if (wcmatch slib "*`\\*")
      (setq sld (_strpart_ZDZ slib "\\" "r"))
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
  (defun init_items_ZDZ ( value / a b)
    (set_tile "cb" value)
    (start_list "lb")
    (setq items (nth (atoi value) wLibItem_ZDZ))
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
    (setico_ZDZ)

    ;;; (ic_act_ZDZ "0") ; DO INITIAL SELECTION
  )
  ; ENABLE/DISABLE BUTTONS
  (defun setbut_ZDZ (pg)
    (if (= pg 0)(mode_tile "btPrev" 1)(mode_tile "btPrev" 0))
    (if (= pg (1- npage))(mode_tile "btNext" 1)(mode_tile "btNext" 0))
  )
  ; LISTBOX ACT
  (defun lb_act_ZDZ (value / oldpg)
    (setq cursel value)
    (setq oldpg page)
    (setq page (fix (/ (atoi cursel) 20)))
    (setbut_ZDZ page)
    (if (/= page oldpg) (setico_ZDZ) (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4)))

    (mode_tile (itoa (rem (atoi cursel) 20)) 4)
    (setq oldsel cursel)
    (set_tile "error" (strcat "Subor : " curpath (nth (atoi cursel) items ) ".dwg"))
  )
  ; ICON ACT
  (defun ic_act_ZDZ (key)
    (setq cursel (itoa (+ (* page 20) (atoi key))))
    (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4))
    (mode_tile (itoa (rem (atoi cursel) 20)) 4)
    (set_tile "lb" cursel)
    (setq oldsel cursel)
    (set_tile "error" (strcat "File : " curpath (nth (atoi cursel) items ) ".dwg"))
  )
  ; COMBOBOX ACT
  (defun cb_act_ZDZ (value)
    (set_tile "error" "")
    (setq cursel nil)
    (init_items_ZDZ value)
    (setq activetopic (atoi value))
  )
  ; PREVIOUS ACT
  (defun pr_act_ZDZ ()
    (setq page (1- page))
    (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4))
    (setq oldsel nil)
    (setbut_ZDZ page)
    (setico_ZDZ)
  )
  ; NEXT ACT
  (defun ne_act_ZDZ ()
    (setq page (1+ page))
    (if (not (null oldsel)) (mode_tile (itoa (rem (atoi oldsel) 20)) 4))
    (setq oldsel nil)
    (setbut_ZDZ page)
    (setico_ZDZ)
  )

  ; BEGIN PROCESS =======================================================>>>>
  ;(_a T)
  ; LOAD DIALOG
  (setq dcl_id (load_dialog "KnihZDZ.dcl"))
  (if (not (new_dialog "lib" dcl_id) ) (exit))

  (set_tile "capt" "Knihovna dopravneho znacenia")
  (mode_tile "blockScale" 2)

  ; ASSIGN ACTION FOR TILES
  (action_tile "cb" "(cb_act_ZDZ $value)")
  (action_tile "lb" "(lb_act_ZDZ $value)")
  (action_tile "tgExp" "(setq explod (atoi $value))")
  (action_tile "btPrev" "(pr_act_ZDZ)")
  (action_tile "btNext" "(ne_act_ZDZ)")
  (action_tile "btAbt" "(_a_ZDZ nil)")
  (action_tile "blockScale" "(setq DimBlockScale (atof $value))")
  (setq count 0)
  (repeat 20
    (action_tile (itoa count) "(ic_act_ZDZ $key)")
    (setq count (1+ count))
  )
  
  ; SET TOPICS ( COMBOBOX )
  (start_list "cb")
  (mapcar ' add_list wLibTopic_ZDZ)
  (end_list)

  ; INIT DEFAULT ITEMS & SELECTION

  (init_items_ZDZ (itoa (setq activetopic wActiveTopic_ZDZ)))

  ; START
  (set_tile "capt" "Knihovna dopravneho znacenia")
  (setq result (start_dialog))
  (if (= result 1)(setq wActiveTopic_ZDZ activetopic))

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
(setq wActiveTopic_ZDZ 0)
(setvar "CMDECHO" 0)
(princ "\n\tKnihovna dopravneho znacenia")
(princ "\n\tZadejte KNIHDZD pre spustenie.")

;<-----------------------if zInitKnihZDZ
));progn ;if


(princ)
�
