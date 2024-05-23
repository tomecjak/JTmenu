;=========================================================================
; Block_base_point.lsp
; Create by Lee Mac from https://www.lee-mac.com
; Edit by Jakub Tomecko
;
; Zmena zakladneho bodu v bloku v modeli
;-------------------------------------------------------------------------

;;------------=={ Zmena zakladneho bodu v bloku v modeli }==------------;;
;;                                                                      ;;
;;  Program umoznuje vytvorit zakladny bod v bloku.                     ;;
;;                                                                      ;;
;;  Program ponuka dve prikazy:                                         ;;
;;                                                                      ;;
;;  ------------------------------------------------------------------  ;;
;;  CBP (Zmena zakladneho bodu)                                         ;;
;;  ------------------------------------------------------------------  ;;
;;                                                                      ;;
;;  Tento prikaz zachova suradnice bodu vlozenia pre vsetky referencie  ;;
;;  vybraneho bloku. Z vizualneho hladiska teda komponenty bloky budu   ;;
;;  pohybovat okolo bodu vlozenia, ked sa zmeni zakaldny bod            ;;
;;                                                                      ;;
;;  ------------------------------------------------------------------  ;;
;;  CBPR (Zmenit zakladny bod a ponechat referencnu polohu)             ;;
;;  ------------------------------------------------------------------  ;;
;;                                                                      ;;
;;  Tento prikaz zachova polohu referencie kazdeho bloku. Preto sa      ;;
;;  kazda referencia bloku presunie, aby sa zachovala vizualna poloha,  ;;
;;  ked sa zmeni zakladny bod.                                          ;;
;;----------------------------------------------------------------------;;

;; Zachova suradnice bodu vlozenia
(defun c:JTBlockBasePoint  nil (LM:changeblockbasepoint nil))

;; Zachova referencnu polohu bloku
(defun c:CBPR nil (LM:changeblockbasepoint t))

;;----------------------------------------------------------------------;;

