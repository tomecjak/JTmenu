(vl-load-com)

;; ------------------------------------------------------------
;; Layer lock support
;; ------------------------------------------------------------

(defun bx:unlock-locked-layers ( / doc lays lay lst)
  (setq doc  (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq lays (vla-get-Layers doc))
  (setq lst  '())

  (vlax-for lay lays
    (if (eq (vla-get-Lock lay) :vlax-true)
      (progn
        (if (not
              (vl-catch-all-error-p
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

;; ------------------------------------------------------------
;; Safe explode helpers
;; ------------------------------------------------------------

(defun bx:entity-type-match-p (obj type-list / oname)
  (setq oname (strcase (vla-get-ObjectName obj)))
  (member oname type-list)
)

(defun bx:explode-vla-object (obj)
  ;; Použijeme metódu Explode cez ActiveX, aby sme sa vyhli hláške "Select object".
  ;; Nie každý objekt ju podporuje, preto to dávame cez vl-catch-all-apply.
  (vl-catch-all-apply
    '(lambda ()
       (vla-Explode obj)
     )
  )
)

(defun bx:process-block-container (blk / items obj)
  ;; Najprv si objekty uložíme do zoznamu, aby sa kolekcia počas explode nemenila pod rukami
  (setq items '())
  (vlax-for obj blk
    (setq items (cons obj items))
  )
  (setq items (reverse items))

  ;; 1. kóty
  (foreach obj items
    (if (bx:entity-type-match-p obj '("ACDBDIMENSION"))
      (bx:explode-vla-object obj)
    )
  )

  ;; 2. polyliny
  (foreach obj items
    (if (bx:entity-type-match-p obj '("ACDBPOLYLINE" "ACDB2DPOLYLINE" "ACDB3DPOLYLINE"))
      (bx:explode-vla-object obj)
    )
  )

  ;; 3. leadery
  (foreach obj items
    (if (bx:entity-type-match-p obj '("ACDBLEADER" "ACDBMLEADER"))
      (bx:explode-vla-object obj)
    )
  )

  ;; 4. mtext
  (foreach obj items
    (if (bx:entity-type-match-p obj '("ACDBMTEXT"))
      (bx:explode-vla-object obj)
    )
  )

  ;; 5. bloky
  (foreach obj items
    (if (bx:entity-type-match-p obj '("ACDBBLOCKREFERENCE"))
      (bx:explode-vla-object obj)
    )
  )
)

(defun bx:explode-nested-blocks-in-container (blk / i)
  ;; viac priechodov kvôli vnoreným blokom
  (repeat 10
    (bx:process-block-container blk)
  )
)

;; ------------------------------------------------------------
;; Model + layouts
;; ------------------------------------------------------------

(defun bx:process-model-space ( / doc ms)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq ms  (vla-get-ModelSpace doc))
  (bx:explode-nested-blocks-in-container ms)
)

(defun bx:process-layouts ( / doc lays lay)
  (setq doc  (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq lays (vla-get-Layouts doc))

  (vlax-for lay lays
    ;; Layouts obsahuje aj Model, ten preskočíme, lebo ten riešime zvlášť
    (if (= :vlax-false (vla-get-ModelType lay))
      (bx:explode-nested-blocks-in-container (vla-get-Block lay))
    )
  )
)

;; ------------------------------------------------------------
;; Cleanup
;; ------------------------------------------------------------

(defun bx:flush-command-stack ()
  ;; ak by niečo predsa ostalo visieť v command stacku
  (while (> (getvar "CMDACTIVE") 0)
    (command "")
  )
)

;; ------------------------------------------------------------
;; Main
;; ------------------------------------------------------------

(defun c:BX_PROCESS_CURRENT ( / doc lockedLayers)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setvar "CMDECHO" 0)
  (setvar "NOMUTT" 1)

  (setq lockedLayers (bx:unlock-locked-layers))

  ;; Model Space
  (bx:process-model-space)

  ;; Všetky layouty / paper space bloky
  (bx:process-layouts)

  (bx:restore-locked-layers lockedLayers)
  (bx:flush-command-stack)

  (vla-save doc)
  (princ)
)