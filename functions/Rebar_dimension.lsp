;=========================================================================
; Rebar_dimension.lsp
; Create by Jakub Tomecko
;
; Kotovanie vystuze (polylina s hrubkou / oblukmi v rohoch).
; Ku kazdemu ramenu prida ANNOTATIVNY text s dlzkou (v mm, zaokruhlene
; na najblizsich 5). Dlzku merania urcuje globalna premenna
; GlobalnaRebarLegth:  "Os" = po osi polyliny, inak po vonkajsom povrchu.
; Pri zaoblenych rohoch sa rameno predlzi k VRCHOLU (priesecniku susednych
; rovnych hran) a merame vrchol-vrchol.
; Pri sikmych ramenach (uhol iny ako 90) dokresli ciarkovany pravouhly
; trojuholnik s vodorovnou a zvislou odvesnou (voci osiam aktualneho UCS)
; a obe odvesny popise dlzkou.
; Text pouzije aktualny textovy styl a vysku z neho.
; Funguje aj v inom UCS ako World (predpoklad: polylina lezi v rovine UCS).
; Vykres v metroch -> hodnoty *1000 -> mm.
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                        Pomocne funkcie - suradnice                    ;;
;;----------------------------------------------------------------------;;

;; WCS -> UCS a UCS -> WCS
(defun _rd-w2u (p) (trans p 0 1))
(defun _rd-u2w (p) (trans p 1 0))

;; novy bod v rovine UCS (drzi elevaciu ez z hlavnej funkcie)
(defun _rd-mk (x y) (list x y ez))

;;----------------------------------------------------------------------;;
;;                           Pomocne funkcie                            ;;
;;----------------------------------------------------------------------;;

;; dlzka v jednotkach vykresu (m) -> string mm, zaokruhlene na najblizsich 5
(defun _rd-mm (d / mm)
  (setq mm (* (abs d) 1000.0))
  (itoa (* 5 (fix (+ 0.5 (/ mm 5.0)))))
)

