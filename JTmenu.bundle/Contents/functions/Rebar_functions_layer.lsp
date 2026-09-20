;=========================================================================
; Rebar_functions_layer.lsp
; Create (vibecode) by Jakub Tomecko
;
; Nastroje pre prace s vystuzou: prienik, fillet, zapis do atributu
;-------------------------------------------------------------------------


;;----------------------------------------------------------------------;;
;;                            Pomocne funkcie                           ;;
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
;;              Funkcia pre vytvorenie oblukov na polylin               ;;
;;----------------------------------------------------------------------;;


(defun c:JTRebarFilletLayer (/ ent ed D R)
  (vl-load-com)

  ;; vyber polyline (LWPOLYLINE)
  (setq ent (car (entsel "\nVyber polyline: ")))
  (if (null ent) (progn (prompt "\nZrusene.") (princ) (exit)))

  (setq ed (entget ent))

  ;; priemer výstuže v mm z názvu hladiny DP_Vystuz_XX
  (setq D (_rebar-get-diameter-from-layer ed))
  (if (or (null D) (<= D 0.0))
    (progn
      (prompt "\nZ nazvu hladiny sa nepodarilo zistit platny priemer (ocakavany tvar 'DP_Vystuz_XX').")
      (princ) (exit)
    )
  )

  (setq D (float D)) ; istota, ze je real

  ;; výpočet polomeru filletu (R v mm)
  (if (<= D 16.0)
    (setq R (+ (* 2.0 D) (/ D 2.0)))   ; (D*4)/2 + D/2
    (setq R (+ (* 3.5 D) (/ D 2.0)))   ; (D*7)/2 + D/2
  )

  ;; nastav fillet radius: predpoklad výkres v metroch => mm/1000
  (setvar "FILLETRAD" (/ R 1000.0))
  (prompt (strcat "\nD=" (rtos D 2 0) " mm, fillet R=" (rtos R 2 1) " mm."))

  ;; FILLET polyline (bez 'P' skratky, použijeme plnú voľbu)
  (command "_.FILLET" "_Polyline" ent)

  (prompt "\nHotovo.")
  (princ)
)


;;----------------------------------------------------------------------;;
;;                            Pomocne funkcie                           ;;
;;----------------------------------------------------------------------;;


;; LM:roundm je zdielana v JT_lib.lsp


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


;; priemer z nazvu hladiny DP_Vystuz_XX (číselná časť za posledným "_")
(defun _rebar-get-diameter-from-layer (ed / lay dstr dval)
  (setq lay  (cdr (assoc 8 ed)))
  (setq dstr (_digits-after-last-underscore lay))
  (if dstr
    (progn
      (setq dval (atoi dstr))
      (if (> dval 0) dval nil)
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


(defun c:JTRebarWriteLayer (/ plEnt plEd num lay cislo obj len kusy lenmm lenmm5 str blkEnt D)
  (vl-load-com)

  (setq plEnt (car (entsel "\nVyber polyline: ")))
  (if (null plEnt) (progn (prompt "\nNic nevybrane.") (princ) (exit)))

  (setq plEd (entget plEnt))

  ;; priemer výstuže v mm z názvu hladiny XX_Vystuz_XX
  (setq D (_rebar-get-diameter-from-layer plEd))
  (if (or (null D) (<= D 0.0))
    (progn
      (prompt "\nZ nazvu hladiny sa nepodarilo zistit platny priemer (ocakavany tvar 'XX_Vystuz_XX').")
      (princ) (exit)
    )
  )

  (setq D   (float D))
  (setq num (rtos D 2 0)) ; priemer v mm (string)

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
        (setq dist (/ (abs (/ D 1000)) 2))

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
      
  ;; dĺžka (v jednotkách výkresu) -> *1000 -> zaokrúhliť na 5  
  (setq lenmm (* len 1000.0))
  (setq lenmm5 (LM:roundm lenmm 5)) ; najbližší násobok 5

  (setq kusy (getstring "\nZadaj pocet kusov: "))
  (if (null kusy) (progn (prompt "\nZrusene.") (princ) (exit)))

  ;; do stringu dávam už zaokrúhlenú dĺžku v mm bez desatinných
  (setq str (strcat num "/" (rtos lenmm5 2 0) "-" kusy "ks"))

  (setq blkEnt (car (entsel "\nVyber blok (s atributmi POPIS): ")))
  (if (null blkEnt) (progn (prompt "\nZrusene.") (princ) (exit)))

  (if (_set-attr blkEnt "POPIS" str)
    (prompt (strcat "\nZapisane do POPIS: " str))
    (prompt "\nBlok nema atribut POPIS.")
  )

  (princ)
)

;;----------------------------------------------------------------------;;
;;                     Funkcia pre offset vystuze                       ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarOffsetLayer (/ *error* doc ent obj ed dist offVar1 offVar2 newObj1 newObj2
                               D lay)

  (vl-load-com)

  ;; pomocná funkcia: číslice za posledným "_"
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

  ;; priemer z nazvu hladiny DP_Vystuz_XX (číselná časť za posledným "_")
  (defun _rebar-get-diameter-from-layer (ed / lay dstr dval)
    (setq lay  (cdr (assoc 8 ed)))        ; layer name
    (setq dstr (_digits-after-last-underscore lay))
    (if dstr
      (progn
        (setq dval (atoi dstr))
        (if (> dval 0) dval nil)
      )
      nil
    )
  )

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
          ;; zisti priemer D (mm) z nazvu hladiny DP_Vystuz_XX
          (setq D (_rebar-get-diameter-from-layer ed))
          (if (or (null D) (<= D 0.0))
            (princ
              "\nZ nazvu hladiny sa nepodarilo zistit platny priemer (ocakavany tvar 'DP_Vystuz_XX')."
            )
            (progn
              (setq D (float D))
              ;; jednotky vykresu = metre, D je v mm -> polomer v m = D/1000/2
              (setq dist (/ D 2000.0))

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
                  " (m) od osi vystuze, vypocitane z priemeru "
                  (rtos D 2 0)
                  " mm."
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