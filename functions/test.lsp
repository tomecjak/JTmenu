(vl-load-com)

(setq *AREA-SCALE-TO-M2* 1.0) ; metre => plocha už je v m2

(defun _pts (e / end i lst)
  (setq end (fix (vlax-curve-getEndParam e)))
  (setq i 0 lst '())
  (while (<= i end)
    (setq lst (cons (vlax-curve-getPointAtParam e i) lst))
    (setq i (1+ i))
  )
  (reverse lst)
)

(defun _minp (lst / m)
  (setq m (car lst))
  (foreach p lst (if (< (cadr p) (cadr m)) (setq m p)))
  m
)

(defun _maxp (lst / m)
  (setq m (car lst))
  (foreach p lst (if (> (cadr p) (cadr m)) (setq m p)))
  m
)

(defun _xint (p1 p2 y / y1 y2 x1 x2 t)
  (setq x1 (car p1) y1 (cadr p1) x2 (car p2) y2 (cadr p2))
  (if (equal y1 y2 1e-12)
    nil
    (progn
      (setq t (/ (- y y1) (- y2 y1)))
      (+ x1 (* t (- x2 x1)))
    )
  )
)

(defun _clip-below (pts yh / out p1 p2 in1 in2 xi)
  (setq out '())
  (while (cdr pts)
    (setq p1 (car pts) p2 (cadr pts))
    (setq in1 (<= (cadr p1) yh))
    (setq in2 (<= (cadr p2) yh))
    (cond
      ((and in1 in2)
       (if (null out) (setq out (list p1 p2)) (setq out (append out (list p2)))))
      ((and in1 (not in2))
       (setq xi (_xint p1 p2 yh))
       (if xi (setq out (append out (list (list xi yh 0.0)))))
      )
      ((and (not in1) in2)
       (setq xi (_xint p1 p2 yh))
       (if xi
         (setq out (append out (list (list xi yh 0.0) p2)))
         (setq out (append out (list p2)))
       )
      )
    )
    (setq pts (cdr pts))
  )
  out
)

(defun _poly-area (pts / a p1 p2)
  (if (< (length pts) 3)
    0.0
    (progn
      (setq a 0.0)
      (setq pts (append pts (list (car pts))))
      (while (cdr pts)
        (setq p1 (car pts) p2 (cadr pts))
        (setq a (+ a (- (* (car p1) (cadr p2)) (* (car p2) (cadr p1)))))
        (setq pts (cdr pts))
      )
      (/ (abs a) 2.0)
    )
  )
)

(defun _area-below (pts yh / cl minx maxx base poly)
  (setq cl (_clip-below pts yh))
  (if (< (length cl) 3)
    0.0
    (progn
      (setq minx (car (_minp pts)))
      (setq maxx (car (_maxp pts)))
      (setq poly
        (append
          cl
          (list (list maxx yh 0.0) (list minx yh 0.0))
        )
      )
      (_poly-area poly)
    )
  )
)

(defun _draw-level (pts yh / minx maxx)
  (setq minx (car (_minp pts)))
  (setq maxx (car (_maxp pts)))
  (entmakex
    (list
      '(0 . "LINE")
      (cons 10 (list (- minx 1.0) yh 0.0))
      (cons 11 (list (+ maxx 1.0) yh 0.0))
    )
  )
)

(defun c:Q100OPENPRECISE (/ e q100 pts lowp lowz lo hi mid am2 iter lineEnt Hhladina)
  (setq e (car (entsel "\nVyber otvorenú polyline: ")))
  (if (and e (member (cdr (assoc 0 (entget e))) '("LWPOLYLINE" "POLYLINE")))
    (progn
      (setq q100 (getreal "\nZadaj Q100 v m2: "))
      (setq pts (_pts e))
      (setq lowp (_minp pts))
      (setq lowz (cadr lowp))
      (setq lo lowz)
      (setq hi (cadr (_maxp pts)))
      (setq iter 0)

      (if (<= (/ (_area-below pts hi) *AREA-SCALE-TO-M2*) q100)
        (princ "\nAj pri najvyššej hladine je plocha menšia alebo rovná Q100.")
        (progn
          (repeat 40
            (setq mid (/ (+ lo hi) 2.0))
            (setq am2 (/ (_area-below pts mid) *AREA-SCALE-TO-M2*))
            (if (> am2 q100)
              (setq hi mid)
              (setq lo mid)
            )
            (setq iter (1+ iter))
          )
          (setq lineEnt (_draw-level pts hi))
          (setq Hhladina (- hi lowz))
          (princ (strcat "\nDefinitívna hladina: " (rtos hi 2 3)))
          (princ (strcat "\nHhladina: " (rtos Hhladina 2 3)))
          (princ (strcat "\nPlocha: " (rtos (/ (_area-below pts hi) *AREA-SCALE-TO-M2*) 2 4) " m2"))
        )
      )
    )
    (princ "\nNie je vybraná polyline.")
  )
  (princ)
)