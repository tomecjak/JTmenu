;=========================================================================
; Auto_block_break.lsp
; (c) Copyright 2020 Lee Mac
; Prelozil Jakub Tomecko
; Verzia: 1.9
;
; Automaticke zarovnanie objektov a blokov
;-------------------------------------------------------------------------

;;-----------=={ Automaticke zarovnanie objektov a blokov }==-----------;;
;;                                                                      ;;
;;  Tento program umoznuje vlozit blok do urceneho bodu s okolitou      ;;
;;  geometriou orezanou na pravouhly obrys bloku. Program automaticky   ;;
;;  otoci blok tak, aby sa zarovnal s objektom krivky predchadzajucim   ;;
;;  bodom vlozenia bloku. Program najprv vyzve uzivatela, aby vybral    ;;
;;  blok, ktory sa ma vlozit. Po platnom vybere program vyzve uzivatela ;;
;;  aby zadal bod vlozenia bloku. Ak sa v bode bloku detekuje objekt    ;;
;;  krivky (oblúk, elepticke obluk, elipsa, kruh, ciara, XLine, Spline  ;;
;;  LWPolyline alebo Polyline), tak sa vlozeni blok autmaticky otoci,   ;;
;;  aby bol zarovnany s krivkou. 
;;                                                                      ;;
;;----------------------------------------------------------------------;;
;;  Autor:  Lee Mac, Copyright © 2010  -  www.lee-mac.com               ;;
;;----------------------------------------------------------------------;;
;;  Verzia: 1.9    -    2020-11-14                                      ;;
;;----------------------------------------------------------------------;;

