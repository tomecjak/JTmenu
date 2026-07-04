;=========================================================================
; Curve_dimension.lsp
; Create by Jakub Tomecko
;
; "Kota podla krivky" - meranie dlzky pozdlz krivky a vytvorenie koty.
; Postup:
;   1) vyber krivky (LINE / ARC / CIRCLE / LWPOLYLINE / POLYLINE / SPLINE / ELLIPSE)
;   2) vyber pociatocneho a koncoveho bodu NA krivke -> dlzka sa merat po krivke
;   3) klik na stranu, kam sa ma kota odsadit + zadanie velkosti offsetu
;   4) vytvori sa:
;        - ciara koty ako OFFSET krivky (kopiruje jej tvar - LWPOLYLINE)
;        - vynasacie ciary na oboch koncoch (s presahom)
;        - sikme znacky (oblique, 45°) na koncoch ciary koty
;        - text s dlzkou (mm, cele cislo) na strede, zarovnany na ciaru koty
; Velkosti (vyska textu, znacky, presah) sa odvodia z AKTUALNEHO textoveho
; stylu (podpora annotativneho stylu - ako v Rebar_dimension).
; Vykres v metroch -> hodnota *1000 -> mm.
; Predpoklad: krivka lezi v rovine XY sveta (bezny 2D vykres); funguje aj
; v UCS otocenom okolo osi Z.
;-------------------------------------------------------------------------

(vl-load-com)

;;----------------------------------------------------------------------;;
;;                     Pomocne funkcie - suradnice                      ;;
;;----------------------------------------------------------------------;;

;; WCS <-> UCS (body)
(defun _cd-w2u (p) (trans p 0 1))
(defun _cd-u2w (p) (trans p 1 0))
;; WCS -> UCS (smerovy vektor)
(defun _cd-vw2u (v) (trans v 0 1 t))

;; bod krivky vo vzdialenosti d (WCS) prevedeny do UCS
(defun _cd-ptu (en d)
  (_cd-w2u (vlax-curve-getpointatdist en d))
)

;; jednotkovy dotycnicovy vektor krivky vo vzdialenosti d (v rovine UCS)
(defun _cd-tanu (en d / v l)
  (setq v (_cd-vw2u (vlax-curve-getfirstderiv en (vlax-curve-getparamatdist en d))))
  (setq l (sqrt (+ (* (car v) (car v)) (* (cadr v) (cadr v)))))
  (if (< l 1e-12)
    (list 1.0 0.0 0.0)
    (list (/ (car v) l) (/ (cadr v) l) 0.0)
  )
)

;; normala (dotycnica otocena o +90°)
(defun _cd-nrm (tv) (list (- (cadr tv)) (car tv) 0.0))

;; posun bodu p v smere normaly n o (znamienkovu) vzdialenost s
(defun _cd-add (p n s)
  (list (+ (car p) (* s (car n)))
        (+ (cadr p) (* s (cadr n)))
        (caddr p)
  )
)

;; normalizovany rozdiel dvoch uhlov do intervalu (-pi, pi>
(defun _cd-angdiff (a b / d)
  (setq d (- a b))
  (while (> d pi) (setq d (- d (* 2.0 pi))))
  (while (< d (- pi)) (setq d (+ d (* 2.0 pi))))
  d
)

;; uhol textu tak, aby nebol "hore nohami"
(defun _cd-read (a)
  (while (< a 0.0) (setq a (+ a (* 2.0 pi))))
  (while (>= a (* 2.0 pi)) (setq a (- a (* 2.0 pi))))
  (if (and (> a (* 0.5 pi)) (<= a (* 1.5 pi))) (- a pi) a)
)

;; dlzka v jednotkach vykresu (m) -> string v mm, zaokruhlene na cele mm
(defun _cd-mm (d)
  (itoa (fix (+ 0.5 (* (abs d) 1000.0))))
)

;;----------------------------------------------------------------------;;
;;                     Pomocne funkcie - kreslenie                      ;;
;;----------------------------------------------------------------------;;

;; ciara z dvoch bodov UCS
(defun _cd-line (p1 p2)
  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 (getvar "CLAYER"))
      (cons 10 (_cd-u2w p1))
      (cons 11 (_cd-u2w p2))
    )
  )
)

