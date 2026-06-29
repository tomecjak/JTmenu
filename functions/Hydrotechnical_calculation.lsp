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
    (cons 'prietok_Q100 (atof (get_tile "hodnotaPrietokuKorytaQ100")))
  )
)


;;----------------------------------------------------------------------;; 
;;               Jedina centralna funkcia pre vypocet                   ;;
;;----------------------------------------------------------------------;; 

(defun HydroCalculate (in /
    vyska_h1 vyska_h2 dlzka_L drsnost_n plocha_S obvod_O prietok_Q100
    delta_h sklon_i hydroraulickyPolomer_R rychlostnySucinitelKoryta_C prietok_Q
    vyhnotenieQ100 vyskaH
  )

  (setq vyska_h1   (cdr (assoc 'vyska_h1 in)))
  (setq vyska_h2   (cdr (assoc 'vyska_h2 in)))
  (setq dlzka_L    (cdr (assoc 'dlzka_L in)))
  (setq drsnost_n  (cdr (assoc 'drsnost_n in)))
  (setq plocha_S   (cdr (assoc 'plocha_S in)))
  (setq obvod_O    (cdr (assoc 'obvod_O in)))
  (setq prietok_Q100 (cdr (assoc 'prietok_Q100 in)))

  ; kontrola vstupov
  (cond
    ((<= dlzka_L 0.0)
      (list (cons 'error "Dlzka koryta musi byt vacsia ako 0.")))
    ((<= drsnost_n 0.0)
      (list (cons 'error "Stupen drsnosti musi byt vacsi ako 0.")))
    ((<= obvod_O 0.0)
      (list (cons 'error "Omoceny obvod musi byt vacsi ako 0. Najprv vyberte polylinu koryta.")))
    ((< plocha_S 0.0)
      (list (cons 'error "Prietocna plocha nemoze byt zaporna.")))
    ((<= prietok_Q100 0.0)
      (list (cons 'error "Q100 musi byt vacsi ako 0.")))
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

          ; vyhodnotenie Q100
          (setq vyhodnoteniQ100 (if (> prietok_Q prietok_Q100) "vyhovuje" "nevyhovuje"))

          ; vypocet vysky vodnej hladiny H nad dnom koryta
          ; H = S / (O / hydroraulickyPolomer_R) -- priblizne cez pomer Q100/Q * hydraulicky polomer
          ; Presnejsi sposob: H = (Q100 / (C * sqrt(i))) ^ (3/5) * (1/n)^... 
          ; Pouzivame zjednodusenu linearnu interpol: H_hladiny = vyska_h2 + (Q100/Q) * R
          ; Fyzikalne spravnejsi odhad: z Manninghovej rovnice S_hladiny = Q100 / (C * sqrt(i))
          ; a potom H = S_hladiny / (O / R) -- ale O zavisí od H => iteracia
          ; Pre jednoduchy odhad: predpokladame trapezovy/obdlznikovy profil
          ; H = vyska_h2 + S_hladiny / (O / R)  kde S_hladiny = Q100 / (C * sqrt(i * R) / R )
          ; Najjednoduchsie: vodna hladina = kota dna + vypoctova hlbka
          ; Hlbka vody d = R * (O / (S/d)) -- iteracne
          ; Pre tento vypocet: pouzijeme aproximaciu cez pomer Q100/Q a R
          ; d_approx = R * (Q100/Q)^(3/5)  -- z Manningovej s konstantnym profilom
          (if (> prietok_Q 0.0)
            (setq vyskaH (* hydroraulickyPolomer_R (expt (/ prietok_Q100 prietok_Q) (/ 3.0 5.0))))
            (setq vyskaH 0.0)
          )

          ; kota vodnej hladiny Q100 = najnizsi bod koryta + vypoctova hlbka
          ; Najnizsi bod = vyska_h2 (koniec koryta, nizsia kota)
          (setq kotaVodnejHladiny (+ vyska_h2 vyskaH))

          (append
            in
            (list
              (cons 'delta_h delta_h)
              (cons 'sklon_i sklon_i)
              (cons 'hydroraulickyPolomer_R hydroraulickyPolomer_R)
              (cons 'rychlostnySucinitelKoryta_C rychlostnySucinitelKoryta_C)
              (cons 'prietok_Q prietok_Q)
              (cons 'vyhodnoteniQ100 vyhodnoteniQ100)
              (cons 'vyskaH vyskaH)
              (cons 'kotaVodnejHladiny kotaVodnejHladiny)
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

      (set_tile "vyskaVodnejHladinyH"
        (strcat (rtos (cdr (assoc 'vyskaH out)) 2 2) " m"))

      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ100"
        (cdr (assoc 'vyhodnoteniQ100 out)))

      ; vykreslenie vodnej hladiny Q100 v AutoCADe
      (KresliVodnuHladinu out)
    )
  )
)


;;----------------------------------------------------------------------;; 
;;         Funkcia vykreslenia vodorovnej ciary vodnej hladiny          ;;
;;----------------------------------------------------------------------;; 

(defun KresliVodnuHladinu (out / 
    kotaHladiny sklon_i dlzka_L vyska_h1 vyska_h2
    pt1 pt2 ent_line ent_text ss
    kota_dna_min kota_dna_max x_offset
  )

  ; ziskanie hodnot
  (setq kotaHladiny  (cdr (assoc 'kotaVodnejHladiny out)))
  (setq sklon_i      (cdr (assoc 'sklon_i out)))
  (setq dlzka_L      (cdr (assoc 'dlzka_L out)))
  (setq vyska_h1     (cdr (assoc 'vyska_h1 out)))
  (setq vyska_h2     (cdr (assoc 'vyska_h2 out)))
  (setq vyskaH       (cdr (assoc 'vyskaH out)))
  (setq prietok_Q100 (cdr (assoc 'prietok_Q100 out)))

  ; Ak existuje predchadzajuca hladina Q100, zmazeme ju
  (if (and *hydro_hladina_line* (entget *hydro_hladina_line*))
    (entdel *hydro_hladina_line*)
  )
  (if (and *hydro_hladina_text* (entget *hydro_hladina_text*))
    (entdel *hydro_hladina_text*)
  )

  ; Zistenie polohy polyliny v ryse (bounding box)
  ; Pouzijeme priame suradnice: X od 0 do dlzka_L, Y = kota
  ; Predpokladame ze polylina je nakreslena v profile (X=dlzka, Y=nadmorska vyska)
  ; Hladina Q100 je vodorovna ciara na kote = vyska_h2 + vyskaH
  ; Rozsah X: od xmin po xmax polyline alebo od 0 po dlzka_L

  ; Pokusime sa najst bounding box polyliny
  (setq pt1 nil)
  (setq pt2 nil)

  (if (and *hydro_polyline_ename* (entget *hydro_polyline_ename*))
    (progn
      (setq obj (vlax-ename->vla-object *hydro_polyline_ename*))
      (vla-GetBoundingBox obj 'bbMin 'bbMax)
      (setq bbMin (vlax-safearray->list bbMin))
      (setq bbMax (vlax-safearray->list bbMax))
      (setq pt1 (list (car bbMin) kotaHladiny (caddr bbMin)))
      (setq pt2 (list (car bbMax) kotaHladiny (caddr bbMax)))
    )
    (progn
      ; ak nie je polylina, nakreslime od 0 po dlzka_L
      (setq pt1 (list 0.0 kotaHladiny 0.0))
      (setq pt2 (list dlzka_L kotaHladiny 0.0))
    )
  )

  ; Nakreslenie vodorovnej ciary vodnej hladiny
  (command "_LINE" pt1 pt2 "")
  (setq *hydro_hladina_line* (entlast))

  ; Nastavenie vlastnosti ciary - farba modra (farba 5), typ DASHED ak existuje
  (entmod
    (append
      (entget *hydro_hladina_line*)
      (list
        (cons 62 5)   ; farba modra
        (cons 8 "VODNA_HLADINA_Q100")  ; vrstva
      )
    )
  )

  ; Pridanie textoveho popisu
  (setq textPt (list
    (+ (car pt1) (* (- (car pt2) (car pt1)) 0.5))
    (+ kotaHladiny (* vyskaH 0.05))
    0.0
  ))

  (setq textStr
    (strcat
      "Q100 = " (rtos prietok_Q100 2 2) " m3/s"
      "  |  H = " (rtos vyskaH 2 2) " m"
      "  |  kota = " (rtos kotaHladiny 2 2) " m"
    )
  )

  ; Zistenie aktualnej vysky textu pre primerane zobrazenie
  (setq txtH (* vyskaH 0.08))
  (if (< txtH 0.05) (setq txtH 0.05))
  (if (> txtH 2.0) (setq txtH 2.0))

  (command "_TEXT" "_J" "_C" textPt txtH 0 textStr)
  (setq *hydro_hladina_text* (entlast))

  ; Nastavenie farby textu - modra
  (entmod
    (append
      (entget *hydro_hladina_text*)
      (list
        (cons 62 5)   ; farba modra
        (cons 8 "VODNA_HLADINA_Q100")  ; vrstva
      )
    )
  )

  (princ (strcat "\nVodna hladina Q100 vykreslena na kote: " (rtos kotaHladiny 2 2) " m\n"))
  (princ)
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
          (setq *hydro_polyline_ename* (car ent))
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
    q q100 evalQ100
    h1 h2 L deltaH sklonI sklonPercent
    drsnostN plochaS obvodO R C vyskaH kotaVodnejHladiny
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
        ;; najprv specialne HTML znaky
        (setq txt (HydroReplaceAll txt "&" "&amp;"))
        (setq txt (HydroReplaceAll txt "<" "&lt;"))
        (setq txt (HydroReplaceAll txt ">" "&gt;"))
        (setq txt (HydroReplaceAll txt "\"" "&quot;"))
        ;; slovenska diakritika
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
              (setq q100 (cdr (assoc 'prietok_Q100 out)))
              (setq evalQ100 (cdr (assoc 'vyhodnoteniQ100 out)))

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
              (setq vyskaH (cdr (assoc 'vyskaH out)))
              (setq kotaVodnejHladiny (cdr (assoc 'kotaVodnejHladiny out)))

              (HydroWriteLine file "<!DOCTYPE html>")
              (HydroWriteLine file "<html lang='sk'>")
              (HydroWriteLine file "<head>")
              (HydroWriteLine file "  <meta charset='UTF-8'>")
              (HydroWriteLine file "  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>")
              (HydroWriteLine file "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>")
              (HydroWriteLine file "  <title>Hydrotechnick&#253; report</title>")
              (HydroWriteLine file "  <style>")
              (HydroWriteLine file "    :root{--bg:#f3f6fb;--panel:#fff;--panel2:#f8fafc;--text:#1f2937;--muted:#6b7280;--line:#e5e7eb;--primary:#0f766e;--primary2:#155e75;--ok:#166534;--okbg:#dcfce7;--bad:#991b1b;--badbg:#fee2e2;--neutral:#92400e;--neutralbg:#fef3c7;--shadow:0 10px 30px rgba(15,23,42,.08);--radius:18px}")
              (HydroWriteLine file "    *{box-sizing:border-box}")
              (HydroWriteLine file "    body{margin:0;font-family:Arial,Helvetica,sans-serif;background:linear-gradient(180deg,#eef4f8 0%,#f8fafc 100%);color:var(--text)}")
              (HydroWriteLine file "    .wrap{max-width:1200px;margin:0 auto;padding:32px 20px 56px}")
              (HydroWriteLine file "    .btn{appearance:none;border:0;border-radius:12px;padding:12px 16px;font-weight:700;cursor:pointer}")
              (HydroWriteLine file "    .btn-print{background:#111827;color:#fff}")
              (HydroWriteLine file "    .hero{background:linear-gradient(135deg,var(--primary) 0%,var(--primary2) 100%);color:#fff;border-radius:24px;padding:32px;box-shadow:var(--shadow);margin-bottom:24px}")
              (HydroWriteLine file "    .hero h1{margin:0 0 8px;font-size:34px}")
              (HydroWriteLine file "    .hero p{margin:0;color:rgba(255,255,255,.88)}")
              (HydroWriteLine file "    .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(340px,1fr));gap:20px}")
              (HydroWriteLine file "    .card{background:var(--panel);border:1px solid var(--line);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden}")
              (HydroWriteLine file "    .card-head{padding:18px 22px;background:var(--panel2);border-bottom:1px solid var(--line)}")
              (HydroWriteLine file "    .card-head h2{margin:0;font-size:20px}")
              (HydroWriteLine file "    .card-body{padding:20px 22px 22px}")
              (HydroWriteLine file "    table{width:100%;border-collapse:collapse}")
              (HydroWriteLine file "    th,td{padding:12px 10px;border-bottom:1px solid var(--line);text-align:center;vertical-align:top}")
              (HydroWriteLine file "    th{font-size:13px;text-transform:uppercase;letter-spacing:.04em;color:var(--muted)}")
              (HydroWriteLine file "    td.num{text-align:center;font-variant-numeric:tabular-nums}")
              (HydroWriteLine file "    .kpi{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:14px}")
              (HydroWriteLine file "    .kpi-box{background:var(--panel2);border:1px solid var(--line);border-radius:16px;padding:16px}")
              (HydroWriteLine file "    .kpi-box .label{color:var(--muted);font-size:13px;margin-bottom:8px}")
              (HydroWriteLine file "    .kpi-box .value{font-size:26px;font-weight:bold;color:var(--primary)}")
              (HydroWriteLine file "    .kpi-box.highlight{border:2px solid #0ea5e9;background:#f0f9ff}")
              (HydroWriteLine file "    .kpi-box.highlight .value{color:#0369a1}")
              (HydroWriteLine file "    .badge{display:inline-block;padding:6px 10px;border-radius:999px;font-size:12px;font-weight:bold}")
              (HydroWriteLine file "    .badge.ok{color:var(--ok);background:var(--okbg)}")
              (HydroWriteLine file "    .badge.bad{color:var(--bad);background:var(--badbg)}")
              (HydroWriteLine file "    .badge.neutral{color:var(--neutral);background:var(--neutralbg)}")
              (HydroWriteLine file "    .geom{background:linear-gradient(180deg,#fcfdff 0%,#f8fafc 100%);border:1px solid var(--line);border-radius:16px;padding:14px}")
              (HydroWriteLine file "    .geom svg{width:100%;height:auto;display:block}")
              (HydroWriteLine file "    .geom-note{margin-top:10px;color:var(--muted);font-size:13px}")
              (HydroWriteLine file "    .formula{background:#fbfdff;border:1px solid var(--line);border-radius:14px;padding:14px 16px;margin-bottom:12px}")
              (HydroWriteLine file "    .formula h3{margin:0 0 8px;font-size:16px}")
              (HydroWriteLine file "    .formula .eq{font-family:'Courier New',monospace;font-size:15px;color:#0f172a;line-height:1.6}")
              (HydroWriteLine file "    .formula .sub{margin-top:8px;color:var(--muted);font-size:14px}")
              (HydroWriteLine file "    .foot{margin-top:24px;color:var(--muted);font-size:13px;text-align:center}")
              (HydroWriteLine file "    @media print{body{background:#fff}.wrap{max-width:none;padding:0}.card,.hero{box-shadow:none;break-inside:avoid;page-break-inside:avoid}.hero{margin-bottom:14px}section{break-inside:avoid;page-break-inside:avoid}@page{size:A4;margin:12mm}}")
              (HydroWriteLine file "    @media (max-width:700px){.hero h1{font-size:26px}.wrap{padding:20px 14px 40px}th,td{padding:10px 8px;font-size:14px}}")
              (HydroWriteLine file "  </style>")
              (HydroWriteLine file "</head>")
              (HydroWriteLine file "<body>")
              (HydroWriteLine file "  <div class='wrap'>")

              ;; hero
              (HydroWriteLine file "    <section class='hero'>")
              (HydroWriteLine file "      <h1>Hydrotechnick&#253; v&#253;po&#269;et kapacity koryta</h1>")
              (HydroWriteLine file "      <p>Preh&#318;ad vstupov, v&#253;sledkov, geometrie pozd&#314;&#382;neho sklonu a pos&#250;denia prietoku Q100.</p>")
              (HydroWriteLine file "    </section>")

              ;; grid
              (HydroWriteLine file "    <div class='grid'>")

              ;; vstupy
              (HydroWriteLine file "      <section class='card'>")
              (HydroWriteLine file "        <div class='card-head'><h2>Vstupn&#233; hodnoty</h2></div>")
              (HydroWriteLine file "        <div class='card-body'>")
              (HydroWriteLine file "          <table>")
              (HydroWriteLine file "            <thead><tr><th>Parameter</th><th>Hodnota</th></tr></thead>")
              (HydroWriteLine file "            <tbody>")
              (HydroWriteLine file (strcat "              <tr><td>V&#253;&#353;ka na za&#269;iatku koryta \"h1\"</td><td class='num'>" (HydroFmt h1 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>V&#253;&#353;ka na konci koryta \"h2\"</td><td class='num'>" (HydroFmt h2 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>D&#314;&#382;ka koryta \"L\"</td><td class='num'>" (HydroFmt L 3) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Stupe&#328; drsnosti \"n\"</td><td class='num'>" (HydroFmt drsnostN 3) " -</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Prieto&#269;n&#225; plocha \"S\"</td><td class='num'>" (HydroFmt plochaS 2) " m2</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td>Omo&#269;en&#253; obvod \"O\"</td><td class='num'>" (HydroFmt obvodO 2) " m</td></tr>"))
              (HydroWriteLine file (strcat "              <tr><td><strong>Q100 [n&#225;vrh. prietok]</strong></td><td class='num'><strong>" (HydroFmt q100 2) " m3/s</strong></td></tr>"))
              (HydroWriteLine file "            </tbody>")
              (HydroWriteLine file "          </table>")
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </section>")

              ;; geometria
              (HydroWriteLine file "      <section class='card'>")
              (HydroWriteLine file "        <div class='card-head'><h2>Pozd&#314;&#382;ny sklon koryta</h2></div>")
              (HydroWriteLine file "        <div class='card-body'>")
              (HydroWriteLine file "          <div class='geom'>")
              (HydroWriteLine file "            <svg viewBox='0 0 760 300' xmlns='http://www.w3.org/2000/svg'>")
              (HydroWriteLine file "              <defs><marker id='arrow' markerWidth='10' markerHeight='10' refX='8' refY='5' orient='auto'><path d='M0,0 L10,5 L0,10 z' fill='#475569'/></marker></defs>")
              (HydroWriteLine file "              <rect x='0' y='0' width='760' height='300' fill='#f8fafc'/>")
              ;; bazova ciara
              (HydroWriteLine file "              <line x1='70' y1='220' x2='690' y2='220' stroke='#cbd5e1' stroke-width='2'/>")
              ;; dno koryta
              (HydroWriteLine file "              <line x1='110' y1='90' x2='650' y2='155' stroke='#0f766e' stroke-width='6' stroke-linecap='round'/>")
              (HydroWriteLine file "              <circle cx='110' cy='90' r='6' fill='#0f766e'/>")
              (HydroWriteLine file "              <circle cx='650' cy='155' r='6' fill='#0f766e'/>")
              ;; zvisle kotovnice
              (HydroWriteLine file "              <line x1='110' y1='90' x2='110' y2='220' stroke='#94a3b8' stroke-dasharray='6 5'/>")
              (HydroWriteLine file "              <line x1='650' y1='155' x2='650' y2='220' stroke='#94a3b8' stroke-dasharray='6 5'/>")
              ;; vodna hladina Q100 - vodorovná modrá čiara
              ;; Y pozicia hladiny: dno je na Y=155 (koniec), hladina = dno - scale*vyskaH
              ;; scale: 65px zodpoveda delta_h => 1m = 65/deltaH px (ak deltaH>0)
              ;; Pre zobrazenie: Y_hladina = 155 - (vyskaH / deltaH) * 65
              (HydroWriteLine file (strcat
                "              <line x1='110' y1='"
                (rtos (- 155.0 (* (if (> deltaH 0) (/ vyskaH deltaH) 0) 65.0)) 2 1)
                "' x2='650' y1='"
                (rtos (- 155.0 (* (if (> deltaH 0) (/ vyskaH deltaH) 0) 65.0)) 2 1)
                "' y2='"
                (rtos (- 155.0 (* (if (> deltaH 0) (/ vyskaH deltaH) 0) 65.0)) 2 1)
                "' stroke='#0ea5e9' stroke-width='3' stroke-dasharray='10 4'/>"
              ))
              ;; popis vodnej hladiny
              (HydroWriteLine file (strcat
                "              <text x='380' y='"
                (rtos (- 150.0 (* (if (> deltaH 0) (/ vyskaH deltaH) 0) 65.0)) 2 1)
                "' text-anchor='middle' font-size='13' fill='#0369a1' font-weight='700'>Vodn&#225; hladina Q100 (H="
                (HydroFmt vyskaH 2) " m)</text>"
              ))
              ;; dlzka L
              (HydroWriteLine file "              <line x1='110' y1='240' x2='650' y2='240' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='380' y='260' text-anchor='middle' font-size='16' fill='#334155'>D&#314;&#382;ka koryta \"L\"</text>")
              (HydroWriteLine file (strcat "              <text x='380' y='278' text-anchor='middle' font-size='18' font-weight='700' fill='#0f172a'>" (HydroFmt L 3) " m</text>"))
              ;; h1
              (HydroWriteLine file "              <line x1='82' y1='90' x2='82' y2='220' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='68' y='160' text-anchor='end' font-size='16' fill='#334155'>h1</text>")
              (HydroWriteLine file (strcat "              <text x='68' y='178' text-anchor='end' font-size='16' font-weight='700' fill='#0f172a'>" (HydroFmt h1 2) "</text>"))
              ;; h2
              (HydroWriteLine file "              <line x1='678' y1='155' x2='678' y2='220' stroke='#475569' stroke-width='2' marker-start='url(#arrow)' marker-end='url(#arrow)'/>")
              (HydroWriteLine file "              <text x='692' y='180' text-anchor='start' font-size='16' fill='#334155'>h2</text>")
              (HydroWriteLine file (strcat "              <text x='692' y='198' text-anchor='start' font-size='16' font-weight='700' fill='#0f172a'>" (HydroFmt h2 2) "</text>"))
              ;; sklon
              (HydroWriteLine file "              <rect x='270' y='40' width='220' height='40' rx='12' fill='#e6fffb' stroke='#99f6e4'/>")
              (HydroWriteLine file "              <text x='380' y='58' text-anchor='middle' font-size='14' fill='#115e59'>Sklon koryta</text>")
              (HydroWriteLine file (strcat "              <text x='380' y='74' text-anchor='middle' font-size='18' font-weight='700' fill='#0f766e'>" (HydroFmt sklonPercent 2) " %</text>"))
              (HydroWriteLine file "            </svg>")
              (HydroWriteLine file "          </div>")
              (HydroWriteLine file (strcat "          <div class='geom-note'>V&#253;&#353;kov&#253; rozdiel dna je " (HydroFmt deltaH 2) " m. Modr&#225; prerušovan&#225; &#269;iara zn&#225;zor&#328;uje vodnú hladinu Q100 (H = " (HydroFmt vyskaH 2) " m nad dnom).</div>"))
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </section>")

              (HydroWriteLine file "    </div>")

              ;; KPI
              (HydroWriteLine file "    <section class='card' style='margin-top:20px;'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Hlavn&#233; v&#253;sledky v&#253;po&#269;tu</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")
              (HydroWriteLine file "        <div class='kpi'>")
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>V&#253;&#353;kov&#253; rozdiel \"dh\"</div><div class='value'>" (HydroFmt deltaH 2) " m</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Sklon koryta \"i\"</div><div class='value'>" (HydroFmt sklonI 3) "</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Hydraulick&#253; polomer \"R\"</div><div class='value'>" (HydroFmt R 3) " m</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>R&#253;chlostn&#253; s&#250;&#269;inite&#318; \"C\"</div><div class='value'>" (HydroFmt C 3) "</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>Kapacita koryta \"Q\"</div><div class='value'>" (HydroFmt q 2) " m3/s</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box highlight'><div class='label'>Vyska vodn. hladiny H (Q100)</div><div class='value'>" (HydroFmt vyskaH 2) " m</div></div>"))
              (HydroWriteLine file (strcat "          <div class='kpi-box highlight'><div class='label'>K&#243;ta vodn. hladiny Q100</div><div class='value'>" (HydroFmt kotaVodnejHladiny 2) " m n.m.</div></div>"))
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              ;; vzorce
              (HydroWriteLine file "    <section class='card' style='margin-top:20px;'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Vzorce a postup v&#253;po&#269;tu</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")

              (HydroWriteLine file "        <div class='formula'>")
              (HydroWriteLine file "          <h3>1. V&#253;&#353;kov&#253; rozdiel</h3>")
              (HydroWriteLine file "          <div class='eq'>dh = h1 - h2</div>")
              (HydroWriteLine file (strcat "          <div class='sub'>dh = " (HydroFmt h1 3) " - " (HydroFmt h2 3) " = " (HydroFmt deltaH 2) " m</div>"))
              (HydroWriteLine file "        </div>")

              (HydroWriteLine file "        <div class='formula'>")
              (HydroWriteLine file "          <h3>2. Sklon koryta</h3>")
              (HydroWriteLine file "          <div class='eq'>i = dh / L</div>")
              (HydroWriteLine file (strcat "          <div class='sub'>i = " (HydroFmt deltaH 2) " / " (HydroFmt L 3) " = " (HydroFmt sklonI 3) " = " (HydroFmt sklonPercent 2) " %</div>"))
              (HydroWriteLine file "        </div>")

              (HydroWriteLine file "        <div class='formula'>")
              (HydroWriteLine file "          <h3>3. Hydraulick&#253; polomer</h3>")
              (HydroWriteLine file "          <div class='eq'>R = S / O</div>")
              (HydroWriteLine file (strcat "          <div class='sub'>R = " (HydroFmt plochaS 2) " / " (HydroFmt obvodO 2) " = " (HydroFmt R 3) " m</div>"))
              (HydroWriteLine file "        </div>")

              (HydroWriteLine file "        <div class='formula'>")
              (HydroWriteLine file "          <h3>4. R&#253;chlostn&#253; s&#250;&#269;inite&#318;</h3>")
              (HydroWriteLine file "          <div class='eq'>C = (1 / n) * R^(1/6)</div>")
              (HydroWriteLine file (strcat "          <div class='sub'>C = (1 / " (HydroFmt drsnostN 3) ") * " (HydroFmt R 3) "^(1/6) = " (HydroFmt C 3) "</div>"))
              (HydroWriteLine file "        </div>")

              (HydroWriteLine file "        <div class='formula'>")
              (HydroWriteLine file "          <h3>5. Kapacita koryta</h3>")
              (HydroWriteLine file "          <div class='eq'>Q = C * S * sqrt(R * i)</div>")
              (HydroWriteLine file (strcat "          <div class='sub'>Q = " (HydroFmt C 3) " * " (HydroFmt plochaS 2) " * sqrt(" (HydroFmt R 3) " * " (HydroFmt sklonI 5) ") = " (HydroFmt q 2) " m3/s</div>"))
              (HydroWriteLine file "        </div>")

              (HydroWriteLine file "        <div class='formula'>")
              (HydroWriteLine file "          <h3>6. V&#253;&#353;ka vodnej hladiny H pre Q100</h3>")
              (HydroWriteLine file "          <div class='eq'>H = R * (Q100 / Q)^(3/5)</div>")
              (HydroWriteLine file (strcat "          <div class='sub'>H = " (HydroFmt R 3) " * (" (HydroFmt q100 2) " / " (HydroFmt q 2) ")^(3/5) = " (HydroFmt vyskaH 2) " m</div>"))
              (HydroWriteLine file "          <div class='sub'>K&#243;ta vodnej hladiny = h2 + H = " (HydroFmt h2 2) " + " (HydroFmt vyskaH 2) " = " (HydroFmt kotaVodnejHladiny 2) " m n.m.</div>")
              (HydroWriteLine file "        </div>")

              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              ;; posudenie Q100
              (HydroWriteLine file "    <section class='card' style='margin-top:20px;'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Pos&#250;denie prietoku Q100</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")
              (HydroWriteLine file "        <table>")
              (HydroWriteLine file "          <thead><tr><th>Prietok</th><th>N&#225;vrhovan&#253; prietok</th><th>Kapacita koryta</th><th>Vyhodnotenie</th></tr></thead>")
              (HydroWriteLine file "          <tbody>")
              (HydroWriteLine file (strcat "            <tr><td><strong>Q100</strong></td><td class='num'>" (HydroFmt q100 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ100) "'>" (HydroSafe evalQ100) "</span></td></tr>"))
              (HydroWriteLine file "          </tbody>")
              (HydroWriteLine file "        </table>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              (HydroWriteLine file "    <div class='foot'>Report bol vytvoren&#253; automaticky z hydrotechnick&#233;ho v&#253;po&#269;tu. (JTmenu)</div>")
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
