;=========================================================================
; Renumbering.lsp
; (c) Copyright 2016 Lee Mac
; Prelozil Jakub Tomecko
; Verzia: 1.8
;
; Automaticke cislovanie objektov v poli
;-------------------------------------------------------------------------

;;------------------------=={ Prirastkove pole }==----------------------;;
;;                                                                      ;;
;;  Tento program usporiada vyber objektov, pricom bude zvysovat        ;;
;;  akykolvek ciselny obsah najdeny v objektoch anotacii v ramci vyberu ;;
;;  Program ma dve rezimy prevadzky: srandartny a dynamicky. Standartny ;;
;;  prikaz: "INCARRAY" nezobrazi dynamicky nahlad, ale zato pobezi      ;;
;;  rychlejsie a plynulejsie ako dynamicka verzia - tento rozdiel je    ;;
;;  obzvlast vyznamny pri pokuse o usporiadanie velkeho poctu objektov. ;;
;;  Dynamicky rezim: "INCARRAYD" zobrazi ukazku usporiadanych objektov, ;;
;;  ked sa mys potiahne po obrazovke. Vzhladom na metodu pouzitu na     ;;
;;  generovanie tohto nahladu je vsak tento rezim chodny len pri        ;;
;;  pouziti na zoskupenie maleho poctu objektov. Po spusteni programu   ;;
;;  sa uzivatelovi zobrazi vyzva na zadanie hodnoty prirastku a potom   ;;
;;  sa zobrazi vyzva na vuber objektov do pola. Tento vyber moze        ;;
;;  zahrnat akykolvek objekt kreslenia s vynimkou vyzerzov. Po platnom  ;;
;;  vybere by mal uzivatel specifikovat zakladny bod a vektor pola      ;;
;;  relativne k zakladnemu bodu. Uhol a dlzka tehto vektora urcia smer  ;;
;;  a hustotu pola, kratsi vektor bude mat za nasledok hustejsie pole.  ;;
;;  Pole mozno teraz generovat tahanim mysi po obrazovke, kym pole      ;;
;;  nedosiahne pozadovanu velkost. Ak vyber objektov zahrna objekty     ;;
;;  Text, MText, Attribute Definitions, Kóty alebo Multileader objekty, ;;
;;  všetky ciselne udaje najdene v textovom obsahu tychto objektov sa   ;;
;;  automaticky zvysia o danu hodnotu prirastku, ked je objekt          ;;
;;  usporiadani do pola.
;;----------------------------------------------------------------------;;

(defun c:INCARRAY  nil (LM:incarray nil)) ;; Standartna verzia
(defun c:INCARRAYD nil (LM:incarray  t )) ;; Dynamicka verzia

;;----------------------------------------------------------------------;;

