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

(defun c:JTRebarFillet (/ ent ed global_width D R)
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

(defun c:JTRebarWrite (/ plEnt plEd global_width num lay cislo obj len kusy lenmm lenmm5 str blkEnt)
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

  ;; dĺžka (v jednotkách výkresu) -> *1000 -> zaokrúhliť na 5
  (setq obj (vlax-ename->vla-object plEnt))
  (setq len (vlax-curve-getDistAtParam obj (vlax-curve-getEndParam obj))) ; [web:130]
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
