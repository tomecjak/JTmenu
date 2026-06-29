(vl-load-com)

(defun pt2d (p) (list (car p) (cadr p)))
(defun zval (p) (if (and p (caddr p)) (caddr p) 0.0))

(defun curve-pts (e / end i pts)
  (setq end (fix (vlax-curve-getEndParam e)))
  (setq i 0 pts '())
  (while (<= i end)
    (setq pts (cons (vlax-curve-getPointAtParam e i) pts))
    (setq i (1+ i))
  )
  (reverse pts)
)

(defun lowest-pt (pts / m)
  (setq m (car pts))
  (foreach p pts
    (if (< (zval p) (zval m)) (setq m p))
  )
  m
)

(defun line-x-at-y (p1 p2 y / x1 y1 x2 y2 t)
  (setq x1 (car p1) y1 (cadr p1) x2 (car p2) y2 (cadr p2))
  (if (equal y1 y2 1e-12)
    nil
    (setq t (/ (- y y1) (- y2 y1)))
  )
  (if (and t (<= 0.0 t) (<= t 1.0))
    (+ x1 (* t (- x2 x1)))
    nil
  )
)

(defun segment-area-below (p1 p2 ybase yh / x1 y1 x2 y2 xa xb ya yb xa2 xb2 h1 h2)
  (setq x1 (car p1) y1 (cadr p1) x2 (car p2) y2 (cadr p2))
  (cond
    ((and (<= y1 yh) (<= y2 yh))
     (* 0.5 (+ (- y1 ybase) (- y2 ybase)) (abs (- x2 x1)))
    )
    ((and (> y1 yh) (> y2 yh)) 0.0)
    (T
     (if (< y1 y2)
       (progn (setq xa x1 ya y1 xb x2 yb y2))
       (progn (setq xa x2 ya y2 xb x1 yb y1))
     )
     (setq xa2 (line-x-at-y (list xa ya 0.0) (list xb yb 0.0) yh))
     (if xa2
       (if (<= ya yh)
         (* 0.5 (+ (- ya ybase) (- yh ybase)) (abs (- xa2 xa)))
         (* 0.5 (+ (- yh ybase) (- yb ybase)) (abs (- xb xa2)))
       )
       0.0
     )
    )
  )
)

(defun area-below-level (pts yh / ybase area i p1 p2)
  (setq ybase (apply 'min (mapcar 'cadr pts)))
  (setq area 0.0
        i 0)
  (while (< i (1- (length pts)))
    (setq p1 (nth i pts)
          p2 (nth (1+ i) pts))
    (setq area (+ area (segment-area-below p1 p2 ybase yh)))
    (setq i (1+ i))
  )
  area
)

(defun draw-level-line (pts yh / xs xe y mid)
  (setq xs nil xe nil)
  (foreach p pts
    (if (or (null xs) (< (car p) xs)) (setq xs (car p)))
    (if (or (null xe) (> (car p) xe)) (setq xe (car p)))
  )
  (entmakex
    (list
      '(0 . "LINE")
      (cons 10 (list (- xs 1.0) yh 0.0))
      (cons 11 (list (+ xe 1.0) yh 0.0))
    )
  )
)

(defun c:Q100OPENREAL (/ e obj pts lowpt lowz q100 yh area besth ln)
  (setq e (car (entsel "\nVyber otvorenú polyline: ")))
  (if (and e (member (cdr (assoc 0 (entget e))) '("LWPOLYLINE" "POLYLINE")))
    (progn
      (setq q100 (getreal "\nZadaj Q100: "))
      (setq obj (vlax-ename->vla-object e))
      (setq pts (curve-pts e))
      (setq lowpt (lowest-pt pts))
      (setq lowz (cadr lowpt))
      (setq yh lowz)
      (setq besth yh)

      (while (<= yh (+ lowz 100000.0))
        (setq area (area-below-level pts yh))
        (if (> area q100)
          (progn
            (setq besth yh)
            (setq ln (draw-level-line pts yh))
            (setq Hhladina (- yh lowz))
            (princ (strcat "\nHladina: " (rtos yh 2 3)))
            (princ (strcat "\nHhladina: " (rtos Hhladina 2 3)))
            (setq yh (+ lowz 1000000.0))
          )
          (setq yh (+ yh 0.01))
        )
      )

      (if (null ln)
        (princ "\nNenašla sa hladina, pri ktorej by plocha prekročila Q100.")
      )
    )
    (princ "\nNie je vybraná polyline.")
  )
  (princ)
)