(defun LM:changeblockbasepoint ( flg / *error* bln cmd ent lck mat nbp vec )

    (defun *error* ( msg )
        (foreach lay lck (vla-put-lock lay :vlax-true))
        (if (= 'int (type cmd)) (setvar 'cmdecho cmd))
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nChyba: " msg))
        )
        (princ)
    )

    (while
        (progn (setvar 'errno 0) (setq ent (car (entsel "\nVyberte block pre jeho zmenu basepointu: ")))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nChyba, skus to znova.")
                )
                (   (= 'ename (type ent))
                    (if (/= "INSERT" (cdr (assoc 0 (entget ent))))
                        (princ "\nVybrany objekt nie je block.")
                    )
                )
            )
        )
    )
    (if (and (= 'ename (type ent)) (setq nbp (getpoint "\nVyberte novy basepoint: ")))
        (progn
            (setq mat (car (revrefgeom ent))
                  vec (mxv mat (mapcar '- (trans nbp 1 0) (trans (cdr (assoc 10 (entget ent))) ent 0)))
                  bln (LM:blockname (vlax-ename->vla-object ent))
            )
            (LM:startundo (LM:acdoc))
            (vlax-for lay (vla-get-layers (LM:acdoc))
                (if (= :vlax-true (vla-get-lock lay))
                    (progn
                        (vla-put-lock lay :vlax-false)
                        (setq lck (cons lay lck))
                    )
                )
            )
            (vlax-for obj (vla-item (vla-get-blocks (LM:acdoc)) bln)
                 (vlax-invoke obj 'move vec '(0.0 0.0 0.0))
            )
            (if flg
                (vlax-for blk (vla-get-blocks (LM:acdoc))
                    (if (= :vlax-false (vla-get-isxref blk))
                        (vlax-for obj blk
                            (if
                                (and
                                    (= "AcDbBlockReference" (vla-get-objectname obj))
                                    (= bln (LM:blockname obj))
                                    (vlax-write-enabled-p obj)
                                )
                                (vlax-invoke obj 'move '(0.0 0.0 0.0) (mxv (car (refgeom (vlax-vla-object->ename obj))) vec))
                            )
                        )
                    )
                )
            )
            (if (= 1 (cdr (assoc 66 (entget ent))))
                (progn
                    (setq cmd (getvar 'cmdecho))
                    (setvar 'cmdecho 0)
                    (vl-cmdf "_.attsync" "_N" bln)
                    (setvar 'cmdecho cmd)
                )
            )
            (foreach lay lck (vla-put-lock lay :vlax-true))
            (vla-regen  (LM:acdoc) acallviewports)
            (LM:endundo (LM:acdoc))
        )
    )
  
    ;hlaska po skonceni programu
    (princ "\nBasepoint blocku bol zmeneny. ")
    (princ)
)

;; RefGeom (gile)
;; Vrati zoznam, ktoreho prvou polozkou je transformacna matica 3x3 a 
;; druha polozka je bod vlozenia objektu v jeho rodicovi (xref, blok alebo medzera)

(defun refgeom ( ent / ang enx mat ocs )
    (setq enx (entget ent)
          ang (cdr (assoc 050 enx))
          ocs (cdr (assoc 210 enx))
    )
    (list
        (setq mat
            (mxm
                (mapcar '(lambda ( v ) (trans v 0 ocs t))
                   '(
                        (1.0 0.0 0.0)
                        (0.0 1.0 0.0)
                        (0.0 0.0 1.0)
                    )
                )
                (mxm
                    (list
                        (list (cos ang) (- (sin ang)) 0.0)
                        (list (sin ang) (cos ang)     0.0)
                       '(0.0 0.0 1.0)
                    )
                    (list
                        (list (cdr (assoc 41 enx)) 0.0 0.0)
                        (list 0.0 (cdr (assoc 42 enx)) 0.0)
                        (list 0.0 0.0 (cdr (assoc 43 enx)))
                    )
                )
            )
        )
        (mapcar '- (trans (cdr (assoc 10 enx)) ocs 0)
            (mxv mat (cdr (assoc 10 (tblsearch "block" (cdr (assoc 2 enx))))))
        )
    )
)

;; RevRefGeom (gile)
;; Inverzia RefGeom

(defun revrefgeom ( ent / ang enx mat ocs )
    (setq enx (entget ent)
          ang (cdr (assoc 050 enx))
          ocs (cdr (assoc 210 enx))
    )
    (list
        (setq mat
            (mxm
                (list
                    (list (/ 1.0 (cdr (assoc 41 enx))) 0.0 0.0)
                    (list 0.0 (/ 1.0 (cdr (assoc 42 enx))) 0.0)
                    (list 0.0 0.0 (/ 1.0 (cdr (assoc 43 enx))))
                )
                (mxm
                    (list
                        (list (cos ang)     (sin ang) 0.0)
                        (list (- (sin ang)) (cos ang) 0.0)
                       '(0.0 0.0 1.0)
                    )
                    (mapcar '(lambda ( v ) (trans v ocs 0 t))
                        '(
                             (1.0 0.0 0.0)
                             (0.0 1.0 0.0)
                             (0.0 0.0 1.0)
                         )
                    )
                )
            )
        )
        (mapcar '- (cdr (assoc 10 (tblsearch "block" (cdr (assoc 2 enx)))))
            (mxv mat (trans (cdr (assoc 10 enx)) ocs 0))
        )
    )
)

;; Matrix x Vector  -  Vladimir Nesterovsky
;; Args: m - nxn matrix, v - vector in R^n

(defun mxv ( m v )
    (mapcar '(lambda ( r ) (apply '+ (mapcar '* r v))) m)
)

;; Matrix x Matrix  -  Vladimir Nesterovsky
;; Args: m,n - nxn matrices

(defun mxm ( m n )
    ((lambda ( a ) (mapcar '(lambda ( r ) (mxv a r)) m)) (trp n))
)

;; Matrix Transpose  -  Doug Wilson
;; Args: m - nxn matrix

(defun trp ( m )
    (apply 'mapcar (cons 'list m))
)

;; Block Name  -  Lee Mac
;; Vrati skutocny (efektivny) nazov dodanej referencie bloku
                        
(defun LM:blockname ( obj )
    (if (vlax-property-available-p obj 'effectivename)
        (defun LM:blockname ( obj ) (vla-get-effectivename obj))
        (defun LM:blockname ( obj ) (vla-get-name obj))
    )
    (LM:blockname obj)
)

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

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nBlock_base_point.lsp | " (JTmenuVersion) " | Lee Mac, prelozil: Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;