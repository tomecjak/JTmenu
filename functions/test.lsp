(vl-load-com)

(setq *AREA-SCALE-TO-M2* 1) ; ak sú výkresové jednotky v mm, plocha / 1 000 000 = m2

(defun _pl-pts (e / obj end i pts)
  (setq obj (vlax-ename->vla-object e))
  (setq end (fix (vlax-curve-getEndParam e)))
  (setq i 0
        pts '())
  (while (<= i end)
    (setq pts (cons (vlax-curve-getPointAtParam e i) pts))
    (setq i (1+ i))
  )
  (reverse pts)
)

(defun _min-y (pts / m)
  (setq m (car pts))
  (foreach p pts
    (if (< (cadr p) (cadr m)) (setq m p))
  )
  m
)

(defun _max-y (pts / m)
  (setq m (car pts))
  (foreach p pts
    (if (> (cadr p) (cadr m)) (setq m p))
  )
  m
)

(defun _segment-area-below (p1 p2 y0 yh / x1 y1 x2 y2 ratio xi)
  (setq x1 (car p1) y1 (cadr p1)
        x2 (car p2) y2 (cadr p2))

  (cond
    ((and (<= y1 yh) (<= y2 yh))
     (* 0.5 (+ (- y1 y0) (- y2 y0)) (abs (- x2 x1)))
    )
    ((and (> y1 yh) (> y2 yh))
     0.0
    )
    (T
     (setq ratio (/ (- yh y1) (- y2 y1)))
     (setq xi (+ x1 (* ratio (- x2 x1))))
     (cond
       ((<= y1 yh)
        (* 0.5 (+ (- y1 y0) (- yh y0)) (abs (- xi x1)))
       )
       (T
        (* 0.5 (+ (- yh y0) (- y2 y0)) (abs (- x2 xi)))
       )
     )
    )
  )
)

(defun _area-below (pts yh / y0 area i p1 p2)
  (setq y0 (cadr (_min-y pts)))
  (setq area 0.0
        i 0)
  (while (< i (1- (length pts)))
    (setq p1 (nth i pts))
    (setq p2 (nth (1+ i) pts))
    (setq area (+ area (_segment-area-below p1 p2 y0 yh)))
    (setq i (1+ i))
  )
  area
)

(defun _draw-level (pts yh / xs xe)
  (setq xs (caar pts)
        xe (caar pts))
  (foreach p pts
    (if (< (car p) xs) (setq xs (car p)))
    (if (> (car p) xe) (setq xe (car p)))
  )
  (entmakex
    (list
      '(0 . "LINE")
      (cons 10 (list (- xs 1.0) yh 0.0))
      (cons 11 (list (+ xe 1.0) yh 0.0))
    )
  )
)

(defun c:Q100OPENFAST (/ e q100 q100dwg pts lowpt lowz miny maxy lo hi mid area areaM2 iter lineEnt Hhladina)
  (setq e (car (entsel "\nVyber otvorenú polyline: ")))
  (cond
    ((null e)
     (princ "\nNebola vybraná polyline.")
    )
    ((not (member (cdr (assoc 0 (entget e))) '("LWPOLYLINE" "POLYLINE")))
     (princ "\nVybraný objekt nie je polyline.")
    )
    (T
     (setq q100 (getreal "\nZadaj Q100 v m2: "))
     (setq pts (_pl-pts e))
     (setq lowpt (_min-y pts))
     (setq lowz (cadr lowpt))
     (setq miny lowz)
     (setq maxy (cadr (_max-y pts)))
     (setq lo miny)
     (setq hi maxy)
     (setq iter 0)

     (if (<= (/ (_area-below pts hi) *AREA-SCALE-TO-M2*) q100)
       (princ "\nAj pri najvyššej hladine je plocha menšia alebo rovná Q100.")
       (progn
         (while (< iter 40)
           (setq mid (/ (+ lo hi) 2.0))
           (setq area (_area-below pts mid))
           (setq areaM2 (/ area *AREA-SCALE-TO-M2*))
           (if (> areaM2 q100)
             (setq hi mid)
             (setq lo mid)
           )
           (setq iter (1+ iter))
         )

         (setq lineEnt (_draw-level pts hi))
         (setq Hhladina (- hi lowz))

         (princ (strcat "\nDefinitívna hladina: " (rtos hi 2 3)))
         (princ (strcat "\nPlocha pri hladine: " (rtos (/ (_area-below pts hi) *AREA-SCALE-TO-M2*) 2 4) " m2"))
         (princ (strcat "\nHhladina: " (rtos Hhladina 2 3)))
         (princ (strcat "\nPočet iterácií: " (itoa iter)))
       )
     )
    )
  )
  (princ)
)