(defun c:ABB ( / *error* blk obj ins sel tmp )

    (defun *error* ( msg )
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nChyba: " msg))
        )
        (princ)
    )

    (cond
        (   (= 4 (logand 4 (cdr (assoc 70 (tblsearch "layer" (getvar 'clayer))))))
            (princ "\nAktualna hladina je zamknuta.")
        )
        (   (progn
                (while
                    (not
                        (progn
                            (setvar 'errno 0)
                            (initget "Browse Name Rotation")
                            (princ (strcat "\nAutomaticka rotacia bloku: " (getenv "LMac\\ABBRotation")))
                            (setq sel
                                (entsel
                                    (strcat "\nVyberte blok [Browse/Name/Rotation]"
                                        (if (= "" (setq blk (getvar 'insname)))
                                            ": "
                                            (strcat " <" blk ">: ")
                                        )
                                    )
                                )
                            )
                            (cond
                                (   (= 7 (getvar 'errno))
                                    (prompt "\nChyba, skus to znova.")
                                )
                                (   (null sel)
                                    (not (if (= "" blk) (setq blk nil)))
                                )
                                (   (= "Rotation" sel)
                                    (initget "ON OFF")
                                    (setenv "LMac\\ABBRotation"
                                        (cond
                                            (   (getkword
                                                    (strcat "\nAutomaticka rotacia bloku [ON/OFF] <"
                                                        (getenv "LMac\\ABBRotation") ">: "
                                                    )
                                                )
                                            )
                                            (   (getenv "LMac\\ABBRotation")   )
                                        )
                                    )
                                    nil
                                )
                                (   (= "Name" sel)
                                    (while
                                        (not
                                            (or
                                                (= ""
                                                    (setq tmp
                                                        (getstring t
                                                            (strcat "\nSpecify block name"
                                                                (if (= "" blk) ": " (strcat " <" blk ">: "))
                                                            )
                                                        )
                                                    )
                                                )
                                                (tblsearch "block" tmp)
                                            )
                                        )
                                        (princ (strcat "\nBlok \"" tmp "\" nie je v aktualnom vykrese definovany."))
                                    )
                                    (cond
                                        (   (/= "" tmp) (setq blk tmp))
                                        (   (/= "" blk))
                                    )
                                )
                                (   (= "Browse" sel)
                                    (setq blk (getfiled "Select Block" "" "dwg" 16))
                                )
                                (   (listp sel)
                                    (if (/= "INSERT" (cdr (assoc 0 (entget (car sel)))))
                                        (prompt "\nObjekt musi byt blok.")
                                        (setq obj (vla-copy (vlax-ename->vla-object (car sel)))
                                              blk (LM:blockname obj)
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
                (not (or blk obj))
            )
        )
        (   (setq ins (getpoint (strcat "\nZadajte bod vlozenia pre " (vl-filename-base blk) " blok: ")))
            (LM:startundo (LM:acdoc))
            (if (null obj)
                (setq obj
                    (vla-insertblock
                        (vlax-get-property (LM:acdoc) (if (= 1 (getvar 'cvport)) 'paperspace 'modelspace))
                        (vlax-3D-point (trans ins 1 0))
                        blk
                        1.0
                        1.0
                        1.0
                        (angle '(0.0 0.0 0.0) (trans (getvar 'ucsxdir) 0 (trans '(0.0 0.0 1.0) 1 0 t) t))
                    )
                )
            )
            (if blk (setvar 'insname (vl-filename-base blk)))
            (vla-put-insertionpoint obj (vlax-3D-point (trans ins 1 0)))
            (LM:autoblockbreak (vlax-vla-object->ename obj) (= "ON" (getenv "LMac\\ABBRotation")))
            (LM:endundo (LM:acdoc))
        )
    )
    (princ)
)

;;-----------=={ Existujuce automaticke prerusenie bloku }==------------;;
;;                                                                      ;;
;;  Tento program umoznuje uzivatelovi vybrat existujuci blok a orezat  ;;
;;  vsetku okolitu geometriu na pravouhly obrus bloku. Volitelne        ;;
;;  program automaticky otoci vybrany blok, aby sa zarovnal s objektom  ;;
;;  krivky predchadzajucim bodom vlozenia bloku. Pri vyzve na vyber     ;;
;;  bloku moze uzivatel zmenit aj nastavenie rotacie. Ak sa v bode      ;;
;;  vlozenia bloku zvoleneho bloku zisti objekt krivky (Obluk,          ;;
;;  elipticky obluk, elipsa, kruh, ciara, XLine, Spline, LWPolyline     ;;
;;  alebo Polyline) a je povelene nastavenie rotacie, blok sa           ;;
;;  automaticky otoci, aby sa zarovnal s krivnou. Vsetky okolite        ;;
;;  kompatibilne objekty, o ktorych sa zistili, ze sa pretinaju         ;;
;;  s vybranym blokom, su potom orezane na obrys obdlznikoveho bloku    ;;
;;                                                                      ;;
;;----------------------------------------------------------------------;;
;;  Autor:  Lee Mac, Copyright © 2010  -  www.lee-mac.com               ;;
;;----------------------------------------------------------------------;;

(defun c:ABBE ( / *error* enx sel )

    (defun *error* ( msg )
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nChyba: " msg))
        )
        (princ)
    )
    
    (while
        (progn
            (setvar 'errno 0)
            (initget "Rotation")
            (princ (strcat "\nAutomaticka rotacia bloku: " (getenv "LMac\\ABBRotation")))
            (setq sel (entsel "\nVyberte blok k orezaniu [Rotation]: "))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nChyba, skus to znovu.")
                )
                (   (= "Rotation" sel)
                    (initget "ON OFF")
                    (setenv "LMac\\ABBRotation"
                        (cond
                            (   (getkword
                                    (strcat "\nAutomaticka rotacia bloku [ON/OFF] <"
                                        (getenv "LMac\\ABBRotation") ">: "
                                    )
                                )
                            )
                            (   (getenv "LMac\\ABBRotation")   )
                        )
                    )
                )
                (   (= 'ename (type (car sel)))
                    (cond
                        (   (/= "INSERT" (cdr (assoc 0 (setq enx (entget (car sel))))))
                            (princ "\nObjekt musi byt blok.")
                        )
                        (   (= 4 (logand 4 (cdr (assoc 70 (tblsearch "LAYER" (cdr (assoc 8 enx)))))))
                            (princ "\nVybrany blok je v zamknutej hladine.")
                        )
                        (   t
                            (LM:startundo (LM:acdoc))
                            (LM:AutoBlockBreak (car sel) (= "ON" (getenv "LMac\\ABBRotation")))
                            (LM:endundo   (LM:acdoc))
                        )
                    )
                    t
                )
            )
        )
    )
    (princ)
)

;;-------------=={ Automaticky vyber prerusenia bloku }==---------------;;
;;                                                                      ;;
;;  Tento program umoznuje uzivatelovi vybrat viacero existujicich      ;;
;;  blokov a automaicky orezat vsetku okolitu geometriu na pravouhly    ;;
;;  obrys kazdeho bloku. Volitelne program automaticky otoci kazdy blok ;;
;;  vo vybere, aby sa zarovnal so zistenymi objektmi krivky, aby presli ;;
;;  cez bod vlozenia bloku.                                             ;;
;;                                                                      ;;
;;----------------------------------------------------------------------;;
;;  Autor:  Lee Mac, Copyright © 2010  -  www.lee-mac.com               ;;
;;----------------------------------------------------------------------;;

(defun c:ABBS ( / *error* inc rot sel )

    (defun *error* ( msg )
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nChyba: " msg))
        )
        (princ)
    )
    
    (setq rot (= "ON" (getenv "LMac\\ABBRotation")))
    (if (setq sel (ssget "_:L" '((0 . "INSERT"))))
        (progn
            (LM:startundo (LM:acdoc))
            (repeat (setq inc (sslength sel))
                (LM:AutoBlockBreak (ssname sel (setq inc (1- inc))) rot)
            )
            (LM:endundo (LM:acdoc))
        )
    )
    (princ)
)

;;-----------=={ Podfunkcia automatickeho prerusenia bloku }==----------;;
;;                                                                      ;;
;;  Po zavolani funkcie s argumentom VLA Block Reference Object,        ;;
;;  funkcia oreze vsetku okolitu kompatibilnu geometriu, ktora sa       ;;
;;  pretina s pravouhlym obrysom dodanej referencie bloku. Okrem toho,  ;;
;;  ak sa zisti, ze objekt s krivkou prechadza cez bod vlozenia bloku   ;;
;;  (alebo je v jeho blizkosti) a argument priznaku otacania ma         ;;
;;  nenulovu hodnotu, dodana referencia bloku sa otoci, aby sa          ;;
;;  zarovnala s krivkou.                                                ;;
;;                                                                      ;;
;;----------------------------------------------------------------------;;
;;  Autor: Lee Mac, Copyright © 2010 - www.lee-mac.com                  ;;
;;----------------------------------------------------------------------;;
;;  Argumenty:                                                          ;;
;;  ent - Block Reference Entity                                        ;;
;;  rot - Rotation flag (if T, block is aligned to curve)               ;;
;;----------------------------------------------------------------------;;

(defun LM:autoblockbreak ( ent rot / *error* _furthestapart ang bbx brk cmd crv di1 di2 enx idx ins int lst ply sel tmp )

    (defun *error* ( msg )
        (if (and (= 'vla-object (type ply)) (vlax-write-enabled-p ply))
            (vla-delete ply)
        )
        (if (= 'int (type cmd))
            (setvar 'cmdecho cmd)
        )
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nChyba: " msg))
        )
        (princ)
    )

    (defun _furthestapart ( lst / dis mxd out pt1 pt2 )
        (setq mxd 0.0)
        (while (setq pt1 (car lst))
            (foreach pt2 (setq lst (cdr lst))
                (if (< mxd (setq dis (distance pt1 pt2)))
                    (setq mxd dis
                          out (list pt1 pt2)
                    )
                )
            )
        )
        out
    )
  
    (if (and (= 'ename (type ent))
             (setq enx (entget ent))
             (= "INSERT" (cdr (assoc 0 enx)))
        )
        (progn
            (if
                (and
                    rot
                    (setq bbx (LM:blockboundingbox (vlax-ename->vla-object ent)))
                    (setq sel
                        (ssget "_C"
                            (trans (car   bbx) 0 1)
                            (trans (caddr bbx) 0 1)
                           '((0 . "ARC,ELLIPSE,CIRCLE,LINE,XLINE,SPLINE,*POLYLINE"))
                        )
                    )
                    (progn
                        (setq ins (trans (cdr (assoc 10 enx)) ent 0)
                              crv (ssname sel (1- (sslength sel)))
                              di1 (distance ins (vlax-curve-getclosestpointto crv ins))
                        )
                        (repeat (setq idx (1- (sslength sel)))
                            (setq tmp (ssname sel (setq idx (1- idx))))
                            (if (< (setq di2 (distance ins (vlax-curve-getclosestpointto tmp ins))) di1)
                                (setq di1 di2
                                      crv tmp
                                )
                            )
                        )
                        (< di1 1e-4)
                    )
                    (setq par (vlax-curve-getparamatpoint crv (vlax-curve-getclosestpointto crv ins)))
                    (cond
                        (   (equal par (vlax-curve-getendparam crv) 1e-8)
                            (setq  par (vlax-curve-getparamatdist crv (- (vlax-curve-getdistatparam crv par) 1e-3)))
                        )
                        (   (equal par (vlax-curve-getstartparam crv) 1e-8)
                            (setq  par (vlax-curve-getparamatdist crv (+ (vlax-curve-getdistatparam crv par) 1e-3)))
                        )
                        (   t   )
                    )
                    (setq der (vlax-curve-getfirstderiv crv par))
                    (setq ang (angle '(0.0 0.0 0.0) (trans der 0 (cdr (assoc 210 (entget crv))))))
                    (or (<= ang (/ pi 2.0))
                        (< (/ (* 3.0 pi) 2.0) ang)
                        (setq ang (+ ang pi))
                    )
                )
                (vla-put-rotation (vlax-ename->vla-object ent) ang) ;; VL used to account for attributes
            )
            (if
                (and
                    (setq bbx (LM:blockboundingbox (vlax-ename->vla-object ent)))
                    (setq sel
                        (ssget "_C"
                            (trans (car   bbx) 0 1)
                            (trans (caddr bbx) 0 1)
                           '((0 . "ARC,ELLIPSE,CIRCLE,LINE,XLINE,SPLINE,*POLYLINE"))
                        )
                    )
                )
                (progn
                    (setq ply
                        (vlax-ename->vla-object
                            (entmakex
                                (append
                                    (list
                                       '(000 . "LWPOLYLINE")
                                       '(100 . "AcDbEntity")
                                       '(100 . "AcDbPolyline")
                                       '(090 . 4)
                                       '(070 . 1)
                                        (cons 38 (cadddr (assoc 10 enx)))
                                    )
                                    (mapcar '(lambda ( p ) (mapcar '+ (cons 10 (trans p 0 ent)) '(0 0 0))) bbx)
                                    (list (assoc 210 enx))
                                )
                            )
                        )
                    )
                    (repeat (setq idx (sslength sel))
                        (setq ent (ssname sel (setq idx (1- idx))))
                        (if (setq int (LM:Intersections (vlax-ename->vla-object ent) ply acextendthisentity))
                            (setq lst (cons (cons ent int) lst))
                        )
                    )
                    (vla-delete ply)
                    (setq cmd (getvar 'cmdecho))
                    (setvar 'cmdecho 0)
                    (foreach int lst
                        (if (setq brk (_furthestapart (cdr int)))
                            (command
                                "_.break" (list  (car int) (trans (car brk) 0 1)) "_F"
                                "_non"    (trans (car  brk) 0 1)
                                "_non"    (trans (cadr brk) 0 1)
                            )
                        )
                    )
                    (setvar 'cmdecho cmd)
                )
            )
        )
    )
    (princ)
)

;; Intersections  -  Lee Mac
;; Returns a list of all points of intersection between two objects.
;; obj1,obj2 - [vla] VLA-Objects with intersectwith method applicable
;; mode      - [int] acextendoption enum of intersectwith method
;; Returns: [lst] List of 3D WCS intersection points, else nil

(defun LM:intersections ( obj1 obj2 mode / l r )
    (setq l (vlax-invoke obj1 'intersectwith obj2 mode))
    (repeat (/ (length l) 3)
        (setq r (cons (list (car l) (cadr l) (caddr l)) r)
              l (cdddr l)
        )
    )
    (reverse r)
)

;;-------------------=={ Blok BoundingBox }==-----------------;;
;;                                                            ;;
;;  Vrati zoznam bodov popisujuci pravouhly ram ohranicujuci  ;;
;;  celu geometriu dodanej referencie bloku. Nazahrna Text,   ;;
;;  MText a Attribute Definitions.
;;------------------------------------------------------------;;
;;  Autor: Lee Mac, Copyright © 2013 - www.lee-mac.com        ;;
;;------------------------------------------------------------;;
;;  Argumenty:                                                ;;
;;  blk - VLA Block Reference Object                          ;;
;;------------------------------------------------------------;;
;;  Vrati: Zoznam bodov WCS popisujuci ohranicujuci ramcek    ;;
;;  bloku                                                     ;;
;;------------------------------------------------------------;;

(defun LM:blockboundingbox ( blk / bnm llp lst urp )
    (setq bnm (strcase (vla-get-name blk)))
    (cond
        (   (setq lst (cdr (assoc bnm LM:blockboundingbox:cache))))
        (   (progn
                (vlax-for obj (vla-item (LM:acblk) bnm)
                    (cond
                        (   (= "AcDbBlockReference" (vla-get-objectname obj))
                            (setq lst (append lst (LM:blockboundingbox obj)))
                        )
                        (   (and
                                (= :vlax-true (vla-get-visible obj))
                                (not (wcmatch (vla-get-objectname obj) "AcDbAttributeDefinition,AcDb*Text"))
                                (vlax-method-applicable-p obj 'getboundingbox)
                                (= :vlax-false (vla-get-freeze (vla-item (LM:aclyr) (vla-get-layer obj))))
                                (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-getboundingbox (list obj 'llp 'urp))))
                            )
                            (setq lst (vl-list* (vlax-safearray->list llp) (vlax-safearray->list urp) lst))
                        )
                    )
                )
                lst
            )
            (setq lst (mapcar '(lambda ( fun ) (apply 'mapcar (cons fun lst))) '(min max)))
            (setq lst
                (list
                    (car lst)
                    (list (caadr lst) (cadar lst))
                    (cadr lst)
                    (list (caar lst) (cadadr lst))
                )
            )
            (setq LM:blockboundingbox:cache (cons (cons bnm lst) LM:blockboundingbox:cache))
        )
    )
    (apply
        (function
            (lambda ( m v )
                (mapcar (function (lambda ( p ) (mapcar '+ (mxv m p) v))) lst)
            )
        )
        (refgeom (vlax-vla-object->ename blk))
    )
)

;; RefGeom (gile)
;; Returns a list which first item is a 3x3 transformation matrix (rotation,
;; scales, normal) and second item the object insertion point in its parent
;; (xref, block or space)
;;
;; Argument : an ename

(defun refgeom ( ent / ang ang mat ocs )
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

;; Matrix x Vector - Vladimir Nesterovsky
;; Args: m - nxn matrix, v - vector in R^n

(defun mxv ( m v )
    (mapcar '(lambda ( r ) (apply '+ (mapcar '* r v))) m)
)

;; Matrix Transpose - Doug Wilson
;; Args: m - nxn matrix

(defun trp ( m )
    (apply 'mapcar (cons 'list m))
)

;; Matrix x Matrix - Vladimir Nesterovsky
;; Args: m,n - nxn matrices

(defun mxm ( m n )
    ((lambda ( a ) (mapcar '(lambda ( r ) (mxv a r)) m)) (trp n))
)

;; Block Name  -  Lee Mac
;; Returns the true (effective) name of a supplied block reference
                        
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

;; Block Collection  -  Lee Mac
;; Returns the VLA Block Collection Object

(defun LM:acblk nil
    (eval (list 'defun 'LM:acblk 'nil (vla-get-blocks (LM:acdoc))))
    (LM:acblk)
)

;; Layer Collection  -  Lee Mac
;; Returns the VLA Layer Collection Object

(defun LM:aclyr nil
    (eval (list 'defun 'LM:aclyr 'nil (vla-get-layers (LM:acdoc))))
    (LM:aclyr)
)

;;----------------------------------------------------------------------;;

(if (null (getenv "LMac\\ABBRotation"))
    (setenv "LMac\\ABBRotation" "ON")
)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;