(defun LM:incarray ( dyn / *error* bpt dim dis ept inc lst obl qty tmp vxu vxw )

    (defun *error* ( msg )
        (if (= 'int (type dim))
            (setvar 'dimzin dim)
        )
        (foreach obj obl
            (if (and (= 'vla-object (type obj)) (not (vlax-erased-p obj)) (vlax-write-enabled-p obj))
                (vla-delete obj)
            )
        )
        (incarray:endundo (incarray:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nChyba: " msg))
        )
        (redraw) (princ)
    )

    (if (not (and (setq inc (getenv "LMac\\incarray")) (setq inc (distof inc))))
        (setq inc 1)
    )
    (if (setq tmp (getreal (strcat "\nZadajte prirastok <" (incarray:num->str inc) ">: ")))
        (setenv "LMac\\incarray" (incarray:num->str (setq inc tmp)))
    )
    (incarray:startundo (incarray:acdoc))
    (setq dim (getvar 'dimzin))
    (setvar 'dimzin 0)
    (cond
        (   (not
                (and
                    (setq lst (incarray:selection->list (ssget "_:L" '((0 . "~VIEWPORT")))))
                    (setq bpt (getpoint "\nSpecify base point: "))
                    (progn
                        (while
                            (and
                                (setq vxu (getpoint "\nZadajte vektor pola: " bpt))
                                (equal bpt vxu 1e-8)
                            )
                            (princ "\nNeplatny vektor pola.")
                        )
                        vxu
                    )
                    (setq vxu (mapcar '- vxu bpt)
                          vxw (trans vxu 1 0 t)
                          dis (distance '(0.0 0.0 0.0) vxw)
                    )
                )
            )
        )
        (   dyn
            (princ "\nZadajte koncovy bod pola: ")
            (while (= 5 (car (setq ept (grread t 13 0))))
                (redraw)
                (foreach obj obl (vla-delete obj))
                (setq qty (/ (caddr (trans (mapcar '- (cadr ept) bpt) 1 vxw t)) dis)
                      obl (incarray:copyvector lst (mapcar (if (minusp qty) '- '+) vxw) (abs (fix qty)) inc)
                )
                (grvecs (list -3 bpt (mapcar '(lambda ( a b ) (+ (* a qty) b)) vxu bpt)))
            )
        )
        (   (setq ept (getpoint bpt "\nZadajte koncovy bod pola: "))
            (setq qty (fix (/ (caddr (trans (mapcar '- ept bpt) 1 vxw t)) dis)))
            (incarray:copyvector lst (mapcar (if (minusp qty) '- '+) vxw) (abs (fix qty)) inc)
        )
    )
    (setvar 'dimzin dim)
    (incarray:endundo (incarray:acdoc))
    (redraw) (princ)
)

;;----------------------------------------------------------------------;;

(defun incarray:num->str ( x / dim rtn )
    (if (equal x (atof (rtos x 2 0)) 1e-8)
        (rtos x 2 0)
        (progn
            (setq dim (getvar 'dimzin))
            (setvar 'dimzin 8)
            (setq rtn (vl-catch-all-apply 'rtos (list x 2 15)))
            (setvar 'dimzin dim)
            (if (not (vl-catch-all-error-p rtn)) rtn)
        )
    )
)

;;----------------------------------------------------------------------;;

(defun incarray:copyvector ( lst vec qty inc / cnt obj obl org )
    (setq org (vlax-3D-point 0 0)
          cnt 1
    )
    (repeat qty
        (foreach itm lst
            (setq obj (vla-copy (car itm))
                  obl (cons obj obl)
            )
            (vla-move obj org (vlax-3D-point (mapcar '* vec (list cnt cnt cnt))))
            (if (= "AcDbBlockReference" (vla-get-objectname obj))
                (mapcar
                    (function
                        (lambda ( att prp )
                            (vl-catch-all-apply 'vlax-put-property
                                (list att (car prp)
                                    (apply 'strcat
                                        (mapcar '(lambda ( x ) (incarray:increment x (* cnt inc)))
                                            (cdr prp)
                                        )
                                    )
                                )
                            )
                        )
                    )
                    (vlax-invoke obj 'getattributes)
                    (cdr itm)
                )
                (foreach prp (cdr itm)
                    (vlax-put-property obj (car prp)
                        (apply 'strcat
                            (mapcar '(lambda ( x ) (incarray:increment x (* cnt inc)))
                                (cdr prp)
                            )
                        )
                    )
                )
            )
        )
        (setq cnt (1+ cnt))
    )
    obl
)

;;----------------------------------------------------------------------;;

(defun incarray:selection->list ( sel / idx lst obj obn )
    (if sel
        (repeat (setq idx (sslength sel))
            (setq obj (vlax-ename->vla-object (ssname sel (setq idx (1- idx))))
                  obn (vla-get-objectname obj)
            )
            (if (and (= "AcDbBlockReference" obn) (= :vlax-true (vla-get-hasattributes obj)))
                (setq lst
                    (cons
                        (cons obj
                            (mapcar '(lambda ( a ) (vl-list* 'textstring (incarray:splitstring (vla-get-textstring a))))
                                (vlax-invoke obj 'getattributes)
                            )
                        )
                        lst
                    )
                )
                (setq lst
                    (cons
                        (cons obj
                            (mapcar '(lambda ( p ) (vl-list* p (incarray:splitstring (vlax-get-property obj p))))
                                (cond
                                    (   (wcmatch obn "AcDb*Text,AcDbMLeader") '(textstring))
                                    (   (wcmatch obn "AcDb*Dimension")        '(textoverride))
                                    (   (= "AcDbAttributeDefinition" obn)     '(tagstring promptstring textstring))
                                )
                            )
                        )
                        lst
                    )
                )
            )
        )
    )
)

;;----------------------------------------------------------------------;;

(defun incarray:splitstring ( str / lst )
    (setq lst (vl-string->list str))
    (read (vl-list->string (vl-list* 40 34 (incarray:split lst (< 47 (car lst) 58)))))
)

;;----------------------------------------------------------------------;;

(defun incarray:split ( lst flg )
    (cond
        (   (null lst) '(34 41))
        (   (member (car lst) '(34 92))
            (if flg
                (vl-list* 34 32 34 92 (car lst) (incarray:split (cdr lst) nil))
                (vl-list* 92 (car lst) (incarray:split (cdr lst) flg))
            )
        )
        (   (or (< 47 (car lst) 58) (and (= 46 (car lst)) flg (< 47 (cadr lst) 58)))
            (if flg
                (vl-list* (car lst) (incarray:split (cdr lst) flg))
                (vl-list* 34 32 34 (car lst) (incarray:split (cdr lst) t))
            )
        )
        (   flg (vl-list* 34 32 34 (car lst) (incarray:split (cdr lst) nil)))
        (   (vl-list* (car lst) (incarray:split (cdr lst) nil)))
    )
)

;;----------------------------------------------------------------------;;

(defun incarray:increment ( str inc / dci dcs len num )
    (if (distof str 2)
        (progn
            (setq num (+ (distof str) inc)
                  inc (incarray:num->str inc)
                  str (vl-string-left-trim "-" str)
                  inc (vl-string-left-trim "-" inc)
                  dci (incarray:decimalplaces inc)
                  dcs (incarray:decimalplaces str)
                  len (strlen str)
                  str (vl-string-left-trim "-" (rtos num 2 (max dci dcs)))
            )
            (cond
                (   (< 0 dcs) (setq len (+ (- len dcs) (max dci dcs))))
                (   (< 0 dci) (setq len (+ dci len 1)))
            )
            (repeat (- len (strlen str))
                (setq str (strcat "0" str))
            )
            (if (minusp num)
                (strcat "-" str)
                str
            )
        )
        str
    )
)

;;----------------------------------------------------------------------;;

(defun incarray:decimalplaces ( str / pos )
    (if (setq pos (vl-string-position 46 str))
        (- (strlen str) pos 1)
        0
    )
)

;;----------------------------------------------------------------------;;

(defun incarray:startundo ( doc )
    (incarray:endundo doc)
    (vla-startundomark doc)
)

;;----------------------------------------------------------------------;;

(defun incarray:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;;----------------------------------------------------------------------;;

(defun incarray:acdoc nil
    (eval (list 'defun 'incarray:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (incarray:acdoc)
)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;