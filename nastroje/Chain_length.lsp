;=========================================================================
; Chain_length.lsp
; (c) Copyright 2015 Lee Mac
; Prelozil Jakub Tomecko
; Verzia: beta
;
; Meranie jednej vzdialenosti nespojenych ciar
;-------------------------------------------------------------------------

;;------------------------=={ Retazova dlzka }==------------------------;;
;;                                                                      ;;
;;  Tento program umoznuje uzivatelovi vypocitat celkovu dlzku objektu  ;;
;;  medzi dvoma bodmi podzlz retazca spojenych objektov. Po zadani      ;;
;;  prikazu "CHAINLEN" na prikazovom riadku AutoCadu je uzivatel        ;;
;;  vyzvany, aby urobil vyber objektov, tento vyber moze pozastavat z   ;;
;;  akejkolvek mnoziny otvorenych geometrickych objektov a moze         ;;
;;  obsahovat viacero retazcov spojenych objektov alebo dokonca ziadne  ;;
;;  spojene objekty. Po platnom vyber moze uzivatel urcit dva odlisne   ;;
;;  body umiestnene na lubovolnych dvoch objektoch vo vybere alebo s    ;;
;;  oboma bodmi umiestnenymi na rovnakom objekte. Program potom spusti  ;;
;;  k vypoctu celkovej dlzky pozdlz serie spojenych objektov medzi      ;;
;;  dvoma danymi bodmi a zobrazi vysledok do prikazoveho riadku.        ;;
;;  Zobrazena dlzka bude naformatovana v sulade s aktualnymi jednotkami ;;
;;  a nastaveniami presnosti. Subor odlisnych objektov sa bude          ;;
;;  povazovat za "ratazec", ak sa kazdy koncovy bod zhoduje s koncovym  ;;
;;  bodom ineho objektu vo vybere. Pouzivatel bude upozorneny, ak dva   ;;
;;  dane body nelezia na rovnakom retazvi objektov vo vybere.           ;;
;;----------------------------------------------------------------------;;

(defun c:CHAINLEN ( / len lst pt1 pt2 sel tmp )
  
  ;definovanie chybovej hlasky v programe
  (defun *error* (errmsg)
    (princ)
    (princ "\nProgram Chain_length.lsp sa ukončil. ")
    (terpri)
    (prompt errmsg)
    (princ)
  )
  
    (if
        (and
            (setq sel
                (ssget
                    (list
                       '(-4 . "<OR")
                           '(0 . "LINE,ARC")
                           '(-4 . "<AND")
                               '(0 . "LWPOLYLINE,SPLINE")
                               '(-4 . "<NOT")
                                   '(-4 . "&=")
                                   '(70 . 1)
                               '(-4 . "NOT>")
                           '(-4 . "AND>")
                           '(-4 . "<AND")
                               '(0 . "POLYLINE")
                               '(-4 . "<NOT")
                                   '(-4 . "&")
                                   '(70 . 89)
                               '(-4 . "NOT>")
                               '(-4 . "AND>")
                           '(-4 . "<AND")
                               '(0 . "ELLIPSE")
                               '(-4 . "<OR")
                                   '(-4 . "<>")
                                   '(41 . 0.0)
                                   '(-4 . "<>")
                                    (cons 42 (+ pi pi))
                               '(-4 . "OR>")
                           '(-4 . "AND>")
                       '(-4 . "OR>")
                        (if (= 1 (getvar 'cvport))
                            (cons 410 (getvar 'ctab))
                           '(410 . "Model")
                        )
                    )
                )
            )
            (setq pt1 (getpoint "\nVýber 1. bod: "))
            (setq pt2 (getpoint "\nVýber 2. bod: " pt1))
        )
        (if
            (setq tmp
                (vl-member-if
                    (function
                        (lambda ( itm / tmp )
                            (cond
                                (   (equal pt1 (setq tmp (vlax-curve-getclosestpointto (cadr itm) pt1)) 1e-3)
                                    (setq  pt1 tmp)
                                )
                                (   (equal pt2 (setq tmp (vlax-curve-getclosestpointto (cadr itm) pt2)) 1e-3)
                                    (mapcar 'set '(pt1 pt2) (list tmp pt1))
                                )
                            )
                        )
                    )
                    (LM:sortedchainselection sel)
                )
                lst
                (vl-member-if
                    (function
                        (lambda ( itm / tmp )
                            (if (equal pt2 (setq tmp (vlax-curve-getclosestpointto (cadr itm) pt2)) 1e-3)
                                (setq  pt2 tmp)
                            )
                        )
                    )
                    (reverse tmp)
                )
            )
            (progn
                (if (cdr lst)
                    (setq len
                        (+
                            (abs
                                (- (vlax-curve-getdistatpoint (cadar tmp) pt1)
                                   (vlax-curve-getdistatpoint (cadar tmp) (caddar tmp))
                                )
                            )
                            (abs
                                (- (vlax-curve-getdistatpoint (cadar lst) pt2)
                                   (vlax-curve-getdistatpoint (cadar lst) (caar lst))
                                )
                            )
                        )
                    )
                    (setq len
                        (abs
                            (-  (vlax-curve-getdistatpoint (cadar lst) pt1)
                                (vlax-curve-getdistatpoint (cadar lst) pt2)
                            )
                        )
                    )
                )
                (foreach itm (cdr (reverse (cdr lst)))
                    (setq len (+ len (vlax-curve-getdistatparam (cadr itm) (vlax-curve-getendparam (cadr itm)))))
                )
                (princ (strcat "\nDĺžka: " (rtos len)))
            )
            (princ "\nVybrané body neležia na rovnakom reťazci objektov.")
        )
    )
    (princ)
)
 
(defun LM:sortedchainselection ( sel / end ent flg idx lst rtn tmp )
    (repeat (setq idx (sslength sel))
        (setq ent (ssname sel (setq idx (1- idx)))
              lst (cons (list (vlax-curve-getstartpoint ent) ent (vlax-curve-getendpoint ent)) lst)
        )
    )
    (setq end (list (caar lst) (caddar lst))
          rtn (list (car lst))
          lst (cdr lst)
    )
    (while
        (progn
            (foreach itm lst
                (cond
                    (   (equal (car itm) (car end) 1e-8)
                        (setq end (cons (caddr itm) (cdr end))
                              rtn (cons (reverse itm) rtn)
                              flg t
                        )
                    )
                    (   (equal (car itm) (cadr end) 1e-8)
                        (setq end (list (car end) (caddr itm))
                              rtn (append rtn (list itm))
                              flg t
                        )
                    )
                    (   (equal (caddr itm) (car end) 1e-8)
                        (setq end (cons (car itm) (cdr end))
                              rtn (cons itm rtn)
                              flg t
                        )
                    )
                    (   (equal (caddr itm) (cadr end) 1e-8)
                        (setq end (list (car end) (car itm))
                              rtn (append rtn (list (reverse itm)))
                              flg t
                        )
                    )
                    (   (setq tmp (cons itm tmp)))
                )
            )
            flg
        )
        (setq lst tmp tmp nil flg nil)
    )
    rtn
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nChain_length.lsp | " (JTmenuVersion) " | Lee Mac, Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;