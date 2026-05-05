(defun _splitcsv (s / p lst)
  (while (setq p (vl-string-search ";" s))
    (setq lst (cons (substr s 1 p) lst))
    (setq s (substr s (+ p 2)))
  )
  (reverse (cons s lst))
)

(defun c:POLYCSV (/ fn f line cols x y z pts)
  (vl-load-com)
  (setq fn (getfiled "Vyber CSV súbor zo súradnicami" "" "csv" 0))
  (if fn
    (progn
      (setq f (open fn "r"))
      (if f
        (progn
          (setq pts '())
          (read-line f) ; preskočí hlavičku

          (while (setq line (read-line f))
            (setq cols (_splitcsv line))
            (if (>= (length cols) 2)
              (progn
                (setq x (distof (nth 0 cols) 2))
                (setq y (distof (nth 1 cols) 2))
                (if (and x y)
                  (setq pts (append pts (list (list x y 0.0))))
                )
              )
            )
          )
          (close f)

          (if (>= (length pts) 2)
            (progn
              (command "_.PLINE")
              (foreach p pts (command p))
              (command "")
              (princ (strcat "\nVytvorená polyline z " (itoa (length pts)) " bodov."))
            )
            (princ "\nV CSV neboli nájdené aspoň 2 platné body.")
          )
        )
        (princ "\nSúbor sa nepodarilo otvoriť.")
      )
    )
  )
  (princ)
)