;; LWPOLYLINE zo zoznamu bodov UCS (extruzia 0,0,1 -> OCS = WCS)
(defun _cd-pline (pts / dxf wp)
  (setq dxf
    (list
      '(0 . "LWPOLYLINE")
      '(100 . "AcDbEntity")
      (cons 8 (getvar "CLAYER"))
      '(100 . "AcDbPolyline")
      (cons 90 (length pts))
      '(70 . 0)
    )
  )
  (foreach p pts
    (setq wp  (_cd-u2w p)
          dxf (append dxf (list (list 10 (car wp) (cadr wp)))))
  )
  (setq dxf (append dxf (list '(210 0.0 0.0 1.0))))
  (entmakex dxf)
)

;; je aktualny textovy styl annotativny? (Lee Mac / JTmenu vzor)
(defun _cd-anno-style-p (/ ent xd res)
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

;; ANNOTATIVNY text (aktualny styl, middle-center). Bod aj uhol su v UCS.
;; Pocas volania musi byt AUNITS = 0 a OSMODE = 0.
(defun _cd-text (str ptucs angrad fixedh paperh / d)
  (setq d (* angrad (/ 180.0 pi)))
  (if fixedh
    (command "_.TEXT" "_J" "_MC" ptucs d str "")
    (command "_.TEXT" "_J" "_MC" ptucs paperh d str "")
  )
)

;; redukcia kolinearnych vrcholov polyliny (tol = uhlova tolerancia v rad)
(defun _cd-reduce (pts tol / out ref i n seg)
  (setq n (length pts))
  (if (< n 3)
    pts
    (progn
      (setq out (list (car pts)))
      (setq ref (angle (nth 0 pts) (nth 1 pts)))
      (setq i 1)
      (while (< i (1- n))
        (setq seg (angle (nth i pts) (nth (1+ i) pts)))
        (if (> (abs (_cd-angdiff seg ref)) tol)
          (setq out (cons (nth i pts) out)
                ref seg)
        )
        (setq i (1+ i))
      )
      (setq out (cons (nth (1- n) pts) out))
      (reverse out)
    )
  )
)

;; je vybrany objekt krivka?
(defun _cd-iscurve (e)
  (and e
       (not (vl-catch-all-error-p
              (vl-catch-all-apply 'vlax-curve-getendparam (list e)))))
)

;;----------------------------------------------------------------------;;
;;                            Hlavna funkcia                            ;;
;;----------------------------------------------------------------------;;

(defun c:JTCurveDimension (/ *error* ocmd oosm oaun en sel p1u p2u p1w p2w
                             d1 d2 tmp sidept offs dm pm tm nm pmdim textpos ang
                             styh anno sc th fixedh paperh exe fxl tickhalf textout sign
                             nsteps i dcur p tv nv pts pdim tickang up)

  (defun *error* (msg)
    (if ocmd (setvar "CMDECHO" ocmd))
    (if oosm (setvar "OSMODE" oosm))
    (if oaun (setvar "AUNITS" oaun))
    (LM:endundo (LM:acdoc))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*,*EXIT*")))
      (princ (strcat "\nChyba: " msg))
    )
    (princ)
  )

  (vl-load-com)

  ;; 1) vyber krivky
  (while
    (progn
      (setq sel (entsel "\nVyber krivku na meranie: "))
      (cond
        ((and sel (_cd-iscurve (car sel))) nil)
        (t (princ "\nVyber krivku (LINE/ARC/PLINE/SPLINE...).") t)
      )
    )
  )
  (setq en (car sel))

  ;; 2) pociatocny a koncovy bod na krivke (loose pick -> premietne sa na krivku)
  (if (null (setq p1u (getpoint "\nPociatocny bod na krivke: "))) (exit))
  (if (null (setq p2u (getpoint "\nKoncovy bod na krivke: "))) (exit))
  (setq p1w (vlax-curve-getclosestpointto en (_cd-u2w p1u))
        p2w (vlax-curve-getclosestpointto en (_cd-u2w p2u)))
  (setq d1 (vlax-curve-getdistatpoint en p1w)
        d2 (vlax-curve-getdistatpoint en p2w))
  (if (> d1 d2) (setq tmp d1 d1 d2 d2 tmp))
  (if (< (abs (- d2 d1)) 1e-6)
    (progn (prompt "\nBody su prilis blizko - nulova dlzka.") (exit))
  )

  ;; 3) strana odsadenia + velkost offsetu
  (if (null (setq sidept (getpoint "\nKlikni na stranu, kam odsadit kotu: "))) (exit))
  (initget 7)
  (setq offs (getdist "\nVelkost offsetu koty: "))

  ;; smer odsadenia (znamienko) podla strany kliknutia - urceny na strede
  (setq dm (/ (+ d1 d2) 2.0)
        pm (_cd-ptu en dm)
        tm (_cd-tanu en dm)
        nm (_cd-nrm tm))
  (setq sign
    (if (>= (+ (* (- (car sidept) (car pm)) (car nm))
               (* (- (cadr sidept) (cadr pm)) (cadr nm)))
            0.0)
      1.0 -1.0)
  )

  ;; velkosti prvkov z aktualneho textoveho stylu
  (setq styh (cdr (assoc 40 (tblsearch "style" (getvar "TEXTSTYLE")))))
  (setq anno (_cd-anno-style-p))
  (setq sc   (getvar "CANNOSCALEVALUE"))
  (if (or (null sc) (<= sc 0.0)) (setq sc 1.0))
  (cond
    ((and anno (> styh 0.0)) (setq fixedh t   th (/ styh sc)))
    ((> styh 0.0)            (setq fixedh t   th styh))
    (t
     (setq fixedh nil paperh (getvar "TEXTSIZE"))
     (if (<= paperh 0.0) (setq paperh 2.5))
     (setq th (if anno (/ paperh sc) paperh)))
  )
  (setq exe      (* th 0.4)     ; presah vynasacej ciary za ciaru koty
        fxl      (* th 2.25)    ; fixna dlzka vynasacej ciary (~4.5 mm pri texte 2.0 mm)
        tickhalf (* th 0.5)     ; polovica dlzky sikmej znacky
        textout  (* th 0.85))   ; posun textu nad ciaru koty

  ;; uloz a nastav systemove premenne
  (setq ocmd (getvar "CMDECHO")
        oosm (getvar "OSMODE")
        oaun (getvar "AUNITS"))
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)
  (setvar "AUNITS" 0)   ; uhly v stupnoch pre prikaz TEXT
  (LM:startundo (LM:acdoc))

  ;; 4a) ciara koty = offset krivky (kopiruje tvar) -> LWPOLYLINE
  (setq nsteps 256 pts '() i 0)
  (while (<= i nsteps)
    (setq dcur (+ d1 (* (/ (- d2 d1) (float nsteps)) i))
          p    (_cd-ptu en dcur)
          tv   (_cd-tanu en dcur)
          nv   (_cd-nrm tv)
          pts  (cons (_cd-add p nv (* sign offs)) pts)
          i    (1+ i))
  )
  (setq pts (reverse pts))
  (setq pts (_cd-reduce pts (/ 1.0 (/ 180.0 pi))))   ; tolerancia 1°
  (_cd-pline pts)

  ;; 4b) vynasacie ciary + sikme znacky na oboch koncoch
  (foreach dd (list d1 d2)
    (setq p    (_cd-ptu en dd)
          tv   (_cd-tanu en dd)
          nv   (_cd-nrm tv)
          pdim (_cd-add p nv (* sign offs)))
    ;; vynasacia ciara: fixna dlzka od ciary koty (nejde az po objekt),
    ;; s malym presahom exe za kotu smerom von
    (_cd-line (_cd-add pdim nv (* sign exe))
              (_cd-add pdim nv (* sign (- fxl))))
    ;; sikma znacka 45° vzhladom na ciaru koty, cez koncovy bod
    (setq tickang (+ (angle '(0.0 0.0) tv) (/ pi 4.0)))
    (_cd-line
      (list (+ (car pdim) (* tickhalf (cos tickang)))
            (+ (cadr pdim) (* tickhalf (sin tickang)))
            (caddr pdim))
      (list (- (car pdim) (* tickhalf (cos tickang)))
            (- (cadr pdim) (* tickhalf (sin tickang)))
            (caddr pdim))
    )
  )

  ;; 4c) text s dlzkou na strede, VZDY nad ciarou koty (v smere citania textu),
  ;;     nezavisle od strany odsadenia
  (setq pmdim (_cd-add pm nm (* sign offs))
        ang   (_cd-read (angle '(0.0 0.0) tm))
        up    (+ ang (/ pi 2.0)))   ; kolmica k citatelnej baseline -> "nahor"
  (setq textpos
    (list (+ (car pmdim)  (* textout (cos up)))
          (+ (cadr pmdim) (* textout (sin up)))
          (caddr pmdim)))
  (_cd-text (_cd-mm (- d2 d1)) textpos ang fixedh paperh)

  ;; obnov systemove premenne
  (setvar "CMDECHO" ocmd)
  (setvar "OSMODE" oosm)
  (setvar "AUNITS" oaun)
  (LM:endundo (LM:acdoc))
  (prompt (strcat "\nHotovo - dlzka koty: " (_cd-mm (- d2 d1)) " mm."))
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nCurve_dimension.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
