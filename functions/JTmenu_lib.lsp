;=========================================================================
; JTmenu_lib.lsp
; Create by Jakub Tomecko
;
; Zdielana kniznica pomocnych funkcii pre JTmenu.
; Tento subor sa nacitava ako prvy v JTmenu.mnl, takze vsetky tu
; definovane funkcie su dostupne globalne pre ostatne moduly.
; Cielom je odstranit duplicitu (Lee Mac helpery boli predtym
; nadefinovane vo viacerych suboroch) a zjednotit opakovane vzorce.
;-------------------------------------------------------------------------

(vl-load-com)

;;----------------------------------------------------------------------;;
;;                     Mierka pre vkladane bloky                        ;;
;;----------------------------------------------------------------------;;

;; Mierka pre bezne bloky z globalnej premennej GlobalnaBlocksScale.
;; Povodne sa vsade opakoval vzorec:
;;   (/ (atof (getenv "GlobalnaBlocksScale")) 1000)
(defun JT:BlockScale ( )
  (/ (atof (getenv "GlobalnaBlocksScale")) 1000.0)
)

;; Mierka pre bloky dopravneho znacenia z GlobalnaSignBlocksScale.
(defun JT:SignScale ( )
  (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000.0)
)

;;----------------------------------------------------------------------;;
;;                  Lee Mac - praca s Undo a dokumentom                 ;;
;;----------------------------------------------------------------------;;

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Closes an Undo Group.
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)

;;----------------------------------------------------------------------;;
;;                       Lee Mac - matematika                           ;;
;;----------------------------------------------------------------------;;

;; Round to Multiple  -  Lee Mac
;; Rounds 'n' to the nearest multiple of 'm'
(defun LM:roundm ( n m )
  (* m (fix ((if (minusp n) - +) (/ n (float m)) 0.5)))
)

;;----------------------------------------------------------------------;;
;;                      Formatovanie retazcov                           ;;
;;----------------------------------------------------------------------;;

;; Doplni cislo na dve miesta (1 -> "01", 12 -> "12")
(defun JT:Pad2 ( n / s )
  (setq s (itoa n))
  (if (< n 10) (strcat "0" s) s)
)

;; Doplni medzery sprava do dlzky n
(defun JT:PadRight ( s n )
  (while (< (strlen s) n) (setq s (strcat s " ")))
  s
)

;; Doplni medzery zlava do dlzky n
(defun JT:PadLeft ( s n )
  (while (< (strlen s) n) (setq s (strcat " " s)))
  s
)

;;----------------------------------------------------------------------;;
;;                     Hladiny vystuze - spolocne                       ;;
;;----------------------------------------------------------------------;;
;; Hladiny vystuze maju tvar <PREFIX>-B <CC> (vystuz) a <PREFIX>-BS <CC>
;; (spony), kde PREFIX je globalna premenna GlobalnaPrefixHladiny a CC je
;; poradove cislo. Funkcie nize su zdielane medzi c:JTRebarLayers
;; (Rebar_functions.lsp) a c:JTRebarLayerManager (Rebar_layers_manager.lsp).

;; Vrati "B" / "BS" ak nazov hladiny zodpoveda hladine vystuze, inak nil.
;; Prefix sa zamerne neoveruje, aby sa nasli aj hladiny z vykresov
;; vytvorenych s inym nastavenim prefixu. Hladiny z xrefov ("XREF|DP-B 01")
;; sa vynechavaju - nedaju sa premenovat ani v nich kreslit.
(defun JT:RebarLayerTag ( name / up )
  (setq up (strcase name))
  (cond
    ((vl-string-search "|" name) nil)
    ((wcmatch up "*-BS #*") "BS")
    ((wcmatch up "*-B #*")  "B")
  )
)

;; Vrati poradove cislo z konca nazvu hladiny ("DP-B 07" -> 7)
(defun JT:RebarLayerNum ( name / i )
  (setq i (strlen name))
  (while (and (> i 0) (wcmatch (substr name i 1) "#"))
    (setq i (1- i))
  )
  (atoi (substr name (1+ i)))
)

;; Zlozi nazov hladiny z aktualneho prefixu, tagu a cisla
(defun JT:RebarLayerName ( tag num )
  (strcat (getenv "GlobalnaPrefixHladiny") "-" tag " " (JT:Pad2 num))
)

;; Farebny cyklus pre dany typ hladiny
(defun JT:RebarLayerColors ( tag )
  (if (= tag "BS")
    '(14 34 54 74 94 114 134 154 174 194 214 234)
    '(11 31 51 71 91 111 131 151 171 191 211 231)
  )
)