;; nacita vrcholy LWPOLYLINE ako zoznam (bodUCS bulge). Vrcholy sa
;; prevedu z OCS (extruzia 210 + elevacia 38) do UCS.
(defun _rd-verts (ename / ed ext elev v pt)
  (setq ed   (entget ename))
  (setq ext  (cond ((cdr (assoc 210 ed))) ('(0.0 0.0 1.0))))
  (setq elev (cond ((cdr (assoc 38 ed))) (0.0)))
  (setq v '())
  (foreach x ed
    (cond
      ((= (car x) 10)
       (setq pt (trans (list (car (cdr x)) (cadr (cdr x)) elev) ext 1))
       (setq v (cons (list pt 0.0) v)))
      ((and (= (car x) 42) v)
       (setq v (cons (list (car (car v)) (cdr x)) (cdr v))))
    )
  )
  (reverse v)
)

;; je uhol (rad) v ramci tolerancie zarovnany s osou X alebo Y (UCS)?
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

;; na ktorej strane usmecky p0->p1 lezi bod pt (znamienko krizoveho sucinu)
(defun _rd-side (p0 p1 pt / z)
  (setq z (- (* (- (car p1) (car p0)) (- (cadr pt) (cadr p0)))
             (* (- (cadr p1) (cadr p0)) (- (car pt) (car p0)))))
  (if (>= z 0.0) 1 -1)
)

;; kolmica k useku (uhol ang) smerujuca na stranu bodu pickPt
(defun _rd-perp-toward (M ang pickPt / n)
  (setq n (+ ang (* 0.5 pi)))
  (if (< (cos (- n (angle M pickPt))) 0.0)
    (- ang (* 0.5 pi))
    n
  )
)

;; smer "von" v bode M (UCS). Pri povrchovom rezime pouzije najblizsi bod
;; povodnej osi (skutocna kolmica von), inak kolmicu na stranu pickPt.
(defun _rd-outward (M ang origObj useOffset pickPt / cpU)
  (if useOffset
    (progn
      (setq cpU (_rd-w2u (vlax-curve-getClosestPointTo origObj (_rd-u2w M))))
      (if (and cpU (> (distance M cpU) 1e-9))
        (angle cpU M)
        (_rd-perp-toward M ang pickPt)
      )
    )
    (_rd-perp-toward M ang pickPt)
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
          (setq xd (cdar xd))
          (foreach it xd
            (if (= (car it) 1070) (setq res (= (cdr it) 1)))
          )
        )
      )
    )
  )
  res
)

;; ANNOTATIVNY text (aktualny styl, middle-center). Vytvara sa prikazom
;; TEXT, aby AutoCAD nastavil annotativnost a aktualnu mierku. Bod pt aj
;; uhol ang su v UCS. Pocas volania musi byt AUNITS = 0 a OSMODE = 0.
(defun _rd-text (str pt ang fixedH paperH / d)
  (setq d (* ang (/ 180.0 pi)))
  (if fixedH
    (command "_.TEXT" "_J" "_MC" pt d str "")
    (command "_.TEXT" "_J" "_MC" pt paperH d str "")
  )
)

;; ciarkovana pomocna ciara (vstup UCS -> entmake vo WCS)
(defun _rd-dline (p1 p2 / dxf)
  (setq dxf
    (list
      '(0 . "LINE")
      (cons 8 (getvar "CLAYER"))
      (cons 10 (_rd-u2w p1))
      (cons 11 (_rd-u2w p2))
    )
  )
  (if (tblsearch "ltype" "DASHED")
    (setq dxf (append dxf (list (cons 6 "DASHED"))))
  )
  (entmakex dxf)
)

;; vyber vonkajsi vrchol pravouhleho trojuholnika (na vonkajsej strane)
(defun _rd-outer-corner (a b origObj useOffset pickPt / c1 c2 d1 d2 sp)
  (setq c1 (_rd-mk (car b) (cadr a)))
  (setq c2 (_rd-mk (car a) (cadr b)))
  (if useOffset
    (progn
      (setq d1 (distance c1 (_rd-w2u (vlax-curve-getClosestPointTo origObj (_rd-u2w c1)))))
      (setq d2 (distance c2 (_rd-w2u (vlax-curve-getClosestPointTo origObj (_rd-u2w c2)))))
      (if (>= d1 d2) c1 c2)
    )
    (progn
      (setq sp (_rd-side a b pickPt))
      (cond
        ((= (_rd-side a b c1) sp) c1)
        ((= (_rd-side a b c2) sp) c2)
        (t c1)
      )
    )
  )
)

;; popis jednej odvesny trojuholnika (P-Q), text mimo trojuholnika
(defun _rd-leg-label (p q third gap fixedH paperH / dx dy midx midy sy sx)
  (setq dx   (abs (- (car q) (car p))))
  (setq dy   (abs (- (cadr q) (cadr p))))
  (setq midx (/ (+ (car p) (car q)) 2.0))
  (setq midy (/ (+ (cadr p) (cadr q)) 2.0))
  (if (>= dx dy)
    ;; vodorovna odvesna (X-UCS) -> text vodorovne, posun v Y od tretieho vrchola
    (progn
      (setq sy (if (> (cadr third) midy) -1.0 1.0))
      (_rd-text (_rd-mm dx) (_rd-mk midx (+ midy (* sy gap))) 0.0 fixedH paperH)
    )
    ;; zvisla odvesna (Y-UCS) -> text zvisle, posun v X od tretieho vrchola
    (progn
      (setq sx (if (> (car third) midx) -1.0 1.0))
      (_rd-text (_rd-mm dy) (_rd-mk (+ midx (* sx gap)) midy) (* 0.5 pi) fixedH paperH)
    )
  )
)

;;----------------------------------------------------------------------;;
;;                            Hlavna funkcia                            ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarDimension (/ *error* plEnt plEd width halfW pickPt axisMode useOffset
                       oCmd oOsm oAun
                       outer vlist n closed origObj ez
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

  ;; rezim merania podla globalnej premennej GlobalnaRebarLegth
  (setq axisMode  (= (getenv "GlobalnaRebarLegth") "Os"))
  (setq useOffset (not axisMode))
  (prompt (if axisMode
            "\nRezim: dlzka po OSI vystuze."
            "\nRezim: dlzka po VONKAJSOM povrchu vystuze."))

  ;; 3) strana na ktoru sa kotuje
  (setq pickPt (getpoint (if axisMode
                           "\nUrci stranu pre koty (klikni bod): "
                           "\nUrci VONKAJSIU stranu (klikni bod na vonkajsej hrane): ")))
  (if (null pickPt) (progn (prompt "\nZrusene.") (exit)))

  ;; --- ANNOTATIVNY textovy styl a vyska z neho ---
  (setq styH (cdr (assoc 40 (tblsearch "style" (getvar "TEXTSTYLE")))))
  (setq anno (_rd-anno-style-p))
  (setq sc   (getvar "CANNOSCALEVALUE"))
  (if (or (null sc) (<= sc 0.0)) (setq sc 1.0))
  (cond
    ((and anno (> styH 0.0))
     (setq fixedH T  th (/ styH sc)))
    ((> styH 0.0)
     (setq fixedH T  th styH))
    (t
     (setq fixedH nil  paperH (getvar "TEXTSIZE"))
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

  ;; 4) zdroj merania: os (povodna) alebo vonkajsia hrana (offset)
  (if useOffset
    (progn
      (command "_.OFFSET" "E" "N" halfW plEnt pickPt "")
      (setq outer (entlast))
      (if (or (null outer) (eq outer plEnt))
        (progn
          (setvar "CMDECHO" oCmd) (setvar "OSMODE" oOsm) (setvar "AUNITS" oAun)
          (prompt "\nOffset vonkajsej hrany sa nepodaril.")
          (exit)
        )
      )
    )
    (setq outer plEnt)
  )

  ;; 5) nacitaj geometriu (vrcholy v UCS)
  (setq vlist  (_rd-verts outer))
  (setq n      (length vlist))
  (setq closed (= 1 (logand 1 (cdr (assoc 70 (entget outer))))))
  (setq ez     (caddr (car (car vlist))))   ; elevacia roviny v UCS

  (if (< n 2)
    (progn
      (if useOffset (entdel outer))
      (setvar "CMDECHO" oCmd) (setvar "OSMODE" oOsm) (setvar "AUNITS" oAun)
      (prompt "\nMalo vrcholov.")
      (exit)
    )
  )

  ;; 6a) zozbieraj len ROVNE useky v poradi ako (start end)
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
  ;;     rovnymi usekmi -> pri obluku dostaneme ostry roh a merame vrchol-vrchol
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

    (setq q0 (if prevSeg
               (cond ((inters (car prevSeg) (cadr prevSeg) p0 p1 nil)) (t p0))
               p0))
    (setq q1 (if nextSeg
               (cond ((inters p0 p1 (car nextSeg) (cadr nextSeg) nil)) (t p1))
               p1))

    (setq ang    (angle q0 q1))
    (setq legmid (_rd-mk (/ (+ (car q0) (car q1)) 2.0)
                         (/ (+ (cadr q0) (cadr q1)) 2.0)))
    (setq outAng (_rd-outward legmid ang origObj useOffset pickPt))

    ;; dlzka ramena vrchol-vrchol v mm
    (_rd-text (_rd-mm (distance q0 q1))
              (polar legmid outAng gap)
              (_rd-read ang)
              fixedH paperH)

    ;; sikme rameno -> pravouhly trojuholnik (vodorovna + zvisla odvesna)
    (if (not (_rd-axis-aligned ang))
      (progn
        (setq c (_rd-outer-corner q0 q1 origObj useOffset pickPt))
        (_rd-dline q0 c)
        (_rd-dline c q1)
        (_rd-leg-label q0 c q1 gap fixedH paperH)   ; odvesna q0-c, treti vrchol q1
        (_rd-leg-label c q1 q0 gap fixedH paperH)   ; odvesna c-q1, treti vrchol q0
      )
    )

    (setq k (1+ k))
  )

  ;; 7) upratovanie
  (if useOffset (entdel outer))   ; docasna offset polylina prec (os zostava)
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
