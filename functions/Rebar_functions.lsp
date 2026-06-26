;=========================================================================
; Rebar_functions.lsp
; Create (vibecode) by Jakub Tomecko
;
; Nastroje pre prace s vystuzou: prienik, fillet, zapis do atributu
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                           Pomocne funkcie                            ;;
;;----------------------------------------------------------------------;;

(defun _3d (p) (list (car p) (cadr p) (if (caddr p) (caddr p) 0.0)))
(defun _2d (p) (list (car p) (cadr p)))
(defun _pt2d (p) (list (car p) (cadr p)))

(defun _draw-lwpoly (pts closed / data)
  (setq data
    (append
      (list '(0 . "LWPOLYLINE")
            '(100 . "AcDbEntity")
            '(100 . "AcDbPolyline")
            (cons 90 (length pts))
            (cons 70 (if closed 1 0))
      )
      (apply 'append
             (mapcar '(lambda (p) (list (cons 10 (_pt2d (_3d p))))) pts)
      )
    )
  )
  (entmakex data)
)

(defun _lw-get-pts (ename / ed pts)
  (setq ed (entget ename))
  (foreach x ed
    (if (= (car x) 10)
      (setq pts (cons (_3d (cdr x)) pts))
    )
  )
  (reverse pts)
)

(defun _lw-get-bulges (ename / ed blg)
  (setq ed (entget ename))
  (foreach x ed
    (if (= (car x) 42)
      (setq blg (cons (cdr x) blg))
    )
  )
  (reverse blg)
)

(defun _safe-nth (i lst def)
  (if (and (>= i 0) (< i (length lst))) (nth i lst) def)
)

;;----------------------------------------------------------------------;;
;;                Funkcia pre vytvorenie vrcholov oblukov               ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarIntersect (/ e ed pts blg nv i
                       pPrev pStart pEnd pNext
                       b oldlay ip)
  (vl-load-com)
  (setq e (car (entsel "\nVyber polyline: ")))
  (if (and e (= (cdr (assoc 0 (entget e))) "LWPOLYLINE"))
    (progn
      (setq oldlay (getvar "CLAYER")) ; uložíme aktuálnu vrstvu [web:23]
      (setvar "CLAYER" oldlay) ; nepotrebujeme ju meniť

      (setq ed  (entget e))
      (setq pts (_lw-get-pts e))
      (setq blg (_lw-get-bulges e))
      (setq nv (length pts))

      (if (< nv 4)
        (prompt "\nPolyline ma malo vrcholov (min. 4).")
        (progn
          ;; segment i: pStart=pts[i] -> pEnd=pts[i+1], bulge=blg[i]
          ;; predchádzajúca line: pPrev=pts[i-1] -> pStart
          ;; nasledujúca line: pEnd -> pNext=pts[i+2]
          (setq i 1)
          (while (<= i (- nv 3))
            (setq pPrev  (nth (1- i) pts))
            (setq pStart (nth i      pts))
            (setq pEnd   (nth (1+ i) pts))
            (setq pNext  (nth (+ i 2) pts))

            (setq b (_safe-nth i blg 0.0))

            (if (/= b 0.0)
              (progn
                ;; prienik dvoch čiar (pPrev->pStart) a (pEnd->pNext)
                (setq ip (inters (_2d pPrev) (_2d pStart)
                                 (_2d pEnd)  (_2d pNext)
                                 nil))
                (if ip
                  (_draw-lwpoly (list pStart ip pEnd) nil)
                )
              )
            )

            (setq i (1+ i))
          )
        )
      )

      (setvar "CLAYER" oldlay)
      (prompt "\nHotovo – polyliny (start–prienik–end) na aktualnej vrstve.")
    )
    (prompt "\nMusi to byt polyline.")
  )
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Funkcia pre vytvorenie oblukov na polylin              ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarFilletPolyline (/ ent ed global_width D R)
  (vl-load-com)

  ;; vyber polyline (LWPOLYLINE)
  (setq ent (car (entsel "\nVyber polyline: ")))
  (if (null ent) (progn (prompt "\nZrusene.") (princ) (exit)))

  (setq ed (entget ent))
  (setq global_width (cdr (assoc 43 ed)))

  (if (or (null global_width) (<= global_width 0.0))
    (progn
      (prompt "\nPolyline nema nastaveny global width (parameter 'Global width').")
      (princ) (exit)
    )
  )

  (setq D (* global_width 1000.0)) ; mm (predpoklad výkres v metroch)

  ;; výpočet polomeru filletu (R v mm)
  (if (<= D 16.0)
    (setq R (+ (* 2.0 D) (/ D 2.0)))   ; (D*4)/2 + D/2
    (setq R (+ (* 3.5 D) (/ D 2.0)))   ; (D*7)/2 + D/2
  )

  ;; nastav fillet radius: predpoklad výkres v metroch => mm/1000
  (setvar "FILLETRAD" (/ R 1000.0))
  (prompt (strcat "\nD=" (rtos D 2 0) " mm, fillet R=" (rtos R 2 1) " mm."))

  ;; FILLET polyline (bez 'P' skratky, použijeme plnú voľbu) [web:192][web:195]
  (command "_.FILLET" "_Polyline" ent)

  (prompt "\nHotovo.")
  (princ)
)

