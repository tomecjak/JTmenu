;=========================================================================
; Traffic_line.lsp
; Create by Jakub Tomecko
;
; Nastavenie sirky a typu ciary dopravnej polylinie podla typu komunikacie
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                        Zdielane pomocne funkcie                       ;;
;;----------------------------------------------------------------------;;

(defun StartUndo ( doc ) (vla-StartUndoMark doc))

(defun EndUndo   ( doc ) (if (= 8 (logand 8 (getvar 'UNDOCTL))) (vla-EndUndomark doc)))

;; Nacita typ ciary "name" zo suboru "file", ak este nie je v kresbe nacitany
(defun LoadLinetype ( doc name file )
  (if
    (vl-catch-all-error-p
      (vl-catch-all-apply 'vla-Item (list (vla-get-Linetypes doc) name))
    )
    (if
      (vl-catch-all-error-p
        (vl-catch-all-apply 'vla-Load (list (vla-get-Linetypes doc) name file))
      )
      (princ (strcat "\nTyp ciary \"" name "\" sa nepodarilo nacitat zo suboru " file "."))
    )
  )
)

;;----------------------------------------------------------------------;;
;;                 Suvisla ciara 601-50 (krajna - tenka)                ;;
;;----------------------------------------------------------------------;;

(defun c:DC60150 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                 Suvisla ciara 601-51 (krajna - hruba)                ;;
;;----------------------------------------------------------------------;;

(defun c:DC60151 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                   Suvisla ciara 601-60 (stredova)                    ;;
;;----------------------------------------------------------------------;;

(defun c:DC60160 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "Continuous")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Suvisla ciara 601-65 (stredova dvojita)                ;;
;;----------------------------------------------------------------------;;

(defun c:DC60165 ( / *error* doc width ltype vmin vmax val off sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Suvisla ciara 601-66 (stredova dvojita)                ;;
;;----------------------------------------------------------------------;;

(defun c:DC60166 ( / *error* doc width ltype vmin vmax val off cwidth sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                    Suvisla ciara 601-75 (deliaca)                    ;;
;;----------------------------------------------------------------------;;

(defun c:DC60175 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                    Suvisla ciara 601-76 (tenka)                      ;;
;;----------------------------------------------------------------------;;

(defun c:DC60176 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "Continuous")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                    Suvisla ciara 601-85 (deliaca)                    ;;
;;----------------------------------------------------------------------;;

(defun c:DC60185 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;            Prerusovana ciara 602-50 (okrajava - tenka)               ;;
;;----------------------------------------------------------------------;;

(defun c:DC60250 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BO  = Bezkol. v obci | BC  = Bezkol. cyklochodnik | KO  = Kol. mimo aj v obci | KC  = Kol. cyklochodnik")
  (initget 1 "BMO BO BC KO KC")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BO/BC/KO/KC] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-2.0") )
    ( (eq typ "BO")  (setq width 0.12 ltype "VDZ_3.0-1.5") )
    ( (eq typ "BC")  (setq width 0.10 ltype "VDZ_1.0-0.5") )
    ( (eq typ "KO")  (setq width 0.12 ltype "VDZ_3.0-1.5") )
    ( (eq typ "KC")  (setq width 0.10 ltype "VDZ_1.0-0.5") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;            Prerusovana ciara 602-51 (okrajava - hruba)               ;;
;;----------------------------------------------------------------------;;

(defun c:DC60251 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BO  = Bezkol. v obci | KO  = Kol. mimo aj v obci")
  (initget 1 "BMO BO KO ")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BO/KO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-2.0") )
    ( (eq typ "BO")  (setq width 0.12 ltype "VDZ_3.0-1.5") )
    ( (eq typ "KO")  (setq width 0.12 ltype "VDZ_3.0-1.5") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                      Prerusovana ciara 602-52                        ;;
;;----------------------------------------------------------------------;;

(defun c:DC60252 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "VDZ_1.5-1.5")
  
  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                      Prerusovana ciara 602-53                        ;;
;;----------------------------------------------------------------------;;

(defun c:DC60253 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "VDZ_3.0-1.5")
  
  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                      Prerusovana ciara 602-55                        ;;
;;----------------------------------------------------------------------;;

(defun c:DC60255 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  MO = Mimo obce aj v obci | CK  = Cyklochodnik")
  (initget 1 "MO CK")
  (setq typ
    (getkword "\nZvolte typ komunikacie [MO/CK] : ")
  )

  (cond
    ( (eq typ "MO") (setq width 0.25 ltype "VDZ_1.5-1.5") )
    ( (eq typ "CK")  (setq width 0.25 ltype "VDZ_0.5-0.5") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                      Prerusovana ciara 602-60                        ;;
;;----------------------------------------------------------------------;;

(defun c:DC60260 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO = Bezkol. v obcie | KMO  = Kol. mimo obce aj v obci")
  (initget 1 "BMO BVO KMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/KMO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-8.0") )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-6.0") )
    ( (eq typ "KMO") (setq width 0.12 ltype "VDZ_3.0-3.0") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                      Prerusovana ciara 602-61                        ;;
;;----------------------------------------------------------------------;;

(defun c:DC60261 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  MO = Mimo obce | VO  = V obci")
  (initget 1 "MO VO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [MO/VO] : ")
  )

  (cond
    ( (eq typ "MO") (setq width 0.12 ltype "VDZ_4.0-2.0") )
    ( (eq typ "VO") (setq width 0.12 ltype "VDZ_3.0-1.5") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;             Prerusovana ciara 602-65 (stredova dvojita)              ;;
;;----------------------------------------------------------------------;;

(defun c:DC60265 ( / *error* doc width ltype vmin vmax val off sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | SMO = Semkol. mimo obce aj v obci")
  (initget 1 "BMO BVO SMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/SMO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-8.0" vmin 0.16 vmax 0.51) )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-6.0" vmin 0.16 vmax 0.51) )
    ( (eq typ "SMO") (setq width 0.12 ltype "VDZ_3.0-3.0" vmin 0.16 vmax 0.51) )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;             Prerusovana ciara 602-66 (stredova dvojita)              ;;
;;----------------------------------------------------------------------;;

(defun c:DC60266 ( / *error* doc width ltype vmin vmax val off cwidth sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | SMO = Semkol. mimo obce aj v obci")
  (initget 1 "BMO BVO SMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/SMO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-8.0" vmin 0.36 vmax 0.76) )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-6.0" vmin 0.36 vmax 0.76) )
    ( (eq typ "SMO") (setq width 0.12 ltype "VDZ_3.0-3.0" vmin 0.36 vmax 0.76) )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;             Prerusovana ciara 602-67 (stredova dvojita)              ;;
;;----------------------------------------------------------------------;;

(defun c:DC60267 ( / *error* doc width ltype vmin vmax val off sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  MO = mimo obce | VO  = V obci")
  (initget 1 "MO VO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [MO/VO] : ")
  )

  (cond
    ( (eq typ "MO") (setq width 0.12 ltype "VDZ_4.0-2.0" vmin 0.16 vmax 0.51) )
    ( (eq typ "VO") (setq width 0.12 ltype "VDZ_3.0-1.5" vmin 0.16 vmax 0.51) )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;             Prerusovana ciara 602-68 (stredova dvojita)              ;;
;;----------------------------------------------------------------------;;

(defun c:DC60268 ( / *error* doc width ltype vmin vmax val off cwidth sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  MO = Mimo obce | VO  = V obci")
  (initget 1 "MO VO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [MO/VO] : ")
  )

  (cond
    ( (eq typ "MO") (setq width 0.12 ltype "VDZ_4.0-2.0" vmin 0.36 vmax 0.76) )
    ( (eq typ "VO") (setq width 0.12 ltype "VDZ_3.0-1.5" vmin 0.36 vmax 0.76) )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                 Prerusovana ciara 602-70 (vodiaca)                   ;;
;;----------------------------------------------------------------------;;

(defun c:DC60270 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BD = Bezkol. dialnica | BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | SD = Semkol. dialnica | SMO = Semkol. mimo obce aj v obci | KMO = Kol. mimo obce aj v obci")
  (initget 1 "BD BMO BVO SD SMO KMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BD/BMO/BVO/SD/SMO/KMO] : ")
  )

  (cond
    ( (eq typ "BD") (setq width 0.15 ltype "VDZ_6.0-12.0") )
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-8.0") )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-6.0") )
    ( (eq typ "SD") (setq width 0.15 ltype "VDZ_6.0-6.0") )
    ( (eq typ "SMO") (setq width 0.12 ltype "VDZ_3.0-3.0") )
    ( (eq typ "KMO") (setq width 0.12 ltype "VDZ_3.0-3.0") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                  Prerusovana ciara 602-71 (vodiaca)                  ;;
;;----------------------------------------------------------------------;;

(defun c:DC60271 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  MO = Mimo obce | VO  = V obci")
  (initget 1 "MO VO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [MO/VO] : ")
  )

  (cond
    ( (eq typ "MO") (setq width 0.12 ltype "VDZ_4.0-2.0") )
    ( (eq typ "VO") (setq width 0.12 ltype "VDZ_3.0-1.5") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                 Prerusovana ciara 602-75 (deliaca)                   ;;
;;----------------------------------------------------------------------;;

(defun c:DC60275 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BD = Bezkol. dialnica | BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | SD = Semkol. dialnica | SMO = Semkol. mimo obce aj v obci | KMO = Kol. mimo obce aj v obci")
  (initget 1 "BD BMO BVO SD SMO KMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BD/BMO/BVO/SD/SMO/KMO] : ")
  )

  (cond
    ( (eq typ "BD") (setq width 0.30 ltype "VDZ_6.0-6.0") )
    ( (eq typ "BMO") (setq width 0.25 ltype "VDZ_4.0-4.0") )
    ( (eq typ "BVO") (setq width 0.25 ltype "VDZ_3.0-3.0") )
    ( (eq typ "SD") (setq width 0.30 ltype "VDZ_6.0-6.0") )
    ( (eq typ "SMO") (setq width 0.25 ltype "VDZ_3.0-3.0") )
    ( (eq typ "KMO") (setq width 0.25 ltype "VDZ_3.0-3.0") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                  Prerusovana ciara 602-76 (deliaca)                  ;;
;;----------------------------------------------------------------------;;

(defun c:DC60276 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.12 ltype "VDZ_3.0-3.0")
  
  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                Prerusovana ciara 602-80 (kyvadlova)                  ;;
;;----------------------------------------------------------------------;;

(defun c:DC60280 ( / *error* doc width ltype vmin vmax val off sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | KMO = Kol. mimo obce aj v obci")
  (initget 1 "BMO BVO KMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/KMO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_8.0-4.0" vmin 0.16 vmax 0.51) )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_6.0-3.0" vmin 0.16 vmax 0.51) )
    ( (eq typ "KMO") (setq width 0.12 ltype "VDZ_3.0-1.5" vmin 0.16 vmax 0.51) )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                Prerusovana ciara 602-81 (kyvadlova)                  ;;
;;----------------------------------------------------------------------;;

(defun c:DC60281 ( / *error* doc width ltype vmin vmax val off cwidth sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | SMO = Semkol. mimo obce aj v obci")
  (initget 1 "BMO BVO SMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/SMO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_8.0-4.0" vmin 0.36 vmax 0.76) )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_6.0-3.0" vmin 0.36 vmax 0.76) )
    ( (eq typ "SMO") (setq width 0.12 ltype "VDZ_3.0-1.5" vmin 0.36 vmax 0.76) )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

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

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                Prerusovana ciara 602-85 (specialna)                  ;;
;;----------------------------------------------------------------------;;

(defun c:DC60285 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | BC = Bezkol. cyklochodnik | SMO = Semkol. mimo obce aj v obci | SC = Semkol. cyklochodnik | KMO = Kol. mimo obce aj v obci | KC = Kol. cyklochodnik")
  (initget 1 "BMO BVO BC SMO SC KMO KC")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/BC/SMO/SC/KMO/KC] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.25 ltype "VDZ_4.0-2.0") )
    ( (eq typ "BVO") (setq width 0.25 ltype "VDZ_3.0-1.5") )
    ( (eq typ "BC")  (setq width 0.25 ltype "VDZ_1.0-0.5") )
    ( (eq typ "SMO") (setq width 0.25 ltype "VDZ_3.0-1.5") )
    ( (eq typ "SC")  (setq width 0.25 ltype "VDZ_1.0-0.5") )
    ( (eq typ "KMO") (setq width 0.25 ltype "VDZ_1.5-1.5") )
    ( (eq typ "KC")  (setq width 0.25 ltype "VDZ_0.5-0.5") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                Prerusovana ciara 602-89 (specialna)                  ;;
;;----------------------------------------------------------------------;;

(defun c:DC60289 ( / *error* doc typ width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BD = Bezkol. dialnica | BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | SMO = Semkol. mimo obce aj v obci | KMO = Kol. mimo obce aj v obci")
  (initget 1 "BD BMO BVO SMO KMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BD/BMO/BVO/SMO/KMO] : ")
  )

  (cond
    ( (eq typ "BD") (setq width 0.30 ltype "VDZ_12.0-6.0") )
    ( (eq typ "BMO") (setq width 0.25 ltype "VDZ_8.0-4.0") )
    ( (eq typ "BVO") (setq width 0.25 ltype "VDZ_6.0-3.0") )
    ( (eq typ "SMO") (setq width 0.25 ltype "VDZ_3.0-1.5") )
    ( (eq typ "KMO") (setq width 0.25 ltype "VDZ_1.5-1.5") )
  )

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)
  
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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                 Prerusovana ciara 602-90 (ochranna)                  ;;
;;----------------------------------------------------------------------;;

(defun c:DC60290 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.10 ltype "VDZ_1.0-1.0")
  
  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;            Prerusovana + suvisla ciara 603-60 (specialna)            ;;
;;----------------------------------------------------------------------;;

(defun c:DC60360 ( / *error* doc typ width ltype off sel ent obj
                     res1 res2 o1 o2 pt p dashObj contObj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | KMO = Kol. mimo obce aj v obci")
  (initget 1 "BMO BVO KMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/KMO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-8.0") )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-6.0") )
    ( (eq typ "KMO") (setq width 0.12 ltype "VDZ_3.0-3.0") )
  )

  ;; Celkova hodnota odsadenia 0.16, na kazdu stranu polovica (0.08)
  (setq off (+ 0.16 0.12))

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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
      ;; Dvojity offset na obe strany o polovicu hodnoty
      (setq res1 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (/ off 2.0))))
      (setq res2 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (- (/ off 2.0)))))
      (if (or (vl-catch-all-error-p res1) (vl-catch-all-error-p res2))
        (princ "\nNepodarilo sa odsadit polyliniu.")
        (progn
          (setq o1 (car res1) o2 (car res2))
          ;; Vyber strany, na ktorej bude prerusovana ciara
          (initget 1)
          (setq pt (getpoint "\nUrcte kliknutim stranu, kde ma byt prerusovana ciara : "))
          (setq p (trans pt 1 0))
          ;; Blizsia odsadena ciara k zadanemu bodu = prerusovana, druha = suvisla
          (if (<= (distance p (vlax-curve-getClosestPointTo o1 p))
                  (distance p (vlax-curve-getClosestPointTo o2 p)))
            (setq dashObj o1 contObj o2)
            (setq dashObj o2 contObj o1)
          )
          ;; Prerusovana ciara - typ podla kodu
          (vla-put-ConstantWidth dashObj width)
          (vla-put-Linetype dashObj ltype)
          (vla-Update dashObj)
          ;; Suvisla ciara na druhej strane
          (vla-put-ConstantWidth contObj width)
          (vla-put-Linetype contObj "Continuous")
          (vla-Update contObj)
        )
      )
    )
  )

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;            Prerusovana + suvisla ciara 603-65 (specialna)            ;;
;;----------------------------------------------------------------------;;

(defun c:DC60365 ( / *error* doc typ width ltype off sel ent obj
                     res1 res2 o1 o2 pt p dashObj contObj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | KMO = Kol. mimo obce aj v obci")
  (initget 1 "BMO BVO KMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/KMO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-8.0" vmin 0.16 vmax 0.51) )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-6.0" vmin 0.16 vmax 0.51) )
    ( (eq typ "KMO") (setq width 0.12 ltype "VDZ_3.0-3.0" vmin 0.16 vmax 0.51) )
  )

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
  (setq off (+ val 0.12))

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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
      ;; Dvojity offset na obe strany o polovicu hodnoty
      (setq res1 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (/ off 2.0))))
      (setq res2 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (- (/ off 2.0)))))
      (if (or (vl-catch-all-error-p res1) (vl-catch-all-error-p res2))
        (princ "\nNepodarilo sa odsadit polyliniu.")
        (progn
          (setq o1 (car res1) o2 (car res2))
          ;; Vyber strany, na ktorej bude prerusovana ciara
          (initget 1)
          (setq pt (getpoint "\nUrcte kliknutim stranu, kde ma byt prerusovana ciara : "))
          (setq p (trans pt 1 0))
          ;; Blizsia odsadena ciara k zadanemu bodu = prerusovana, druha = suvisla
          (if (<= (distance p (vlax-curve-getClosestPointTo o1 p))
                  (distance p (vlax-curve-getClosestPointTo o2 p)))
            (setq dashObj o1 contObj o2)
            (setq dashObj o2 contObj o1)
          )
          ;; Prerusovana ciara - typ podla kodu
          (vla-put-ConstantWidth dashObj width)
          (vla-put-Linetype dashObj ltype)
          (vla-Update dashObj)
          ;; Suvisla ciara na druhej strane
          (vla-put-ConstantWidth contObj width)
          (vla-put-Linetype contObj "Continuous")
          (vla-Update contObj)
        )
      )
    )
  )

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;            Prerusovana + suvisla ciara 603-66 (specialna)            ;;
;;----------------------------------------------------------------------;;

(defun c:DC60366 ( / *error* doc typ width ltype off cwidth val vmin vmax sel ent obj
                     res1 res2 o1 o2 pt p dashObj contObj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | KMO = Kol. mimo obce aj v obci")
  (initget 1 "BMO BVO KMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BMO/BVO/KMO] : ")
  )

  (cond
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-8.0" vmin 0.36 vmax 0.76) )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-6.0" vmin 0.36 vmax 0.76) )
    ( (eq typ "KMO") (setq width 0.12 ltype "VDZ_3.0-3.0" vmin 0.36 vmax 0.76) )
  )

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
  (setq off (+ val 0.12))
  ;; Sirka stredovej ciary: hodnota offsetu - 0.1
  (setq cwidth (- off 0.1))

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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
      ;; Nastavenie sirky stredovej ciary
      (vla-put-ConstantWidth obj cwidth)
      (vla-Update obj)
      ;; Dvojity offset na obe strany o polovicu hodnoty
      (setq res1 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (/ off 2.0))))
      (setq res2 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (- (/ off 2.0)))))
      (if (or (vl-catch-all-error-p res1) (vl-catch-all-error-p res2))
        (princ "\nNepodarilo sa odsadit polyliniu.")
        (progn
          (setq o1 (car res1) o2 (car res2))
          ;; Vyber strany, na ktorej bude prerusovana ciara
          (initget 1)
          (setq pt (getpoint "\nUrcte kliknutim stranu, kde ma byt prerusovana ciara : "))
          (setq p (trans pt 1 0))
          ;; Blizsia odsadena ciara k zadanemu bodu = prerusovana, druha = suvisla
          (if (<= (distance p (vlax-curve-getClosestPointTo o1 p))
                  (distance p (vlax-curve-getClosestPointTo o2 p)))
            (setq dashObj o1 contObj o2)
            (setq dashObj o2 contObj o1)
          )
          ;; Prerusovana ciara - typ podla kodu
          (vla-put-ConstantWidth dashObj width)
          (vla-put-Linetype dashObj ltype)
          (vla-Update dashObj)
          ;; Suvisla ciara na druhej strane
          (vla-put-ConstantWidth contObj width)
          (vla-put-Linetype contObj "Continuous")
          (vla-Update contObj)
        )
      )
    )
  )

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;             Prerusovana + suvisla ciara 603-70 (vodiaca)             ;;
;;----------------------------------------------------------------------;;

(defun c:DC60370 ( / *error* doc typ width ltype off sel ent obj
                     res1 res2 o1 o2 pt p dashObj contObj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BD = Bezkol. dialnica | BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | SD = Semkol. dialnica | SMO = Semkol. mimo obce aj v obci")
  (initget 1 "BD BMO BVO SD SMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BD/BMO/BVO/SD/SMO] : ")
  )

  (cond
    ( (eq typ "BD") (setq width 0.15 ltype "VDZ_6.0-12.0" dmax 0.20) )
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-8.0" dmax 0.16) )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-6.0" dmax 0.16) )
    ( (eq typ "SD") (setq width 0.15 ltype "VDZ_6.0-6.0" dmax 0.20) )
    ( (eq typ "SMO") (setq width 0.12 ltype "VDZ_3.0-3.0" dmax 0.16) )
  )

  ;; Celkova hodnota odsadenia 0.16, na kazdu stranu polovica (0.08)
  (setq off (+ dmax width))

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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
      ;; Dvojity offset na obe strany o polovicu hodnoty
      (setq res1 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (/ off 2.0))))
      (setq res2 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (- (/ off 2.0)))))
      (if (or (vl-catch-all-error-p res1) (vl-catch-all-error-p res2))
        (princ "\nNepodarilo sa odsadit polyliniu.")
        (progn
          (setq o1 (car res1) o2 (car res2))
          ;; Vyber strany, na ktorej bude prerusovana ciara
          (initget 1)
          (setq pt (getpoint "\nUrcte kliknutim stranu, kde ma byt prerusovana ciara : "))
          (setq p (trans pt 1 0))
          ;; Blizsia odsadena ciara k zadanemu bodu = prerusovana, druha = suvisla
          (if (<= (distance p (vlax-curve-getClosestPointTo o1 p))
                  (distance p (vlax-curve-getClosestPointTo o2 p)))
            (setq dashObj o1 contObj o2)
            (setq dashObj o2 contObj o1)
          )
          ;; Prerusovana ciara - typ podla kodu
          (vla-put-ConstantWidth dashObj width)
          (vla-put-Linetype dashObj ltype)
          (vla-Update dashObj)
          ;; Suvisla ciara na druhej strane
          (vla-put-ConstantWidth contObj width)
          (vla-put-Linetype contObj "Continuous")
          (vla-Update contObj)
        )
      )
    )
  )

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;             Prerusovana + suvisla ciara 603-75 (deliaca)             ;;
;;----------------------------------------------------------------------;;

(defun c:DC60375 ( / *error* doc typ width ltype off sel ent obj
                     res1 res2 o1 o2 pt p dashObj contObj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ "\nTypy komunikacie:")
  (princ "\n  BD = Bezkol. dialnica | BMO = Bezkol. mimo obce | BVO  = Bezkol. v obci | SD = Semkol. dialnica | SMO = Semkol. mimo obce aj v obci")
  (initget 1 "BD BMO BVO SD SMO")
  (setq typ
    (getkword "\nZvolte typ komunikacie [BD/BMO/BVO/SD/SMO] : ")
  )

  (cond
    ( (eq typ "BD") (setq width 0.15 ltype "VDZ_6.0-6.0" dmax 0.20) )
    ( (eq typ "BMO") (setq width 0.12 ltype "VDZ_4.0-4.0" dmax 0.16) )
    ( (eq typ "BVO") (setq width 0.12 ltype "VDZ_3.0-3.0" dmax 0.16) )
    ( (eq typ "SD") (setq width 0.15 ltype "VDZ_6.0-6.0" dmax 0.20) )
    ( (eq typ "SMO") (setq width 0.12 ltype "VDZ_3.0-3.0" dmax 0.16) )
  )

  ;; Celkova hodnota odsadenia 0.16, na kazdu stranu polovica (0.08)
  (setq off (+ dmax width))

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

  (StartUndo doc)

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
      ;; Dvojity offset na obe strany o polovicu hodnoty
      (setq res1 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (/ off 2.0))))
      (setq res2 (vl-catch-all-apply 'vlax-invoke (list obj 'Offset (- (/ off 2.0)))))
      (if (or (vl-catch-all-error-p res1) (vl-catch-all-error-p res2))
        (princ "\nNepodarilo sa odsadit polyliniu.")
        (progn
          (setq o1 (car res1) o2 (car res2))
          ;; Vyber strany, na ktorej bude prerusovana ciara
          (initget 1)
          (setq pt (getpoint "\nUrcte kliknutim stranu, kde ma byt prerusovana ciara : "))
          (setq p (trans pt 1 0))
          ;; Blizsia odsadena ciara k zadanemu bodu = prerusovana, druha = suvisla
          (if (<= (distance p (vlax-curve-getClosestPointTo o1 p))
                  (distance p (vlax-curve-getClosestPointTo o2 p)))
            (setq dashObj o1 contObj o2)
            (setq dashObj o2 contObj o1)
          )
          ;; Prerusovana ciara - typ podla kodu
          (vla-put-ConstantWidth dashObj width)
          (vla-put-Linetype dashObj ltype)
          (vla-Update dashObj)
          ;; Suvisla ciara na druhej strane
          (vla-put-ConstantWidth contObj width)
          (vla-put-Linetype contObj "Continuous")
          (vla-Update contObj)
        )
      )
    )
  )

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                         Cyklisticka ciara 640                        ;;
;;----------------------------------------------------------------------;;

(defun c:DC640 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.10 ltype "Continuous")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                       Cyklisticka ciara 641-50                       ;;
;;----------------------------------------------------------------------;;

(defun c:DC64150 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.10 ltype "VDZ_0.5-3.0")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                       Cyklisticka ciara 641-51                       ;;
;;----------------------------------------------------------------------;;

(defun c:DC64151 ( / *error* doc width ltype sel ent obj )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.10 ltype "VDZ_3.0-0.5")

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                      Cyklisticka ciara 641-60                        ;;
;;----------------------------------------------------------------------;;

(defun c:DC64160 ( / *error* doc width ltype vmin vmax val off sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.10 ltype "VDZ_0.5-3.0" vmin 0.10 vmax 0.30)

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

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

  ;; Odsadenie na kazdu stranu: polovica hodnoty + 0.05 (polovica sirky ciary)
  (setq off (+ (/ val 2.0) 0.05))

  (StartUndo doc)

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

  (EndUndo doc)
  (princ)
)

;;----------------------------------------------------------------------;;
;;                      Cyklisticka ciara 641-61                        ;;
;;----------------------------------------------------------------------;;

(defun c:DC64161 ( / *error* doc width ltype vmin vmax val off sel ent obj res )

  (defun *error* ( msg )
    (and doc (EndUndo doc))
    (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
        (princ (strcat "\n** Chyba: " msg " **")))
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (setq width 0.10 ltype "VDZ_3.0-0.5" vmin 0.10 vmax 0.30)

  ;nacitanie zvoleneho typu ciary zo suboru DPP_VDZ_VL62.lin
  (LoadLinetype doc ltype "DPP_VDZ_VL62.lin")

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

  ;; Odsadenie na kazdu stranu: polovica hodnoty + 0.05 (polovica sirky ciary)
  (setq off (+ (/ val 2.0) 0.05))

  (StartUndo doc)

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

  (EndUndo doc)
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