;; Dalsia farba v cykle za farbou curr (nil -> prva farba)
(defun JT:RebarNextColor ( curr colors / pos )
  (if (and curr (setq pos (vl-position curr colors)))
    (nth (rem (1+ pos) (length colors)) colors)
    (car colors)
  )
)

;; Vrati (maxCislo farbaPoslednejHladiny) pre dany tag ("B" / "BS")
(defun JT:RebarMaxLayerInfo ( tag / rec lname num maxn maxname laydata laycol )
  (setq maxn 0)
  (setq rec (tblnext "LAYER" T))
  (while rec
    (setq lname (cdr (assoc 2 rec)))
    (if (= tag (JT:RebarLayerTag lname))
      (progn
        (setq num (JT:RebarLayerNum lname))
        (if (and num (> num maxn))
          (setq maxn num maxname lname)
        )
      )
    )
    (setq rec (tblnext "LAYER"))
  )
  (if maxname
    (progn
      (setq laydata (tblsearch "LAYER" maxname))
      (setq laycol (abs (cdr (assoc 62 laydata))))
    )
  )
  (list maxn laycol)
)

;; Vytvori 'pocet' novych hladin daneho tagu, farby nadvazuju na posledne
;; existujucu hladinu. Pouziva entmake (nie command), takze je bezpecne
;; volatelna aj z callbacku DCL dialogu. Vracia zoznam vytvorenych nazvov.
(defun JT:RebarCreateLayers ( tag pocet / info maxn colors farba i cislo name created )
  (setq colors  (JT:RebarLayerColors tag)
        info    (JT:RebarMaxLayerInfo tag)
        maxn    (car info)
        farba   (JT:RebarNextColor (cadr info) colors)
        i       1
  )
  (while (<= i pocet)
    (setq cislo (+ maxn i)
          name  (JT:RebarLayerName tag cislo)
    )
    (if (not (tblsearch "LAYER" name))
      (if (entmake
            (list
              '(0 . "LAYER")
              '(100 . "AcDbSymbolTableRecord")
              '(100 . "AcDbLayerTableRecord")
              (cons 2 name)
              '(70 . 0)
              (cons 62 farba)
              '(6 . "Continuous")
            )
          )
        (setq created (cons name created))
      )
    )
    (setq farba (JT:RebarNextColor farba colors))
    (setq i (1+ i))
  )
  (reverse created)
)

;; Vrati vsetky hladiny daneho tagu ako (("nazov" . cislo) ...) zoradene
;; vzostupne podla cisla
(defun JT:RebarLayersOfTag ( tag / rec lname lst )
  (setq rec (tblnext "LAYER" T))
  (while rec
    (setq lname (cdr (assoc 2 rec)))
    (if (= tag (JT:RebarLayerTag lname))
      (setq lst (cons (cons lname (JT:RebarLayerNum lname)) lst))
    )
    (setq rec (tblnext "LAYER"))
  )
  (vl-sort lst
    (function
      (lambda ( a b )
        (if (= (cdr a) (cdr b))
          (< (strcase (car a)) (strcase (car b)))
          (< (cdr a) (cdr b))
        )
      )
    )
  )
)

;; Zaklad nazvu hladiny bez poradoveho cisla ("DP-B 08" -> "DP-B ")
(defun JT:RebarLayerBase ( name / i )
  (setq i (strlen name))
  (while (and (> i 0) (wcmatch (substr name i 1) "#"))
    (setq i (1- i))
  )
  (substr name 1 i)
)

;; Nahradi cislo na konci nazvu hladiny novym cislom, prefix ostava zachovany
;; ("DP-B 08" 9 -> "DP-B 09")
(defun JT:RebarRenumberName ( name newnum )
  (strcat (JT:RebarLayerBase name) (JT:Pad2 newnum))
)

;; Farba, ktora patri danemu poradovemu cislu v ramci farebneho cyklu
(defun JT:RebarColorForNum ( tag num / colors )
  (setq colors (JT:RebarLayerColors tag))
  (nth (rem (max 0 (1- num)) (length colors)) colors)
)

;; Priradi vsetkym hladinam daneho tagu farbu podla ich poradoveho cisla.
;; Pouziva ActiveX, takze sa nezmeni stav zapnutia/vypnutia hladiny.
(defun JT:RebarRecolorLayers ( tag / layers )
  (setq layers (vla-get-layers (LM:acdoc)))
  (foreach x (JT:RebarLayersOfTag tag)
    (vl-catch-all-apply 'vla-put-color
      (list (vla-item layers (car x)) (JT:RebarColorForNum tag (cdr x)))
    )
  )
)

