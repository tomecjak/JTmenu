;=========================================================================
; Help.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Prekliknutie na stránku Help
;-------------------------------------------------------------------------

;definovanie funkcie prikazu "JTHelp"
(defun c:JTRebatTable (/ ss ent blk atts x lst)
  
  
  ;(setq cislo_vystuze (cons (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "PopisVystuze"))) 0) "Cislo") cislo_vystuze))
  ;(setq popis_vystuze (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "PopisVystuze"))) 0) "Popis"))
 
  
    (if (setq ss (ssget "X" '((0 . "INSERT") (66 . 1) (2 . "PopisVystuze") (410 . "Model"))))
    (foreach ent (vl-remove-if 'listp (mapcar 'cadr (ssnamex SS)))
      (setq blk (vlax-ename->vla-object ent)
            atts (vlax-safearray->list (vlax-variant-value (vla-getattributes blk)))
      )
      (foreach x atts
        (if (= (vla-get-tagstring x) "Cislo") 
          (setq lst (cons (atoi (vla-get-textstring x)) lst))
        )
      )
      
    )  
  )
  
    (if (setq ss (ssget "X" '((0 . "INSERT") (66 . 1) (2 . "PopisVystuze") (410 . "Model"))))
    (foreach ent (vl-remove-if 'listp (mapcar 'cadr (ssnamex SS)))
      (setq blk (vlax-ename->vla-object ent)
            atts (vlax-safearray->list (vlax-variant-value (vla-getattributes blk)))
      )
      (foreach x atts
        (if (= (vla-get-tagstring x) "Popis") 
          (setq lst2 (cons (atoi (vla-get-textstring x)) lst2))
        )
      )
      
    )  
  )

   
  (princ lst)
  (princ lst2)
  ;(princ popis_vystuze)
  (princ)
  
  
)

(defun LM:effectivename ( obj )
    (vlax-get-property obj
        (if (vlax-property-available-p obj 'effectivename)
            'effectivename
            'name
        )
    )
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nHelp.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;