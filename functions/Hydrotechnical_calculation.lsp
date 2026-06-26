;=========================================================================
; Hydrotechnical_calculation.lsp
; Create by Jakub Tomecko
;
; Hydrotechnicky vypocet kapacity koryta
;-------------------------------------------------------------------------


;;----------------------------------------------------------------------;;
;;                  Hlavna funkcia nacitania dialogu                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTHydrotechnical ()

  (vl-load-com)

  ; inicializacia globalnych premennych
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
  (setq select_polyline nil)

  ; nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Hydrotechnical_calculation.dcl"))

  ; test existencie dialogu
  (if (not (new_dialog "Hydrotechnical_calculation" dcl_id))
    (exit)
  )

  ; nastavenie hodnot z predchadzajuceho vyberu alebo ulozenia
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

  ; definovanie tlacidla vyber polylinu
  (action_tile "polylinaKoryta"
    "(setq select_polyline t) (done_dialog)"
  )

  ; definovanie tlacidla cancel
  (action_tile "cancel"
    "(UkoncenieHydrotechnicalCalculation)"
  )

  ; definovanie tlacidla vypocitaj
  (action_tile "vypocitaj"
    "(VypocetHydrotechnicalCalculation)"
  )

  ; definovanie tlacidla report
  (action_tile "report"
    "(ReportHydrotechnicalCalculation)"
  )

  ; spustenie dialogu
  (start_dialog)

  ; ak bol vybrany vyber polyliny, vykonaj ho
  (if select_polyline
    (progn
      (PolylineKorytaHydrotechnicalCalculation)
      (c:JTHydrotechnical)
    )
  )

  ; unload dialogu
  (unload_dialog dcl_id)

  (princ)
)


;;----------------------------------------------------------------------;;
;;            Pomocna funkcia na ziskanie vstupov z dialogu             ;;
;;----------------------------------------------------------------------;;

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


;;----------------------------------------------------------------------;;
;;               Jedina centralna funkcia pre vypocet                   ;;
;;----------------------------------------------------------------------;;

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

  ; kontrola vstupov
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


;;----------------------------------------------------------------------;;
;;       Funkcia vypoctu - iba zobrazenie vysledkov do dialogu          ;;
;;----------------------------------------------------------------------;;

