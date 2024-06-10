;=========================================================================
; VerticalLine.lsp
; Create by Lee Mac/Swamp  from https://www.lee-mac.com
; Edit by Jakub Tomecko
;
; Vytvorenie kolmicez krivky
;-------------------------------------------------------------------------

(defun c:JTVerticalLine (/ entity pt)
  (while (setq entity (car (entsel "\nVyberte krivku: ")))
    (while
    (setq pt (getpoint "\nVyberte bod pre nakreslenie kolmice: "))
      (entmake (list '(0 . "LINE") (cons 10 (trans pt 1 0))
        (cons 11 (vlax-curve-getClosestPointTo entity (trans pt 1 0))))
      )
    )
  )
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;