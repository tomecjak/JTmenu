;=========================================================================
; VerticalLine.lsp
; Create by Lee Mac/Swamp  from https://www.lee-mac.com
; Edit by Jakub Tomecko
;
; Vytvorenie kolmice z krivky
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

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nVerticalLine.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;