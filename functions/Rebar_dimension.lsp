;=========================================================================
; Rebar_dimension.lsp
; Create by Jakub Tomecko
;
; Kotovanie vystuze (polylina s hrubkou / oblukmi v rohoch).
; Na vonkajsiu hranu prida ku kazdemu useku text s dlzkou (v mm).
; Pri sikmych usekoch (uhol iny ako 90) dokresli ciarkovany
; pravouhly trojuholnik s vodorovnou a zvislou odvesnou a obe
; odvesny popise ich dlzkou (v mm).
; Text je ANNOTATIVNY - pouzije aktualny textovy styl vykresu a
; vysku prevezme z neho (papierova vyska stylu).
; Vykres v metroch -> hodnoty *1000 -> celé mm.
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                           Pomocne funkcie                            ;;
;;----------------------------------------------------------------------;;

(defun _rd-3d (p) (list (car p) (cadr p) 0.0))

;; dlzka v jednotkach vykresu (m) -> string celych mm
(defun _rd-mm (d) (itoa (fix (+ 0.5 (* (abs d) 1000.0)))))

;; nacita vrcholy polyliny ako zoznam (bod bulge), robustne aj ked
;; DXF nevracia skupinu 42 pre kazdy vrchol (bulge sa priradi
;; poslednemu nacitanemu vrcholu 10)
(defun _rd-verts (ename / ed v)
  (setq ed (entget ename) v '())
  (foreach x ed
    (cond
      ((= (car x) 10)
       (setq v (cons (list (_rd-3d (cdr x)) 0.0) v)))
      ((and (= (car x) 42) v)
       (setq v (cons (list (car (car v)) (cdr x)) (cdr v))))
    )
  )
  (reverse v)
)

;; je uhol (rad) v ramci tolerancie zarovnany s osou X alebo Y?
(defun _rd-axis-aligned (ang / a)
  (setq a (rem (+ (* ang (/ 180.0 pi)) 720.0) 90.0))
  (or (< a 1.0) (> a 89.0))
)

;; normalizuje uhol textu tak, aby nebol "hore nohami"
(defun _rd-read (ang / a)
  (setq a ang)
  (while (< a 0.0) (setq a (+ a (* 2.0 pi))))
  (while (>= a (* 2.0 pi)) (setq a (- a (* 2.0 pi))))
  (if (and (> a (* 0.5 pi)) (<= a (* 1.5 pi))) (- a pi) a)
)

;; smer "von" od materialu v bode M (kolmo na hranu).
;; Pri hrubke > 0 pouzije najblizsi bod povodnej osi, inak pick bod.
(defun _rd-outward (M origObj halfW pickPt / cp)
  (if (> halfW 1e-9)
    (progn
      (setq cp (vlax-curve-getClosestPointTo origObj M))
      (if (and cp (> (distance M cp) 1e-9))
        (angle cp M)
        (angle M pickPt)
      )
    )
    (angle M pickPt)
  )
)

;; je aktualny textovy styl annotativny?
(defun _rd-anno-style-p (/ ent xd res)
  (setq res nil)
  (setq ent (tblobjname "style" (getvar "TEXTSTYLE")))
  (if ent
    (progn
      (setq xd (cdr (assoc -3 (entget ent '("AcadAnnotative")))))
      (if xd
        (progn
          (setq xd (cdar xd)) ; zoznam dvojic pod appid
          (foreach it xd
            (if (= (car it) 1070) (setq res (= (cdr it) 1)))
          )
        )
      )
    )
  )
  res
)

;; ANNOTATIVNY text (aktualny styl, zarovnany middle-center).
;; Vytvara sa prikazom TEXT, aby AutoCAD nastavil annotativnost a
;; aktualnu annotativnu mierku. fixedH = styl ma pevnu vysku (papierova
;; vyska sa neptata), inak sa poskytne paperH.
;; Pozn.: pocas volania musi byt AUNITS = 0 (uhol v stupnoch) a OSMODE = 0.
(defun _rd-text (str pt ang fixedH paperH / d)
  (setq d (* ang (/ 180.0 pi)))
  (if fixedH
    (command "_.TEXT" "_J" "_MC" (_rd-3d pt) d str "")
    (command "_.TEXT" "_J" "_MC" (_rd-3d pt) paperH d str "")
  )
)

;; ciarkovana pomocna ciara (ak je DASHED nacitany, inak plna)
(defun _rd-dline (p1 p2 / dxf)
  (setq dxf
    (list
      '(0 . "LINE")
      (cons 8 (getvar "CLAYER"))
      (cons 10 (_rd-3d p1))
      (cons 11 (_rd-3d p2))
    )
  )
  (if (tblsearch "ltype" "DASHED")
    (setq dxf (append dxf (list (cons 6 "DASHED"))))
  )
  (entmakex dxf)
)

;; vyber vonkajsi vrchol pravouhleho trojuholnika (na vonkajsej strane)
(defun _rd-outer-corner (a b origObj halfW pickPt / c1 c2 d1 d2)
  (setq c1 (list (car b) (cadr a) 0.0))
  (setq c2 (list (car a) (cadr b) 0.0))
  (if (> halfW 1e-9)
    (progn
      (setq d1 (distance c1 (vlax-curve-getClosestPointTo origObj c1)))
      (setq d2 (distance c2 (vlax-curve-getClosestPointTo origObj c2)))
      (if (>= d1 d2) c1 c2)
    )
    (if (>= (distance c1 pickPt) (distance c2 pickPt)) c2 c1)
  )
)

;; popis jednej odvesny trojuholnika (P-Q), text mimo trojuholnika
(defun _rd-leg-label (p q third gap fixedH paperH / dx dy mid sy sx)
  (setq dx (abs (- (car q) (car p))))
  (setq dy (abs (- (cadr q) (cadr p))))
  (setq mid (list (/ (+ (car p) (car q)) 2.0)
                  (/ (+ (cadr p) (cadr q)) 2.0)
                  0.0))
  (if (>= dx dy)
    ;; vodorovna odvesna -> text vodorovne, posun v Y od tretieho vrchola
    (progn
      (setq sy (if (> (cadr third) (cadr mid)) -1.0 1.0))
      (_rd-text (_rd-mm dx)
                (list (car mid) (+ (cadr mid) (* sy gap)) 0.0)
                0.0 fixedH paperH)
    )
    ;; zvisla odvesna -> text zvisle, posun v X od tretieho vrchola
    (progn
      (setq sx (if (> (car third) (car mid)) -1.0 1.0))
      (_rd-text (_rd-mm dy)
                (list (+ (car mid) (* sx gap)) (cadr mid) 0.0)
                (* 0.5 pi) fixedH paperH)
    )
  )
)

;;----------------------------------------------------------------------;;
;;                            Hlavna funkcia                            ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarDim (/ *error* plEnt plEd width halfW pickPt
                       oCmd oOsm oAun oClayer
                       outer vlist n closed origObj
                       styH anno sc th gap fixedH paperH
                       i j bulge SS m k seg p0 p1 prevSeg nextSeg
                       q0 q1 legmid ang outAng c)

  (defun *error* (msg)
    (if oCmd (setvar "CMDECHO" oCmd))
    (if oOsm (setvar "OSMODE" oOsm))
    (if oAun (setvar "AUNITS" oAun))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (prompt (strcat "\nChyba: " msg))
    )
    (princ)
  )

  (vl-load-com)

  ;; DASHED linetype pre pomocne ciary
  (if (not (tblsearch "ltype" "DASHED"))
    (vl-catch-all-apply
      '(lambda () (command "_.-LINETYPE" "_Load" "DASHED" "acad.lin" ""))
    )
  )
  (if (not (tblsearch "ltype" "DASHED"))
    (vl-catch-all-apply
      '(lambda () (command "_.-LINETYPE" "_Load" "DASHED" "acadiso.lin" ""))
    )
  )

  ;; 1) vyber polyliny
  (setq plEnt (car (entsel "\nVyber vystuz (LWPOLYLINE): ")))
  (if (or (null plEnt) (/= (cdr (assoc 0 (entget plEnt))) "LWPOLYLINE"))
    (progn (prompt "\nMusi to byt LWPOLYLINE.") (exit))
  )
  (setq plEd (entget plEnt))

  ;; 2) hrubka (global width 43) - musi byt nastavena na polyline
  (setq width (cdr (assoc 43 plEd)))
  (if (or (null width) (<= (abs width) 1e-9))
    (progn
      (prompt "\nPolyline nema nastavenu hrubku (global width) - najprv nastav hrubku polyliny.")
      (exit)
    )
  )
  (setq halfW (/ (abs width) 2.0))

  ;; 3) vonkajsia strana
  (setq pickPt (getpoint "\nUrci VONKAJSIU stranu (klikni bod na vonkajsej hrane): "))
  (if (null pickPt) (progn (prompt "\nZrusene.") (exit)))

  ;; --- ANNOTATIVNY textovy styl a vyska z neho ---
  (setq styH (cdr (assoc 40 (tblsearch "style" (getvar "TEXTSTYLE")))))
  (setq anno (_rd-anno-style-p))
  (setq sc   (getvar "CANNOSCALEVALUE"))
  (if (or (null sc) (<= sc 0.0)) (setq sc 1.0))
  (cond
    ;; annotativny styl s pevnou papierovou vyskou (bezny pripad)
    ((and anno (> styH 0.0))
     (setq fixedH T
           th     (/ styH sc)))          ; modelova vyska = papierova / mierka
    ;; nean. styl s pevnou vyskou
    ((> styH 0.0)
     (setq fixedH T
           th     styH))
    ;; styl bez pevnej vysky -> prikaz sa spyta, dodame TEXTSIZE
    (t
     (setq fixedH nil
           paperH (getvar "TEXTSIZE"))
     (if (<= paperH 0.0) (setq paperH 2.5))
     (setq th (if anno (/ paperH sc) paperH)))
  )
  (setq gap th)

  (setq origObj (vlax-ename->vla-object plEnt))

  ;; uloz a nastav systemove premenne
  (setq oCmd (getvar "CMDECHO")
        oOsm (getvar "OSMODE")
        oAun (getvar "AUNITS"))
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)
  (setvar "AUNITS" 0)   ; uhly v stupnoch pre prikaz TEXT

  ;; 4) vonkajsia hrana = offset osi o polovicu hrubky na stranu pickPt
  (if (> halfW 1e-9)
    (progn
      (command "_.OFFSET" "E" "N" halfW plEnt pickPt "")
      (setq outer (entlast))
    )
    (setq outer plEnt)   ; bez hrubky = meriame os
  )

  (if (or (null outer)
          (and (> halfW 1e-9) (eq outer plEnt)))
    (progn
      (setvar "CMDECHO" oCmd)
      (setvar "OSMODE" oOsm)
      (setvar "AUNITS" oAun)
      (prompt "\nOffset vonkajsej hrany sa nepodaril.")
      (exit)
    )
  )

  ;; 5) nacitaj geometriu vonkajsej hrany
  (setq vlist  (_rd-verts outer))
  (setq n      (length vlist))
  (setq closed (= 1 (logand 1 (cdr (assoc 70 (entget outer))))))

  (if (< n 2)
    (progn
      (if (> halfW 1e-9) (entdel outer))
      (setvar "CMDECHO" oCmd)
      (setvar "OSMODE" oOsm)
      (setvar "AUNITS" oAun)
      (prompt "\nMalo vrcholov.")
      (exit)
    )
  )

  ;; 6a) zozbieraj len ROVNE useky vonkajsej hrany v poradi ako (start end)
  (setq SS '())
  (setq i 0)
  (while (< i (if closed n (1- n)))
    (setq bulge (cadr (nth i vlist)))
    (setq j     (if (= i (1- n)) 0 (1+ i)))
    (if (< (abs bulge) 1e-8)
      (setq SS (cons (list (car (nth i vlist)) (car (nth j vlist))) SS))
    )
    (setq i (1+ i))
  )
  (setq SS (reverse SS))
  (setq m  (length SS))

  ;; 6b) kazdy rovny usek predlz k VRCHOLU (priesecniku) so susednymi
  ;;     rovnymi usekmi -> tam kde je obluk, dostaneme ostry roh a dlzku
  ;;     merame vrchol-vrchol.
  (setq k 0)
  (while (< k m)
    (setq seg (nth k SS)
          p0  (car seg)
          p1  (cadr seg))

    (setq prevSeg (cond ((> k 0) (nth (1- k) SS))
                        (closed  (nth (1- m) SS))
                        (t nil)))
    (setq nextSeg (cond ((< k (1- m)) (nth (1+ k) SS))
                        (closed       (nth 0 SS))
                        (t nil)))

    ;; vrchol na zaciatku = priesecnik predosleho a tohto useku (predlzene)
    (setq q0 (if prevSeg
               (cond ((inters (car prevSeg) (cadr prevSeg) p0 p1 nil))
                     (t p0))
               p0))
    ;; vrchol na konci = priesecnik tohto a nasledujuceho useku (predlzene)
    (setq q1 (if nextSeg
               (cond ((inters p0 p1 (car nextSeg) (cadr nextSeg) nil))
                     (t p1))
               p1))

    (setq ang    (angle q0 q1))
    (setq legmid (list (/ (+ (car q0) (car q1)) 2.0)
                       (/ (+ (cadr q0) (cadr q1)) 2.0)
                       0.0))
    (setq outAng (_rd-outward legmid origObj halfW pickPt))

    ;; dlzka ramena vrchol-vrchol v mm
    (_rd-text (_rd-mm (distance q0 q1))
              (polar legmid outAng gap)
              (_rd-read ang)
              fixedH paperH)

    ;; sikme rameno -> pravouhly trojuholnik (vodorovna + zvisla odvesna)
    (if (not (_rd-axis-aligned ang))
      (progn
        (setq c (_rd-outer-corner q0 q1 origObj halfW pickPt))
        (_rd-dline q0 c)
        (_rd-dline c q1)
        (_rd-leg-label q0 c q1 gap fixedH paperH)   ; odvesna q0-c, treti vrchol q1
        (_rd-leg-label c q1 q0 gap fixedH paperH)   ; odvesna c-q1, treti vrchol q0
      )
    )

    (setq k (1+ k))
  )

  ;; 7) upratovanie
  (if (> halfW 1e-9) (entdel outer))   ; docasna offset polylina prec
  (setvar "CMDECHO" oCmd)
  (setvar "OSMODE" oOsm)
  (setvar "AUNITS" oAun)
  (prompt "\nHotovo – vystuz okotovana.")
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nRebar_dimension.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
