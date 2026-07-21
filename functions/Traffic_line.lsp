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
