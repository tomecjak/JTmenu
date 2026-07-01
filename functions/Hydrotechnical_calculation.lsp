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
  (if (not *hydro_hhladina*) (setq *hydro_hhladina* nil))
  (if (not *hydro_wetarea*) (setq *hydro_wetarea* nil))
  (if (not *hydro_poly_pts*) (setq *hydro_poly_pts* nil))
  (if (not *hydro_yw*) (setq *hydro_yw* nil))
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

  ; zobrazenie vysledkov vypoctu hladiny z predchadzajuceho vyberu polyliny
  (if *hydro_hhladina* (set_tile "vyskaHladinyPriQ100" (strcat (rtos *hydro_hhladina* 2 3) " m")))
  (if *hydro_wetarea* (set_tile "prietocnaPlochaPriQ100" (strcat (rtos *hydro_wetarea* 2 2) " m2")))

  ; definovanie tlacidla vyber polylinu
  ; pred zatvorenim dialogu ulozime vstupy, aby boli k dispozicii pre vypocet hladiny
  (action_tile "polylinaKoryta"
    "(HydroSaveTiles) (setq select_polyline t) (done_dialog)"
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

  ; definovanie tlacidla vykresli ciaru hladiny
  (action_tile "vykresli"
    "(HydroVykresliHladina)"
  )

  ; spustenie dialogu
  (start_dialog)

  ; ak bol vybrany vyber polyliny, vykonaj ho
  ; pri zatvoreni dialogu ostavaju posledne vypocitane hodnoty v pamati
  ; (globalne premenne) az do zatvorenia vykresu / AutoCADu
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
    vyhodnotenieQ100
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

          (setq vyhodnotenieQ100 (if (> prietok_Q prietok_Q100) "vyhovuje" "nevyhovuje"))

          (append
            in
            (list
              (cons 'delta_h delta_h)
              (cons 'sklon_i sklon_i)
              (cons 'hydroraulickyPolomer_R hydroraulickyPolomer_R)
              (cons 'rychlostnySucinitelKoryta_C rychlostnySucinitelKoryta_C)
              (cons 'prietok_Q prietok_Q)
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

(defun VypocetHydrotechnicalCalculation ( / in out err hladRes )
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

      (set_tile "vyhodnoteniePosudeniaPrietokuKorytaQ100"
        (cdr (assoc 'vyhodnotenieQ100 out)))

      ; prepocet vysky hladiny a prietocnej plochy pre Q100 (ak je vybrana polylina)
      ; umoznuje zmenit hodnoty a spustit vypocet znovu bez noveho vyberu polyliny
      (if *hydro_poly_pts*
        (progn
          (setq hladRes
            (HydroComputeHladina
              *hydro_poly_pts*
              (cdr (assoc 'drsnost_n out))
              (cdr (assoc 'sklon_i out))
              (cdr (assoc 'prietok_Q100 out))))
          (if (car hladRes)
            (progn
              (setq *hydro_yw*       (car hladRes)
                    *hydro_wetarea*  (cadr hladRes)
                    *hydro_hhladina* (caddr hladRes))
              (set_tile "vyskaHladinyPriQ100"
                (strcat (rtos (caddr hladRes) 2 3) " m"))
              (set_tile "prietocnaPlochaPriQ100"
                (strcat (rtos (cadr hladRes) 2 2) " m2")))
            (progn
              (setq *hydro_yw* nil *hydro_wetarea* nil *hydro_hhladina* nil)
              (set_tile "vyskaHladinyPriQ100" "")
              (set_tile "prietocnaPlochaPriQ100" ""))
          )
        )
      )
    )
  )
)


;;----------------------------------------------------------------------;;
;;          Pomocna funkcia na ulozenie vstupov z dialogu               ;;
;;----------------------------------------------------------------------;;

(defun HydroSaveTiles ()
  (setq *hydro_vyska_zac* (atof (get_tile "vyskaNaZaciatkuKoryta")))
  (setq *hydro_vyska_kon* (atof (get_tile "vyskaNaKonciKoryta")))
  (setq *hydro_dlzka*     (atof (get_tile "dlzkaKoryta")))
  (setq *hydro_drsnost*   (atof (get_tile "stupenDrsnostiKoryta")))
  (setq *hydro_plocha*    (atof (get_tile "prietocnaPlochaKoryta")))
  (setq *hydro_obvod*     (atof (get_tile "omocvenyObvodKoryta")))
  (setq *hydro_q100*      (atof (get_tile "hodnotaPrietokuKorytaQ100")))
  (princ)
)


;;----------------------------------------------------------------------;;
;;         Pomocne geometricke funkcie pre vypocet hladiny              ;;
;;----------------------------------------------------------------------;;

;; ziskanie vrcholov polyliny ako zoznam bodov ((x y) (x y) ...)
;; pozn.: oblukove segmenty (bulge) su brane ako rovne usecky
(defun HydroGetPolyPoints (obj / coords lst)
  (setq coords (vlax-safearray->list
                 (vlax-variant-value (vla-get-coordinates obj))))
  (setq lst '())
  (while coords
    (setq lst (cons (list (car coords) (cadr coords)) lst))
    (setq coords (cddr coords))
  )
  (setq lst (reverse lst))
  ;; ak je polylina uzavreta, doplnime uzatvaraci segment
  (if (= (vla-get-closed obj) :vlax-true)
    (setq lst (append lst (list (car lst))))
  )
  lst
)

;; orezanie usecky na cast pod hladinou yw; vrati ((ax ay) (bx by)) alebo nil
(defun HydroClipSeg (x1 y1 x2 y2 yw / b1 b2 tt xi)
  (setq b1 (<= y1 yw) b2 (<= y2 yw))
  (cond
    ((and b1 b2) (list (list x1 y1) (list x2 y2)))
    ((and (not b1) (not b2)) nil)
    (T
      (setq tt (/ (- yw y1) (- y2 y1)))
      (setq xi (+ x1 (* tt (- x2 x1))))
      (if b1
        (list (list x1 y1) (list xi yw))
        (list (list xi yw) (list x2 y2))
      )
    )
  )
)

;; vypocet prietocnej plochy S a omoceneho obvodu O pri hladine yw
;; vrati (S O)
(defun HydroWetSO (pts yw / lst p1 p2 seg a b ax ay bx by S O)
  (setq S 0.0 O 0.0 lst pts)
  (while (cdr lst)
    (setq p1 (car lst) p2 (cadr lst))
    (setq seg (HydroClipSeg (car p1) (cadr p1) (car p2) (cadr p2) yw))
    (if seg
      (progn
        (setq a (car seg) b (cadr seg))
        (setq ax (car a) ay (cadr a) bx (car b) by (cadr b))
        ;; prietocna plocha (integral (yw - y) dx pozdlz koryta)
        (setq S (+ S (* 0.5 (- bx ax) (+ (- yw ay) (- yw by)))))
        ;; omoceny obvod (dlzka casti koryta pod hladinou)
        (setq O (+ O (sqrt (+ (expt (- bx ax) 2.0) (expt (- by ay) 2.0)))))
      )
    )
    (setq lst (cdr lst))
  )
  (list (abs S) O)
)

;; kapacita koryta Q pri hladine yw (Chezyho vztah Q = C*S*sqrt(R*i))
(defun HydroQAtLevel (pts yw n_drs i_slope / so S O R C)
  (setq so (HydroWetSO pts yw))
  (setq S (car so) O (cadr so))
  (if (and (> O 0.0) (> S 0.0) (> i_slope 0.0))
    (progn
      (setq R (/ S O))
      (setq C (* (/ 1.0 n_drs) (expt R (/ 1.0 6.0))))
      (* C S (sqrt (* i_slope R)))
    )
    0.0
  )
)

;; x-suradnice priesecnikov hladiny yw s polylinou
(defun HydroCrossX (pts yw / lst p1 p2 x1 y1 x2 y2 tt res)
  (setq lst pts res '())
  (while (cdr lst)
    (setq p1 (car lst) p2 (cadr lst))
    (setq x1 (car p1) y1 (cadr p1) x2 (car p2) y2 (cadr p2))
    (if (and (/= y1 y2)
             (or (and (<= y1 yw) (>= y2 yw))
                 (and (>= y1 yw) (<= y2 yw))))
      (progn
        (setq tt (/ (- yw y1) (- y2 y1)))
        (setq res (cons (+ x1 (* tt (- x2 x1))) res))
      )
    )
    (setq lst (cdr lst))
  )
  res
)

;; prepocet world suradnic do SVG viewportu (Y je v SVG smerom dole)
(defun HydroSvgX (x xmin ox scale) (+ ox (* (- x xmin) scale)))
(defun HydroSvgY (y ymin vbh oy scale) (- vbh oy (* (- y ymin) scale)))

;; vykreslenie priecneho rezu koryta a hladiny do SVG (do otvoreneho suboru)
(defun HydroWriteCrossSvg (file pts yw hh /
    xmin xmax ymin ymax dw dh vbw vbh pad scale ox oy
    lst p1 p2 seg a b ax ay bx by p ptstr
    xs xlc xrc wyN wx1N wx2N)
  (setq xmin (apply 'min (mapcar 'car pts))
        xmax (apply 'max (mapcar 'car pts))
        ymin (apply 'min (mapcar 'cadr pts))
        ymax (apply 'max (mapcar 'cadr pts)))
  (setq dw (- xmax xmin) dh (- ymax ymin))
  (if (<= dw 1e-9) (setq dw 1.0))
  (if (<= dh 1e-9) (setq dh 1.0))
  (setq vbw 760.0 vbh 360.0 pad 50.0)
  (setq scale (min (/ (- vbw (* 2.0 pad)) dw) (/ (- vbh (* 2.0 pad)) dh)))
  (setq ox (/ (- vbw (* dw scale)) 2.0))
  (setq oy (/ (- vbh (* dh scale)) 2.0))

  (write-line "            <svg viewBox='0 0 760 360' xmlns='http://www.w3.org/2000/svg'>" file)
  (write-line "              <rect x='0' y='0' width='760' height='360' fill='#f8fafc'/>" file)

  ;; vyplnenie vodnej plochy - trapezy medzi dnom koryta a hladinou
  (setq lst pts)
  (while (cdr lst)
    (setq p1 (car lst) p2 (cadr lst))
    (setq seg (HydroClipSeg (car p1) (cadr p1) (car p2) (cadr p2) yw))
    (if seg
      (progn
        (setq a (car seg) b (cadr seg))
        (setq ax (car a) ay (cadr a) bx (car b) by (cadr b))
        (write-line
          (strcat "              <polygon points='"
            (rtos (HydroSvgX ax xmin ox scale) 2 2) "," (rtos (HydroSvgY yw ymin vbh oy scale) 2 2) " "
            (rtos (HydroSvgX ax xmin ox scale) 2 2) "," (rtos (HydroSvgY ay ymin vbh oy scale) 2 2) " "
            (rtos (HydroSvgX bx xmin ox scale) 2 2) "," (rtos (HydroSvgY by ymin vbh oy scale) 2 2) " "
            (rtos (HydroSvgX bx xmin ox scale) 2 2) "," (rtos (HydroSvgY yw ymin vbh oy scale) 2 2)
            "' fill='#bae6fd' stroke='none'/>")
          file)
      )
    )
    (setq lst (cdr lst))
  )

  ;; obrys koryta (polylinia dna)
  (setq ptstr "")
  (foreach p pts
    (setq ptstr (strcat ptstr
                  (rtos (HydroSvgX (car p) xmin ox scale) 2 2) ","
                  (rtos (HydroSvgY (cadr p) ymin vbh oy scale) 2 2) " ")))
  (write-line (strcat "              <polyline points='" ptstr "' fill='none' stroke='#475569' stroke-width='3'/>") file)

  ;; ciara hladiny medzi priesecnikmi + popis
  (setq xs (HydroCrossX pts yw))
  (if (>= (length xs) 2)
    (progn
      (setq xlc (apply 'min xs) xrc (apply 'max xs))
      (setq wyN  (HydroSvgY yw ymin vbh oy scale))
      (setq wx1N (HydroSvgX xlc xmin ox scale))
      (setq wx2N (HydroSvgX xrc xmin ox scale))
      (write-line (strcat "              <line x1='" (rtos wx1N 2 2) "' y1='" (rtos wyN 2 2)
                          "' x2='" (rtos wx2N 2 2) "' y2='" (rtos wyN 2 2)
                          "' stroke='#0284c7' stroke-width='3'/>") file)
      (write-line (strcat "              <text x='" (rtos (* 0.5 (+ wx1N wx2N)) 2 2)
                          "' y='" (rtos (- wyN 8.0) 2 2)
                          "' text-anchor='middle' font-size='15' font-weight='700' fill='#0369a1'>Hladina (Hhladina = "
                          (rtos hh 2 3) " m)</text>") file)
    )
  )
  (write-line "            </svg>" file)
  (princ)
)

;; najde vrstvu vodneho toku ("XX-VODNY TOK" s lubovolnym prefixom);
;; ak neexistuje, vytvori zaloznu vrstvu "VODNY TOK"
(defun HydroWaterLayer ( / lay name found)
  (setq lay (tblnext "LAYER" T) found nil)
  (while (and lay (not found))
    (setq name (cdr (assoc 2 lay)))
    (if (wcmatch (strcase name) "*VODNY TOK") (setq found name))
    (setq lay (tblnext "LAYER"))
  )
  (if (not found)
    (progn
      (setq found "VODNY TOK")
      (if (not (tblsearch "LAYER" found))
        (entmakex
          (list
            (cons 0 "LAYER")
            (cons 100 "AcDbSymbolTableRecord")
            (cons 100 "AcDbLayerTableRecord")
            (cons 2 found)
            (cons 70 0)
            (cons 62 5)
          )
        )
      )
    )
  )
  found
)

;; centralny vypocet vysky hladiny pre kapacitu Q100 (bez vykreslenia)
;; vrati (yw S hh sprava) - yw = nil ak vypocet nie je mozny
(defun HydroComputeHladina (pts n_drs i_slope target /
    ymin ymax qmax ylo yhi ymid q iter so S hh)
  (cond
    ((or (null pts) (< (length pts) 2))
      (list nil nil nil "Nie je vybrana platna polylina koryta."))
    ((<= n_drs 0.0)
      (list nil nil nil "Zadaj stupen drsnosti koryta vacsi ako 0."))
    ((<= i_slope 0.0)
      (list nil nil nil "Sklon koryta musi byt vacsi ako 0 (skontroluj vysky a dlzku koryta)."))
    ((<= target 0.0)
      (list nil nil nil "Zadaj hodnotu prietoku Q100 vacsiu ako 0."))
    (T
      (setq ymin (apply 'min (mapcar 'cadr pts)))
      (setq ymax (apply 'max (mapcar 'cadr pts)))
      (setq qmax (HydroQAtLevel pts ymax n_drs i_slope))
      (if (< qmax target)
        (setq ymid ymax)              ; koryto nema dostatocnu kapacitu -> horna hrana
        (progn
          ;; bisekcia: Q rastie s vyskou hladiny -> hladame uroven kde Q = Q100
          (setq ylo ymin yhi ymax iter 0)
          (while (< iter 60)
            (setq ymid (* 0.5 (+ ylo yhi)))
            (setq q (HydroQAtLevel pts ymid n_drs i_slope))
            (if (< q target) (setq ylo ymid) (setq yhi ymid))
            (setq iter (1+ iter))
          )
        )
      )
      (setq so (HydroWetSO pts ymid))
      (setq S (car so) hh (- ymid ymin))
      (list ymid S hh
            (if (< qmax target)
              "Koryto nema dostatocnu kapacitu pre Q100 - hladina je na hornej hrane koryta."
              nil))
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
          (setq *hydro_poly_pts* (HydroGetPolyPoints obj))
          ;; vysku hladiny pri Q100 sa prepocita az po stlaceni tlacidla Vypocitaj
          (setq *hydro_yw* nil *hydro_wetarea* nil *hydro_hhladina* nil)
          (princ (strcat "\nPlocha: " (rtos *hydro_plocha* 2 2) " m²\n"))
          (princ (strcat "Obvod: " (rtos *hydro_obvod* 2 2) " m\n"))
          (princ "Vysku hladiny pri Q100 vypocitas tlacidlom Vypocitaj.\n")
        )
        (princ "\nVybrana entita nie je polylina.\n")
      )
    )
    (princ "\nNevybral si ziadnu polylinu.\n")
  )
)


;;----------------------------------------------------------------------;;
;;       Funkcia vykreslenia ciary hladiny na vrstvu vodneho toku       ;;
;;----------------------------------------------------------------------;;

(defun HydroVykresliHladina ( /
    pts n_drs i_slope target res yw ycontain xs xmin xmax lay )
  (HydroSaveTiles)
  (setq pts *hydro_poly_pts*)
  (if (null pts)
    (alert "Najprv vyber polylinu koryta.")
    (progn
      (setq n_drs  *hydro_drsnost*)
      (setq target *hydro_q100*)
      (setq i_slope
        (if (and *hydro_vyska_zac* *hydro_vyska_kon* *hydro_dlzka*
                 (> *hydro_dlzka* 0.0))
          (/ (- *hydro_vyska_zac* *hydro_vyska_kon*) *hydro_dlzka*)
          0.0))
      (setq res (HydroComputeHladina pts n_drs i_slope target))
      (setq yw (car res))
      ;; hladina je "mimo koryta" ak stupla nad hornu hranu (nizsi breh koryta)
      ;; alebo koryto nema dostatocnu kapacitu pre Q100 (voda pretecie)
      (setq ycontain (min (cadr (car pts)) (cadr (last pts))))
      (cond
        ;; neplatne vstupy pre vypocet
        ((null yw)
          (alert (cadddr res)))
        ;; hladina mimo koryta -> ciara sa nevykresli
        ((or (cadddr res) (> yw ycontain))
          (alert "Hladina je mimo koryta - ciara sa nevykreslila.")
          (princ "\nHladina je mimo koryta - ciara sa nevykreslila.\n"))
        (T
          (setq *hydro_yw*       yw
                *hydro_wetarea*  (cadr res)
                *hydro_hhladina* (caddr res))
          (set_tile "vyskaHladinyPriQ100"
            (strcat (rtos (caddr res) 2 3) " m"))
          (set_tile "prietocnaPlochaPriQ100"
            (strcat (rtos (cadr res) 2 2) " m2"))
          ;; vykreslenie iba ciary hladiny - sirka hladiny (medzi priesecnikmi)
          (setq xs (HydroCrossX pts yw))
          (if (>= (length xs) 2)
            (progn
              (setq xmin (apply 'min xs) xmax (apply 'max xs))
              (setq lay (HydroWaterLayer))
              (entmakex
                (list
                  (cons 0 "LINE")
                  (cons 8 lay)
                  (cons 10 (list xmin yw 0.0))
                  (cons 11 (list xmax yw 0.0))
                )
              )
              (princ (strcat "\nCiara hladiny vykreslena na vrstvu \"" lay "\".\n")))
            (alert "Hladina je mimo koryta - ciara sa nevykreslila.")
          )
        )
      )
    )
  )
  (princ)
)


;;----------------------------------------------------------------------;;
;;                  Funkcia reportu                                     ;;
;;----------------------------------------------------------------------;;

(defun ReportHydrotechnicalCalculation ( /
    in out err filePath file
    dwgName dwgPrefix reportDateTime defaultName reportDateForName
    q q100 evalQ100
    h1 h2 L deltaH sklonI sklonPercent
    drsnostN plochaS obvodO R C
    hladRes ywR hhR
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
    ;; NEVYHOVUJE obsahuje aj "VYHOV", preto testujeme "NEVYHOV" ako prve
    (cond
      ((wcmatch t1 "*NEVYHOV*") "bad")
      ((wcmatch t1 "*VYHOV*") "ok")
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

              ;; vypocet vysky hladiny pre Q100 (pre report a vykres priecneho rezu)
              (setq hladRes (HydroComputeHladina *hydro_poly_pts* drsnostN sklonI q100))
              (setq ywR  (car hladRes))
              (setq hhR  (caddr hladRes))

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
              (HydroWriteLine file "    .toolbar{display:flex;justify-content:flex-end;gap:12px;margin-bottom:16px}")
              (HydroWriteLine file "    .btn{appearance:none;border:0;border-radius:12px;padding:12px 16px;font-weight:700;cursor:pointer}")
              (HydroWriteLine file "    .btn-print{background:#111827;color:#fff}")
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
              (HydroWriteLine file "    th,td{padding:12px 10px;border-bottom:1px solid var(--line);text-align:center;vertical-align:top}")
              (HydroWriteLine file "    th{font-size:13px;text-transform:uppercase;letter-spacing:.04em;color:var(--muted)}")
              (HydroWriteLine file "    td.num{text-align:center;font-variant-numeric:tabular-nums}")
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
              (HydroWriteLine file "    .formula{background:#fbfdff;border:1px solid var(--line);border-radius:14px;padding:14px 16px;margin-bottom:12px}")
              (HydroWriteLine file "    .formula h3{margin:0 0 8px;font-size:16px}")
              (HydroWriteLine file "    .formula .eq{font-family:'Courier New',monospace;font-size:15px;color:#0f172a;line-height:1.6}")
              (HydroWriteLine file "    .formula .sub{margin-top:8px;color:var(--muted);font-size:14px}")
              (HydroWriteLine file "    .foot{margin-top:24px;color:var(--muted);font-size:13px;text-align:center}")
              (HydroWriteLine file "    @media print{body{background:#fff}.toolbar{display:none}.wrap{max-width:none;padding:0}.card,.hero{box-shadow:none;break-inside:avoid;page-break-inside:avoid}.hero{margin-bottom:14px}section{break-inside:avoid;page-break-inside:avoid}@page{size:A4;margin:12mm}}")
              (HydroWriteLine file "    @media (max-width:700px){.hero h1{font-size:26px}.wrap{padding:20px 14px 40px}th,td{padding:10px 8px;font-size:14px}}")
              (HydroWriteLine file "  </style>")
              (HydroWriteLine file "</head>")
              (HydroWriteLine file "<body>")
              (HydroWriteLine file "  <div class='wrap'>")

              ;; hero
              (HydroWriteLine file "    <section class='hero'>")
              (HydroWriteLine file "      <h1>Hydrotechnick&#253; v&#253;po&#269;et kapacity koryta</h1>")
              (HydroWriteLine file "      <p>Preh&#318;ad vstupov, v&#253;sledkov, geometrie pozd&#314;&#382;neho sklonu a pos&#250;denia prietokov.</p>")
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
              (HydroWriteLine file "            </tbody>")
              (HydroWriteLine file "          </table>")
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </section>")

              ;; priecny rez koryta a hladina (z vybranej polyliny) - namiesto pozdlzneho sklonu
              (if (and *hydro_poly_pts* ywR)
                (progn
                  (HydroWriteLine file "      <section class='card'>")
                  (HydroWriteLine file "        <div class='card-head'><h2>Prie&#269;ny rez koryta a hladina pri Q100</h2></div>")
                  (HydroWriteLine file "        <div class='card-body'>")
                  (HydroWriteLine file "          <div class='geom'>")
                  (HydroWriteCrossSvg file *hydro_poly_pts* ywR hhR)
                  (HydroWriteLine file "          </div>")
                  (HydroWriteLine file (strcat "          <div class='geom-note'>Tvar koryta poch&#225;dza z vybranej polylinie. Modr&#225; plocha predstavuje prieto&#269;n&#253; prierez pri kapacite Q100 = " (HydroFmt q100 2) " m3/s. V&#253;&#353;ka hladiny nad najni&#382;&#353;&#237;m bodom koryta je " (HydroFmt hhR 3) " m.</div>"))
                  (HydroWriteLine file "        </div>")
                  (HydroWriteLine file "      </section>")
                )
                (progn
                  (HydroWriteLine file "      <section class='card'>")
                  (HydroWriteLine file "        <div class='card-head'><h2>Prie&#269;ny rez koryta a hladina pri Q100</h2></div>")
                  (HydroWriteLine file "        <div class='card-body'>")
                  (HydroWriteLine file "          <div class='geom-note'>Prie&#269;ny rez sa zobraz&#237; po v&#253;bere polylinie koryta a stla&#269;en&#237; tla&#269;idla Vypocitaj.</div>")
                  (HydroWriteLine file "        </div>")
                  (HydroWriteLine file "      </section>")
                )
              )

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
              (HydroWriteLine file (strcat "          <div class='kpi-box'><div class='label'>V&#253;&#353;ka hladiny pri Q100 \"Hhladina\"</div><div class='value'>" (HydroFmt hhR 3) " m</div></div>"))
              (HydroWriteLine file "        </div>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              ;; posudenie
              (HydroWriteLine file "    <section class='card' style='margin-top:20px;'>")
              (HydroWriteLine file "      <div class='card-head'><h2>Pos&#250;denie prietoku Q100</h2></div>")
              (HydroWriteLine file "      <div class='card-body'>")
              (HydroWriteLine file "        <table>")
              (HydroWriteLine file "          <thead><tr><th>Prietok</th><th>N&#225;vrhovan&#253; prietok</th><th>Kapacita koryta</th><th>Vyhodnotenie</th></tr></thead>")
              (HydroWriteLine file "          <tbody>")

              (HydroWriteLine file (strcat "            <tr><td>Q100</td><td class='num'>" (HydroFmt q100 2) " m3/s</td><td class='num'>" (HydroFmt q 2) " m3/s</td><td><span class='badge " (HydroStatusClass evalQ100) "'>" (HydroSafe evalQ100) "</span></td></tr>"))

              (HydroWriteLine file "          </tbody>")
              (HydroWriteLine file "        </table>")
              (HydroWriteLine file "      </div>")
              (HydroWriteLine file "    </section>")

              ;; vzorce a postup vypoctu (pod sekciou posudenie)
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
  (HydroSaveTiles)

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