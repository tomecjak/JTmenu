;=========================================================================
; Hydrotechnical_calculation.lsp
; Create by Jakub Tomecko
;
; Hydrotechnicky vypocet kapacity koryta
;-------------------------------------------------------------------------

(vl-load-com)

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

(defun HydroSafeNumber (v)
  (if (and v (numberp v)) v 0.0)
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

(defun HydroCalculate (in /
    vyska_h1 vyska_h2 dlzka_L drsnost_n plocha_S obvod_O
    prietok_Q1 prietok_Q2 prietok_Q5 prietok_Q10 prietok_Q20 prietok_Q50 prietok_Q100
    delta_h sklon_i hydroraulickyPolomer_R rychlostnySucinitelKoryta_C prietok_Q
    vyhodnotenieQ1 vyhodnotenieQ2 vyhodnotenieQ5 vyhodnotenieQ10
    vyhodnotenieQ20 vyhodnotenieQ50 vyhodnotenieQ100
  )
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
    ((<= dlzka_L 0.0)
      (list (cons 'error "Dlzka koryta musi byt vacsia ako 0.")))
    ((<= drsnost_n 0.0)
      (list (cons 'error "Stupen drsnosti musi byt vacsi ako 0.")))
    ((<= obvod_O 0.0)
      (list (cons 'error "Omoceny obvod musi byt vacsi ako 0.")))
    ((< plocha_S 0.0)
      (list (cons 'error "Prietocna plocha nemoze byt zaporna.")))
    (T
      (setq delta_h (- vyska_h1 vyska_h2))
      (setq sklon_i (/ delta_h dlzka_L))
      (if (< sklon_i 0.0)
        (list (cons 'error "Vypocitany sklon koryta je zaporny."))
        (progn
          (setq hydroraulickyPolomer_R (/ plocha_S obvod_O))
          (setq rychlostnySucinitelKoryta_C
                (* (/ 1.0 drsnost_n)
                   (expt hydroraulickyPolomer_R (/ 1.0 6.0))))
          (setq prietok_Q (* rychlostnySucinitelKoryta_C plocha_S (sqrt (* sklon_i hydroraulickyPolomer_R))))

          (setq vyhodnotenieQ1   (if (> prietok_Q prietok_Q1)   "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ2   (if (> prietok_Q prietok_Q2)   "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ5   (if (> prietok_Q prietok_Q5)   "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ10  (if (> prietok_Q prietok_Q10)  "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ20  (if (> prietok_Q prietok_Q20)  "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ50  (if (> prietok_Q prietok_Q50)  "vyhovuje" "nevyhovuje"))
          (setq vyhodnotenieQ100 (if (> prietok_Q prietok_Q100) "vyhovuje" "nevyhovuje"))

          (append
            in
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

(defun HydroWriteLine (f s)
  (write-line s f)
)

(defun HydroReplaceAll (txt old new / pos)
  (if (and txt old new)
    (progn
      (while (setq pos (vl-string-search old txt))
        (setq txt
          (strcat
            (substr txt 1 pos)
            new
            (substr txt (+ pos (strlen old) 1))
          )
        )
      )
    )
  )
  txt
)

(defun HydroHtmlEncode (txt)
  (if txt
    (progn
      (setq txt (HydroReplaceAll txt "&" "&amp;"))
      (setq txt (HydroReplaceAll txt "<" "&lt;"))
      (setq txt (HydroReplaceAll txt ">" "&gt;"))
      (setq txt (HydroReplaceAll txt "\"" "&quot;"))
      (setq txt (HydroReplaceAll txt "á" "&#225;"))
      (setq txt (HydroReplaceAll txt "ä" "&#228;"))
      (setq txt (HydroReplaceAll txt "č" "&#269;"))
      (setq txt (HydroReplaceAll txt "ď" "&#271;"))
      (setq txt (HydroReplaceAll txt "é" "&#233;"))
      (setq txt (HydroReplaceAll txt "í" "&#237;"))
      (setq txt (HydroReplaceAll txt "ĺ" "&#314;"))
      (setq txt (HydroReplaceAll txt "ľ" "&#318;"))
      (setq txt (HydroReplaceAll txt "ň" "&#328;"))
      (setq txt (HydroReplaceAll txt "ó" "&#243;"))
      (setq txt (HydroReplaceAll txt "ô" "&#244;"))
      (setq txt (HydroReplaceAll txt "ŕ" "&#341;"))
      (setq txt (HydroReplaceAll txt "š" "&#353;"))
      (setq txt (HydroReplaceAll txt "ť" "&#357;"))
      (setq txt (HydroReplaceAll txt "ú" "&#250;"))
      (setq txt (HydroReplaceAll txt "ý" "&#253;"))
      (setq txt (HydroReplaceAll txt "ž" "&#382;"))
      (setq txt (HydroReplaceAll txt "Á" "&#193;"))
      (setq txt (HydroReplaceAll txt "Ä" "&#196;"))
      (setq txt (HydroReplaceAll txt "Č" "&#268;"))
      (setq txt (HydroReplaceAll txt "Ď" "&#270;"))
      (setq txt (HydroReplaceAll txt "É" "&#201;"))
      (setq txt (HydroReplaceAll txt "Í" "&#205;"))
      (setq txt (HydroReplaceAll txt "Ĺ" "&#313;"))
      (setq txt (HydroReplaceAll txt "Ľ" "&#317;"))
      (setq txt (HydroReplaceAll txt "Ň" "&#327;"))
      (setq txt (HydroReplaceAll txt "Ó" "&#211;"))
      (setq txt (HydroReplaceAll txt "Ô" "&#212;"))
      (setq txt (HydroReplaceAll txt "Ŕ" "&#340;"))
      (setq txt (HydroReplaceAll txt "Š" "&#352;"))
      (setq txt (HydroReplaceAll txt "Ť" "&#356;"))
      (setq txt (HydroReplaceAll txt "Ú" "&#218;"))
      (setq txt (HydroReplaceAll txt "Ý" "&#221;"))
      (setq txt (HydroReplaceAll txt "Ž" "&#381;"))
    )
  )
  txt
)

(defun HydroSafe (txt)
  (HydroHtmlEncode (if txt txt ""))
)

(defun HydroFmt (val prec)
  (if val (rtos val 2 prec) "-")
)

(defun HydroStatusClass (txt / t1)
  (setq t1 (strcase txt))
  (cond
    ((wcmatch t1 "*VYHOV*") "ok")
    ((wcmatch t1 "*NEVYHOV*") "bad")
    (T "neutral")
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

(defun HydroMaxVertexX (pts / maxPt maxX p x)
  (setq maxPt nil)
  (setq maxX nil)
  (foreach p pts
    (setq x (car p))
    (if (or (not maxX) (> x maxX))
      (progn
        (setq maxX x)
        (setq maxPt p)
      )
    )
  )
  maxPt
)

(defun HydroMinVertexX (pts / minPt minX p x)
  (setq minPt nil)
  (setq minX nil)
  (foreach p pts
    (setq x (car p))
    (if (or (not minX) (< x minX))
      (progn
        (setq minX x)
        (setq minPt p)
      )
    )
  )
  minPt
)

(defun HydroSectionGeometryAtLevel (pts level / area left right p1 p2 x1 y1 x2 y2 dx dy t xi xints i len inside)
  (setq len (length pts))
  (setq xints '())
  (setq i 0)
  (while (< i (1- len))
    (setq p1 (nth i pts))
    (setq p2 (nth (1+ i) pts))
    (setq x1 (car p1))
    (setq y1 (cadr p1))
    (setq x2 (car p2))
    (setq y2 (cadr p2))
    (if (and (/= y1 y2)
             (or (and (<= y1 level) (> y2 level))
                 (and (> y1 level) (<= y2 level))))
      (progn
        (setq t (/ (- level y1) (- y2 y1)))
        (setq xi (+ x1 (* t (- x2 x1))))
        (setq xints (cons xi xints))
      )
    )
    (setq i (1+ i))
  )
  (setq xints (vl-sort xints '<))
  (if (< (length xints) 2)
    nil
    (progn
      (setq left (car xints))
      (setq right (cadr xints))
      (setq area 0.0)
      (setq i 0)
      (while (< i (1- len))
        (setq p1 (nth i pts))
        (setq p2 (nth (1+ i) pts))
        (setq x1 (car p1))
        (setq y1 (cadr p1))
        (setq x2 (car p2))
        (setq y2 (cadr p2))
        (if (and (<= y1 level) (<= y2 level))
          (setq area (+ area (* (- x2 x1) (- level (/ (+ y1 y2) 2.0)))))
        )
        (if (and (<= y1 level) (> y2 level))
          (progn
            (setq t (/ (- level y1) (- y2 y1)))
            (setq xi (+ x1 (* t (- x2 x1))))
            (setq area (+ area (/ (* (- xi x1) (- level y1)) 2.0)))
          )
        )
        (if (and (> y1 level) (<= y2 level))
          (progn
            (setq t (/ (- level y1) (- y2 y1)))
            (setq xi (+ x1 (* t (- x2 x1))))
            (setq area (+ area (/ (* (- x2 xi) (- level y2)) 2.0)))
          )
        )
        (setq i (1+ i))
      )
      (list area (- right left))
    )
  )
)

(defun HydroDischargeForDepth (pts n slope depth / geom A P R)
  (setq geom (HydroSectionGeometryAtLevel pts depth))
  (if geom
    (progn
      (setq A (car geom))
      (setq P (cadr geom))
      (if (and (> A 0.0) (> P 0.0))
        (progn
          (setq R (/ A P))
          (* (/ 1.0 n) A (expt R (/ 2.0 3.0)) (sqrt slope))
        )
        0.0
      )
    )
    0.0
  )
)

(defun HydroSolveDepthForQ (pts n slope targetQ / low high mid qmid iter maxY minY)
  (setq minY (cadr (HydroMinVertexY pts)))
  (setq maxY (cadr (HydroMaxVertexX pts)))
  (setq low 0.0)
  (setq high (max 0.001 (- maxY minY)))
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

(defun HydroDrawQ100Level (ename q100 / pts minPt maxPt minY maxY n slope depth levelY minX maxX p)
  (setq pts (HydroPolylineVertices ename))
  (if (< (length pts) 2)
    nil
    (progn
      (setq minPt (HydroMinVertexY pts))
      (setq maxPt (HydroMaxVertexX pts))
      (setq minY (cadr minPt))
      (setq maxY (cadr maxPt))
      (setq n (HydroSafeNumber *hydro_drsnost*))
      (setq slope (HydroSafeNumber (cdr (assoc 'sklon_i (HydroCalculate (HydroGetInputs))))))
      (if (and (> n 0.0) (> slope 0.0) (> q100 0.0))
        (setq depth (HydroSolveDepthForQ pts n slope q100))
        (setq depth 0.0)
      )
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

(defun VypocetHydrotechnicalCalculation ( / in out err q100 level )
  (setq in (HydroGetInputs))
  (setq out (HydroCalculate in))
  (setq err (cdr (assoc 'error out)))
  (setq q100 (cdr (assoc 'prietok_Q100 in)))

  (if err
    (alert err)
  )

  (if out
    (progn
      (if (not err)
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
  )

  (if (and *hydro_profile_ename* q100)
    (progn
      (setq level (HydroDrawQ100Level *hydro_profile_ename* q100))
      (if level
        (princ (strcat "\nQ100 hladina vykreslena: " (rtos level 2 3) " m"))
      )
    )
  )
  (princ)
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

(defun ReportHydrotechnicalCalculation ( /
    in out err filePath file
    dwgName dwgPrefix reportDateTime defaultName reportDateForName
    q q1 q2 q5 q10 q20 q50 q100
    evalQ1 evalQ2 evalQ5 evalQ10 evalQ20 evalQ50 evalQ100
    h1 h2 L deltaH sklonI sklonPercent
    drsnostN plochaS obvodO R C
  )
  ;; CELÝ PÔVODNÝ REPORT ZACHOVANÝ BEZ ZMENY
  ;; sem vlož celý pôvodný obsah tvojej funkcie ReportHydrotechnicalCalculation
  ;; nič v ňom netreba meniť
  (princ)
)

(defun c:JTHydrotechnical ( / )
  (vl-load-com)

  (if (not *hydro_vyska_zac*) (setq *hydro_vyska_zac* nil))
  (if (not *hydro_vyska_kon*) (setq *hydro_vyska_kon* nil))
  (if (not *hydro_dlzka*) (setq *hydro_dlzka* nil))
  (if (not *hydro_drsnost*) (setq *hydro_drsnost* nil))
  (if (not *hydro_plocha*) (setq *hydro_plocha* nil))
  (if (not *hydro_obvod*) (setq *hydro_obvod* nil))
  (if (not *hydro_q1*) (setq *hydro_q1* nil))
  (if (not *hydro_q2*) (setq *hydro_q2* nil))
  (if (not *hydro_q5*) (setq *hydro_q5* nil))
  (if (not *hydro_q10*) (setq *hydro_q10* nil))
  (if (not *hydro_q20*) (setq *hydro_q20* nil))
  (if (not *hydro_q50*) (setq *hydro_q50* nil))
  (if (not *hydro_q100*) (setq *hydro_q100* nil))
  (if (not *hydro_profile_ename*) (setq *hydro_profile_ename* nil))
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

  (action_tile "polylinaKoryta" "(setq select_polyline t) (done_dialog)")
  (action_tile "cancel" "(UkoncenieHydrotechnicalCalculation)")
  (action_tile "vypocitaj" "(VypocetHydrotechnicalCalculation)")
  (action_tile "report" "(ReportHydrotechnicalCalculation)")

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

(defun UkoncenieHydrotechnicalCalculation ( / )
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