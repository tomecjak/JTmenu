(vl-load-com)

(defun bx:ss-to-list (ss / i lst)
  (setq i 0 lst '())
  (if ss
    (repeat (sslength ss)
      (setq lst (cons (ssname ss i) lst))
      (setq i (1+ i))
    )
  )
  (reverse lst)
)

(defun bx:explode-entity (en)
  (if (and en (entget en))
    (vl-catch-all-apply
      '(lambda ()
         (vl-cmdf "_.EXPLODE" en)
       )
    )
  )
)

(defun bx:explode-type (mask / ss lst)
  (setq ss (ssget "_X" (list (cons 0 mask))))
  (setq lst (bx:ss-to-list ss))
  (foreach en lst
    (bx:explode-entity en)
  )
)

(defun bx:explode-blocks-nested ()
  (repeat 10
    (bx:explode-type "INSERT")
  )
)

(defun c:BX_PROCESS_CURRENT ( / doc)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setvar "CMDECHO" 0)
  (setvar "NOMUTT" 1)

  ;; poradie rozbíjania – môžeš doladiť podľa potreby
  (bx:explode-type "DIMENSION")
  (bx:explode-type "LWPOLYLINE,POLYLINE")
  (bx:explode-type "LEADER,MULTILEADER")
  (bx:explode-type "MTEXT")
  (bx:explode-type "INSERT")
  (bx:explode-blocks-nested)

  (vla-save doc)
  (princ)
)