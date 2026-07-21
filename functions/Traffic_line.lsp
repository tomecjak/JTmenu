;=========================================================================
; Traffic_line.lsp
; Create by Jakub Tomecko
;
; Nastavenie sirky a typu ciary dopravnej polylinie podla typu komunikacie
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                        Zdielane pomocne funkcie                       ;;
;;----------------------------------------------------------------------;;

(defun _StartUndo ( doc ) (vla-StartUndoMark doc))

(defun _EndUndo   ( doc ) (if (= 8 (logand 8 (getvar 'UNDOCTL))) (vla-EndUndomark doc)))

;;----------------------------------------------------------------------;;
;;                 Suvisla ciara 601-50 (krajna - tenka)                ;;
;;----------------------------------------------------------------------;;

(defun c:DC60150 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

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

  (setq sel (entsel (strcat "\nVyberte polyliniu pre typ \"" typ "\" : ")))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      (vla-put-ConstantWidth obj width)
      (vla-put-Linetype obj ltype)
      (vla-Update obj)
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                 Suvisla ciara 601-51 (krajna - hruba)                ;;
;;----------------------------------------------------------------------;;

(defun c:DC60151 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (initget 1 "Dialnica Mimo")
  (setq typ
    (getkword "\nZvolte typ komunikacie [Dialnica (0.30)/Mimo dialnice (0.25)] : ")
  )

  (cond
    ( (eq typ "Dialnica") (setq width 0.30 ltype "Continuous") )
    ( (eq typ "Mimo")     (setq width 0.25 ltype "Continuous") )
  )

  (_StartUndo doc)

  (setq sel (entsel (strcat "\nVyberte polyliniu pre typ \"" typ "\" : ")))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      (vla-put-ConstantWidth obj width)
      (vla-put-Linetype obj ltype)
      (vla-Update obj)
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                   Suvisla ciara 601-60 (stredova)                    ;;
;;----------------------------------------------------------------------;;

(defun c:DC60160 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "Continuous")

  (_StartUndo doc)

  (setq sel (entsel "\nVyberte polyliniu : "))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      (vla-put-ConstantWidth obj width)
      (vla-put-Linetype obj ltype)
      (vla-Update obj)
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Suvisla ciara 601-65 (stredova dvojita)                ;;
;;----------------------------------------------------------------------;;

(defun c:DC60165 ( / *error* doc width ltype vmin vmax val off sel ent obj res )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "Continuous" vmin 0.16 vmax 0.51)

  ;; Nacitanie celkovej hodnoty s obmedzenim vmin - vmax
  (while
    (progn
      (initget 1)
      (setq val (getdist (strcat "\nZadajte celkovu hodnotu <" (rtos vmin) " - " (rtos vmax) "> : ")))
      (cond
        ( (< val vmin) (princ (strcat "\nHodnota musi byt minimalne " (rtos vmin) ".")) t )
        ( (> val vmax) (princ (strcat "\nHodnota musi byt maximalne " (rtos vmax) ".")) t )
        ( t nil )
      )
    )
  )

  ;; Odsadenie na kazdu stranu: polovica hodnoty + 0.06 (polovica sirky ciary)
  (setq off (+ (/ val 2.0) 0.06))

  (_StartUndo doc)

  (setq sel (entsel "\nVyberte polyliniu : "))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      (foreach d (list off (- off))
        (setq res (vl-catch-all-apply 'vlax-invoke (list obj 'Offset d)))
        (if (vl-catch-all-error-p res)
          (princ "\nNepodarilo sa odsadit polyliniu.")
          (foreach no res
            (vla-put-ConstantWidth no width)
            (vla-put-Linetype no ltype)
            (vla-Update no)
          )
        )
      )
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Suvisla ciara 601-66 (stredova dvojita)                ;;
;;----------------------------------------------------------------------;;

(defun c:DC60166 ( / *error* doc width ltype vmin vmax val off cwidth sel ent obj res )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "Continuous" vmin 0.36 vmax 0.76)

  ;; Nacitanie celkovej hodnoty s obmedzenim vmin - vmax
  (while
    (progn
      (initget 1)
      (setq val (getdist (strcat "\nZadajte celkovu hodnotu <" (rtos vmin) " - " (rtos vmax) "> : ")))
      (cond
        ( (< val vmin) (princ (strcat "\nHodnota musi byt minimalne " (rtos vmin) ".")) t )
        ( (> val vmax) (princ (strcat "\nHodnota musi byt maximalne " (rtos vmax) ".")) t )
        ( t nil )
      )
    )
  )

  ;; Odsadenie na kazdu stranu: polovica hodnoty + 0.06 (polovica sirky ciary)
  (setq off (+ (/ val 2.0) 0.06))
  ;; Sirka stredovej ciary: hodnota offsetu - 0.1
  (setq cwidth (- val 0.1))

  (_StartUndo doc)

  (setq sel (entsel "\nVyberte polyliniu : "))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      ;; Nastavenie sirky stredovej ciary
      (vla-put-ConstantWidth obj cwidth)
      (vla-put-Linetype obj ltype)
      (vla-Update obj)
      ;; Odsadene ciary na obe strany
      (foreach d (list off (- off))
        (setq res (vl-catch-all-apply 'vlax-invoke (list obj 'Offset d)))
        (if (vl-catch-all-error-p res)
          (princ "\nNepodarilo sa odsadit polyliniu.")
          (foreach no res
            (vla-put-ConstantWidth no width)
            (vla-put-Linetype no ltype)
            (vla-Update no)
          )
        )
      )
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                    Suvisla ciara 601-75 (deliaca)                    ;;
;;----------------------------------------------------------------------;;

(defun c:DC60175 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (initget 1 "Dialnica Mimo")
  (setq typ
    (getkword "\nZvolte typ komunikacie [Dialnica (0.30)/Mimo dialnice (0.25)] : ")
  )

  (cond
    ( (eq typ "Dialnica") (setq width 0.30 ltype "Continuous") )
    ( (eq typ "Mimo")     (setq width 0.25 ltype "Continuous") )
  )

  (_StartUndo doc)

  (setq sel (entsel (strcat "\nVyberte polyliniu pre typ \"" typ "\" : ")))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      (vla-put-ConstantWidth obj width)
      (vla-put-Linetype obj ltype)
      (vla-Update obj)
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                    Suvisla ciara 601-76 (tenka)                      ;;
;;----------------------------------------------------------------------;;

(defun c:DC60176 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "Continuous")

  (_StartUndo doc)

  (setq sel (entsel "\nVyberte polyliniu : "))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      (vla-put-ConstantWidth obj width)
      (vla-put-Linetype obj ltype)
      (vla-Update obj)
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                    Suvisla ciara 601-85 (deliaca)                    ;;
;;----------------------------------------------------------------------;;

(defun c:DC60185 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (initget 1 "Dialnica Cyklo")
  (setq typ
    (getkword "\nZvolte typ komunikacie [Dialnica (0.25)/Cyklochodnik (0.25)] : ")
  )

  (cond
    ( (eq typ "Dialnica") (setq width 0.25 ltype "Continuous") )
    ( (eq typ "Cyklo")     (setq width 0.25 ltype "Continuous") )
  )

  (_StartUndo doc)

  (setq sel (entsel (strcat "\nVyberte polyliniu pre typ \"" typ "\" : ")))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      (vla-put-ConstantWidth obj width)
      (vla-put-Linetype obj ltype)
      (vla-Update obj)
    )
  )

  (_EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;            Prerusovana ciara 602-50 (okrajava - tenka)               ;;
;;----------------------------------------------------------------------;;

(defun c:DC60250 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (_EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (initget 1 "BezMimoObce BezObec BezCyklo KolObec KolCyklo")
  (setq typ
    (getkword "\nZvolte typ komunikacie [Bezkol. mimo obce (0.12)/Bezkol. v obci (0.12)/Bezkol. cyklochodnik (0.10)/ Kol. mimo aj v obici (0.12)/Kol. cyklochodnik (0.10)] : ")
  )

  (cond
    ( (eq typ "BezMimoObce") (setq width 0.12 ltype "Continuous") )
    ( (eq typ "BezObec") (setq width 0.12 ltype "Continuous") )
    ( (eq typ "BezCyklo") (setq width 0.10 ltype "Continuous") )
    ( (eq typ "KolObec") (setq width 0.12 ltype "Continuous") )
    ( (eq typ "KolCyklo") (setq width 0.10 ltype "Continuous") )
  )

  (_StartUndo doc)

  (setq sel (entsel (strcat "\nVyberte polyliniu pre typ \"" typ "\" : ")))
  (cond
    ( (null sel)
      (princ "\nNebola vybrana ziadna polylinia.")
    )
    ( (not (wcmatch (cdr (assoc 0 (entget (setq ent (car sel))))) "LWPOLYLINE,POLYLINE"))
      (princ "\nVybrany objekt nie je polylinia.")
    )
    ( t
      (setq obj (vlax-ename->vla-object ent))
      (vla-put-ConstantWidth obj width)
      (vla-put-Linetype obj ltype)
      (vla-Update obj)
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