(defun VypocetHydrotechnicalCalculation ( / in out err )
  (setq in (HydroGetInputs))
  (setq out (HydroCalculate in))
  (setq err (cdr (assoc 'error out)))

  (if err
    (alert err)
    (progn
      (set_tile "vyskovyRozdielKoryta"
        (strcat (rtos (cdr (assoc 'delta_h out)) 2 2) " m"))

      (set_tile "vypocitanySklonKoryta"
        (strcat (rtos (* (cdr (assoc 'sklon_i out)) 100.0) 2 2) " %"))

      (set_tile "hydrailickyPolomer"
        (strcat (rtos (cdr (assoc 'hydroraulickyPolomer_R out)) 2 2) " m"))

      (set_tile "rychlostniSucinitel"
        (strcat (rtos (cdr (assoc 'rychlostnySucinitelKoryta_C out)) 2 2) " -"))

      (set_tile "prietokoveMnozstvo"
        (strcat (rtos (cdr (assoc 'prietok_Q out)) 2 2) " m3/s"))

      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ1"
        (cdr (assoc 'vyhodnotenieQ1 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ2"
        (cdr (assoc 'vyhodnotenieQ2 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ5"
        (cdr (assoc 'vyhodnotenieQ5 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ10"
        (cdr (assoc 'vyhodnotenieQ10 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ20"
        (cdr (assoc 'vyhodnotenieQ20 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ50"
        (cdr (assoc 'vyhodnotenieQ50 out)))
      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ100"
        (cdr (assoc 'vyhodnotenieQ100 out)))
    )
  )
)


;;----------------------------------------------------------------------;;
;;            Funkcia vyberu polyliny pre hydrotechnicky vypocet        ;;
;;----------------------------------------------------------------------;;

(defun PolylineKorytaHydrotechnicalCalculation ()
  (vl-load-com)
  (setq ent (entsel "\nVyber polylinu koryta: "))
  (if ent
    (progn
      (setq obj (vlax-ename->vla-object (car ent)))
      (if (= (vla-get-objectname obj) "AcDbPolyline")
        (progn
          (setq *hydro_plocha* (vla-get-area obj))
          (setq *hydro_obvod* (vla-get-length obj))
          (princ (strcat "\nPlocha: " (rtos *hydro_plocha* 2 2) " m²\n"))
          (princ (strcat "Obvod: " (rtos *hydro_obvod* 2 2) " m\n"))
        )
        (princ "\nVybrana entita nie je polylina.\n")
      )
    )
    (princ "\nNevybral si ziadnu polylinu.\n")
  )
)


;;----------------------------------------------------------------------;;
;;                  Funkcia reportu                                     ;;
;;----------------------------------------------------------------------;;

(defun ReportHydrotechnicalCalculation ( /
    in out err filePath file
    dwgName dwgPrefix reportDateTime defaultName reportDateForName
    q q1 q2 q5 q10 q20 q50 q100
    evalQ1 evalQ2 evalQ5 evalQ10 evalQ20 evalQ50 evalQ100
    h1 h2 L deltaH sklonI sklonPercent
    y1 y2
  )

  (defun HydroWriteLine (f s)
    (write-line s f)
  )

  (defun HydroStatusClass (txt / t1)
    (setq t1 (strcase txt))
    (cond
      ((wcmatch t1 "*VYHOV*") "ok")
      ((wcmatch t1 "*NEVYHOV*") "bad")
      (T "neutral")
    )
  )

  (setq in  (HydroGetInputs))
  (setq out (HydroCalculate in))
  (setq err (cdr (assoc 'error out)))

  (if err
    (alert err)
    (progn
      (setq dwgName   (getvar "DWGNAME"))
      (setq dwgPrefix (getvar "DWGPREFIX"))
      (setq reportDateTime    (menucmd "M=$(edtime,$(getvar,date),DD.MM.YYYY HH:MM:SS)"))
      (setq reportDateForName (menucmd "M=$(edtime,$(getvar,date),YYYYMMDD)"))

      (setq defaultName
        (strcat "Hydrotechnical_report_" reportDateForName ".html")
      )

      (setq filePath
        (getfiled
          "Ulozit hydrotechnicky report"
          (strcat dwgPrefix defaultName)
          "html"
          1
        )
      )

      (if filePath
        (progn
          (setq file (open filePath "w"))

          (if file
            (progn
              (setq q    (cdr (assoc 'prietok_Q out)))
              (setq q1   (cdr (assoc 'prietok_Q1 out)))
              (setq q2   (cdr (assoc 'prietok_Q2 out)))
              (setq q5   (cdr (assoc 'prietok_Q5 out)))
              (setq q10  (cdr (assoc 'prietok_Q10 out)))
              (setq q20  (cdr (assoc 'prietok_Q20 out)))
              (setq q50  (cdr (assoc 'prietok_Q50 out)))
              (setq q100 (cdr (assoc 'prietok_Q100 out)))

              (setq evalQ1   (cdr (assoc 'vyhodnotenieQ1 out)))
              (setq evalQ2   (cdr (assoc 'vyhodnotenieQ2 out)))
              (setq evalQ5   (cdr (assoc 'vyhodnotenieQ5 out)))
              (setq evalQ10  (cdr (assoc 'vyhodnotenieQ10 out)))
              (setq evalQ20  (cdr (assoc 'vyhodnotenieQ20 out)))
              (setq evalQ50  (cdr (assoc 'vyhodnotenieQ50 out)))
              (setq evalQ100 (cdr (assoc 'vyhodnotenieQ100 out)))

              (setq h1 (cdr (assoc 'vyska_h1 out)))
              (setq h2 (cdr (assoc 'vyska_h2 out)))
              (setq L  (cdr (assoc 'dlzka_L out)))
              (setq deltaH (cdr (assoc 'delta_h out)))
              (setq sklonI (cdr (assoc 'sklon_i out)))
              (setq sklonPercent (* sklonI 100.0))

              ;; Y suradnice pre jednoduchu SVG geometriu
              ;; vacsia vyska = vyssie v obrazku
              (setq y1 90)
              (setq y2 150)

              (HydroWriteLine file "<!DOCTYPE html>")
              (HydroWriteLine file "<html lang='sk'>")
              (HydroWriteLine file "<head>")
              (HydroWriteLine file "  <meta charset='UTF-8'>")
              (HydroWriteLine file "  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>")
              (HydroWriteLine file "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>")
              (HydroWriteLine file "  <title>Hydrotechnicky report</title>")
              (HydroWriteLine file "  <style>")
              (HydroWriteLine file "    :root {")
              (HydroWriteLine file "      --bg:#f3f6fb; --panel:#ffffff; --panel2:#f8fafc; --text:#1f2937;")
              (HydroWriteLine file "      --muted:#6b7280; --line:#e5e7eb; --primary:#0f766e; --primary2:#155e75;")
              (HydroWriteLine file "      --ok:#166534; --okbg:#dcfce7; --bad:#991b1b; --badbg:#fee2e2;")
              (HydroWriteLine file "      --neutral:#92400e; --neutralbg:#fef3c7; --shadow:0 10px 30px rgba(15,23,42,.08);")
              (HydroWriteLine file "      --radius:18px;")
              (HydroWriteLine file "    }")
              (HydroWriteLine file "    *{box-sizing:border-box}")
              (HydroWriteLine file "    body{margin:0;font-family:Arial,Helvetica,sans-serif;background:linear-gradient(180deg,#eef4f8 0%,#f8fafc 100%);color:var(--text)}")
              (HydroWriteLine file "    .wrap{max-width:1200px;margin:0 auto;padding:32px 20px 56px}")
              (HydroWriteLine file "    .hero{background:linear-gradient(135deg,var(--primary) 0%,var(--primary2) 100%);color:#fff;border-radius:24px;padding:32px;box-shadow:var(--shadow);margin-bottom:24px}")
              (HydroWriteLine file "    .hero h1{margin:0 0 8px;font-size:34px}")
              (HydroWriteLine file "    .hero p{margin:0;color:rgba(255,255,255,.88)}")
              (HydroWriteLine file "    .meta{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:16px;margin-top:22px}")
              (HydroWriteLine file "    .meta-card{background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.18);border-radius:16px;padding:16px}")
              (HydroWriteLine file "    .meta-card .label{font-size:12px;text-transform:uppercase;letter-spacing:.08em;opacity:.82;margin-bottom:6px}")
              (HydroWriteLine file "    .meta-card .value{font-size:16px;font-weight:bold;word-break:break-word}")
              (HydroWriteLine file "    .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(340px,1fr));gap:20px}")
              (HydroWriteLine file "    .card{background:var(--panel);border:1px solid var(--line);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden}")
              (HydroWriteLine file "    .card-head{padding:18px 22px;background:var(--panel2);border-bottom:1px solid var(--line)}")
              (HydroWriteLine file "    .card-head h2{margin:0;font-size:20px}")
              (HydroWriteLine file "    .card-body{padding:20px 22px 22px}")
              (HydroWriteLine file "    table{width:100%;border-collapse:collapse}")
              (HydroWriteLine file "    th,td{padding:12px 10px;border-bottom:1px solid var(--line);text-align:left;vertical-align:middle}")
              (HydroWriteLine file "    th{font-size:13px;text-transform:uppercase;letter-spacing:.04em;color:var(--muted)}")
              (HydroWriteLine file "    td.num{text-align:right;font-variant-numeric:tabular-nums}")
              (HydroWriteLine file "    .kpi{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:14px}")
              (HydroWriteLine file "    .kpi-box{background:var(--panel2);border:1px solid var(--line);border-radius:16px;padding:16px}")
              (HydroWriteLine file "    .kpi-box .label{color:var(--muted);font-size:13px;margin-bottom:8px}")
              (HydroWriteLine file "    .kpi-box .value{font-size:26px;font-weight:bold;color:var(--primary)}")
              (HydroWriteLine file "    .badge{display:inline-block;padding:6px 10px;border-radius:999px;font-size:12px;font-weight:bold}")
              (HydroWriteLine file "    .badge.ok{color:var(--ok);background:var(--okbg)}")
              (HydroWriteLine file "    .badge.bad{color:var(--bad);background:var(--badbg)}")
              (HydroWriteLine file "    .badge.neutral{color:var(--neutral);background:var(--neutralbg)}")
              (HydroWriteLine file "    .geom{background:linear-gradient(180deg,#fcfdff 0%,#f8fafc 100%);border:1px solid var(--line);border-radius:16px;padding:14px}")
              (HydroWriteLine file "    .geom svg{width:100%;height:auto;display:block}")
              (HydroWriteLine file "    .geom-note{margin-top:10px;color:var(--muted);font-size:13px}")
              (HydroWriteLine file "    .foot{margin-top:24px;color:var(--muted);font-size:13px;text-align:center}")
              (HydroWriteLine file "    @media (max-width:700px){.hero h1{font-size:26px}.wrap{padding:20px 14px 40px}th,td{padding:10px 8px;font-size:14px}}")
              (HydroWriteLine file "  </style>")
              (HydroWriteLine file "</head>")
              (HydroWriteLine file "<body>")
              (HydroWriteLine file "  <div class='wrap'>")

              ;; Hero
              (HydroWriteLine file "    <section class='hero'>")
              (HydroWriteLine file "      <h1>Hydrotechnicky vypocet kapacity koryta</h1>")
              (HydroWriteLine file "      <p>Prehlad vstupov, vysledkov vypoctu a posudenia prietokov v modernom HTML reporte.</p>")
              (HydroWriteLine file "      <div class='meta'>")
              (HydroWriteLine file (strcat "        <div class='meta-card'><div class='label'>Zdrojovy DWG</div><div class='value'>" dwgName "</div></div>"))
              (HydroWriteLine file (strcat "        <div class='meta-card'><div class='label'>Datum a cas</div><div class='value'>" reportDateTime "</div></div>"))
              (HydroWriteLine file (strcat "        <div class='meta-card'><div class='label'>Kapacita koryta Q</div><div class='value'>" (rtos q 2 2) " m3/s</div></div>"))
              (HydroWriteLine file (strcat "        <div class='meta-card'><div class='label'>Sklon koryta</div><div class='value'>" (rtos sklonPercent 2 2) " %</div></div>"))
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              ;; Horna sekcia: vstupy + geometria
              (HydroWriteLine file "    <div class='grid'>")

              (HydroWriteLine file "      <section class='card'>")
              (HydroWriteLine file "        <div class='card-head'><h2>Vstupne hodnoty</h2></div>")
              (HydroWriteLine file "        <div class='card-body'>")
              (HydroWriteLine file "          <table>")
              (HydroWriteLine file "            <thead><tr><th>Parameter</th><th>Hodnota</th></tr></thead>")
              (HydroWriteLine file "            <tbody>")
              (HydroWriteLine file (strcat "              <tr><td>Vyska na zaciatku koryta</td><td class='num'>" (rtos h1 2 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Vyska na konci koryta</td><td class='num'>" (rtos h2 2 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Dlzka koryta</td><td class='num'>" (rtos L 2 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Stupen drsnosti n</td><td class='num'>" (rtos (cdr (assoc 'drsnost_n out)) 2 3) " -</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Prietocna plocha S</td><td class='num'>" (rtos (cdr (assoc 'plocha_S out)) 2 2) " m2</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Omoceny obvod O</td><td class='num'>" (rtos (cdr (assoc 'obvod_O out)) 2 2) " m</td></tr>"))
              (HydroWriteLine file "            </tbody>")
              (HydroWriteLine file "          </table>")
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </section>")

              (HydroWriteLine file "      <section class='card'>")
              (HydroWriteLine file "        <div class='card-head'><h2>Pozdlzny sklon koryta</h2></div>")
              (HydroWriteLine file "        <div class='card-body'>")
              (HydroWriteLine file "          <div class='geom'>")
              (HydroWriteLine file "            <svg viewBox='0 0 760 260' xmlns='http://www.w3.org/2000/svg'>")
              (HydroWriteLine file "              <defs>")
              (HydroWriteLine file "                <marker id='arrow' markerWidth='10' markerHeight='10' refX='8' refY='5' orient='auto'>")
              (HydroWriteLine file "                  <path d='M0,0 L10,5 L0,10 z' fill='#475569' />")
              (HydroWriteLine file "                </marker>")
              (HydroWriteLine file "              </defs>")
              (HydroWriteLine file "              <rect x='0' y='0' width='760' height='260' fill='#f8fafc'/>")
              (HydroWriteLine file "              <line x1='70' y1='190' x2='690' y2='190' stroke='#cbd5e1' stroke-width='2'/>")

              (HydroWriteLine file "              <line x1='110' y1='90' x2='650' y2='150' stroke='#0f766e' stroke-width='6' stroke-linecap='round'/>")
              (HydroWriteLine file "              <circle cx='110' cy='90' r='6' fill='#0f766e'/>")
              (HydroWriteLine file "              <circle cx='650' cy='150' r='6' fill='#0f766e'/>")

              (HydroWriteLine file "              <line x1='110' y1='90' x2='110' y2='190' stroke='#94a3b8' stroke-dasharray='6 5'/>")
              (HydroWriteLine file "              <line x1='650' y1='150' x2='650' y2='190' stroke='#94a3b8' stroke-dasharray='6 5'/>")

              (HydroWriteLine file "              <line x1='110' y1='210' x2='650' y2='210' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='380' y='232' text-anchor='middle' font-size='16' fill='#334155'>Dlzka L</text>")
              (HydroWriteLine file (strcat "              <text x='380' y='250' text-anchor='middle' font-size='18' font-weight='700' fill='#0f172a'>" (rtos L 2 3) " m</text>"))

              (HydroWriteLine file "              <line x1='82' y1='90' x2='82' y2='190' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='68' y='145' text-anchor='end' font-size='16' fill='#334155'>h1</text>")
              (HydroWriteLine file (strcat "              <text x='68' y='165' text-anchor='end' font-size='16' font-weight='700' fill='#0f172a'>" (rtos h1 2 3) " m</text>"))

              (HydroWriteLine file "              <line x1='678' y1='150' x2='678' y2='190' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='692' y='164' text-anchor='start' font-size='16' fill='#334155'>h2</text>")
              (HydroWriteLine file (strcat "              <text x='692' y='184' text-anchor='start' font-size='16' font-weight='700' fill='#0f172a'>" (rtos h2 2 3) " m</text>"))

              (HydroWriteLine file "              <rect x='280' y='40' width='200' height='56' rx='12' fill='#e6fffb' stroke='#99f6e4'/>")
              (HydroWriteLine file "              <text x='380' y='62' text-anchor='middle' font-size='14' fill='#115e59'>Sklon koryta i</text>")
              (HydroWriteLine file (strcat "              <text x='380' y='82' text-anchor='middle' font-size='18' font-weight='700' fill='#0f766e'>" (rtos sklonI 2 5) " = " (rtos sklonPercent 2 2) " %</text>"))

              (HydroWriteLine file "            </svg>")
              (HydroWriteLine file "          </div>")
              (HydroWriteLine file (strcat "          <div class='geom-note'>Geometria zobrazuje pozdlzny priebeh dna koryta medzi zaciatkom a koncom useku. Vyskovy rozdiel dh = " (rtos deltaH 2 2) " m.</div>"))
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </section>")

              (HydroWriteLine file "    </div>")

              ;; Hlavne vysledky
              (HydroWriteLine file "    <section class='card' style='margin-top:20px;'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Hlavne vysledky vypoctu</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")
              (HydroWriteLine file "        <div class='kpi'>")
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Vyskovy rozdiel dh</div><div class='value'>" (rtos deltaH 2 2) " m</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Sklon i</div><div class='value'>" (rtos sklonI 2 5) "</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Hydraulicky polomer R</div><div class='value'>" (rtos (cdr (assoc 'hydroraulickyPolomer_R out)) 2 3) " m</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Rychlostny sucinitel C</div><div class='value'>" (rtos (cdr (assoc 'rychlostnySucinitelKoryta_C out)) 2 3) "</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Kapacita koryta Q</div><div class='value'>" (rtos q 2 2) " m3/s</div></div>"))
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              ;; Posudenie prietokov - jedina tabulka s Q navrhovymi hodnotami
              (HydroWriteLine file "    <section class='card' style='margin-top:20px;'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Posudenie prietokov</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")
              (HydroWriteLine file "        <table>")
              (HydroWriteLine file "          <thead><tr><th>Prietok</th><th>Navrhovany prietok</th><th>Kapacita koryta</th><th>Vyhodnotenie</th></tr></thead>")
              (HydroWriteLine file "          <tbody>")

              (HydroWriteLine file (strcat
                "            <tr><td>Q1</td><td class='num'>" (rtos q1 2 2) " m3/s</td><td class='num'>" (rtos q 2 2) " m3/s</td><td><span class='badge "
                (HydroStatusClass evalQ1) "'>" evalQ1 "</span></td></tr>"))

              (HydroWriteLine file (strcat
                "            <tr><td>Q2</td><td class='num'>" (rtos q2 2 2) " m3/s</td><td class='num'>" (rtos q 2 2) " m3/s</td><td><span class='badge "
                (HydroStatusClass evalQ2) "'>" evalQ2 "</span></td></tr>"))

              (HydroWriteLine file (strcat
                "            <tr><td>Q5</td><td class='num'>" (rtos q5 2 2) " m3/s</td><td class='num'>" (rtos q 2 2) " m3/s</td><td><span class='badge "
                (HydroStatusClass evalQ5) "'>" evalQ5 "</span></td></tr>"))

              (HydroWriteLine file (strcat
                "            <tr><td>Q10</td><td class='num'>" (rtos q10 2 2) " m3/s</td><td class='num'>" (rtos q 2 2) " m3/s</td><td><span class='badge "
                (HydroStatusClass evalQ10) "'>" evalQ10 "</span></td></tr>"))

              (HydroWriteLine file (strcat
                "            <tr><td>Q20</td><td class='num'>" (rtos q20 2 2) " m3/s</td><td class='num'>" (rtos q 2 2) " m3/s</td><td><span class='badge "
                (HydroStatusClass evalQ20) "'>" evalQ20 "</span></td></tr>"))

              (HydroWriteLine file (strcat
                "            <tr><td>Q50</td><td class='num'>" (rtos q50 2 2) " m3/s</td><td class='num'>" (rtos q 2 2) " m3/s</td><td><span class='badge "
                (HydroStatusClass evalQ50) "'>" evalQ50 "</span></td></tr>"))

              (HydroWriteLine file (strcat
                "            <tr><td>Q100</td><td class='num'>" (rtos q100 2 2) " m3/s</td><td class='num'>" (rtos q 2 2) " m3/s</td><td><span class='badge "
                (HydroStatusClass evalQ100) "'>" evalQ100 "</span></td></tr>"))

              (HydroWriteLine file "          </tbody>")
              (HydroWriteLine file "        </table>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              (HydroWriteLine file "    <div class='foot'>HTML report bol vytvoreny automaticky z vypoctu hydrotechnickej kapacity koryta.</div>")
              (HydroWriteLine file "  </div>")
              (HydroWriteLine file "</body>")
              (HydroWriteLine file "</html>")

              (close file)
              (alert (strcat "HTML report bol ulozeny do suboru:\n" filePath))
              (princ (strcat "\nHTML report bol ulozeny: " filePath))
            )
            (alert "Subor reportu sa nepodarilo vytvorit.")
          )
        )
        (princ "\nUkladanie reportu bolo zrusene pouzivatelom.")
      )
    )
  )

  (princ)
)

;;----------------------------------------------------------------------;;
;;                  Funkcia zavretia dialogoveho okna                   ;;
;;----------------------------------------------------------------------;;

(defun UkoncenieHydrotechnicalCalculation()
  ; ulozenie hodnot pred zatvorenim
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

  ; zavretie dialogu
  (done_dialog)
  (princ "\nUkoncenie hydrotechnickeho vypoctu.\n")
)


;;----------------------------------------------------------------------;;

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


;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;