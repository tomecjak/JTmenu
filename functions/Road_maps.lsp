;=========================================================================
; Road_maps.lsp
; Create by Jakub Tomecko
;
; Vyhladavanie miesta v cestnej databanke podľa JTSK
;-------------------------------------------------------------------------

;;------=={ Vyhladavanie miesta v cestnej databanke podľa JTSK }==------;;
;;                                                                      ;;
;;  Tento program umoznuje po vybrati/vlozeni suradnic v JTSK zobrazit  ;;
;;  dane miestno na mapach od Google, Mapy.cz alebo ZBGIS mapy.         ;;
;;  Je mozne pre vyhladanie vyuzit UCS World alebo vlastny.             ;;
;;----------------------------------------------------------------------;;

;definovanie funkcie prikazu "JTRoadMaps"
(defun c:JTRoadMaps ()
  
  ;definovanie chybovej hlasky v programe + nastavenie 
  (defun *error* (errmsg)
    (command-s "_.ucs" "_Previous")
    (princ)
    (princ "\nProgram Road_maps.lsp sa ukoncil. ")
    (terpri)
    (prompt errmsg)
    (princ)
  )
  
  ;vytvrenie premenej VyberUCSRoadMaps pre vyber pouzivaneho UCS
  (initget "WCS Vlastne")
  (setq VyberUCSRoadMaps (getkword "\nAke pouzit UCS? [WCS/Vlastne] <WCS>: "))
  (if (null VyberUCSRoadMaps) (setq VyberUCSRoadMaps "WCS"))

  (cond
    ((= VyberUCSRoadMaps "WCS")
      ;nastavenie UCS na World
      (command "_.ucs" "_World")
    )
    ((= VyberUCSRoadMaps "Vlastne")
      ;UCS zostane bez zmeny
      (princ)
    )
  )
  
  ;definovanie premenej "polohaBoduMapy" do krotej sú zapísane súradnice
  (setq polohaBoduMapy (getpoint "Zadajte suradnice: "))

  ;definovanie premenej "RoadMapaURL" do ktorej je zapísana url adresa
  (setq RoadMapaURL (getSuradniceMapaURL polohaBoduMapy))
  
  ;spustenie prikazu browser z vlozenou url
  (command "browser" RoadMapaURL)
  
  ;vyhodnotenie vyberu UCS po prikaze
  (cond
    ((= VyberUCSRoadMaps "WCS")
      ;nastavenie UCS na predchadzajuce
      (command "_.ucs" "_Previous")
    )
    ((= VyberUCSRoadMaps "Vlastne")
      ;UCS zostane bez zmeny
      (princ)
    )
  ) 
  
  ;hlaska po skonceni programu
  (princ "\nMapa sa otvorila v internetovom prehliadaci. ")
  (princ)
)

;;----------------------------------------------------------------------;;

