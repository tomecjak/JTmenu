;=========================================================================
; Create_polyline.lsp
; (c) Copyright 2026 Tomecko Jakub
;
; Program pre vytvorenie polyliny pre vytycenie
; na zaklade priecnych rezov a master krivky
;-------------------------------------------------------------------------

(vl-load-com)

(defun LM:intersections (obj1 obj2 mode / lst pts)
  (setq lst (vlax-invoke obj1 'intersectwith obj2 mode)
        pts nil
  )
  (if lst
    (repeat (/ (length lst) 3)
      (setq pts (cons (list (car lst) (cadr lst) (caddr lst)) pts)
            lst (cdddr lst))
    )
  )
  (reverse pts)
)

(defun curve-dist-safe (curve pt / cpt)
  (setq cpt (vlax-curve-getClosestPointTo curve pt)) ; [web:64]
  (vlax-curve-getDistAtPoint curve cpt)              ; [web:43]
)

(defun col-key-on-master (master col / ipts pt d minD)
  (setq ipts (LM:intersections master col 0))
  (if ipts
    (progn
      (setq minD nil)
      (foreach pt ipts
        (setq d (curve-dist-safe master pt))
        (if (or (null minD) (< d minD)) (setq minD d))
      )
      minD
    )
  )
)

(defun pick-intersection-by-masterkey (rib col master key / ipts pt d best bestErr err)
  (setq ipts (LM:intersections rib col 0))
  (if ipts
    (progn
      (setq best nil bestErr nil)
      (foreach pt ipts
        (setq d (curve-dist-safe master pt))
        (setq err (abs (- d key)))
        (if (or (null bestErr) (< err bestErr))
          (setq best pt bestErr err)
        )
      )
      best
    )
  )
)

(defun list-set (lst idx val / i out)
  (setq i 0 out '())
  (foreach x lst
    (setq out (cons (if (= i idx) val x) out))
    (setq i (1+ i))
  )
  (reverse out)
)

(defun make-nils (n / out)
  (setq out '())
  (repeat n (setq out (cons nil out)))
  out
)

(defun c:JTCreatePolyline ( / masterE master ssCols ssRibs i n cols ribs
                            colData colObj key ribObj pt
                            grid row rowIdx colIdx
                            nRows nCols allPts)
  (setq allPts '())

  ;; 0) MASTER
  (prompt "\nVyber master polylinu (referencia pre poradie rezov): ")
  (setq masterE (car (entsel)))
  (if (not masterE) (progn (prompt "\nZiadna master krivka.") (exit)))
  (setq master (vlax-ename->vla-object masterE))

  ;; 1) STĹPCE
  (prompt "\nVyber vsetky rezy (LINE/LWPOLYLINE/POLYLINE): ")
  (setq ssCols (ssget '((0 . "LINE,LWPOLYLINE,POLYLINE"))))
  (if (not ssCols) (progn (prompt "\nZiadne rezy.") (exit)))

  (setq cols '()
        i (1- (sslength ssCols)))
  (while (>= i 0)
    (setq cols (append cols (list (vlax-ename->vla-object (ssname ssCols i)))))
    (setq i (1- i))
  )

  ;; 2) RIEBKY
  (prompt "\nVyber postupne jednotlivo pozdlzne polyliny (LINE/LWPOLYLINE/POLYLINE): ")
  (setq ssRibs (ssget '((0 . "LINE,LWPOLYLINE,POLYLINE"))))
  (if (not ssRibs) (progn (prompt "\nZiadne polyliny.") (exit)))

  (setq ribs '()
        i 0
        n (sslength ssRibs))
  (while (< i n)
    (setq ribs (append ribs (list (vlax-ename->vla-object (ssname ssRibs i)))))
    (setq i (1+ i))
  )

  ;; 3) Zoradiť stĺpce podľa master-key
  (setq colData '())
  (foreach colObj cols
    (setq key (col-key-on-master master colObj))
    (if key
      (setq colData (cons (list key colObj) colData))
    )
  )
  (if (null colData)
    (progn (prompt "\nZiaden rez nepretina master polylinu.") (exit))
  )
  (setq colData
    (vl-sort colData (function (lambda (a b) (< (car a) (car b))))) ; [web:29]
  )

  (setq nRows (length ribs))
  (setq nCols (length colData))

  ;; 4) Grid: pre každú riebku vytvor zoznam bodov v poradí stĺpcov
  (setq grid '()
        rowIdx 0)
  (foreach ribObj ribs
    (setq row (make-nils nCols)
          colIdx 0)
    (foreach colObj colData
      (setq pt (pick-intersection-by-masterkey ribObj (cadr colObj) master (car colObj)))
      (if pt
        (setq row (list-set row colIdx (list (car pt) (cadr pt))))
      )
      (setq colIdx (1+ colIdx))
    )
    (setq grid (append grid (list row)))
    (setq rowIdx (1+ rowIdx))
  )

  ;; 5) PRIEČNY cik-cak: iteruj cez stĺpce a pre každý stĺpec prejdi riebky
  (setq colIdx 0)
  (while (< colIdx nCols)
    ;; vyber "stĺpcový" zoznam bodov z gridu (z každej riebky bod s indexom colIdx)
    (setq rowIdx 0
          row '())
    (while (< rowIdx nRows)
      (setq pt (nth colIdx (nth rowIdx grid)))
      (if pt (setq row (append row (list pt))))
      (setq rowIdx (1+ rowIdx))
    )



    (setq allPts (append allPts row))
    (setq colIdx (1+ colIdx))
  )

  (if allPts
    (progn
      (entmakex
        (append
          (list (cons 0 "LWPOLYLINE")
                (cons 100 "AcDbEntity")
                (cons 100 "AcDbPolyline")
                (cons 90 (length allPts))
                (cons 70 0))
          (apply 'append
                 (mapcar '(lambda (p) (list (cons 10 (list (car p) (cadr p))))) allPts))
        )
      )
      (princ (strcat "\nVytvorena polylina obsahujuca " (itoa (length allPts)) " bodov."))
    )
    (prompt "\nZiadne priesecniky.")
  )

  (princ)
)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;