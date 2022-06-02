;=========================================================================
; Double_offset.lsp
; (c) Copyright 2011 Lee Mac
; Prelozil Jakub Tomecko
; Verzia: 1.1
;
; Ofset ciary do oboch smerov naraz
;-------------------------------------------------------------------------

;;--------------------=={ Dvojity Offset }==------------------;;
;;                                                            ;;
;;  Odsadi kazdy objek vo vybere na obe strany o zadanu       ;;
;;  vzdialenost. S dalsimi ovladacimi prvakmi na vymazenie    ;;
;;  zdrojoveho objektu a offset vrstvy.
;;------------------------------------------------------------;;

(defun c:DOFF nil (c:DoubleOffset))

(defun c:DoubleOffset ( / *error* _StartUndo _EndUndo DoubleOffset doc exitflag layer mpoint obj object of point sel symbol value )

  (defun *error* ( msg )    
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (defun _StartUndo ( doc ) (vla-StartUndoMark doc))

  (defun _EndUndo   ( doc ) (if (= 8 (logand 8 (getvar 'UNDOCTL))) (vla-EndUndomark doc)))
  
  (defun DoubleOffset ( object offset layer )
    (mapcar
      (function
        (lambda ( o )
          (if
            (and
              (not
                (vl-catch-all-error-p
                  (setq o
                    (vl-catch-all-apply
                      (function vlax-invoke) (list object 'Offset o)
                    )
                  )
                )
              )
              layer
            )
            (mapcar
              (function
                (lambda ( o )
                  (vla-put-layer o (getvar 'CLAYER))
                )
              )
              o
            )
          )
        )
      )
      (list offset (- offset))
    )
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (mapcar
    '(lambda ( symbol value ) (or (boundp symbol) (set symbol value)))
    '(*dOff:Erase *dOff:Layer) '("No" "Source")
  )

  (if
    (progn
      (while
        (progn
          (princ
            (strcat
              "\nAktualne nastavenie: Vymazat zdroj="
              *dOff:Erase
              "  Layer="
              *dOff:Layer
              "  OFFSETGAPTYPE="
              (itoa (getvar 'OFFSETGAPTYPE))
            )
          )
          (initget 6 "Through Erase Layer")
          (setq of
            (getdist
              (strcat "\nZadajte vzdialenost ofsetu [Through/Erase/Layer] <"
                (if (minusp (getvar 'OFFSETDIST)) "Through"  (rtos (getvar 'OFFSETDIST))) "> : "
              )
            )
          )
          (cond
            (
              (null of) (not (setq of (getvar 'OFFSETDIST)))
            )
            (
              (eq "Through" of) (setq of (setvar 'OFFSETDIST -1)) nil
            )
            (
              (eq "Erase" of) (initget "Yes No")

              (setq *dOff:Erase
                (cond
                  (
                    (getkword
                      (strcat "\nPo odsadeni vymazat zdrojovy objekt? [Yes/No] <" *doff:Erase "> : ")
                    )
                  )
                  ( *dOff:Erase )
                )
              )
            )
            (
              (eq "Layer" of) (initget "Current Source")

              (setq *dOff:Layer
                (cond
                  (
                    (getkword
                      (strcat "\nZadajte vrstvu pre odsadene objekty [Current/Source] <" *dOff:Layer "> : ")
                    )
                  )
                  ( *dOff:Layer )
                )
              )
            )
            ( of (setvar 'OFFSETDIST of) nil )
          )
        )
      )
      of
    )
    (while
      (progn
        (or ExitFlag
          (progn (initget "Exit")
            (setq sel (entsel "\nVyberte objket na odsadenia alebo [Exit] <Exit> : "))
          )
        )
        
        (cond
          (
            (or ExitFlag (null sel) (eq sel "Exit")) nil
          )
          ( (vl-consp sel)

            (_EndUndo doc) (_StartUndo doc)

            (if (and (wcmatch (cdr (assoc 0 (entget (car sel)))) "ARC,CIRCLE,ELLIPSE,SPLINE,LWPOLYLINE,XLINE,LINE")
                     (setq obj (vlax-ename->vla-object (car sel))))

              (if (minusp of)
                (if
                  (progn (initget "Exit Multiple")
                    (and
                      (setq point (getpoint "\nUvedte priamy bod alebo [Exit/Multiple] <Exit> : "))
                      (not (eq "Exit" point))
                    )
                  )
                  (if (eq "Multiple" point)
                    (while
                      (progn (initget "Exit")
                        (setq mpoint (getpoint "\nUvedte priamy bod alebo [Exit] <next object> : "))

                        (cond
                          (
                            (eq "Exit" mpoint)

                            (if (eq "Yes" *dOff:Erase) (vla-delete obj))

                            (not (setq ExitFlag t))
                          )
                          (
                            (null mpoint)

                            (if (eq "Yes" *dOff:Erase) (vla-delete obj))

                            nil
                          )
                          (
                            (listp mpoint)
                           
                            (DoubleOffset obj
                              (distance (trans mpoint 1 0)
                                (vlax-curve-getClosestPointto (car sel) (trans mpoint 1 0) t)
                              )
                              (eq "Current" *dOff:Layer)
                            )
                           t
                          )
                        )
                      )
                    )
                    (progn
                      (DoubleOffset obj
                        (distance (trans point 1 0)
                          (vlax-curve-getClosestPointto (car sel) (trans point 1 0) t)
                        )
                        (eq "Current" *dOff:Layer)
                      )
                      (if (eq "Yes" *dOff:Erase) (vla-delete obj))
                     t
                    )
                  )
                  (setq ExitFlag t)
                )
                (progn
                  (DoubleOffset obj of (eq "Current" *dOff:Layer))

                  (if (eq "Yes" *dOff:Erase) (vla-delete obj))
                )
              )
              (princ "\n** Nemozem odsadit objekt **")
            )
           t
          )
        )
      )
    )
  )  
  (_EndUndo doc) (princ)
)   

;;------------------------------------------------------------;;
;;                         End of File                        ;;
;;------------------------------------------------------------;;