;;----------------------------------------------------------------------;;
;;                           Pomocne funkcie                            ;;
;;----------------------------------------------------------------------;;

(defun LM:roundm ( n m )
  ;; Round to the nearest multiple (Lee Mac style) [web:171]
  (* m (fix ((if (minusp n) - +) (/ n (float m)) 0.5)))
)

(defun _digits-after-last-underscore (s / i n out)
  (setq n (strlen s) i n out nil)
  (while (and (> i 0) (/= "_" (substr s i 1))) (setq i (1- i)))
  (if (> i 0)
    (progn
      (setq i (1+ i) out "")
      (while (and (<= i n) (wcmatch (substr s i 1) "#"))
        (setq out (strcat out (substr s i 1)))
        (setq i (1+ i))
      )
      (if (= out "") nil out)
    )
    nil
  )
)

(defun _set-attr (blkEname tag val / obj atts a ok)
  (setq obj (vlax-ename->vla-object blkEname))
  (if (= (vla-get-HasAttributes obj) :vlax-true)
    (progn
      (setq atts (vlax-invoke obj 'GetAttributes))
      (foreach a atts
        (if (= (strcase (vla-get-TagString a)) (strcase tag))
          (progn (vla-put-TextString a val) (setq ok T))
        )
      )
    )
  )
  ok
)

(defun _digits-after-B-or-BS (s / posB posBS start n i out)
  (if (and s (> (strlen s) 0))
    (progn
      (setq posB (vl-string-search "B" s))
      (setq posBS (vl-string-search "BS" s))
      (cond
        (posBS (setq start (+ posBS 2)))
        (posB (if (and (< (+ posB 2) (strlen s)) (= (substr s (+ posB 2) 1) "S"))
                  (setq start (+ posB 2))  ; ak je BS
                  (setq start (1+ posB))   ; ak je len B
                )
        )
        (t (setq start nil))
      )
      (if start
        (progn
          (setq n (strlen s) i start out "")
          ;; preskoc znaky ktore nie su cisla
          (while (and (<= i n) (not (wcmatch (substr s i 1) "#")))
            (setq i (1+ i))
          )
          ;; nacitaj cisla
          (while (and (<= i n) (wcmatch (substr s i 1) "#"))
            (setq out (strcat out (substr s i 1)))
            (setq i (1+ i))
          )
          (if (= out "") nil out)
        )
        nil
      )
    )
    nil
  )
)

;;----------------------------------------------------------------------;;
;;                      Funkcia pre zapis do bloku                      ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarWritePolyline (/ plEnt plEd global_width num lay cislo obj len kusy lenmm lenmm5 str blkEnt)
  (vl-load-com)

  (setq plEnt (car (entsel "\nVyber polyline: ")))
  (if (null plEnt) (progn (prompt "\nNic nevybrane.") (princ) (exit)))

  (setq plEd (entget plEnt))
  (setq global_width (cdr (assoc 43 plEd)))

  (if (or (null global_width) (<= global_width 0.0))
    (progn
      (prompt "\nPolyline nema nastaveny global width (parameter 'Global width').")
      (princ) (exit)
    )
  )

  (setq num (rtos (* global_width 1000.0) 2 0)) ; mm (predpoklad výkres v metroch)

  ;; načítaj číslo z názvu hladiny za "B" alebo "BS"
  (setq lay (cdr (assoc 8 plEd)))
  (setq cislo (_digits-after-B-or-BS lay))
  
  ;; ak je v hladine BS, pridaj S pred číslo
  (if (and cislo (vl-string-search "BS" lay))
    (setq cislo (strcat "S" cislo))
  )

  ;nastavenie modu urcenia dlzky vystuze
  (if (= (getenv "GlobalnaRebarLegth") "Os")
    ;dlzka polyliny z osi
    (progn
      (setq obj (vlax-ename->vla-object plEnt))
      (setq len (vlax-curve-getDistAtParam obj (vlax-curve-getEndParam obj)))
    )
    ;dlzka polyliny z povrchu  
    (progn
        ;; pôvodná polyline + jej dĺžka
        (setq orig-obj (vlax-ename->vla-object plEnt))
        (setq orig-len (vla-get-length orig-obj)) ; dĺžka pôvodnej polyliny[web:3][web:6]

        ;; offset vzdialenost = global_width
        (setq dist (/ (abs global_width) 2))

        (setq ptMax (getvar "EXTMAX")) ; bod pre jednu stranu[web:29]
        (setq ptMin (getvar "EXTMIN")) ; bod pre opačnú stranu[web:29]

        ;; OFFSET na stranu k EXTMAX (erase = no)
        (command
          "_.OFFSET"
          "E" "N"
          dist
          plEnt
          ptMax
          ""
        )
        (setq off1 (entlast))

        (if off1
          (setq len1 (vla-get-length (vlax-ename->vla-object off1))) ; dĺžka 1. offsetu[web:3][web:6]
        )

        ;; OFFSET na stranu k EXTMIN (erase = no)
        (command
          "_.OFFSET"
          "E" "N"
          dist
          plEnt
          ptMin
          ""
        )
        (setq off2 (entlast))

        (if off2
          (setq len2 (vla-get-length (vlax-ename->vla-object off2))) ; dĺžka 2. offsetu[web:3][web:6]
        )

        ;; vyber dlhšiu offsetovanú polylínu
        (cond
          ((and off1 off2)
          (if (>= len1 len2)
            (progn
              (setq chosen    off1
                    chosenLen len1)
              (entdel off2) ; kratšiu zmaž[web:19]
            )
            (progn
              (setq chosen    off2
                    chosenLen len2)
              (entdel off1) ; kratšiu zmaž[web:19]
            )
          )
          )
          ((and off1 (not off2))
          (setq chosen    off1
                chosenLen len1)
          )
          ((and off2 (not off1))
          (setq chosen    off2
                chosenLen len2)
          )
        )
      
      ;; výslednú hodnotu ulož do globálnej premennej obj
      (setq len chosenLen)
    
      ;; po ziskani dlzky zmaz offset (povodna polylina zostane)
      (entdel chosen)[web:19]
      
    )  
  )
  
  ;dĺžka (v jednotkách výkresu) -> *1000 -> zaokrúhliť na 5
  (setq lenmm  (* len 1000.0))
  (setq lenmm5 (LM:roundm lenmm 5)) ; najbližší násobok 5 [web:171]

  (setq kusy (getstring "\nZadaj pocet kusov: "))
  (if (null kusy) (progn (prompt "\nZrusene.") (princ) (exit)))

  ;; do stringu dávam už zaokrúhlenú dĺžku v mm bez desatinných
  (setq str (strcat num "/" (rtos lenmm5 2 0) "-" kusy "ks"))

  (setq blkEnt (car (entsel "\nVyber blok (s atributmi POPIS a Cislo): ")))
  (if (null blkEnt) (progn (prompt "\nZrusene.") (princ) (exit)))

  (if (_set-attr blkEnt "POPIS" str)
    (prompt (strcat "\nZapisane do POPIS: " str))
    (prompt "\nBlok nema atribut POPIS.")
  )

  (if cislo
    (if (_set-attr blkEnt "Cislo" cislo)
      (prompt (strcat "\nZapisane do Cislo: " cislo))
      (prompt "\nBlok nema atribut Cislo.")
    )
    (prompt "\nV nazve hladiny sa nenaslo cislo za 'B' alebo 'BS'.")
  )

  (princ)
)


;;;;;;;;;;;;;;

(vl-load-com)

(defun c:OFFLEN (/ ename edata width dist
                   orig-obj orig-len
                   ptMax ptMin
                   off1 off2
                   len1 len2
                   chosen chosenLen)

  (prompt "\nVyber LWPOLYLINE so zadanou WIDTH: ")
  (if (setq ename (car (entsel)))
    (progn
      ;; pôvodná polyline + jej dĺžka
      (setq orig-obj (vlax-ename->vla-object ename))
      (setq orig-len (vla-get-length orig-obj)) ; dĺžka pôvodnej polyliny[web:3][web:6]

      ;; DXF kód 43 = global / constant width pre LWPOLYLINE
      (setq edata (entget ename))
      (setq width (cdr (assoc 43 edata)))

      ;; Ak nemá global width, spýtaj sa na hodnotu
      (if (or (null width) (<= (abs width) 1e-9))
        (setq width (getreal "\nPolyline nema global WIDTH, zadaj offset vzdialenost: "))
      )

      (if width
        (progn
          (setq dist (/ (abs width) 2)) ; offset vzdialenost = WIDTH

          (setq ptMax (getvar "EXTMAX")) ; bod pre jednu stranu[web:29]
          (setq ptMin (getvar "EXTMIN")) ; bod pre opacnu stranu[web:29]

          ;; OFFSET na stranu k EXTMAX (erase = no)
          (command
            "_.OFFSET"
            "E" "N"
            dist
            ename
            ptMax
            ""
          )
          (setq off1 (entlast))

          (if off1
            (setq len1 (vla-get-length (vlax-ename->vla-object off1))) ; dĺžka 1. offsetu[web:3][web:6]
          )

          ;; OFFSET na stranu k EXTMIN (erase = no)
          (command
            "_.OFFSET"
            "E" "N"
            dist
            ename
            ptMin
            ""
          )
          (setq off2 (entlast))

          (if off2
            (setq len2 (vla-get-length (vlax-ename->vla-object off2))) ; dĺžka 2. offsetu[web:3][web:6]
          )

          ;; vyber dlhšiu offsetovanú polylínu
          (cond
            ((and off1 off2)
             (if (>= len1 len2)
               (progn
                 (setq chosen    off1
                       chosenLen len1)
                 (entdel off2) ; kratšiu zmaž[web:19]
               )
               (progn
                 (setq chosen    off2
                       chosenLen len2)
                 (entdel off1) ; kratšiu zmaž[web:19]
               )
             )
            )
            ((and off1 (not off2))
             (setq chosen    off1
                   chosenLen len1)
            )
            ((and off2 (not off1))
             (setq chosen    off2
                   chosenLen len2)
            )
          )

          (if chosen
            (progn
              ;; voliteľná kontrola – mala by byť väčšia ako pôvodná
              (if (<= chosenLen orig-len)
                (prompt "\nUpozornenie: dlzka offsetu nie je vacsia ako povodna.")
              )

              (prompt
                (strcat
                  "\nDlzka (dlhsej) offsetovanej polyliny = "
                  (rtos chosenLen 2 3)
                )
              )

              ;; po ziskani dlzky zmaz offset (povodna polylina zostane)
              (entdel chosen)[web:19]
            )
            (prompt "\nOffset sa nepodaril.")
          )
        )
      )
    )
    (prompt "\nNebola zvolena ziadna entita.")
  )

  (princ)
)


;;;;;;;;;;;;;




;;----------------------------------------------------------------------;;
;;               Funkcia pre vytvaranie hladin vystuze                  ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarLayers (/ volba pocet tag info maxNum lastColor i cislo novaHladina farby farba)

  (vl-load-com)

  (defun _pad2 (n / s)
    (setq s (itoa n))
    (if (< n 10)
      (strcat "0" s)
      s
    )
  )

  (defun _extract-number-after-pattern (s patt / pos start numtxt ch)
    (setq pos (vl-string-search patt s))
    (if pos
      (progn
        (setq start (+ pos (strlen patt) 1))
        (setq numtxt "")
        (while (<= start (strlen s))
          (setq ch (substr s start 1))
          (if (wcmatch ch "#")
            (setq numtxt (strcat numtxt ch))
            (setq start (+ (strlen s) 1))
          )
          (setq start (1+ start))
        )
        (if (/= numtxt "")
          (atoi numtxt)
          nil
        )
      )
      nil
    )
  )

  (defun _get-max-layer-info (tag / rec lname num patt maxn maxname laydata laycol)
    (setq maxn 0)
    (setq maxname nil)
    (setq laycol nil)
    (setq patt (strcat tag " "))
    (setq rec (tblnext "LAYER" T))

    (while rec
      (setq lname (cdr (assoc 2 rec)))
      (if (wcmatch lname (strcat "*" patt "*"))
        (progn
          (setq num (_extract-number-after-pattern lname patt))
          (if (and num (> num maxn))
            (progn
              (setq maxn num)
              (setq maxname lname)
            )
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

  (defun _next-cycle-color (curr colors / pos)
    (if curr
      (progn
        (setq pos (vl-position curr colors))
        (if pos
          (nth (rem (1+ pos) (length colors)) colors)
          (car colors)
        )
      )
      (car colors)
    )
  )

  (initget "Vystuz Spony")
  (setq volba (getkword "\nVyber typ hladin [Vystuz/Spony]: "))

  (cond
    ((null volba)
      (princ "\nNebola zvolena moznost.")
    )

    (T
      (initget 7)
      (setq pocet (getint "\nZadaj pocet hladin na vytvorenie: "))

      (if (null pocet)
        (princ "\nPocet musi byy kladne cele cislo.")
        (progn
          (setq tag   (if (= volba "Vystuz") "B" "BS"))
          (setq farby_B '(11 31 51 71 91 111 131 151 171 191 211 231))
          (setq farby_BS '(14 34 54 74 94 114 134 154 174 194 214 234))
          (setq info (_get-max-layer-info tag))
          (setq maxNum (car info))
          (setq lastColor (cadr info))

          (if (= tag "B")
            ;pre "B"
            (setq farba (_next-cycle-color lastColor farby_B))
            ;pre "BS"
            (setq farba (_next-cycle-color lastColor farby_BS))
          )

          (setq i 1)
          (while (<= i pocet)
            (setq cislo (+ maxNum i))
            (setq novaHladina (strcat (getenv "GlobalnaPrefixHladiny") "-" tag " " (_pad2 cislo)))

            (if (not (tblsearch "LAYER" novaHladina))
              (progn
                (command "_.-LAYER" "_New" novaHladina "")
                (command "_.-LAYER" "_Color" (itoa farba) novaHladina "")
              )
            )

            (if (= tag "B")
              ;pre "B"
              (setq farba (_next-cycle-color farba farby_B))
              ;pre "BS"
              (setq farba (_next-cycle-color farba farby_BS))
            )
            (setq i (1+ i))
          )

          (princ
            (strcat
              "\nVytvorenych "
              (itoa pocet)
              " hladin od "
              tag " " (_pad2 (1+ maxNum))
              " po "
              tag " " (_pad2 (+ maxNum pocet))
              ". Farebny cyklus nadvazuje na posledne existujucu hladinu."
            )
          )
        )
      )
    )
  )

  (princ)
)

;;----------------------------------------------------------------------;;
;;                      Funkcia pre offset vystuze                      ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarOffsetPolyline (/ *error* doc ent obj ed gw dist offVar1 offVar2 newObj1 newObj2 arr)

  (vl-load-com)

  (defun _getOffsetObj (v / a)
    (setq a (vlax-variant-value v))
    (cond
      ((= (type a) 'safearray)
       (car (vlax-safearray->list a)))
      (T a)
    )
  )

  (defun *error* (msg)
    (if doc (vla-EndUndoMark doc))
    (if (and msg (/= msg "Function cancelled"))
      (princ (strcat "\nChyba: " msg))
    )
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vla-StartUndoMark doc)

  (if (setq ent (car (entsel "\nVyber polyline: ")))
    (progn
      (setq obj (vlax-ename->vla-object ent))
      (setq ed  (entget ent))

      (if (/= (cdr (assoc 0 ed)) "LWPOLYLINE")
        (princ "\nObjekt nie je LWPOLYLINE.")
        (progn
          (setq gw (cond ((cdr (assoc 43 ed))) (0.0)))

          (if (<= gw 0.0)
            (princ "\nPolyline nema nenulovy Global Width.")
            (progn
              (setq dist (/ gw 2.0))

              (setq offVar1 (vla-Offset obj dist))
              (setq offVar2 (vla-Offset obj (- dist)))

              (setq newObj1 (_getOffsetObj offVar1))
              (setq newObj2 (_getOffsetObj offVar2))

              (if newObj1 (vla-put-ConstantWidth newObj1 0.0))
              (if newObj2 (vla-put-ConstantWidth newObj2 0.0))

              (princ
                (strcat
                  "\nHotovo. Vytvorene 2 offsety vo vzdialenosti +/- "
                  (rtos dist 2 3)
                  " a obom bol nastaveny Global Width na 0."
                )
              )
            )
          )
        )
      )
    )
  )

  (vla-EndUndoMark doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                  Funkcia pre export popisu vystuze                   ;;
;;----------------------------------------------------------------------;;

(vl-load-com)

;; ------------------------------------------------------------
;; Vráti skutočný názov referencie bloku
;; - pri dynamickom bloku EffectiveName
;; - inak Name
;; ------------------------------------------------------------
(defun GetBlockEffectiveName (blk / obj)
  (setq obj (vlax-ename->vla-object blk))
  (if (vlax-property-available-p obj 'EffectiveName)
    (vla-get-EffectiveName obj)
    (vla-get-Name obj)
  )
)

;; ------------------------------------------------------------
;; Vráti hodnotu atribútu podľa TAG-u
;; ------------------------------------------------------------
(defun GetAttr (blk tag / e att typ val)
  (setq tag (strcase tag T))
  (setq e blk
        val nil
  )

  (while (and e (null val) (setq e (entnext e)))
    (setq att (entget e)
          typ (cdr (assoc 0 att))
    )
    (cond
      ((= typ "ATTRIB")
       (if (= tag (strcase (cdr (assoc 2 att)) T))
         (setq val (cdr (assoc 1 att)))
       )
      )
      ((= typ "SEQEND")
       (setq e nil)
      )
    )
  )
  val
)

;; ------------------------------------------------------------
;; Wrapper pre rtos - ignoruje vplyv DIMZIN
;; aby sa zachovali trailing zeros [web:62][web:70]
;; ------------------------------------------------------------
(defun MyRtos (real units prec / oldDimzin result)
  (setq oldDimzin (getvar "DIMZIN"))
  (setvar "DIMZIN" 0)
  (setq result (rtos real units prec))
  (setvar "DIMZIN" oldDimzin)
  result
)

;; ------------------------------------------------------------
;; Prevod mm -> m, 3 desatinné miesta, desatinná čiarka
;; napr. "5725" -> "5,725"
;; ------------------------------------------------------------
(defun FormatMetersComma (mmStr /)
  (if (and mmStr (> (strlen mmStr) 0))
    (vl-string-subst "," "." (MyRtos (/ (atof mmStr) 1000.0) 2 3))
    ""
  )
)

;; ------------------------------------------------------------
;; Vráti selection set všetkých referencií bloku podľa EffectiveName
;; vrátane anonymných / dynamických referencií
;; ------------------------------------------------------------
(defun GetBlockRefsByEffectiveName (blkName / ssNorm ssAnon ssOut i ent)
  (setq ssOut (ssadd))

  ;; Normálne referencie podľa mena
  (if (setq ssNorm (ssget "_X" (list '(0 . "INSERT") (cons 2 blkName))))
    (progn
      (setq i 0)
      (while (< i (sslength ssNorm))
        (ssadd (ssname ssNorm i) ssOut)
        (setq i (1+ i))
      )
    )
  )

  ;; Anonymné dynamické referencie *U*
  (if (setq ssAnon (ssget "_X" '((0 . "INSERT") (2 . "`*U*"))))
    (progn
      (setq i 0)
      (while (< i (sslength ssAnon))
        (setq ent (ssname ssAnon i))
        (if (= (strcase (GetBlockEffectiveName ent) T)
               (strcase blkName T))
          (ssadd ent ssOut)
        )
        (setq i (1+ i))
      )
    )
  )

  ssOut
)

;; ------------------------------------------------------------
;; Hlavná funkcia exportu
;; ------------------------------------------------------------
(defun c:JTRebarTagExport
  (/ ss cnt blk
     paramCislo paramPopis
     priemer dlzka kusy
     slashPos minusPos rest kusyPart dlzkaMm
     csvPath csvFile rows row)

  (vl-load-com)

  ;; dialóg – užívateľ si vyberie / zadá CSV
  (setq csvPath
        (getfiled
          "Ulozit CSV subor"
          (strcat (getvar "DWGPREFIX") "PopisVystuze_export.csv")
          "csv"
          1
        )
  )

  (if (not csvPath)
    (progn
      (princ "\nZrusene uzivatelom.")
      (princ)
    )
    (progn
      ;; zoznam riadkov
      (setq rows '())

      ;; vyber aj normálne aj dynamické/anonymné referencie
      (setq ss (GetBlockRefsByEffectiveName "PopisVystuze"))

      (if (> (sslength ss) 0)
        (progn
          (setq cnt 0)
          (while (< cnt (sslength ss))
            (setq blk (ssname ss cnt))

            ;; atribúty
            (setq paramCislo (GetAttr blk "CISLO"))
            (setq paramPopis (GetAttr blk "POPIS"))

            ;; defaulty
            (setq priemer ""
                  dlzka   ""
                  kusy    ""
            )

            ;; parsuj Popis: "14/5725-20ks"
            (if (and paramPopis (> (strlen paramPopis) 0))
              (progn
                ;; pozícia "/"
                (setq slashPos (vl-string-search "/" paramPopis))
                (if slashPos
                  (progn
                    ;; priemer = pred "/"
                    (setq priemer (substr paramPopis 1 slashPos))

                    ;; zvyšok za "/"
                    (setq rest (substr paramPopis (+ slashPos 2)))

                    ;; pozícia "-" v zbytku
                    (setq minusPos (vl-string-search "-" rest))
                    (if minusPos
                      (progn
                        ;; dĺžka v mm ako text
                        (setq dlzkaMm (substr rest 1 minusPos))

                        ;; prevod mm -> m, 3 desatinné, s čiarkou
                        (setq dlzka (FormatMetersComma dlzkaMm))

                        ;; kusy + "ks" = za "-"
                        (setq kusyPart (substr rest (+ minusPos 2)))
                        (if kusyPart
                          (setq kusy (vl-string-right-trim "ksKS" kusyPart))
                        )
                      )
                    )
                  )
                )
              )
            )

            ;; pridaj riadok
            (setq rows
                  (cons
                    (list
                      (if paramCislo paramCislo "")
                      priemer
                      dlzka
                      kusy
                      (if paramPopis paramPopis "")
                    )
                    rows
                  )
            )

            (setq cnt (1+ cnt))
          )

          ;; zotriedenie podľa Cislo vzostupne numericky
          (setq rows
                (vl-sort
                  rows
                  '(lambda (a b)
                     (< (atoi (car a)) (atoi (car b)))
                   )
                )
          )

          ;; otvor CSV a zapíš
          (setq csvFile (open csvPath "w"))

          (if (not csvFile)
            (princ "\nNepodarilo sa otvorit CSV subor na zapis.")
            (progn
              ;; hlavička
              (write-line "Cislo;Priemer_mm;Dlzka_m;Pocet_kusov;Popis" csvFile)

              ;; riadky
              (foreach row rows
                (write-line
                  (strcat
                    (nth 0 row) ";"   ; Cislo
                    (nth 1 row) ";"   ; Priemer_mm
                    (nth 2 row) ";"   ; Dlzka_m
                    (nth 3 row) ";"   ; Pocet_kusov
                    (nth 4 row)       ; Popis
                  )
                  csvFile
                )
              )

              (close csvFile)
              (princ (strcat "\nCSV export ukonceny: " csvPath))
            )
          )
        )
        (princ "\nNenasli sa ziadne bloky 'PopisVystuze' ani ich dynamicke/anonymne referencie.")
      )
    )
  )

  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nRebar_functions.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;