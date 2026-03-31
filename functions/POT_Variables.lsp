;;; =============================================================
;;; POT_Variables.lsp  –  AutoCAD Variable Manager (POT)
;;; Príkaz: POT_VAR
;;; =============================================================

;;; ----- Globálne premenné rutiny -----
(defun pot:init-globals ()
  (setq POT:VARLIST
    '(
      ("3DOSMODE"                 "11"        "139"    "Registry")
      ("BACKGROUNDPLOT"           "3"         "2"      "Registry")
      ("CACHEMAXFILES"            "0"         "256"    "Registry")
      ("CACHEMAXTOTALSIZE"        "0"         "1024"   "Registry")
      ("CLOUDCOLLABMODIFIEDOPTION" "1"        "0"      "Registry")
      ("COMMANDPREVIEW"           "0"         "1"      "Registry")
      ("COMPLEXLTPREVIEW"         "0"         "1"      "Registry")
      ("DISPSILHBLOCKS"           "0"         "1"      "Registry")
      ("DRAWORDERCTL"             "0"         "3"      "Drawing")
      ("DX12FRAMERATEUNLIMITED"   "1"         "0"      "Registry")
      ("DYNTOOLTIPS"              "0"         "1"      "Registry")
      ("DYNMODE"                  "0"         "3"      "Registry")
      ("EXPERT"                   "1"         "0"      "Registry")
      ("FASTSHADEDMODE"           "1"         "0"      "Registry")
      ("FILLMODE"                 "0"         "1"      "Drawing")
      ("GEOMARKERVISIBILITY"      "0"         "1"      "Registry")
      ("GRIPOBJLIMIT"             "2"         "100"    "Registry")
      ("GRIPMULTIFUNCTIONAL"      "0"         "3"      "Registry")
      ("GROUPDISPLAYMODE"         "0"         "2"      "Registry")
      ("HPMAXLINES"               "10000000"  "100000" "Registry")
      ("HPQUICKPREVIEW"           "0"         "1"      "Registry")
      ("INDEXCTL"                 "3"         "0"      "Drawing")
      ("INPUTSEARCHDELAY"         "100"       "1000"   "Registry")
      ("ISAVEPERCENT"             "0"         "50"     "Registry")
      ("LAYERFILTERALERT"         "0"         "2"      "Registry")
      ("LAYOUTREGENCTL"           "3"         "2"      "Registry")
      ("MAXSORT"                  "800"       "1000"   "Registry")
      ("NAVVCUBEOPACITY"          "100"       "50"     "Registry")
      ("NAVVCUBESIZE"             "1"         "4"      "Registry")
      ("PALETTEOPAQUE"            "1"         "0"      "Registry")
      ("PEDITACCEPT"              "1"         "0"      "Registry")
      ("PROPOBJLIMIT"             "0"         "25000"  "Registry")
      ("PROXYGRAPHICS"            "0"         "1"      "Registry")
      ("PDFSHX"                   "0"         "1"      "Registry")
      ("REGENMODE"                "0"         "1"      "Registry")
      ("REMEMBERFOLDERS"          "0"         "1"      "Registry")
      ("ROLLOVERTIPS"             "0"         "1"      "Registry")
      ("RTREGENAUTO"              "0"         "1"      "Registry")
      ("SAVEFIDELITY"             "0"         "1"      "Registry")
      ("SELECTIONANNODISPLAY"     "0"         "1"      "Registry")
      ("SAVETIME"                 "30"        "10"     "Registry")
      ("SELECTIONPREVIEW"         "0"         "3"      "Registry")
      ("TOOLTIPS"                 "0"         "1"      "Registry")
      ("WHIPARC"                  "0"         "1"      "Registry")
      ("WHIPTHREAD"               "2"         "1"      "Registry")
      ("XREFREGAPPCTL"            "1"         "2"      "Registry")
      ("ZOOMFACTOR"               "100"       "60"     "Registry")
    )
  )
  (setq POT:NROWS (length POT:VARLIST))
  ;; Načítame aktuálne hodnoty z AutoCADu
  (setq POT:CURVALS (mapcar (function (lambda (v) (pot:getvar-safe (car v)))) POT:VARLIST))
  ;; Editačné hodnoty – štart = optimalizované
  (setq POT:EDITVALS (mapcar 'cadr POT:VARLIST))
  ;; Aktuálne vybrané riadky (zoznam indexov)
  (setq POT:SELROWS (list 0))
)

;;; ----- Bezpečné čítanie premennej -----
(defun pot:getvar-safe (vname / r)
  (setq r (vl-catch-all-apply 'getvar (list vname)))
  (if (vl-catch-all-error-p r) "???" (vl-princ-to-string r))
)

;;; ----- Bezpečné nastavenie premennej -----
(defun pot:setvar-safe (vname vval / rv ri)
  ;; Skúsime float, potom int
  (setq rv (vl-catch-all-apply 'setvar (list vname (atof vval))))
  (if (vl-catch-all-error-p rv)
    (progn
      (setq ri (vl-catch-all-apply 'setvar (list vname (atoi vval))))
      (not (vl-catch-all-error-p ri))
    )
    T
  )
)

;;; ----- Prvých n prvkov zoznamu -----
(defun pot:list-head (lst n / i r)
  (setq i 0 r '())
  (while (< i n) (setq r (append r (list (nth i lst))) i (1+ i)))
  r
)

;;; ----- Nahraď n-tý prvok zoznamu -----
(defun pot:list-replace (lst idx val)
  (append (pot:list-head lst idx) (list val) (nthcdr (1+ idx) lst))
)

;;; ----- Padding reťazca na šírku w -----
(defun pot:pad (s w / l pad)
  (setq l (strlen s))
  (cond
    ((>= l w) (substr s 1 w))
    (T
     (setq pad "")
     (repeat (- w l) (setq pad (strcat pad " ")))
     (strcat s pad)
    )
  )
)

;;; ----- Zostavenie reťazca riadku pre list_box -----
(defun pot:format-row (idx / vd vname optv curv defv stor mark)
  (setq vd   (nth idx POT:VARLIST))
  (setq vname (car vd))
  (setq optv  (cadr vd))
  (setq defv  (caddr vd))
  (setq stor  (cadddr vd))
  (setq curv  (nth idx POT:CURVALS))
  ;; Označenie zmeny oproti default
  (setq mark (if (= curv defv) " " "*"))
  (strcat
    mark " "
    (pot:pad vname 26)
    (pot:pad optv  12)
    (pot:pad curv  12)
    (pot:pad defv  10)
    stor
  )
)

;;; ----- Obnova celého list_box -----
(defun pot:refresh-list (sel-idx)
  (start_list "var_list" 3)
  (setq i 0)
  (while (< i POT:NROWS)
    (add_list (pot:format-row i))
    (setq i (1+ i))
  )
  (end_list)
  ;; Obnoviť výber
  (set_tile "var_list" (vl-princ-to-string sel-idx))
)

;;; ----- Parsovanie výberu list_box (reťazec "0 3 7" → zoznam (0 3 7)) -----
(defun pot:parse-sel (s / chars tok result c)
  (setq chars (vl-string->list s) tok "" result '())
  (foreach c chars
    (if (= c 32)
      (progn
        (if (/= tok "") (setq result (append result (list (atoi tok)))))
        (setq tok "")
      )
      (setq tok (strcat tok (chr c)))
    )
  )
  (if (/= tok "") (setq result (append result (list (atoi tok)))))
  result
)

;;; ----- Aktualizuj info panel pre vybraný riadok -----
(defun pot:update-info (idx / vd)
  (setq vd (nth idx POT:VARLIST))
  (set_tile "lbl_varname" (car vd))
  (set_tile "lbl_optval"  (cadr vd))
  (set_tile "lbl_defval"  (caddr vd))
  (set_tile "lbl_stored"  (cadddr vd))
  (set_tile "lbl_curval"  (nth idx POT:CURVALS))
  (set_tile "edit_value"  (nth idx POT:EDITVALS))
)

;;; ----- Zapíš DCL súbor -----
(defun pot:write-dcl (fpath / f)
  (setq f (open fpath "w"))
  (foreach line
    '(
      "pot_variables : dialog {"
      "  label = \"POT - AutoCAD Variable Manager\";"
      "  width = 78;"
      ""
      "  // Hlavička stĺpcov"
      "  : row {"
      "    : text { label = \"  Premenná\"; width = 28; alignment = left; }"
      "    : text { label = \"Opt. hodnota\"; width = 13; alignment = left; }"
      "    : text { label = \"Aktuálna\"; width = 13; alignment = left; }"
      "    : text { label = \"Predvolená\"; width = 11; alignment = left; }"
      "    : text { label = \"Kde\"; width = 8; alignment = left; }"
      "  }"
      ""
      "  // Zoznam premenných"
      "  : list_box {"
      "    key          = \"var_list\";"
      "    width        = 78;"
      "    height       = 18;"
      "    multiple_select = true;"
      "    fixed_width  = true;"
      "  }"
      ""
      "  // Panel úpravy"
      "  : boxed_column {"
      "    label = \"Vybraná premenná\";"
      "    : row {"
      "      : text  { label = \"Názov:\";      width = 10; alignment = right; }"
      "      : text  { key = \"lbl_varname\"; label = \"-\"; width = 24; alignment = left; }"
      "      : text  { label = \"Opt. hodn.:\"; width = 13; alignment = right; }"
      "      : text  { key = \"lbl_optval\";  label = \"-\"; width = 12; alignment = left; }"
      "      : text  { label = \"Uložené:\";   width = 10; alignment = right; }"
      "      : text  { key = \"lbl_stored\";  label = \"-\"; width = 10; alignment = left; }"
      "    }"
      "    : row {"
      "      : text  { label = \"Predvolená:\"; width = 10; alignment = right; }"
      "      : text  { key = \"lbl_defval\";  label = \"-\"; width = 24; alignment = left; }"
      "      : text  { label = \"Aktuálna:\";  width = 13; alignment = right; }"
      "      : text  { key = \"lbl_curval\";  label = \"-\"; width = 12; alignment = left; }"
      "      : text  { label = \"Nová hodnota:\"; width = 14; alignment = right; }"
      "      : edit_box { key = \"edit_value\"; width = 10; }"
      "      : button  { key = \"btn_apply1\"; label = \"Nastav\"; width = 8; }"
      "    }"
      "  }"
      ""
      "  // Tlačidlá"
      "  : row {"
      "    : button { key = \"btn_select_all\"; label = \"Vybrať všetko\"; width = 16; }"
      "    : button { key = \"btn_save\";       label = \"Uložiť označené\"; is_default = true; width = 18; }"
      "    : button { key = \"btn_reset\";      label = \"Reset\"; width = 14; }"
      "    : spacer { width = 4; }"
      "    : button { key = \"accept\";         label = \"Zavrieť\"; is_cancel = true; width = 14; }"
      "  }"
      ""
      "  : text { key = \"status_msg\"; label = \" \"; width = 78; alignment = left; }"
      "}"
    )
    (write-line line f)
  )
  (close f)
)

;;; ----- Hlavná funkcia -----
(defun c:POT_VAR ( / dcl-path dcl-id done)
  (vl-load-com)
  (pot:init-globals)
  
  (setq dcl-path (strcat (getvar "TEMPPREFIX") "pot_variables.dcl"))
  (pot:write-dcl dcl-path)
  
  (setq dcl-id (load_dialog dcl-path))
  (if (< dcl-id 0) (progn (alert "Chyba: DCL sa nepodarilo načítať!") (exit)))
  
  (if (not (new_dialog "pot_variables" dcl-id))
    (progn (alert "Chyba: new_dialog zlyhalo!") (unload_dialog dcl-id) (exit))
  )
  
  ;; Naplniť zoznam
  (pot:refresh-list 0)
  
  ;; Zobraziť info pre prvý riadok
  (pot:update-info 0)
  
  ;; Výber riadku
  (action_tile "var_list"
    (quote
      (progn
        (setq POT:SELROWS (pot:parse-sel $value))
        (if POT:SELROWS (pot:update-info (car POT:SELROWS)))
      )
    )
  )
  
  ;; Nastav jednu hodnotu (edit_value → editvals)
  (action_tile "btn_apply1"
    (quote
      (progn
        (if POT:SELROWS
          (progn
            (setq _idx (car POT:SELROWS))
            (setq _nv  (get_tile "edit_value"))
            (setq POT:EDITVALS (pot:list-replace POT:EDITVALS _idx _nv))
            (set_tile "status_msg"
              (strcat "Hodnota " (car (nth _idx POT:VARLIST)) " nastavená na: " _nv " (ešte neuložené do AutoCADu)"))
          )
          (set_tile "status_msg" "Žiadna premenná nie je vybraná.")
        )
      )
    )
  )
  
  ;; Vybrať všetko
  (action_tile "btn_select_all"
    (quote
      (progn
        (setq _allsel "")
        (setq _i 0)
        (while (< _i POT:NROWS)
          (setq _allsel
            (if (= _allsel "") (itoa _i) (strcat _allsel " " (itoa _i)))
          )
          (setq _i (1+ _i))
        )
        (set_tile "var_list" _allsel)
        (setq POT:SELROWS (pot:parse-sel _allsel))
        (set_tile "status_msg" (strcat "Vybraných " (itoa POT:NROWS) " premenných."))
      )
    )
  )
  
  ;; Uložiť označené
  (action_tile "btn_save"
    (quote
      (progn
        (setq _ok 0 _err 0)
        (foreach _idx POT:SELROWS
          (setq _vn  (car  (nth _idx POT:VARLIST)))
          (setq _vv  (nth  _idx POT:EDITVALS))
          (if (pot:setvar-safe _vn _vv)
            (progn
              (setq _ok (1+ _ok))
              (setq POT:CURVALS (pot:list-replace POT:CURVALS _idx (pot:getvar-safe _vn)))
            )
            (setq _err (1+ _err))
          )
        )
        (pot:refresh-list (if POT:SELROWS (car POT:SELROWS) 0))
        (if POT:SELROWS (pot:update-info (car POT:SELROWS)))
        (set_tile "status_msg"
          (strcat "Uložených: " (itoa _ok)
                  (if (> _err 0) (strcat "  |  Chýb (read-only?): " (itoa _err)) "")))
      )
    )
  )
  
  ;; Reset — obnoviť predvolené hodnoty pre vybrané premenné
  (action_tile "btn_reset"
    (quote
      (progn
        (setq _ok 0 _err 0)
        (foreach _idx POT:SELROWS
          (setq _vn  (car   (nth _idx POT:VARLIST)))
          (setq _dv  (caddr (nth _idx POT:VARLIST)))
          (setq POT:EDITVALS (pot:list-replace POT:EDITVALS _idx _dv))
          (if (pot:setvar-safe _vn _dv)
            (progn
              (setq _ok (1+ _ok))
              (setq POT:CURVALS (pot:list-replace POT:CURVALS _idx (pot:getvar-safe _vn)))
            )
            (setq _err (1+ _err))
          )
        )
        (pot:refresh-list (if POT:SELROWS (car POT:SELROWS) 0))
        (if POT:SELROWS (pot:update-info (car POT:SELROWS)))
        (set_tile "status_msg"
          (strcat "Reset hotový: " (itoa _ok) " premenných obnovených na predvolené hodnoty."
                  (if (> _err 0) (strcat "  Chýb: " (itoa _err)) "")))
      )
    )
  )
  
  ;; Zavrieť (klávesa Cancel / button accept = zavretie)
  (action_tile "accept" "(done_dialog 0)")
  
  (start_dialog)
  (unload_dialog dcl-id)
  (princ "\nPOT_VAR: Dialóg zavretý.\n")
  (princ)
)

(princ "\n=== POT Variable Manager načítaný ===")
(princ "\nSpustite príkazom: POT_VAR\n")
(princ)