;; Vlozi 'pocet' novych hladin zacinajucich poradovym cislom 'num'.
;; Vsetky existujuce hladiny daneho tagu s cislom >= num sa posunu o 'pocet'
;; vyssie (premenuju sa), pricom si zachovaju svoj vlastny prefix.
;; Premenuvava sa od najvyssieho cisla nadol, takze nemoze dojst ku kolizii
;; nazvov. Na zaver sa cela rada prefarbi podla novych cisel.
;; Vracia ((novyNazov ...) (("staryNazov" . "novyNazov") ...))
;; Vsetko sa robi cez entmake/ActiveX (nie command), takze je funkcia
;; bezpecne volatelna aj z callbacku DCL dialogu.
(defun JT:RebarInsertLayers ( tag num pocet / layers lst shift name i created renamed )
  (setq layers (vla-get-layers (LM:acdoc)))
  (setq lst    (JT:RebarLayersOfTag tag))

  ;; hladiny na posun - od najvyssieho cisla nadol
  (setq shift
    (reverse (vl-remove-if (function (lambda ( x ) (< (cdr x) num))) lst))
  )

  (foreach x shift
    (setq name (JT:RebarRenumberName (car x) (+ (cdr x) pocet)))
    (if (not (vl-catch-all-error-p
               (vl-catch-all-apply 'vla-put-name
                 (list (vla-item layers (car x)) name)
               )
             )
        )
      (setq renamed (cons (cons (car x) name) renamed))
    )
  )

  ;; vytvorenie novych (prazdnych) hladin na uvolnenych cislach
  (setq i 0)
  (while (< i pocet)
    (setq name (JT:RebarLayerName tag (+ num i)))
    (if (not (tblsearch "LAYER" name))
      (if (entmake
            (list
              '(0 . "LAYER")
              '(100 . "AcDbSymbolTableRecord")
              '(100 . "AcDbLayerTableRecord")
              (cons 2 name)
              '(70 . 0)
              (cons 62 (JT:RebarColorForNum tag (+ num i)))
              '(6 . "Continuous")
            )
          )
        (setq created (cons name created))
      )
    )
    (setq i (1+ i))
  )

  ;; zosuladenie farieb celej rady s novymi cislami
  (JT:RebarRecolorLayers tag)

  (list (reverse created) (reverse renamed))
)

;; Precisluje hladiny daneho tagu od 1 po koniec - zaplni medzery v cislovani
;; (1, 2, 5, 6, 9 -> 1, 2, 3, 4, 5). Hladiny sa najprv zoskupia podla zakladu
;; nazvu (prefixu pred cislom) a kazda skupina sa precisluje samostatne, takze
;; sa nemozu pomiesat hladiny z vykresov s roznym prefixom. Premenuvava sa
;; vzostupne - kazda hladina ide na rovnake alebo nizsie cislo, takze cielovy
;; nazov je vzdy volny. Na zaver sa cela rada prefarbi podla novych cisel.
;; Vracia (("staryNazov" . "novyNazov") ...)
(defun JT:RebarRenumberLayers ( tag / layers groups pair base i newname renamed )
  (setq layers (vla-get-layers (LM:acdoc)))

  ;; zoskupenie podla zakladu nazvu
  (foreach x (JT:RebarLayersOfTag tag)
    (setq base (JT:RebarLayerBase (car x)))
    (if (setq pair (assoc base groups))
      (setq groups (subst (cons base (cons (car x) (cdr pair))) pair groups))
      (setq groups (cons (list base (car x)) groups))
    )
  )

  (foreach g groups
    (setq i 1)
    ;; cons zoznam otoci poradie, reverse ho vrati na vzostupne podla cisla
    (foreach nm (reverse (cdr g))
      (setq newname (strcat (car g) (JT:Pad2 i)))
      (if (and (/= (strcase nm) (strcase newname))
               (not (vl-catch-all-error-p
                      (vl-catch-all-apply 'vla-put-name
                        (list (vla-item layers nm) newname)
                      )
                    )
               )
          )
        (setq renamed (cons (cons nm newname) renamed))
      )
      (setq i (1+ i))
    )
  )

  ;; zosuladenie farieb celej rady s novymi cislami
  (JT:RebarRecolorLayers tag)

  (reverse renamed)
)


;;----------------------------------------------------------------------;;
;;                Zistenie priemeru vystuze v hladine                   ;;
;;----------------------------------------------------------------------;;
;; Priemer sa drzi ako cele cislo v desatinach milimetra (10 mm -> 100),
;; aby sa hodnoty z blokov a z polylin dali porovnat bez chyb desatinnej
;; aritmetiky.

