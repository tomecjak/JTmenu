;=========================================================================
; Hydrotechnical_calculation.lsp
; Create by Jakub Tomecko
;
; Hydrotechnicky vypocet kapacity koryta
;-------------------------------------------------------------------------

(vl-load-com)

(defun HydroNum (v)
  (if (numberp v) v 0.0)
)

(defun HydroGetProp (key lst)
  (cdr (assoc key lst))
)

(defun HydroLine (p1 p2)
  (entmake
    (list
      (cons 0 "LINE")
      (cons 100 "AcDbEntity")
      (cons 100 "AcDbLine")
      (cons 10 p1)
      (cons 11 p2)
    )
  )
)

(defun HydroPolylineVertices (ename / ed pts p)
  (setq ed (entget ename))
  (setq pts '())
  (foreach p ed
    (if (= (car p) 10)
      (setq pts (cons (cdr p) pts))
    )
  )
  (reverse pts)
)

(defun HydroMinVertexY (pts / minPt minY p y)
  (setq minPt nil)
  (setq minY nil)
  (foreach p pts
    (setq y (cadr p))
    (if (or (not minY) (< y minY))
      (progn
        (setq minY y)
        (setq minPt p)
      )
    )
  )
  minPt
)

(defun HydroMaxVertexY (pts / maxPt maxY p y)
  (setq maxPt nil)
  (setq maxY nil)
  (foreach p pts
    (setq y (cadr p))
    (if (or (not maxY) (> y maxY))
      (progn
        (setq maxY y)
        (setq maxPt p)
      )
    )
  )
  maxPt
)

(defun HydroPointList (p)
  (list (car p) (cadr p) 0.0)
)

(defun HydroSectionGeometryAtLevel (pts level / area perim p1 p2 x1 y1 x2 y2 dx dy t xi yi insidePts i yAtX xint inters xints pA pB)
  (setq area 0.0)
  (setq perim 0.0)

  (setq inters '())
  (setq i 0)
  (while (< i (1- (length pts)))
    (setq pA (nth i pts))
    (setq pB (nth (1+ i) pts))
    (setq y1 (cadr pA))
    (setq y2 (cadr pB))
    (setq x1 (car pA))
    (setq x2 (car pB))

    (if (and (/= y1 y2)
             (or (and (<= y1 level) (> y2 level))
                 (and (> y1 level) (<= y2 level))))
      (progn
        (setq t (/ (- level y1) (- y2 y1)))
        (setq xint (+ x1 (* t (- x2 x1))))
        (setq inters (cons xint inters))
      )
    )
    (setq i (1+ i))
  )

  (setq xints (vl-sort inters '<))

  (if (< (length xints) 2)
    nil
    (progn
      (setq area 0.0)
      (setq perim 0.0)

      (setq i 0)
      (while (< i (1- (length pts)))
        (setq pA (nth i pts))
        (setq pB (nth (1+ i) pts))
        (setq x1 (car pA))
        (setq y1 (cadr pA))
        (setq x2 (car pB))
        (setq y2 (cadr pB))

        (if (or (and (<= y1 level) (<= y2 level))
                (and (<= y1 level) (> y2 level))
                (and (> y1 level) (<= y2 level)))
          (progn
            (if (and (<= y1 level) (<= y2 level))
              (setq area (+ area (/ (* (- x2 x1) (+ (- level y1) (- level y2))) 2.0)))
            )
            (if (and (<= y1 level) (> y2 level))
              (progn
                (setq t (/ (- level y1) (- y2 y1)))
                (setq xi (+ x1 (* t (- x2 x1))))
                (setq area (+ area (/ (* (- xi x1) (+ (- level y1) 0.0)) 2.0)))
              )
            )
            (if (and (> y1 level) (<= y2 level))
              (progn
                (setq t (/ (- level y1) (- y2 y1)))
                (setq xi (+ x1 (* t (- x2 x1))))
                (setq area (+ area (/ (* (- x2 xi) (+ 0.0 (- level y2))) 2.0)))
              )
            )
          )
        )

        (if (and (/= y1 y2)
                 (or (and (<= y1 level) (> y2 level))
                     (and (> y1 level) (<= y2 level))))
          (progn
            (setq t (/ (- level y1) (- y2 y1)))
            (setq xi (+ x1 (* t (- x2 x1))))
            (setq yi level)
            (if (<= y1 level)
              (setq perim (+ perim (distance pA (list xi yi 0.0))))
              (setq perim (+ perim (distance (list xi yi 0.0) pB)))
            )
          )
        )

        (if (and (<= y1 level) (<= y2 level))
          (setq perim (+ perim (distance pA pB)))
        )

        (setq i (1+ i))
      )

      (if (< perim 0.000001)
        nil
        (list area perim)
      )
    )
  )
)

(defun HydroDischargeForDepth (pts n slope depth / g geom A P R Q)
  (setq g 9.81)
  (setq geom (HydroSectionGeometryAtLevel pts depth))
  (if geom
    (progn
      (setq A (car geom))
      (setq P (cadr geom))
      (setq R (/ A P))
      (setq Q (* (/ 1.0 n) A (expt R (/ 2.0 3.0)) (sqrt slope)))
      Q
    )
    0.0
  )
)

(defun HydroSolveDepthForQ (pts n slope targetQ / minPt maxPt minY maxY low high mid qmid iter)
  (setq minPt (HydroMinVertexY pts))
  (setq maxPt (HydroMaxVertexY pts))
  (setq minY (cadr minPt))
  (setq maxY (cadr maxPt))

  (setq low 0.0)
  (setq high (- maxY minY))
  (if (<= high 0.0) (setq high 1.0))

  (setq iter 0)
  (while (< iter 60)
    (setq mid (/ (+ low high) 2.0))
    (setq qmid (HydroDischargeForDepth pts n slope mid))
    (if (> qmid targetQ)
      (setq high mid)
      (setq low mid)
    )
    (setq iter (1+ iter))
  )
  (/ (+ low high) 2.0)
)

(defun HydroDrawQ100Level (ename q100 / obj pts minPt maxPt minY maxY n slope depth levelY xLeft xRight p1 p2 minX maxX)
  (setq obj (vlax-ename->vla-object ename))
  (setq pts (HydroPolylineVertices ename))

  (if (< (length pts) 2)
    nil
    (progn
      (setq minPt (HydroMinVertexY pts))
      (setq maxPt (HydroMaxVertexY pts))
      (setq minY (cadr minPt))
      (setq maxY (cadr maxPt))

      (setq n (HydroNum *hydro_drsnost*))
      (setq slope (HydroNum (cdr (assoc 'sklon_i (HydroCalculate (HydroGetInputs))))))

      (if (or (<= n 0.0) (<= slope 0.0))
        nil
        (progn
          (setq depth (HydroSolveDepthForQ pts n slope q100))
          (setq levelY (+ minY depth))

          (setq minX (car (car pts)))
          (setq maxX (car (car pts)))
          (foreach p pts
            (if (< (car p) minX) (setq minX (car p)))
            (if (> (car p) maxX) (setq maxX (car p)))
          )

          (HydroLine (list minX levelY 0.0) (list maxX levelY 0.0))
          (HydroLine (list (car minPt) minY 0.0) (list (car minPt) levelY 0.0))
          levelY
        )
      )
    )
  )
)

(defun c:JTHydrotechnical ( / )
  (setq *hydro_vyska_zac* (if *hydro_vyska_zac* *hydro_vyska_zac* nil))
  (setq *hydro_vyska_kon* (if *hydro_vyska_kon* *hydro_vyska_kon* nil))
  (setq *hydro_dlzka* (if *hydro_dlzka* *hydro_dlzka* nil))
  (setq *hydro_drsnost* (if *hydro_drsnost* *hydro_drsnost* nil))
  (setq *hydro_plocha* (if *hydro_plocha* *hydro_plocha* nil))
  (setq *hydro_obvod* (if *hydro_obvod* *hydro_obvod* nil))
  (setq *hydro_q1* (if *hydro_q1* *hydro_q1* nil))
  (setq *hydro_q2* (if *hydro_q2* *hydro_q2* nil))
  (setq *hydro_q5* (if *hydro_q5* *hydro_q5* nil))
  (setq *hydro_q10* (if *hydro_q10* *hydro_q10* nil))
  (setq *hydro_q20* (if *hydro_q20* *hydro_q20* nil))
  (setq *hydro_q50* (if *hydro_q50* *hydro_q50* nil))
  (setq *hydro_q100* (if *hydro_q100* *hydro_q100* nil))
  (setq *hydro_profile_ename* (if *hydro_profile_ename* *hydro_profile_ename* nil))
  (setq select_polyline nil)

  (setq dcl_id (load_dialog "Hydrotechnical_calculation.dcl"))

  (if (not (new_dialog "Hydrotechnical_calculation" dcl_id))
    (exit)
  )

  (if *hydro_vyska_zac* (set_tile "vyskaNaZaciatkuKoryta" (rtos *hydro_vyska_zac* 2 3)))
  (if *hydro_vyska_kon* (set_tile "vyskaNaKonciKoryta" (rtos *hydro_vyska_kon* 2 3)))
  (if *hydro_dlzka* (set_tile "dlzkaKoryta" (rtos *hydro_dlzka* 2 3)))
  (if *hydro_drsnost* (set_tile "stupenDrsnostiKoryta" (rtos *hydro_drsnost* 2 3)))
  (if *hydro_plocha* (set_tile "prietocnaPlochaKoryta" (rtos *hydro_plocha* 2 2)))
  (if *hydro_obvod* (set_tile "omocvenyObvodKoryta" (rtos *hydro_obvod* 2 2)))
  (if *hydro_q1* (set_tile "hodnotaPrietokuKorytaQ1" (rtos *hydro_q1* 2 2)))
  (if *hydro_q2* (set_tile "hodnotaPrietokuKorytaQ2" (rtos *hydro_q2* 2 2)))
  (if *hydro_q5* (set_tile "hodnotaPrietokuKorytaQ5" (rtos *hydro_q5* 2 2)))
  (if *hydro_q10* (set_tile "hodnotaPrietokuKorytaQ10" (rtos *hydro_q10* 2 2)))
  (if *hydro_q20* (set_tile "hodnotaPrietokuKorytaQ20" (rtos *hydro_q20* 2 2)))
  (if *hydro_q50* (set_tile "hodnotaPrietokuKorytaQ50" (rtos *hydro_q50* 2 2)))
  (if *hydro_q100* (set_tile "hodnotaPrietokuKorytaQ100" (rtos *hydro_q100* 2 2)))

  (action_tile "polylinaKoryta"
    "(setq select_polyline t) (done_dialog)"
  )
  (action_tile "cancel"
    "(UkoncenieHydrotechnicalCalculation)"
  )
  (action_tile "vypocitaj"
    "(VypocetHydrotechnicalCalculation)"
  )
  (action_tile "report"
    "(ReportHydrotechnicalCalculation)"
  )

  (start_dialog)

  (if select_polyline
    (progn
      (PolylineKorytaHydrotechnicalCalculation)
      (c:JTHydrotechnical)
    )
  )

  (unload_dialog dcl_id)
  (princ)
)

(defun HydroGetInputs ( / )
  (list
    (cons 'vyska_h1   (atof (get_tile "vyskaNaZaciatkuKoryta")))
    (cons 'vyska_h2   (atof (get_tile "vyskaNaKonciKoryta")))
    (cons 'dlzka_L    (atof (get_tile "dlzkaKoryta")))
    (cons 'drsnost_n  (atof (get_tile "stupenDrsnostiKoryta")))
    (cons 'plocha_S   (atof (get_tile "prietocnaPlochaKoryta")))
    (cons 'obvod_O    (atof (get_tile "omocvenyObvodKoryta")))
    (cons 'prietok_Q1   (atof (get_tile "hodnotaPrietokuKorytaQ1")))
    (cons 'prietok_Q2   (atof (get_tile "hodnotaPrietokuKorytaQ2")))
    (cons 'prietok_Q5   (atof (get_tile "hodnotaPrietokuKorytaQ5")))
    (cons 'prietok_Q10  (atof (get_tile "hodnotaPrietokuKorytaQ10")))
    (cons 'prietok_Q20  (atof (get_tile "hodnotaPrietokuKorytaQ20")))
    (cons 'prietok_Q50  (atof (get_tile "hodnotaPrietokuKorytaQ50")))
    (cons 'prietok_Q100 (atof (get_tile "hodnotaPrietokuKorytaQ100")))
  )
)

(defun HydroCalculate (in / vyska_h1 vyska_h2 dlzka_L drsnost_n plocha_S obvod_O prietok_Q1 prietok_Q2 prietok_Q5 prietok_Q10 prietok_Q20 prietok_Q50 prietok_Q100 delta_h sklon_i hydroraulickyPolomer_R rychlostnySucinitelKoryta_C prietok_Q vyhodnotenieQ1 vyhodnotenieQ2 vyhodnotenieQ5 vyhodnotenieQ10 vyhodnotenieQ20 vyhodnotenieQ50 vyhodnotenieQ100)
  (setq vyska_h1   (cdr (assoc 'vyska_h1 in)))
  (setq vyska_h2   (cdr (assoc 'vyska_h2 in)))
  (setq dlzka_L    (cdr (assoc 'dlzka_L in)))
  (setq drsnost_n  (cdr (assoc 'drsnost_n in)))
  (setq plocha_S   (cdr (assoc 'plocha_S in)))
  (setq obvod_O    (cdr (assoc 'obvod_O in)))
  (setq prietok_Q1   (cdr (assoc 'prietok_Q1 in)))
  (setq prietok_Q2   (cdr (assoc 'prietok_Q2 in)))
  (setq prietok_Q5   (cdr (assoc 'prietok_Q5 in)))
  (setq prietok_Q10  (cdr (assoc 'prietok_Q10 in)))
  (setq prietok_Q20  (cdr (assoc 'prietok_Q20 in)))
  (setq prietok_Q50  (cdr (assoc 'prietok_Q50 in)))
  (setq prietok_Q100 (cdr (assoc 'prietok_Q100 in)))

  (cond
    ((<= dlzka_L 0.0) (list (cons 'error "Dlzka koryta musi byt vacsia ako 0.")))
    ((<= drsnost_n 0.0) (list (cons 'error "Stupen drsnosti musi byt vacsi ako 0.")))
    ((<= obvod_O 0.0) (list (cons 'error "Omoceny obvod musi byt vacsi ako 0.")))
    ((< plocha_S 0.0) (list (cons 'error "Prietocna plocha nemoze byt zaporna.")))
    (T
      (setq delta_h (- vyska_h1 vyska_h2))
      (setq sklon_i (/ delta_h dlzka_L))
      (if (< sklon_i 0.0)
        (list (cons 'error "Vypocitany sklon koryta je zaporny."))
        (progn
          (setq hydroraulickyPolomer_R (/ plocha_S obvod_O))
          (setq rychlostnySucinitelKoryta_C (* (/ 1.0 drsnost_n) (expt hydroraulickyPolomer_R (/ 1.0 6.0))))
          (setq prietok_Q (* rychlostnySucinitelKoryta_C plocha_S (sqrt (* sklon_i hydroraulickyPolomer_R))))
          (setq vyhodnotenieQ1   (if (> prietok_Q prietok_Q1)   "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ2   (if (> prietok_Q prietok_Q2)   "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ5   (if (> prietok_Q prietok_Q5)   "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ10  (if (> prietok_Q prietok_Q10)  "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ20  (if (> prietok_Q prietok_Q20)  "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ50  (if (> prietok_Q prietok_Q50)  "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ100 (if (> prietok_Q prietok_Q100) "vyhovuje" "nevyhovuje"))
          (append in
            (list
              (cons 'delta_h delta_h)
              (cons 'sklon_i sklon_i)
              (cons 'hydroraulickyPolomer_R hydroraulickyPolomer_R)
              (cons 'rychlostnySucinitelKoryta_C rychlostnySucinitelKoryta_C)
              (cons 'prietok_Q prietok_Q)
              (cons 'vyhodnotenieQ1 vyhodnotenieQ1)
              (cons 'vyhodnotenieQ2 vyhodnotenieQ2)
              (cons 'vyhodnotenieQ5 vyhodnotenieQ5)
              (cons 'vyhodnotenieQ10 vyhodnotenieQ10)
              (cons 'vyhodnotenieQ20 vyhodnotenieQ20)
              (cons 'vyhodnotenieQ50 vyhodnotenieQ50)
              (cons 'vyhodnotenieQ100 vyhodnotenieQ100)
            )
          )
        )
      )
    )
  )
)

(defun VypocetHydrotechnicalCalculation ( / in out err )
  (setq in (HydroGetInputs))
  (setq out (HydroCalculate in))
  (setq err (cdr (assoc 'error out)))
  (if err
    (alert err)
    (progn
      (set_tile "vyskovyRozdielKoryta" (strcat (rtos (cdr (assoc 'delta_h out)) 2 2) " m"))
      (set_tile "vypocitanySklonKoryta" (strcat (rtos (* (cdr (assoc 'sklon_i out)) 100.0) 2 2) " %"))
      (set_tile "hydrailickyPolomer" (strcat (rtos (cdr (assoc 'hydroraulickyPolomer_R out)) 2 2) " m"))
      (set_tile "rychlostniSucinitel" (strcat (rtos (cdr (assoc 'rychlostnySucinitelKoryta_C out)) 2 2) " -"))
      (set_tile "prietokoveMnozstvo" (strcat (rtos (cdr (assoc 'prietok_Q out)) 2 2) " m3/s"))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ1" (cdr (assoc 'vyhodnotenieQ1 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ2" (cdr (assoc 'vyhodnotenieQ2 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ5" (cdr (assoc 'vyhodnotenieQ5 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ10" (cdr (assoc 'vyhodnotenieQ10 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ20" (cdr (assoc 'vyhodnotenieQ20 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ50" (cdr (assoc 'vyhodnotenieQ50 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ100" (cdr (assoc 'vyhodnotenieQ100 out)))
    )
  )
)

(defun PolylineKorytaHydrotechnicalCalculation ( / ent obj )
  (setq ent (entsel "\nVyber polylinu koryta: "))
  (if ent
    (progn
      (setq obj (vlax-ename->vla-object (car ent)))
      (if (wcmatch (vla-get-objectname obj) "*Polyline")
        (progn
          (setq *hydro_plocha* (vla-get-area obj))
          (setq *hydro_obvod* (vla-get-length obj))
          (setq *hydro_profile_ename* (car ent))
          (princ (strcat "\nPlocha: " (rtos *hydro_plocha* 2 2) " m²\n"))
          (princ (strcat "Obvod: " (rtos *hydro_obvod* 2 2) " m\n"))
        )
        (princ "\nVybrana entita nie je polylina.\n")
      )
    )
    (princ "\nNevybral si ziadnu polylinu.\n")
  )
)

(defun UkoncenieHydrotechnicalCalculation ()
  (if (get_tile "vyskaNaZaciatkuKoryta") (setq *hydro_vyska_zac* (atof (get_tile "vyskaNaZaciatkuKoryta"))))
  (if (get_tile "vyskaNaKonciKoryta") (setq *hydro_vyska_kon* (atof (get_tile "vyskaNaKonciKoryta"))))
  (if (get_tile "dlzkaKoryta") (setq *hydro_dlzka* (atof (get_tile "dlzkaKoryta"))))
  (if (get_tile "stupenDrsnostiKoryta") (setq *hydro_drsnost* (atof (get_tile "stupenDrsnostiKoryta"))))
  (if (get_tile "prietocnaPlochaKoryta") (setq *hydro_plocha* (atof (get_tile "prietocnaPlochaKoryta"))))
  (if (get_tile "omocvenyObvodKoryta") (setq *hydro_obvod* (atof (get_tile "omocvenyObvodKoryta"))))
  (if (get_tile "hodnotaPrietokuKorytaQ1") (setq *hydro_q1* (atof (get_tile "hodnotaPrietokuKorytaQ1"))))
  (if (get_tile "hodnotaPrietokuKorytaQ2") (setq *hydro_q2* (atof (get_tile "hodnotaPrietokuKorytaQ2"))))
  (if (get_tile "hodnotaPrietokuKorytaQ5") (setq *hydro_q5* (atof (get_tile "hodnotaPrietokuKorytaQ5"))))
  (if (get_tile "hodnotaPrietokuKorytaQ10") (setq *hydro_q10* (atof (get_tile "hodnotaPrietokuKorytaQ10"))))
  (if (get_tile "hodnotaPrietokuKorytaQ20") (setq *hydro_q20* (atof (get_tile "hodnotaPrietokuKorytaQ20"))))
  (if (get_tile "hodnotaPrietokuKorytaQ50") (setq *hydro_q50* (atof (get_tile "hodnotaPrietokuKorytaQ50"))))
  (if (get_tile "hodnotaPrietokuKorytaQ100") (setq *hydro_q100* (atof (get_tile "hodnotaPrietokuKorytaQ100"))))
  (done_dialog)
  (princ "\nUkoncenie hydrotechnickeho vypoctu.\n")
)

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
  (strcat
    "\nHydrotechnical_calculation.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
    (menucmd "m=$(edtime,0,yyyy)")
    "\n"
  )
)
(princ)