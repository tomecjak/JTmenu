;=========================================================================
; Traffic_line.lsp
; Create by Jakub Tomecko
;
; Nastavenie sirky a typu ciary dopravnej polylinie podla typu komunikacie
;-------------------------------------------------------------------------

(defun c:DC60150 ( / *error* _StartUndo _EndUndo _LoadLinetype
                         doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (defun _StartUndo ( doc ) (vla-StartUndoMark doc))

  (defun _EndUndo   ( doc ) (if (= 8 (logand 8 (getvar 'UNDOCTL))) (vla-EndUndomark doc)))

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (initget 1 "Dialnica Mimo")
  (setq typ
    (getkword "\nZvolte typ komunikacie [Dialnica (0.15)/Mimo dialnice (0.12)] : ")
  )

  (cond
    ( (eq typ "Dialnica") (setq width 0.15 ltype "Continuous") )
    ( (eq typ "Mimo")     (setq width 0.12 ltype "Continuous") )
  )

  (_StartUndo doc)

  (while
    (progn
      (setq sel (entsel (strcat "\nVyberte polyliniu pre typ \"" typ "\" alebo [Enter na ukoncenie] : ")))
      (cond
        ( (null sel) nil )
        ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
          (princ "\nVybrany objekt nie je polylinia, skuste znova.")
          t
        )
        ( t
          (setq obj (vlax-ename->vla-object ent))
          (vla-put-ConstantWidth obj width)
          (vla-put-Linetype obj ltype)
          (vla-Update obj)
          t
        )
      )
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTraffic_line.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