;definovanie funkcie "getSuradniceMapaURL" pre získanie plného tvaru url adresy
(defun getSuradniceMapaURL (pp_point)
  ;definovanie súradníc X a Y
  (setq SuradnicaX (abs (nth 1 pp_point)))
  (setq SuradnicaY (abs (nth 0 pp_point)))

  ;prepocet z Y, X suradnic do latitude a longitude pre S-JTSK
  (setq fiO 59.71186)
  (setq la0 42.52539)
   
  (setq fi0rad (* fiO (/ pi 180)))
  (setq la0rad (* la0 (/ pi 180)))
  
  (setq betakv (* pi (/ 11.5 180)))
  
  (setq mmm (cos betakv))
  
  (setq gamma (atan SuradnicaY SuradnicaX))
  
  (setq lambv (/ gamma mmm))

  (setq ro1 (sqrt (+ (expt SuradnicaX 2.0) (expt SuradnicaY 2.0))))
  
  (setq RGaussScale 6380065.5402)
  
  (setq c1 (* RGaussScale (sin betakv)))
  (setq c2 (/ c1 mmm))
  (setq c3 (tan (/ betakv 2)))
  (setq c4 (expt c3 mmm))
  (setq ccc (/ c2 c4))
  
  (setq betav1 (expt (/ ro1 ccc) (/ 1 mmm)))
  (setq betav (* 2 (atan betav1)))
  
  (setq fi1 (* (cos betav) (sin fi0rad)))
  (setq fi2 (* (sin betav) (cos fi0rad) (cos lambv)))
  (setq fi (asin (- fi1 fi2)))
  
  (setq la1 (* (sin betav) (sin lambv)))
  (setq la2 (cos fi))
  (setq la (asin (/ la1 la2)))
  
  (setq aaa 6377397.155)
  (setq bbb 6356078.96325)
  
  (setq e11 (- (expt aaa 2.0) (expt bbb 2.0)))
  (setq e12 (expt aaa 2.0))
  (setq e1 (sqrt (/ e11 e12)))
  
  (setq e21 (- (expt aaa 2.0) (expt bbb 2.0)))
  (setq e22 (expt bbb 2.0))
  (setq e2 (sqrt (/ e21 e22)))
  
  (setq Flnrad (* pi (/ 49.5 180)))
  
  (setq Vn (sqrt (+ 1 (* (expt e2 2.0) (expt (cos Flnrad) 2.0)))))
  
  (setq fin (atan (tan Flnrad) Vn))
  
  (setq nnn (/ (sin Flnrad) (sin fin)))
  
  (setq k1 (tan (+ (/ pi 4) (/ fin 2))))
  (setq k2 (expt (tan (+ (/ pi 4) (/ Flnrad 2))) nnn))
  (setq k3 (- 1 (* e1 (sin Flnrad))))
  (setq k4 (+ 1 (* e1 (sin Flnrad))))
  (setq k5 (expt (/ k3 k4) (* nnn (/ e1 2))))
  (setq k6 (* k2 k5))
  (setq kkk (/ k1 k6))
  
  (setq LArad (/ (- la0rad la) nnn))
  
  (setq Flk1 (/ 1 kkk))
  (setq Flk2 (tan (+ (/ pi 4) (/ fi 2))))
  (setq Flk3 (* Flk1 Flk2))
  (setq Flk (- (* 2 (atan (expt Flk3 (/ 1 nnn)))) (/ pi 2)))
  
  (setq tga01 (- 1 (* e1 (sin Flk))))
  (setq tga02 (+ 1 (* e1 (sin Flk))))
  (setq tga03 (/ tga01 tga02))
  (setq tga (expt tga03 (* nnn (/ e1 2))))
  
  (setq Fl1rad1 (/ 1 kkk tga))
  (setq Fl1rad2 (tan (+ (/ pi 4) (/ fi 2))))
  (setq Fl1rad3 (* Fl1rad1 Fl1rad2))
  (setq Fl1rad4 (expt Fl1rad3 (/ 1 nnn)))
  (setq Fl1rad (- (* 2 (atan Fl1rad4)) (/ pi 2)))
  
  (setq tga21 (- 1 (* e1 (sin Fl1rad))))
  (setq tga22 (+ 1 (* e1 (sin Fl1rad))))
  (setq tga23 (/ tga21 tga22))
  (setq tga2 (expt tga23 (* nnn (/ e1 2))))
  
  (setq Fl2rad1 (/ 1 kkk tga2))
  (setq Fl2rad2 (tan (+ (/ pi 4) (/ fi 2))))
  (setq Fl2rad3 (* Fl2rad1 Fl2rad2))
  (setq Fl2rad4 (expt Fl2rad3 (/ 1 nnn)))
  (setq Fl2rad (- (* 2 (atan Fl2rad4)) (/ pi 2)))
  
  (setq tga31 (- 1 (* e1 (sin Fl2rad))))
  (setq tga32 (+ 1 (* e1 (sin Fl2rad))))
  (setq tga33 (/ tga31 tga32))
  (setq tga3 (expt tga33 (* nnn (/ e1 2))))
  
  (setq Fl3rad1 (/ 1 kkk tga3))
  (setq Fl3rad2 (tan (+ (/ pi 4) (/ fi 2))))
  (setq Fl3rad3 (* Fl3rad1 Fl3rad2))
  (setq Fl3rad4 (expt Fl3rad3 (/ 1 nnn)))
  (setq Fl3rad (- (* 2 (atan Fl3rad4)) (/ pi 2)))
  
  (setq tga41 (- 1 (* e1 (sin Fl3rad))))
  (setq tga42 (+ 1 (* e1 (sin Fl3rad))))
  (setq tga43 (/ tga41 tga42))
  (setq tga4 (expt tga43 (* nnn (/ e1 2))))
  
  (setq Fl4rad1 (/ 1 kkk tga4))
  (setq Fl4rad2 (tan (+ (/ pi 4) (/ fi 2))))
  (setq Fl4rad3 (* Fl4rad1 Fl4rad2))
  (setq Fl4rad4 (expt Fl4rad3 (/ 1 nnn)))
  (setq Fl4rad (- (* 2 (atan Fl4rad4)) (/ pi 2)))
  
  (setq tga51 (- 1 (* e1 (sin Fl4rad))))
  (setq tga52 (+ 1 (* e1 (sin Fl4rad))))
  (setq tga53 (/ tga51 tga52))
  (setq tga5 (expt tga53 (* nnn (/ e1 2))))
  
  (setq Flrad1 (/ 1 kkk tga5))
  (setq Flrad2 (tan (+ (/ pi 4) (/ fi 2))))
  (setq Flrad3 (* Flrad1 Flrad2))
  (setq Flrad4 (expt Flrad3 (/ 1 nnn)))
  (setq Flrad (- (* 2 (atan Flrad4)) (/ pi 2)))
  
  ;vypocet S-JTSK latitude
  (setq Fl (* Flrad (/ 180 pi)))
  
  (setq LAFerro (* LArad (/ 180 pi)))
  ;vypocet S-JTSK longitude
  (setq LAGreenW (- LAFerro 17.66667))
  
  ;prepocet z S-JTSK do WGS84
  (setq Fl1_rad (* Fl (/ pi 180)))
  (setq LA1_rad (* LAGreenW (/ pi 180)))
  
  (setq a1 6377397.155)
  (setq f1 0.00334277318217481)
  (setq a2 6378137)
  (setq f2 0.00335281066474748)
  
  ;Moldensky shift parametre
  (setq dX 589)
  (setq dY 76)
  (setq dZ 480)
  
  (setq eee (sqrt (- (* 2 f1) (* f1 f1))))
  
  (setq M (/ (* a1 (- 1 (* eee eee))) (expt (- 1 (* (* eee eee) (* (sin Fl1_rad) (sin Fl1_rad)))) 1.5)))
  (setq N (/ a1 (sqrt (- 1 (* (* eee eee) (* (sin Fl1_rad) (sin Fl1_rad)))))))
  
  (setq dFlsec01 (* -1 dX (sin Fl1_rad) (cos LA1_rad)))
  (setq dFlsec02 (* -1 dY (sin Fl1_rad) (sin LA1_rad)))
  (setq dFlsec03 (* dZ (cos Fl1_rad)))
  (setq dFlsec04 (* a1 (- f2 f1)))
  (setq dFlsec05 (* f1 (- a2 a1)))
  (setq dFlsec06 (sin (* 2 Fl1_rad)))
  (setq dFlsec07 (* M (sin (/ pi 180 3600))))
  (setq dFlsec08 (* (+ dFlsec04 dFlsec05) dFlsec06))
  (setq dFlsec (/ (+ dFlsec01 dFlsec02 dFlsec03 dFlsec08) dFlsec07))
  
  (setq dLAsec01 (* -1 dX (sin LA1_rad)))
  (setq dLAsec02 (* dY (cos LA1_rad)))
  (setq dLAsec03 (* N (cos Fl1_rad) (sin (/ pi 180 3600))))
  (setq dLAsec (/ (+ dLAsec01 dLAsec02) dLAsec03))
  
  ;WGS84 latitude
  (setq Fl2 (+ Fl (/ dFlsec 3600)))
  ;WGS84 longitude
  (setq LA2 (+ LAGreenW (/ dLAsec 3600)))
  
  ;prepocet z WGS84 do UTM (ETRS89)
  (setq UTM_a 6378137)
  (setq UTM_e 0.0818191908469312)
  (setq UTM_FE 500000)
  (setq UTM_FN 0)
  (setq UTM_lambda0 (+ 21 (* 6 (- (LM:rounddown (/ LA2 6) 1) 3))))
  (setq UTM_lambda0_rad (* UTM_lambda0 (/ pi 180)))
  (setq UTM_fi0 0)
  (setq UTM_fi0_rad (* UTM_fi0 (/ pi 180)))
  (setq UTM_k0 0.9996)
  (setq UTM_fi_rad (* Fl2 (/ pi 180)))
  (setq UTM_lambda_rad (* LA2 (/ pi 180)))
  (setq UTM_e_ciarka_2 (/ (* UTM_e UTM_e) (- 1 (* UTM_e UTM_e))))
  (setq UTM_N (/ UTM_a (sqrt (- 1 (* UTM_e UTM_e (sin UTM_fi_rad) (sin UTM_fi_rad))))))
  (setq UTM_T (* (tan UTM_fi_rad) (tan UTM_fi_rad)))
  (setq UTM_C (* UTM_e_ciarka_2 (cos UTM_fi_rad) (cos UTM_fi_rad)))
  (setq UTM_A_velke (* (- UTM_lambda_rad UTM_lambda0_rad) (cos UTM_fi_rad)))
  (setq UTM_M1 (* UTM_fi_rad (- 1 (/ (* UTM_e UTM_e) 4) (/ (* 3 (expt UTM_e 4)) 64) (/ (* 5 (expt UTM_e 6))256))))
  (setq UTM_M2 (* (sin (* 2 UTM_fi_rad)) (+ (/ (* 3 UTM_e UTM_e) 8) (* 3 (/ (expt UTM_e 4) 32)) (/ (* 45 (expt UTM_e 6)) 1024))))
  (setq UTM_M3 (* (sin (* 4 UTM_fi_rad)) (+ (/ (* 15 (expt UTM_e 4)) 256) (/ (* 45 (expt UTM_e 6)) 1024))))
  (setq UTM_M4 (* (sin (* 6 UTM_fi_rad)) (/ (* 35 (expt UTM_e 6)) 3072)))
  (setq UTM_M (* UTM_a (+ UTM_M1 (- UTM_M3 UTM_M2 UTM_M3))))
  (setq UTM_M0_1 (- 1 (/ (* UTM_e UTM_e) 4) (/ (* 3 (expt UTM_e 4)) 64) (/ (* 5 (expt UTM_e 6))256)))
  (setq UTM_M0_2 (* (sin (* 2 UTM_fi0_rad)) (+ (/ (* 3 UTM_e UTM_e) 8) (* 3 (/ (expt UTM_e 4) 32)) (/ (* 45 (expt UTM_e 6)) 1024))))
  (setq UTM_M0_3 (* (sin (* 4 UTM_fi0_rad)) (+ (/ (* 15 (expt UTM_e 4)) 256) (/ (* 45 (expt UTM_e 6)) 1024))))
  (setq UTM_M0_4 (* (sin (* 6 UTM_fi0_rad)) (/ (* 35 (expt UTM_e 6)) 3072)))
  (setq UTM_M0 (* UTM_a UTM_fi0_rad (+ UTM_M0_1 (- UTM_M0_3 UTM_M0_2 UTM_M0_3))))
  (setq UTM_x_male_1 (+ UTM_A_velke (* (- 1 (+ UTM_T UTM_C)) (/ (expt UTM_A_velke 3) 6))))
  (setq UTM_x_male_2 (* (- (+ (- 5 (* 18 UTM_T)) (+ (* UTM_T UTM_T) (* 72 UTM_C))) (* 85 UTM_e_ciarka_2)) (/ (expt UTM_A_velke 5) 120)))
  (setq UTM_x_male (* UTM_k0 UTM_N (+ UTM_x_male_1 UTM_x_male_2)))
  (setq UTM_y_male_1 (+ (/ (* UTM_A_velke UTM_A_velke) 2) (* (+ (- 5 UTM_T) (* 9 UTM_C) (* 4 UTM_C UTM_C)) (/ (expt UTM_A_velke 4) 24))))
  (setq UTM_y_male_2 (* (- (+ (- 61 (* 58 UTM_T)) (* UTM_T UTM_T) (* 600 UTM_C)) (* 330 UTM_e_ciarka_2)) (/ (expt UTM_A_velke 6) 720)))
  (setq UTM_y_male (* UTM_k0 (+ (- UTM_M UTM_M0) (* UTM_N (tan UTM_fi_rad) (+ UTM_y_male_1 UTM_y_male_2)))))
  ;navysenie suradnic o 200 pre horny roh zobrazenia
  (setq UTM_X_velke (+ UTM_x_male UTM_FE 200))
  (setq UTM_Y_velke (+ UTM_y_male UTM_FN 200))
  ;znizenie suradnic o 400 pre dolny roh zobrazenia
  (setq UTM_X2_velke (- UTM_X_velke 400))
  (setq UTM_Y2_velke (- UTM_Y_velke 400))
  
  
  ;spojenie stringov do jedného url - https://ismcs.cdb.sk/mapviewer/views?viewid=70ddf82c0243461fb614d7f6c8d22cb2&extent=514057.5426810.516082.5428093
  (strcat
    "https://ismcs.cdb.sk/mapviewer/views?viewid=70ddf82c0243461fb614d7f6c8d22cb2&extent="
    ;prevedenie čísla do stringu (2-decimal, 0-precision)
    (rtos UTM_X_velke 2 0)
    "."
    (rtos UTM_Y_velke 2 0)
    "."
    (rtos UTM_X2_velke 2 0)
    "."
    (rtos UTM_Y2_velke 2 0)
  )

)

;;----------------------------------------------------------------------;;

;definovanie matematickej funkciet tangens
(defun tan ( x )
    (if (not (equal 0.0 (cos x) 1e-10))
        (/ (sin x) (cos x))
    )
)

;definovanie matematickej funkcie arkussinus
(defun asin ( x )
    (if (<= -1.0 x 1.0)
        (atan x (sqrt (- 1.0 (* x x))))
    )
)

;; Round Down  -  Lee Mac
;; Rounds 'n' down to the nearest 'm'

(defun LM:rounddown ( n m )
    ((lambda ( r ) (cond ((equal 0.0 r 1e-8) n) ((< n 0) (- n r m)) ((- n r)))) (rem n m))
)

;;----------------------------------------------------------------------;;

;definovanie chybovej hlasky v programe + nastavenie 
(defun *error* (errmsg)
  (command-s "_.ucs" "_Previous")
  (princ)
  (princ "\nV programe sa vyskytla chyba. ")
  (terpri)
  (prompt errmsg)
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nRoad_maps.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;