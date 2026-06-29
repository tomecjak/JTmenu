(vl-load-com)

(setq *AREA-SCALE-TO-M2* 1.0) ; keď kreslíš v metroch

(defun _ename->obj (e)
  (vlax-ename->vla-object e)
)

(defun _curve-pts (e / end i pts)
  (setq end (fix (vlax-curve-getEndParam e)))
  (setq i 0 pts '())
  (while (<= i end)
    (setq pts (cons (vlax-curve-getPointAtParam e i) pts))
    (setq i (1+ i))
  )
  (reverse pts)
)

(defun _min-x (pts / m)
  (setq m (car pts))
  (foreach p pts (if (< (car p) (car m)) (setq m p)))
  m
)

(defun _max-x (pts / m)
  (setq m (car pts))
  (foreach p pts (if (> (car p) (car m)) (setq m p)))
  m
)

(defun _min-y (pts / m)
  (setq m (car pts))
  (foreach p pts (if (< (cadr p) (cadr m)) (setq m p)))
  m
)

(defun _max-y (pts / m)
  (setq m (car pts))
  (foreach p pts (if (> (cadr p) (cadr m)) (setq m p)))
  m
)

(defun _interp-x (p1 p2 y / y1 y2 x1 x2 t)
  (setq x1 (car p1) y1 (cadr p1)
        x2 (car p2) y2 (cadr p2))
  (if (equal y1 y2 1e-12)
    nil
    (progn
      (setq t (/ (- y y1) (- y2 y1)))
      (+ x1 (* t (- x2 x1)))
    )
  )
)

(defun _segments (pts / lst)
  (setq lst '())
  (while (cdr pts)
    (setq lst (cons (list (car pts) (cadr pts)) lst))
    (setq pts (cdr pts))
  )
  (reverse lst)
)

(defun _clip-poly-below-y (pts yh / out pts2 p1 p2 xI inside1 inside2 xA xB)
  (setq out '())
  (setq pts2 pts)
  (while (cdr pts2)
    (setq p1 (car pts2) p2 (cadr pts2))
    (setq inside1 (<= (cadr p1) yh))
    (setq inside2 (<= (cadr p2) yh))
    (cond
      ((and inside1 inside2)
       (setq out (append out (list p2)))
      )
      ((and inside1 (not inside2))
       (setq xI (_interp-x p1 p2 yh))
       (setq out (append out (list (list xI yh 0.0))))
      )
      ((and (not inside1) inside2)
       (setq xI (_interp-x p1 p2 yh))
       (setq out (append out (list (list xI yh 0.0) p2)))
      )
    )
    (setq pts2 (cdr pts2))
  )
  out
)

(defun _area-polygon-2d (pts / a p1 p2)
  (setq a 0.0)
  (setq pts (append pts (list (car pts))))
  (while (cdr pts)
    (setq p1 (car pts) p2 (cadr pts))
    (setq a (+ a (- (* (car p1) (cadr p2)) (* (car p2) (cadr p1)))))
    (setq pts (cdr pts))
  )
  (/ (abs a) 2.0)
)

(defun _area-below-level (pts yh / clipped minx maxx basepoly area)
  (setq clipped (_clip-poly-below-y pts yh))
  (if (< (length clipped) 3)
    0.0
    (progn
      (setq minx (car (_min-x pts)))
      (setq maxx (car (_max-x pts)))
      (setq basepoly (list (list minx yh 0.0) (list maxx yh 0.0)))
      (setq clipped
        (append
          (list (last clipped))
          clipped
          basepoly
        )
      )
      (_area-polygon-2d clipped)
    )
  )
)

(defun _draw-level-line (pts yh / minx maxx)
  (setq minx (car (_min-x pts)))
  (setq maxx (car (_max-x pts)))
  (entmakex
    (list
      '(0 . "LINE")
      (cons 10 (list (- minx 1.0) yh 0.0))
      (cons 11 (list (+ maxx 1.0) yh 0.0))
    )
  )
)

(defun c:Q100OPENPRECISE (/ e q100 pts lowpt lowz miny maxy lo hi mid aM2 i lineEnt Hhladina)
  (setq e (car (entsel "\nVyber otvorenú polyline: ")))
  (if (and e (member (cdr (assoc 0 (entget e))) '("LWPOLYLINE" "POLYLINE")))
    (progn
      (setq q100 (getreal "\nZadaj Q100 v m2: "))
      (setq pts (_curve-pts e))
      (setq lowpt (_min-y pts))
      (setq lowz (cadr lowpt))
      (setq lo lowz)
      (setq hi (cadr (_max-y pts)))
      (setq i 0)

      (if (<= (/ (_area-below-level pts hi) *AREA-SCALE-TO-M2*) q100)
        (princ "\nAj pri najvyššej hladine je plocha menšia alebo rovná Q100.")
        (progn
          (repeat 40
            (setq mid (/ (+ lo hi) 2.0))
            (setq aM2 (/ (_area-below-level pts mid) *AREA-SCALE-TO-M2*))
            (if (> aM2 q100)
              (setq hi mid)
              (setq lo mid)
            )
            (setq i (1+ i))
          )
          (setq lineEnt (_draw-level-line pts hi))
          (setq Hhladina (- hi lowz))
          (princ (strcat "\nDefinitívna hladina: " (rtos hi 2 3)))
          (princ (strcat "\nHhladina: " (rtos Hhladina 2 3)))
          (princ (strcat "\nPlocha: " (rtos (/ (_area-below-level pts hi) *AREA-SCALE-TO-M2*) 2 4) " m2"))
        )
      )
    )
    (princ "\nNie je vybraná polyline.")
  )
  (princ)
)