;; Vrati prve cislo v retazci ako realne cislo ("10 mm" -> 10.0), inak nil
(defun JT:ParseNum ( s / i n )
  (setq i 1 n (strlen s))
  (while (and (<= i n) (not (wcmatch (substr s i 1) "#")))
    (setq i (1+ i))
  )
  (if (<= i n) (atof (substr s i)))
)

;; Hodnota dynamickej vlastnosti bloku (napr. prepinac viditelnosti "Priemer")
(defun JT:GetDynProp ( blk prp / props )
  (setq prp (strcase prp))
  (if (and (vlax-property-available-p blk 'isdynamicblock)
           (= :vlax-true (vla-get-isdynamicblock blk))
           (not (vl-catch-all-error-p
                  (setq props (vl-catch-all-apply 'vlax-invoke
                                (list blk 'getdynamicblockproperties)))
                )
           )
      )
    (vl-some
      (function
        (lambda ( x )
          (if (= prp (strcase (vla-get-propertyname x)))
            (vlax-get x 'value)
          )
        )
      )
      props
    )
  )
)

;; Hodnota atributu bloku podla tagu
(defun JT:GetAttValue ( blk tag / atts )
  (setq tag (strcase tag))
  (if (and (vlax-property-available-p blk 'hasattributes)
           (= :vlax-true (vla-get-hasattributes blk))
           (not (vl-catch-all-error-p
                  (setq atts (vl-catch-all-apply 'vlax-invoke
                               (list blk 'getattributes)))
                )
           )
      )
    (vl-some
      (function
        (lambda ( a )
          (if (= tag (strcase (vla-get-tagstring a)))
            (vla-get-textstring a)
          )
        )
      )
      atts
    )
  )
)

;; Priemer vystuze z bloku v desatinach mm.
;; Hlada dynamicku vlastnost "Priemer" (prepinac viditelnosti so stavmi typu
;; "10 mm"), ak nie je, skusi atribut PRIEMER. Ocakava textovu hodnotu,
;; z ktorej sa precita prve cislo ako hodnota v milimetroch.
(defun JT:RebarBlockDia ( obj / val num )
  (setq val (JT:GetDynProp obj "Priemer"))
  (if (null val) (setq val (JT:GetAttValue obj "PRIEMER")))
  (if (and (= (type val) 'STR) (setq num (JT:ParseNum val)))
    (fix (+ 0.5 (* 10.0 num)))
  )
)

;; Priemer vystuze z polyline v desatinach mm - berie sa global (constant)
;; width, ktory je v metroch, takze 0.010 -> 100 desatin mm.
;; Polyline bez globalnej sirky vrati 0, co sa neskor prejavi ako nezhoda.
(defun JT:RebarPlineDia ( obj / w )
  (setq w (vl-catch-all-apply 'vla-get-constantwidth (list obj)))
  (if (vl-catch-all-error-p w) (setq w 0.0))
  (fix (+ 0.5 (* 10000.0 w)))
)

;; Text do stlpca priemer. 'bd' su hodnoty z blokov, 'pd' z polylin.
;; Viac roznych hodnot v ramci jedneho zdroja alebo nezhoda medzi zdrojmi
;; znamena chybu. Ak je k dispozicii len jeden zdroj, vypise sa jeho hodnota.
(defun JT:RebarDiaText ( bd pd )
  (cond
    ((and (null bd) (null pd)) "-")
    ((> (length bd) 1) "chyba")
    ((> (length pd) 1) "chyba")
    ((and bd pd (/= (car bd) (car pd))) "chyba")
    (T (JT:DiaToStr (cond ((car bd)) ((car pd)))))
  )
)

;; Priemer z desatin mm na text ("100" -> "10", "105" -> "10.5")
(defun JT:DiaToStr ( d10 )
  (if (zerop (rem d10 10))
    (itoa (/ d10 10))
    (rtos (/ d10 10.0) 2 1)
  )
)

;;----------------------------------------------------------------------;;
;;                  Statistika hladin vystuze v modeli                  ;;
;;----------------------------------------------------------------------;;

;; Zvysi pocitadlo pre kluc v asociacnom zozname
(defun JT:AssocInc ( lst key / pair )
  (if (setq pair (assoc key lst))
    (subst (cons key (1+ (cdr pair))) pair lst)
    (cons (cons key 1) lst)
  )
)

;; Prida hodnotu do zoznamu pri kluci, duplicity sa ignoruju
(defun JT:AssocPush ( lst key val / pair )
  (cond
    ((null (setq pair (assoc key lst))) (cons (list key val) lst))
    ((member val (cdr pair)) lst)
    (T (subst (cons key (cons val (cdr pair))) pair lst))
  )
)

;; Jeden prechod cez model space. Vracia zoznam piatich asociacnych zoznamov:
;; (spolu bloky polyliny priemeryZBlokov priemeryZPolylin), vsetky kluce su
;; nazvy hladin velkymi pismenami. Priemery sa zistuju len pre hladiny
;; vystuze, aby sa zbytocne neprechadzali dynamicke vlastnosti inych blokov.
(defun JT:RebarLayerStats ( / totals blocks plines bdias pdias obj lay typ val )
  (vlax-for obj (vla-get-modelspace (LM:acdoc))
    (setq lay (strcase (vla-get-layer obj)))
    ;; nerebarove hladiny sa uplne preskocia - do zoznamu sa aj tak nedostanu
    ;; a asociacne zoznamy tak ostavaju kratke (rychlejsi subst)
    (if (JT:RebarLayerTag lay)
      (progn
        (setq totals (JT:AssocInc totals lay))
        (setq typ (vla-get-objectname obj))
        (cond
          ((= typ "AcDbBlockReference")
            (setq blocks (JT:AssocInc blocks lay))
            (if (setq val (JT:RebarBlockDia obj))
              (setq bdias (JT:AssocPush bdias lay val))
            )
          )
          ((= typ "AcDbPolyline")
            (setq plines (JT:AssocInc plines lay))
            (if (setq val (JT:RebarPlineDia obj))
              (setq pdias (JT:AssocPush pdias lay val))
            )
          )
        )
      )
    )
  )
  (list totals blocks plines bdias pdias)
)

;; Vrati zoradeny zoznam hladin vystuze vo formate
;; ((nazov tag cislo spolu bloky polyliny priemerText) ...)
;; - najprv "B", potom "BS", v ramci typu podla poradoveho cisla
(defun JT:RebarLayerList ( / stats totals blocks plines bdias pdias rec lname tag up lst )
  (setq stats  (JT:RebarLayerStats)
        totals (nth 0 stats)
        blocks (nth 1 stats)
        plines (nth 2 stats)
        bdias  (nth 3 stats)
        pdias  (nth 4 stats)
  )
  (setq rec (tblnext "LAYER" T))
  (while rec
    (setq lname (cdr (assoc 2 rec)))
    (if (setq tag (JT:RebarLayerTag lname))
      (progn
        (setq up (strcase lname))
        (setq lst
          (cons
            (list lname tag (JT:RebarLayerNum lname)
                  (cond ((cdr (assoc up totals))) (0))
                  (cond ((cdr (assoc up blocks))) (0))
                  (cond ((cdr (assoc up plines))) (0))
                  (JT:RebarDiaText (cdr (assoc up bdias)) (cdr (assoc up pdias)))
            )
            lst
          )
        )
      )
    )
    (setq rec (tblnext "LAYER"))
  )
  (vl-sort lst
    (function
      (lambda ( a b )
        (cond
          ((/= (cadr a)  (cadr b))  (< (cadr a)  (cadr b)))
          ((/= (caddr a) (caddr b)) (< (caddr a) (caddr b)))
          (T (< (strcase (car a)) (strcase (car b))))
        )
      )
    )
  )
)

;; Hlavicka stlpcov zoznamu - musi sediet s JT:RebarLayerRow
(defun JT:RebarLayerHeader ( )
  "Nazov hladiny        | Spolu | Blok | Plin | Priemer"
)

;; Naformatuje jeden riadok do list_boxu dialogu
(defun JT:RebarLayerRow ( item )
  (strcat
    (JT:PadRight (car item) 20)
    " |" (JT:PadLeft (itoa (nth 3 item)) 6)
    " |" (JT:PadLeft (itoa (nth 4 item)) 5)
    " |" (JT:PadLeft (itoa (nth 5 item)) 5)
    " |" (JT:PadLeft (nth 6 item) 8)
  )
)

;; T ak je hladina zmrazena (nemozno ju nastavit ako aktualnu)
(defun JT:LayerFrozen ( name / d )
  (and (setq d (tblsearch "LAYER" name))
       (= 1 (logand 1 (cdr (assoc 70 d))))
  )
)

;;----------------------------------------------------------------------;;

(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nJTmenu_lib.lsp | " (JTmenuVersion) " | Lee Mac, Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
