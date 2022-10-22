;=========================================================================
; Center_measure.lsp
; (c) Copyright 2011 Lee Mac
; Prelozil Jakub Tomecko
;
; Rozmiestnenie objektov od stredu ciary
;-------------------------------------------------------------------------

;;-------------------=={ Stredové zarovnie }==----------------;;
;;                                                            ;;
;;  Emuluje spravenie standartneho prikazu "Measure", ale     ;;
;;  centruje delenie pozdlz vybraneho objektu                 ;;
;;------------------------------------------------------------;;

(defun c:CMEASURE ( / *error* _StartUndo _EndUndo _SelectIf _IsCurveObject acdoc al bl d0 di en mx nm pt )
  
  ;vytvorenie premenej VyberTypuMeasure
  (setq VyberTypuMeasure
    (getstring "\nVyberte si sposob rozdelenia [Automaticky/Okolo/Stred] <Automaticky: ")
  )
  
  (if (or (= VyberTypuMeasure "") (= VyberTypuMeasure "A") (= VyberTypuMeasure "a"))
  ;premenna pre automaicky sposob
  (setq TypCMeasure "Automaticky")
    (if (or (= VyberTypuMeasure "O") (= VyberTypuMeasure "o"))
    ;premenna pre sposob okolo
    (setq TypCMeasure "Okolo")
      (if (or (= VyberTypuMeasure "S") (= VyberTypuMeasure "s"))
      ;premenna pre sposob stred
      (setq TypCMeasure "stred")
      (princ "\nNeplatny vyber.")
      )
    )
  ) 
  
  (defun *error* ( msg )
    (if acdoc (_EndUndo acdoc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (defun _StartUndo ( doc ) (_EndUndo doc)
    (vla-StartUndoMark doc)
  )

  (defun _EndUndo ( doc )
    (if (= 8 (logand 8 (getvar 'UNDOCTL)))
      (vla-EndUndoMark doc)
    )
  )

  (defun _SelectIf ( msg pred func / sel ) (setq pred (eval pred))  
    (while
      (progn (setvar 'ERRNO 0) (setq sel (car (func msg)))
        (cond
          ( (= 7 (getvar 'ERRNO))
            (princ "\nChyba, skss to znovu.")
          )
          ( (eq 'ENAME (type sel))
            (if (and pred (not (pred sel)))
              (princ "\nVybrany nespravny objekt.")
            )
          )
        )
      )
    )
    sel
  )

  (defun _IsCurveObject ( entity / param )
    (and
      (not
        (vl-catch-all-error-p
          (setq param
            (vl-catch-all-apply 'vlax-curve-getendparam (list entity))
          )
        )
      )
      param
    )
  )

  (setq acdoc (vla-get-activedocument (vlax-get-acad-object))
        nm    (trans '(0. 0. 1.) 1 0 t)
  )
  (if (setq en (_SelectIf "\nVyberte objekt na Center Measure: " '_isCurveObject entsel))
    (progn
      (initget 7 "Block")
      (setq di (getdist "\nZadajte dlzku segmentu alebo vyberte [Block]: "))
      
      (if (eq "Block" di)
        (progn
          (while
            (progn (setq bl (getstring t "\nZadajte nazov bloku, ktori chcete vlozit: "))
              (cond
                ( (not (snvalid bl))
                  (princ "\nNespravny nazov bloku.")
                )
                ( (not (tblsearch "BLOCK" bl))
                  (princ (strcat "\nNemozem najst block \"" bl "\"."))
                )
              )
            )
          )
          (initget "Ano Nie")
          (setq al (not (eq "Nie" (getkword "\nZarovnat block s objektom? [Ano/Nie] <A>: "))))
          (initget 7)
          (setq di (getdist "\nZadajte dlzku segmentu: "))
        )
      )
      
      ;vyber typu funkckie vypoctu rozdelenia
      (if (= TypCMeasure "Automaticky")
        (vzorecVypoctuAutomaticky)
          (if (= TypCMeasure "Okolo")
            (vzorecVypoctuOkolo)
              (if (= TypCMeasure "stred")
                (vzorecVypoctuStred)
              )
          )
      )
      
      (_StartUndo acdoc)
      (while (and (<= (setq d0 (+ d0 di)) mx) (setq pt (vlax-curve-getpointatdist en d0)))
        (if bl
          (entmakex
            (list
              (cons 0 "INSERT")
              (cons 2 bl)
              (cons 10 (trans pt 0 nm))
              (cons 50
                (if al
                  (angle '(0. 0. 0.)
                    (trans
                      (vlax-curve-getfirstderiv en (vlax-curve-getparamatpoint en pt)) 0 nm
                    )
                  )
                  0.
                )
              )
              (cons 210 nm)
            )
          )
          (entmakex (list (cons 0 "POINT") (cons 10 pt)))
        )
      )
      (_EndUndo acdoc)
    )
    (princ "\n*Cancel*")
  )
  ;hlaska po skonceni programu
  (princ "\nCenter measure bol vykonany. ")
  (princ)
)

;vypocet measure automaticky
(defun vzorecVypoctuAutomaticky ()
  (setq mx (vlax-curve-getdistatparam en (vlax-curve-getendparam en))
    d0 (- (/ (- mx (* di (fix (/ mx di)))) 2.) di)
  )
)

;vypocet measure okolo
(defun vzorecVypoctuOkolo ()
  (setq mx (vlax-curve-getdistatparam en (vlax-curve-getendparam en))
    d0 (- (/ (- mx (* di (+ 1. (* 2. (fix (/ (/ (- mx di) 2.) di)))))) 2.) di)
  )
)

;vypocet measure stred
(defun vzorecVypoctuStred ()
  (setq mx (vlax-curve-getdistatparam en (vlax-curve-getendparam en))
    d0 (- (/ (- mx (* (* 2 di) (fix (/ (/ mx 2.) di)))) 2.) di)
  )
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nCenter_measure.lsp | " (JTmenuVersion) " | Lee Mac, Jakub Tomecko, Michal Kravec | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;