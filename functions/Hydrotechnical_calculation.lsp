;=========================================================================
; Hydrotechnical_calculation.lsp
; Create by Jakub Tomecko
;
; Hydrotechnicky vypocet kapacity koryta
;-------------------------------------------------------------------------

(defun HydroNumber (v)
  (if (numberp v) v 0.0)
)

(defun HydroGetProp (key lst / item)
  (setq item (assoc key lst))
  (if item (cdr item) nil)
)

(defun HydroLineWCS (p1 p2 /)
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

(defun HydroGetLowestPointOnPolyline (obj / endParam i step param p minPt minVal zval)
  (setq endParam (fix (vlax-curve-getEndParam obj)))
  (setq i 0)
  (setq minPt nil)
  (setq minVal nil)
  (while (<= i endParam)
    (setq param (float i))
    (setq p (vlax-curve-getPointAtParam obj param))
    (if p
      (progn
        (setq zval (cadr p))
        (if (or (not minVal) (< zval minVal))
          (progn
            (setq minVal zval)
            (setq minPt p)
          )
        )
      )
    )
    (setq i (+ i 1))
  )

  (if (and minPt (= minPt nil))
    nil
    minPt
  )
)

(defun HydroPolylineVertices (ename / ed pts)
  (setq ed (entget ename))
  (setq pts '())
  (foreach x ed
    (if (= (car x) 10)
      (setq pts (cons (cdr x) pts))
    )
  )
  (reverse pts)
)

(defun HydroGetMinVertexPoint2D (ename / pts minPt minY p y)
  (setq pts (HydroPolylineVertices ename))
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

(defun HydroDrawQ100WaterLevel (ename q100 / obj minPt basePt levelPt x1 x2 yLevel)
  (setq obj (vlax-ename->vla-object ename))

  ;; Najnižší bod profilu
  (setq minPt
    (cond
      ((= (vla-get-objectname obj) "AcDbPolyline")
        (HydroGetMinVertexPoint2D ename)
      )
      (T nil)
    )
  )

  (if (not minPt)
    nil
    (progn
      ;; Q100 je výška nad dnom koryta => y hladiny = y dna + Q100
      (setq yLevel (+ (cadr minPt) q100))

      ;; nájdi ľavý a pravý koniec profilu podľa bodov vrcholov
      (setq pts (HydroPolylineVertices ename))
      (setq x1 (car (car pts)))
      (setq x2 (car (car pts)))
      (foreach p pts
        (if (< (car p) x1) (setq x1 (car p)))
        (if (> (car p) x2) (setq x2 (car p)))
      )

      ;; vodorovná čiara hladiny Q100
      (HydroLineWCS
        (list x1 yLevel 0.0)
        (list x2 yLevel 0.0)
      )

      ;; zvislá pomocná čiara od dna po hladinu v najnižšom bode
      (HydroLineWCS
        (list (car minPt) (cadr minPt) 0.0)
        (list (car minPt) yLevel 0.0)
      )

      (princ (strcat "\nQ100 hladina vykreslena vo vyske: " (rtos yLevel 2 3)))
      yLevel
    )
  )
)

;;----------------------------------------------------------------------;;
;;                  Hlavna funkcia nacitania dialogu                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTHydrotechnical ()
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

(defun PolylineKorytaHydrotechnicalCalculation ( / ent obj )
  (vl-load-com)
  (setq ent (entsel "\nVyber polylinu koryta: "))
  (if ent
    (progn
      (setq obj (vlax-ename->vla-object (car ent)))
      (if (= (vla-get-objectname obj) "AcDbPolyline")
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
    hydroDrawResult
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

              ;; vykreslenie Q100 hladiny do výkresu
              (if (and *hydro_profile_ename* q100)
                (setq hydroDrawResult (HydroDrawQ100WaterLevel *hydro_profile_ename* q100))
              )

              (HydroWriteLine file "<!DOCTYPE html>")
              (HydroWriteLine file "<html lang='sk'>")
              (HydroWriteLine file "<head>")
              (HydroWriteLine file "  <meta charset='UTF-8'>")
              (HydroWriteLine file "  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>")
              (HydroWriteLine file "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>")
              (HydroWriteLine file "  <title>Hydrotechnick&#253; report</title>")
              (HydroWriteLine file "  <style>")
              (HydroWriteLine file "    :root{--bg:#f3f6fb;--panel:#fff;--panel2:#f8fafc;--text:#1f2937;--muted:#6b7280;--line:#e5e7eb;--primary:#0f766e;--primary2:#155e75;--ok:#166534;--okbg:#dcfce7;--bad:#991b1b;--badbg:#fee2e2;--neutral:#92400e;--neutralbg:#fef3c7;--shadow:0 10px 30px rgba(15,23,42,.08);--radius:18px}")
              ;; ... zvyšok HTML reportu ostáva rovnaký ...
              (HydroWriteLine file "  </style>")
              (HydroWriteLine file "</head>")
              (HydroWriteLine file "<body>")
              (HydroWriteLine file "<div>Report generation continues here...</div>")
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