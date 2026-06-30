;=========================================================================
; JT_lib.lsp
; Create by Jakub Tomecko
;
; Zdielana kniznica pomocnych funkcii pre JTmenu.
; Tento subor sa nacitava ako prvy v JTmenu.mnl, takze vsetky tu
; definovane funkcie su dostupne globalne pre ostatne moduly.
; Cielom je odstranit duplicitu (Lee Mac helpery boli predtym
; nadefinovane vo viacerych suboroch) a zjednotit opakovane vzorce.
;-------------------------------------------------------------------------

(vl-load-com)

;;----------------------------------------------------------------------;;
;;                     Mierka pre vkladane bloky                        ;;
;;----------------------------------------------------------------------;;

;; Mierka pre bezne bloky z globalnej premennej GlobalnaBlocksScale.
;; Povodne sa vsade opakoval vzorec:
;;   (/ (atof (getenv "GlobalnaBlocksScale")) 1000)
(defun JT:BlockScale ( )
  (/ (atof (getenv "GlobalnaBlocksScale")) 1000.0)
)

;; Mierka pre bloky dopravneho znacenia z GlobalnaSignBlocksScale.
(defun JT:SignScale ( )
  (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000.0)
)

;;----------------------------------------------------------------------;;
;;                  Lee Mac - praca s Undo a dokumentom                 ;;
;;----------------------------------------------------------------------;;

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Closes an Undo Group.
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)

;;----------------------------------------------------------------------;;
;;                       Lee Mac - matematika                           ;;
;;----------------------------------------------------------------------;;

;; Round to Multiple  -  Lee Mac
;; Rounds 'n' to the nearest multiple of 'm'
(defun LM:roundm ( n m )
  (* m (fix ((if (minusp n) - +) (/ n (float m)) 0.5)))
)

;;----------------------------------------------------------------------;;

(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nJT_lib.lsp | " (JTmenuVersion) " | Lee Mac, Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
