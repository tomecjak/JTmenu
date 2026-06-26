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
    drsnostN plochaS obvodO R C
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
    (setq t1 (strcase (if txt txt "")))
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
              (setq drsnostN (cdr (assoc 'drsnost_n out)))
              (setq plochaS (cdr (assoc 'plocha_S out)))
              (setq obvodO (cdr (assoc 'obvod_O out)))
              (setq R (cdr (assoc 'hydroraulickyPolomer_R out)))
              (setq C (cdr (assoc 'rychlostnySucinitelKoryta_C out)))

              (HydroWriteLine file "<!DOCTYPE html>")
              (HydroWriteLine file "<html lang='sk'>")
              (HydroWriteLine file "<head>")
              (HydroWriteLine file "  <meta charset='UTF-8'>")
              (HydroWriteLine file "  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>")
              (HydroWriteLine file "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>")
              (HydroWriteLine file "  <title>Hydrotechnick&#253; report</title>")
              (HydroWriteLine file "  <style>")
              (HydroWriteLine file "    :root{--bg:#f3f6fb;--panel:#fff;--panel2:#f8fafc;--text:#1f2937;--muted:#6b7280;--line:#e5e7eb;--primary:#0f766e;--primary2:#155e75;--ok:#166534;--okbg:#dcfce7;--bad:#991b1b;--badbg:#fee2e2;--neutral:#92400e;--neutralbg:#fef3c7;--shadow:0 6px 20px rgba(15,23,42,.06);--radius:12px}")
              (HydroWriteLine file "    *{box-sizing:border-box}")
              (HydroWriteLine file "    html,body{margin:0;padding:0;font-family:Arial,Helvetica,sans-serif;color:var(--text);background:#eef4f8}")
              (HydroWriteLine file "    body{font-size:13px;line-height:1.35}")
              (HydroWriteLine file "    .wrap{max-width:1120px;margin:0 auto;padding:14px}")
              (HydroWriteLine file "    .toolbar{display:flex;justify-content:flex-end;gap:8px;margin-bottom:10px}")
              (HydroWriteLine file "    .btn{appearance:none;border:0;border-radius:10px;padding:8px 12px;font-weight:700;cursor:pointer;font-size:12px}")
              (HydroWriteLine file "    .btn-print{background:#111827;color:#fff}")
              (HydroWriteLine file "    .hero{background:linear-gradient(135deg,var(--primary) 0%,var(--primary2) 100%);color:#fff;border-radius:16px;padding:14px 16px;box-shadow:var(--shadow);margin-bottom:10px}")
              (HydroWriteLine file "    .hero h1{margin:0 0 4px;font-size:22px;line-height:1.1}")
              (HydroWriteLine file "    .hero p{margin:0;font-size:12px;color:rgba(255,255,255,.9)}")
              (HydroWriteLine file "    .meta{display:grid;grid-template-columns:repeat(4,1fr);gap:8px;margin-top:10px}")
              (HydroWriteLine file "    .meta-card{background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.18);border-radius:10px;padding:8px 10px}")
              (HydroWriteLine file "    .meta-card .label{font-size:10px;text-transform:uppercase;letter-spacing:.05em;opacity:.82;margin-bottom:3px}")
              (HydroWriteLine file "    .meta-card .value{font-size:13px;font-weight:bold;word-break:break-word}")
              (HydroWriteLine file "    .grid{display:grid;grid-template-columns:1fr 1fr;gap:10px}")
              (HydroWriteLine file "    .card{background:var(--panel);border:1px solid var(--line);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden;break-inside:avoid;page-break-inside:avoid}")
              (HydroWriteLine file "    .card-head{padding:10px 12px;background:var(--panel2);border-bottom:1px solid var(--line)}")
              (HydroWriteLine file "    .card-head h2{margin:0;font-size:14px;line-height:1.2}")
              (HydroWriteLine file "    .card-body{padding:10px 12px}")
              (HydroWriteLine file "    table{width:100%;border-collapse:collapse;font-size:12px}")
              (HydroWriteLine file "    th,td{padding:6px 6px;border-bottom:1px solid var(--line);text-align:left;vertical-align:top;line-height:1.25}")
              (HydroWriteLine file "    th{font-size:10px;text-transform:uppercase;letter-spacing:.04em;color:var(--muted)}")
              (HydroWriteLine file "    td.num{text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}")
              (HydroWriteLine file "    .kpi{display:grid;grid-template-columns:repeat(5,1fr);gap:8px}")
              (HydroWriteLine file "    .kpi-box{background:var(--panel2);border:1px solid var(--line);border-radius:10px;padding:8px 10px}")
              (HydroWriteLine file "    .kpi-box .label{color:var(--muted);font-size:10px;margin-bottom:4px;line-height:1.15}")
              (HydroWriteLine file "    .kpi-box .value{font-size:18px;font-weight:bold;color:var(--primary);line-height:1.1}")
              (HydroWriteLine file "    .badge{display:inline-block;padding:4px 8px;border-radius:999px;font-size:10px;font-weight:bold;white-space:nowrap}")
              (HydroWriteLine file "    .badge.ok{color:var(--ok);background:var(--okbg)}")
              (HydroWriteLine file "    .badge.bad{color:var(--bad);background:var(--badbg)}")
              (HydroWriteLine file "    .badge.neutral{color:var(--neutral);background:var(--neutralbg)}")
              (HydroWriteLine file "    .geom{background:linear-gradient(180deg,#fcfdff 0%,#f8fafc 100%);border:1px solid var(--line);border-radius:10px;padding:8px}")
              (HydroWriteLine file "    .geom svg{width:100%;height:auto;display:block}")
              (HydroWriteLine file "    .geom-note{margin-top:6px;color:var(--muted);font-size:11px;line-height:1.25}")
              (HydroWriteLine file "    .formula-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px}")
              (HydroWriteLine file "    .formula{background:#fbfdff;border:1px solid var(--line);border-radius:10px;padding:8px 10px;margin:0}")
              (HydroWriteLine file "    .formula h3{margin:0 0 4px;font-size:12px;line-height:1.15}")
              (HydroWriteLine file "    .formula .eq{font-family:'Courier New',monospace;font-size:11px;color:#0f172a;line-height:1.35}")
              (HydroWriteLine file "    .formula .sub{margin-top:4px;color:var(--muted);font-size:10px;line-height:1.3}")
              (HydroWriteLine file "    .section-gap{margin-top:10px}")
              (HydroWriteLine file "    .foot{margin-top:10px;color:var(--muted);font-size:10px;text-align:center}")
              (HydroWriteLine file "    @page{size:A4 portrait;margin:7mm}")
              (HydroWriteLine file "    @media print{html,body{width:210mm;height:297mm;background:#fff;-webkit-print-color-adjust:exact;print-color-adjust:exact}body{font-size:11px;line-height:1.2}.toolbar{display:none}.wrap{width:196mm;max-width:196mm;padding:0;margin:0 auto}.hero{box-shadow:none;margin-bottom:6px;padding:10px 12px;border-radius:10px}.hero h1{font-size:18px;margin-bottom:2px}.hero p{font-size:10px}.meta{gap:5px;margin-top:6px}.meta-card{padding:5px 6px;border-radius:8px}.meta-card .label{font-size:8px;margin-bottom:2px}.meta-card .value{font-size:10px;line-height:1.15}.grid{gap:6px}.section-gap{margin-top:6px}.card{box-shadow:none;border-radius:8px}.card-head{padding:6px 8px}.card-head h2{font-size:11px}.card-body{padding:6px 8px}table{font-size:9px}th,td{padding:3px 4px;line-height:1.15}th{font-size:8px}.kpi{gap:5px}.kpi-box{padding:5px 6px;border-radius:8px}.kpi-box .label{font-size:8px;margin-bottom:2px}.kpi-box .value{font-size:12px}.badge{font-size:8px;padding:2px 6px}.geom{padding:4px;border-radius:8px}.geom-note{font-size:8px;margin-top:4px}.formula-grid{gap:5px}.formula{padding:5px 6px;border-radius:8px}.formula h3{font-size:9px;margin-bottom:2px}.formula .eq{font-size:8px;line-height:1.2}.formula .sub{font-size:8px;line-height:1.2;margin-top:2px}.foot{margin-top:6px;font-size:8px}.card,.hero,.formula,.kpi-box,tr,td,th{break-inside:avoid;page-break-inside:avoid}.no-print{display:none!important}}")
              (HydroWriteLine file "    @media (max-width:900px){.meta,.grid,.kpi,.formula-grid{grid-template-columns:1fr}}")
              (HydroWriteLine file "  </style>")
              (HydroWriteLine file "</head>")
              (HydroWriteLine file "<body>")
              (HydroWriteLine file "  <div class='wrap'>")
              (HydroWriteLine file "    <div class='toolbar'>")
              (HydroWriteLine file "      <button class='btn btn-print' onclick='window.print()'>Export do PDF / Tla&#269;</button>")
              (HydroWriteLine file "    </div>")

              (HydroWriteLine file "    <section class='hero'>")
              (HydroWriteLine file "      <h1>Hydrotechnick&#253; v&#253;po&#269;et kapacity koryta</h1>")
              (HydroWriteLine file "      <p>Kompaktn&#253; jednostranov&#253; report optimalizovan&#253; pre A4 a export do PDF.</p>")
              (HydroWriteLine file "      <div class='meta'>")
              (HydroWriteLine file (strcat "        <div class='meta-card'><div class='label'>Zdrojov&#253; DWG</div><div class='value'>" (HydroSafe dwgName) "</div></div>"))
              (HydroWriteLine file (strcat "        <div class='meta-card'><div class='label'>D&#225;tum a &#269;as</div><div class='value'>" (HydroSafe reportDateTime) "</div></div>"))
              (HydroWriteLine file (strcat "        <div class='meta-card'><div class='label'>Kapacita koryta Q</div><div class='value'>" (HydroFmt q 2) " m3/s</div></div>"))
              (HydroWriteLine file (strcat "        <div class='meta-card'><div class='label'>Sklon koryta</div><div class='value'>" (HydroFmt sklonPercent 2) " %</div></div>"))
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              (HydroWriteLine file "    <div class='grid'>")

              (HydroWriteLine file "      <section class='card'>")
              (HydroWriteLine file "        <div class='card-head'><h2>Vstupn&#233; hodnoty</h2></div>")
              (HydroWriteLine file "        <div class='card-body'>")
              (HydroWriteLine file "          <table>")
              (HydroWriteLine file "            <thead><tr><th>Parameter</th><th>Hodnota</th></tr></thead>")
              (HydroWriteLine file "            <tbody>")
              (HydroWriteLine file (strcat "              <tr><td>V&#253;&#353;ka na za&#269;iatku koryta</td><td class='num'>" (HydroFmt h1 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>V&#253;&#353;ka na konci koryta</td><td class='num'>" (HydroFmt h2 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>D&#314;&#382;ka koryta</td><td class='num'>" (HydroFmt L 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Stupe&#328; drsnosti n</td><td class='num'>" (HydroFmt drsnostN 3) " -</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Prieto&#269;n&#225; plocha S</td><td class='num'>" (HydroFmt plochaS 2) " m2</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Omo&#269;en&#253; obvod O</td><td class='num'>" (HydroFmt obvodO 2) " m</td></tr>"))
              (HydroWriteLine file "            </tbody>")
              (HydroWriteLine file "          </table>")
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </section>")

              (HydroWriteLine file "      <section class='card'>")
              (HydroWriteLine file "        <div class='card-head'><h2>Pozd&#314;&#382;ny sklon koryta</h2></div>")
              (HydroWriteLine file "        <div class='card-body'>")
              (HydroWriteLine file "          <div class='geom'>")
              (HydroWriteLine file "            <svg viewBox='0 0 760 220' xmlns='http://www.w3.org/2000/svg'>")
              (HydroWriteLine file "              <defs><marker id='arrow' markerWidth='10' markerHeight='10' refX='8' refY='5' orient='auto'><path d='M0,0 L10,5 L0,10 z' fill='#475569'/></marker></defs>")
              (HydroWriteLine file "              <rect x='0' y='0' width='760' height='220' fill='#f8fafc'/>")
              (HydroWriteLine file "              <line x1='70' y1='165' x2='690' y2='165' stroke='#cbd5e1' stroke-width='2'/>")
              (HydroWriteLine file "              <line x1='110' y1='78' x2='650' y2='128' stroke='#0f766e' stroke-width='6' stroke-linecap='round'/>")
              (HydroWriteLine file "              <circle cx='110' cy='78' r='6' fill='#0f766e'/>")
              (HydroWriteLine file "              <circle cx='650' cy='128' r='6' fill='#0f766e'/>")
              (HydroWriteLine file "              <line x1='110' y1='78' x2='110' y2='165' stroke='#94a3b8' stroke-dasharray='6 5'/>")
              (HydroWriteLine file "              <line x1='650' y1='128' x2='650' y2='165' stroke='#94a3b8' stroke-dasharray='6 5'/>")
              (HydroWriteLine file "              <line x1='110' y1='188' x2='650' y2='188' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='380' y='205' text-anchor='middle' font-size='15' fill='#334155'>D&#314;&#382;ka L</text>")
              (HydroWriteLine file (strcat "              <text x='380' y='219' text-anchor='middle' font-size='17' font-weight='700' fill='#0f172a'>" (HydroFmt L 3) " m</text>"))
              (HydroWriteLine file "              <line x1='82' y1='78' x2='82' y2='165' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='68' y='122' text-anchor='end' font-size='15' fill='#334155'>h1</text>")
              (HydroWriteLine file (strcat "              <text x='68' y='138' text-anchor='end' font-size='15' font-weight='700' fill='#0f172a'>" (HydroFmt h1 3) " m</text>"))
              (HydroWriteLine file "              <line x1='678' y1='128' x2='678' y2='165' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='692' y='138' text-anchor='start' font-size='15' fill='#334155'>h2</text>")
              (HydroWriteLine file (strcat "              <text x='692' y='154' text-anchor='start' font-size='15' font-weight='700' fill='#0f172a'>" (HydroFmt h2 3) " m</text>"))
              (HydroWriteLine file "              <rect x='280' y='28' width='200' height='44' rx='10' fill='#e6fffb' stroke='#99f6e4'/>")
              (HydroWriteLine file "              <text x='380' y='46' text-anchor='middle' font-size='13' fill='#115e59'>Sklon koryta i</text>")
              (HydroWriteLine file (strcat "              <text x='380' y='62' text-anchor='middle' font-size='16' font-weight='700' fill='#0f766e'>" (HydroFmt sklonI 5) " = " (HydroFmt sklonPercent 2) " %</text>"))
              (HydroWriteLine file "            </svg>")
              (HydroWriteLine file "          </div>")
              (HydroWriteLine file (strcat "          <div class='geom-note'>V&#253;&#353;kov&#253; rozdiel dh = " (HydroFmt deltaH 2) " m.</div>"))
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </section>")

              (HydroWriteLine file "    </div>")

              (HydroWriteLine file "    <section class='card section-gap'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Hlavn&#233; v&#253;sledky v&#253;po&#269;tu</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")
              (HydroWriteLine file "        <div class='kpi'>")
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>dh</div><div class='value'>" (HydroFmt deltaH 2) " m</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>i</div><div class='value'>" (HydroFmt sklonI 5) "</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>R</div><div class='value'>" (HydroFmt R 3) " m</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>C</div><div class='value'>" (HydroFmt C 3) "</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Q</div><div class='value'>" (HydroFmt q 2) " m3/s</div></div>"))
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              (HydroWriteLine file "    <section class='card section-gap'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Vzorce a postup v&#253;po&#269;tu</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")
              (HydroWriteLine file "        <div class='formula-grid'>")

              (HydroWriteLine file "          <div class='formula'>")
              (HydroWriteLine file "            <h3>1. V&#253;&#353;kov&#253; rozdiel</h3>")
              (HydroWriteLine file "            <div class='eq'>dh = h1 - h2</div>")
              (HydroWriteLine file (strcat "            <div class='sub'>dh = " (HydroFmt h1 3) " - " (HydroFmt h2 3) " = " (HydroFmt deltaH 2) " m</div>"))
              (HydroWriteLine file "          </div>")

              (HydroWriteLine file "          <div class='formula'>")
              (HydroWriteLine file "            <h3>2. Sklon koryta</h3>")
              (HydroWriteLine file "            <div class='eq'>i = dh / L</div>")
              (HydroWriteLine file (strcat "            <div class='sub'>i = " (HydroFmt deltaH 2) " / " (HydroFmt L 3) " = " (HydroFmt sklonI 5) " = " (HydroFmt sklonPercent 2) " %</div>"))
              (HydroWriteLine file "          </div>")

              (HydroWriteLine file "          <div class='formula'>")
              (HydroWriteLine file "            <h3>3. Hydraulick&#253; polomer</h3>")
              (HydroWriteLine file "            <div class='eq'>R = S / O</div>")
              (HydroWriteLine file (strcat "            <div class='sub'>R = " (HydroFmt plochaS 2) " / " (HydroFmt obvodO 2) " = " (HydroFmt R 3) " m</div>"))
              (HydroWriteLine file "          </div>")

              (HydroWriteLine file "          <div class='formula'>")
              (HydroWriteLine file "            <h3>4. R&#253;chlostn&#253; s&#250;&#269;inite&#318;</h3>")
              (HydroWriteLine file "            <div class='eq'>C = (1 / n) * R^(1/6)</div>")
              (HydroWriteLine file (strcat "            <div class='sub'>C = (1 / " (HydroFmt drsnostN 3) ") * " (HydroFmt R 3) "^(1/6) = " (HydroFmt C 3) "</div>"))
              (HydroWriteLine file "          </div>")

              (HydroWriteLine file "          <div class='formula'>")
              (HydroWriteLine file "            <h3>5. Kapacita koryta</h3>")
              (HydroWriteLine file "            <div class='eq'>Q = C * S * sqrt(R * i)</div>")
              (HydroWriteLine file (strcat "            <div class='sub'>Q = " (HydroFmt C 3) " * " (HydroFmt plochaS 2) " * sqrt(" (HydroFmt R 3) " * " (HydroFmt sklonI 5) ") = " (HydroFmt q 2) " m3/s</div>"))
              (HydroWriteLine file "          </div>")

              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              (HydroWriteLine file "    <section class='card section-gap'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Pos&#250;denie prietokov</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")
              (HydroWriteLine file "        <table>")
              (HydroWriteLine file "          <thead><tr><th>Prietok</th><th>N&#225;vrhovan&#253; prietok</th><th>Kapacita koryta</th><th>Vyhodnotenie</th></tr></thead>")
              (HydroWriteLine file "          <tbody>")
              (HydroWriteLine file (strcat "            <tr><td>Q1</td><td class='num'>" (HydroFmt q1 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ1) "'>" (HydroSafe evalQ1) "</span></td></tr>"))
              (HydroWriteLine file (strcat "            <tr><td>Q2</td><td class='num'>" (HydroFmt q2 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ2) "'>" (HydroSafe evalQ2) "</span></td></tr>"))
              (HydroWriteLine file (strcat "            <tr><td>Q5</td><td class='num'>" (HydroFmt q5 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ5) "'>" (HydroSafe evalQ5) "</span></td></tr>"))
              (HydroWriteLine file (strcat "            <tr><td>Q10</td><td class='num'>" (HydroFmt q10 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ10) "'>" (HydroSafe evalQ10) "</span></td></tr>"))
              (HydroWriteLine file (strcat "            <tr><td>Q20</td><td class='num'>" (HydroFmt q20 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ20) "'>" (HydroSafe evalQ20) "</span></td></tr>"))
              (HydroWriteLine file (strcat "            <tr><td>Q50</td><td class='num'>" (HydroFmt q50 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ50) "'>" (HydroSafe evalQ50) "</span></td></tr>"))
              (HydroWriteLine file (strcat "            <tr><td>Q100</td><td class='num'>" (HydroFmt q100 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ100) "'>" (HydroSafe evalQ100) "</span></td></tr>"))
              (HydroWriteLine file "          </tbody>")
              (HydroWriteLine file "        </table>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              (HydroWriteLine file "    <div class='foot'>Report bol vytvoren&#253; automaticky z hydrotechnick&#233;ho v&#253;po&#269;tu. PDF export je dostupn&#253; cez tla&#269;idlo hore.</div>")
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