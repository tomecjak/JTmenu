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
  ;; Dôležitá zmena: EXPLODE vždy voláme s entitou aj s "" na ukončenie,
  ;; takže príkaz nezostane visieť v stave "Select objects".
  (if (and en (entget en))
    (vl-catch-all-apply
      '(lambda ()
         (vl-cmdf "_.EXPLODE" en "")
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

;; ----------------------------------------------------------------------
;; Zamknuté hladiny – dočasne odomknúť a po skončení znova zamknúť
;; ----------------------------------------------------------------------

(defun bx:unlock-locked-layers ( / doc lays lay lst)
  (setq doc  (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq lays (vla-get-Layers doc))
  (setq lst  '())

  (vlax-for lay lays
    (if (eq (vla-get-Lock lay) :vlax-true)
      (progn
        (if (not (vl-catch-all-error-p
                   (vl-catch-all-apply
                     '(lambda () (vla-put-Lock lay :vlax-false))
                   )
                 )
            )
          (setq lst (cons (vla-get-Name lay) lst))
        )
      )
    )
  )
  lst
)

(defun bx:restore-locked-layers (locked-list / doc lays lay)
  (if locked-list
    (progn
      (setq doc  (vla-get-ActiveDocument (vlax-get-acad-object)))
      (setq lays (vla-get-Layers doc))

      (foreach name locked-list
        (vl-catch-all-apply
          '(lambda ()
             (setq lay (vla-Item lays name))
             (vla-put-Lock lay :vlax-true)
           )
        )
      )
    )
  )
)

;; ----------------------------------------------------------------------
;; Hlavný worker príkaz
;; ----------------------------------------------------------------------

(defun c:BX_PROCESS_CURRENT ( / doc lockedLayers)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setvar "CMDECHO" 0)
  (setvar "NOMUTT" 1)

  ;; dočasne odomkneme zamknuté hladiny
  (setq lockedLayers (bx:unlock-locked-layers))

  ;; poradie rozbíjania
  (bx:explode-type "DIMENSION")
  (bx:explode-type "LWPOLYLINE,POLYLINE")
  (bx:explode-type "LEADER,MULTILEADER")
  (bx:explode-type "MTEXT")
  (bx:explode-type "INSERT")
  (bx:explode-blocks-nested)

  ;; vrátime pôvodný stav zámkov
  (bx:restore-locked-layers lockedLayers)

  ;; bezpečnostný „zametač“ – ak by predsa len nejaký príkaz ešte bežal,
  ;; pošleme mu opakované Enter, kým CMDACTIVE > 0.
  (while (> (getvar "CMDACTIVE") 0)
    (command "")
  )

  (vla-save doc)
  (princ)
)