;verze 2.23dev - opraveno - nastavení ATTDIA, ATTREQ
;verze 2.24dev - opraveno - stanièení u funkce "KL-stanic_pline" pokud se nezaèínalo o nuly
;verze 2.25dev - pridana funkce "KL-ukaz_staniceni_na_krivce"
;verze 2.26dev - do funkce "KL-ukaz_staniceni_na_krivce" je pridano mereni od zacatku. Je opravana chyba pokud neni nic vybrano.
;verze 2.27dev - pridano automaticke nacteni (vl-load-com) do funkce "KL-stanic_pline"
;verze 2.28dev - funkce "KL-ukaz_staniceni_na_krivce" nefungovala v uzivatelskem souradnem systemu
;              - funkce "KL-stanic_pline" funguje i v uzivatelskem USS (pri vkladani bloku prepina do globalu)
;verze 2.29dev - pridano automaticke nacteni (vl-load-com) do funkce "KL-ukaz_staniceni_na_krivce"
;verze 2.30dev - ve funkci "KL-ukaz_staniceni_na_krivce" je jine mereni celkove delky (stare nefungovalo v Civilu 3D 2010)


;Utilita na mereni staniceni + vkladani bloku (defaultne LOM) - nacita odklikane vzdalenosti 2D.
;Hodnota staniceni je ulozena v globalni promenne "LOM_STANICENI".
;Vyzaduje blok (defaultne s nazvem LOM) s jednim atributem.
;Stanici je v km (predpoklada situace kde 1 jednotka = 1m). Do popisu vklada string "V" a cislo lomu.
;pocet desetinnych mist dle nastaveni JEDNOTEK (promenna LUPREC)


;KL  ...... staniceni se vkladanim bloku
;KL0  ..... nuluje staniceni
;KLSET .... nastaveni pocatecniho staniceni, cisla lomu, nazev bloku
;KL-delta ..cislovani - vklada blok a do atributu pricita konstantni hodnotu (napr. 0.1 pro staniceni kilometru).
;           potrebuje blok s jednim stanicenim (defaultne nazev "STANIC")
;KL-stanic_pline ... vpodstate automaticka aplikace funkce KL, kdy se bloky automaticky vlozi do vsech lomovych bodu
;                    LWPOLYLINE. Vyhlazene krivky a spline jsou entity VERTEX - ty funkce neumi a preskoci. UMI i obloukove useky køivek.
;                    ! Pozor na smìr køivky.
;KL-ukaz_staniceni_na_krivce ....ukaze staniceni v urcitem bodu na krivce. Pocita staniceni od KONCE i od ZACATKU krivky (tedy napr u kanalizace je to od zacatku staniceni)



;-------------------------------------------------------------------------------------------
;made by Alfred :-D
;Toto je FREEWARE a je možno ho šíøit jak kdo uzná za vhodné (vcelku i po èástech).
;Prostì si s tím dìlejte co chcete...
;
;Autor neruèí za zpùsobené problémy a chyby v programech (nevím o nich, ale mozna tam jsou).
;Pokud na nìjaké chyby narazíte, kontaktujte mì prosím na adrese 'alfred.samca@seznam.cz'
;Jestli máte zájem a zajimá Vás LISP mrknìte na moje stránky
;http://mujweb.cz/Pocitace/alfred
;nebo
;http://mine.at/alfred
;Stránky jsou prastaré a již neudržované, ale možná mohou trochu zaèáteèníkùm pomoct.
;-------------------------------------------------------------------------------------------
;



(princ "\n Pøíkaz 'KL' 'KL0' 'KLSET' 'KL-delta' 'KL-stanic_pline'")

(defun *error_lom* (msg)
  (princ "error: ")
  (setq *error* *old_error*)
  
  (if (/= olddimzin nil)(setvar "dimzin" olddimzin))
  (if (/= old_osmode nil)(setvar "OSMODE" old_osmode))
  (if (/= oldattreq nil)(setvar "attreq" oldattreq))
  (if (/= oldattdia nil)(setvar "attdia" oldattdia))
	(if (/= old_cmdecho nil)(setvar "cmdecho" old_cmdecho))
  (command "_undo" "_E")
  
  (princ msg)(print)
); defun error



(defun distance2d (p1 p2)
	(setq p1 (list (nth 0 p1)(nth 1 p1)))
	(setq p2 (list (nth 0 p2)(nth 1 p2)))
	(distance p1 p2);NÁVRATOVÁ HODNOTA
);defun


(defun c:klSET ()
  ;delta pricitani k cislu lomu
  (setq LOM_delta 1)
  (SETQ LOM_STANICENI (getreal "Poèátek stanièení [0 m]: "))
  (if (= LOM_STANICENI nil)(setq LOM_STANICENI 0))
	
	;string predpony pred staniceni
	(print "Zadejte text na zaèátek popisu lomu [napø. 'V']: ")
	(print "Pokud zadáte prázdný øetìzec (ENTER), nebudou se lomy èíslovat!")
	(setq LOM_POPIS (getstring "Zadej popis: "))
  ;(if (= LOM_POPIS "")(SETQ LOM_POPIS "V"))

	;pokud je zadán prázdný øetìzec LOM_POPIS tak se bloky nebudou èíslovat
	(if (/= LOM_POPIS "")
		(progn
		  (SETQ lom_cislo (GETINT "Zadej èíslo prvního dalšího lomu [1]: "))
		  (if (= lom_cislo nil)(setq lom_cislo 1))
		)
	);if
  
  (setq lom_jmeno_bloku

				 (getstring "Zmeno bloku [LOM]: "))
  (if (= lom_jmeno_bloku "")(setq lom_jmeno_bloku "LOM"))
	
  (print)
);defun

(defun c:kl0 ()
  (setq LOM_STANICENI 0)
  (print (strcat "Staniceni je na hodnote: " (rtos LOM_STANICENI 2 1) " m"))
  (print)
);defun

(defun sqr (x)
  (* x x)
);defun

(defun c:kl (/ point x y delta p1 p2 stanic)
  (if (= LOM_STANICENI nil)(c:klSET))
	;nastaveni promenych
	(setq olddimzin (getvar "dimzin"))(setvar "dimzin" 0)
	(setq oldattreq (getvar "attreq"))(setvar "attreq" 1)
  (setq oldattdia (getvar "attdia"))(setvar "attdia" 0)
  (setq *old_error* *error*)(setq *error* *error_lom*)
	(command "_undo" "_G")
	
  (setq delta LOM_delta)

	(if (/= LOM_POPIS "")
		(setq x lom_cislo)
		(setq x 1)
	);if

  (setq point 0)

  (print (strcat "Staniceni je: " (rtos LOM_STANICENI 2 1) " m"))
  (setq p1 (getpoint "point: "))
  (setq p2 (getpoint "point: "))
  (setq LOM_STANICENI (+ LOM_STANICENI (distance2d p1 p2)))
  (print (strcat "Staniceni je: " (rtos LOM_STANICENI 2 1) " m"))
  
  (while (/= p2 nil)
   	
	(setq stanic (rtos (/ LOM_STANICENI 1000) 2 (getvar "luprec")))
	(setq popis_lomu (strcat LOM_POPIS (rtos x 2 0) " " stanic))
	(command "_-insert" lom_jmeno_bloku p2 "" "" PAUSE popis_lomu)
	(setq x (+ x delta))


	(setq p1 p2)
	(setq p2 (getpoint "point: "))
    	(if (/= p2 nil)
    	  (progn 
		(setq LOM_STANICENI (+ LOM_STANICENI (distance2d p1 p2)))
    		(setq stanic (rtos LOM_STANICENI 2 1))
		(print (strcat "Staniceni je: " stanic " m"))
	    )
    	)
    )
	(if (/= LOM_POPIS "")
		(SETQ lom_cislo x)
	);if

	;zpetne nastaveni
  (setq *error* *old_error*)
  (setvar "dimzin" olddimzin)
  (setvar "attreq" oldattreq)
  (setvar "attdia" oldattdia)
  (command "_undo" "_E")

  (print)
);DEFUN
  
;--------------------------------------------------------------------

(DEFUN C:KL-delta ( / point x y delta lom_jmeno_bloku)
;NASTAVENI PROMENNYCH
	(setq olddimzin (getvar "dimzin"))(setvar "dimzin" 0)
	(setq oldattreq (getvar "attreq"))(setvar "attreq" 1)
  (setq oldattdia (getvar "attdia"))(setvar "attdia" 0)

	(setq delta (getreal "Zadej pøírùstek èíslování DELTA [0.1]: "))
	(if (= DELTA nil)(setq DELTA 0.1))
	
	(setq lom_jmeno_bloku (getstring "Zmeno bloku [STANIC]: "))
  (if (= lom_jmeno_bloku "")(setq lom_jmeno_bloku "STANIC"))

  (setq x (getreal "Zadej poèáteèní èíslo [pro 0.000 ENTER]: " ))
	(if (= x nil) (setq x 0))


(setq point 0)
(WHILE (/= point nil)
	(setq y (rtos x 2 (getvar "luprec")))
	(setq point (getpoint "Další lom: "))
	(if (/= point nil)
		(progn
			(command "_-insert" lom_jmeno_bloku point "" "" PAUSE y)
			(setq x (+ x delta))
		)
	);if
);while
	
;zpetne nastaveni
(setvar "dimzin" olddimzin)
(setvar "attreq" oldattreq)
(setvar "attdia" oldattdia)
  
(print)
);defun

;------------------------------------------------------------------------------

(defun c:KL-stanic_pline ( / i staniceni_celkem PointList vybrana_entita entlist Number_of_vertices n vlastnost p1 p2
                       uhel_pro_text lom_jmeno_bloku alfa_1 alfa_2 pp2 pp1 pp3 STANICENI-START
                       )
	;nastaveni promennych
	(setq *old_error* *error*)(setq *error* *error_stanic_pline*)
  (setq old_cmdecho (getvar "cmdecho"))(setvar "cmdecho" 0)
  (setq olddimzin (getvar "dimzin"))(setvar "dimzin" 0)
  (setq oldattreq (getvar "attreq"))(setvar "attreq" 1)
  (setq oldattdia (getvar "attdia"))(setvar "attdia" 0)
  (command "_undo" "_G")
	
;*******************************************************
	(vl-load-com)
	
	(setq vybrana_entita (CAR (entsel)))
	(if (= vybrana_entita nil)
		(progn
			(print "Nic nevybráno - konèím...")
			(exit)
		)
	)
	(setq entlist (ENTGET vybrana_entita))
			
	(if (= (cdr (assoc 0 entlist)) "LWPOLYLINE")
    ;popis køivky
    (progn
         (setq Number_of_vertices (cdr (assoc 90 entlist))) ;poèet bodù køivky
			   (setq n 0)
			   (setq PointList nil)
      ;vytvoreni PointList (seznam bodu krivky)
         (while (/= (nth n entlist) nil)
				  (setq vlastnost (car (nth n entlist)))
				  (if (= vlastnost 10)
					 (setq PointList (append PointList (list (cdr(nth n entlist))))
					 );setq
				  );if
				  (setq n (+ n 1))
				 );while - PointList (seznam bodu krivky)

         
			   (setq n 1)

			   (c:klSET)
			   ;(setq lom_jmeno_bloku (getstring "Zmeno bloku [LOM]: "))
         ;(if (= lom_jmeno_bloku "")(setq lom_jmeno_bloku "LOM"))
			
         ;(setq staniceni_celkem (getreal "zadej pocatecni staniceni [km]: "))
         (setq STANICENI-START LOM_STANICENI)
         (setq staniceni_celkem STANICENI-START)
			
         ;popis prvniho staniceni
         (setq p1 (nth (- n 1) PointList))
				 (setq p2 (nth n PointList))

				 (setq pp2 (vlax-curve-getPointAtParam vybrana_entita 0.01))
			
         (setq uhel_pro_text (angtos (- (angle p1 pp2) (/ pi 2))))
			
         ;prevod z m na km
			   (setq popis_lomu (rtos (/ staniceni_celkem 1000) 2 (getvar "luprec")))

         (if (= LOM_POPIS "")
					 (setq popis_lomu (strcat popis_lomu)) ;necisluje lomy
				   (setq popis_lomu (strcat LOM_POPIS (rtos (- (+ n lom_cislo) 1) 2 0) " " popis_lomu)) ;cisluje lomy
				 );if
         ;vlozit blok - prvni staniceni
         (setq oldosmode (getvar "osmode"))
			   (setvar "osmode" 0)
			   (command "_-insert" lom_jmeno_bloku p1 "" "" uhel_pro_text popis_lomu)
				 (setvar "osmode" oldosmode)
      
      ;cyklus pro popsani - prochazi vsechny vrcholy a popisuje je
         (while (/= n Number_of_vertices)
				   (setq p1 (nth (- n 1) PointList));predchozi bod
				   (setq p2 (nth n PointList))      ;popisovany bod
           (setq p3 (nth (+ n 1) PointList));nasledujici bod
           (if (= p3 nil)(setq p3 p2))

					 ;nastaveni staniceni
           ;(setq deltaL (DISTANCE p1 p2))
           ;(setq staniceni_celkem (+ staniceni_celkem deltaL))
					 (setq staniceni_celkem (+ STANICENI-START (vlax-curve-getDistAtPoint vybrana_entita p2)))

					 

					 
					 ;POKUS - START***********************************************************************************
					 ;(princ uhel_pro_text)(princ ".....")(princ n) (princ ".....")
           (if (= (+ n 1) Number_of_vertices)
             ;posledni bod
             (progn
							 (setq pp1 (vlax-curve-getPointAtParam vybrana_entita (- n 0.01)))
							 (setq px p2)
               (setq uhel_pro_text (- (angle pp1 p2) (/ pi 2)))
							 (setq uhel_pro_text (angtos uhel_pro_text))

             );progn
             ;mezilehle body
						 (progn
							 (setq pp3 (vlax-curve-getPointAtParam vybrana_entita (+ n 0.01)))
							 (setq pp1 (vlax-curve-getPointAtParam vybrana_entita (- n 0.01)))
							 
							 (setq alfa_1 (angle pp1 p2))
							 (setq alfa_2 (angle p2 pp3))
							 
							 ;(if (= alfa_2 0)(setq alfa_2 (* 2 pi))) ; pokud je alfa_2 = 2*pi, tak se rovna i nule
							 
							 (setq uhel_pro_text (/ (+ alfa_1 alfa_2) 2))
							 (if (or
										 ;1-4
										 (and (>= alfa_1 0)
													(<= alfa_1 (* pi 0.5))
													(>= alfa_2 (* pi 1.5))
													(< alfa_2 (* pi 2))
											 );and
										 ;4-1
										 (and (>= alfa_1 (* pi 1.5))
													(< alfa_1 (* pi 2))
													(>= alfa_2 (* pi 0)); nikdy není rovno nule - viz výše
													(<= alfa_2 (* pi 0.5))
										 );and
										 ;4-2
										 (and (> alfa_1 (* pi 1.5))
													(< alfa_1 (* pi 2))
													(>= alfa_2 (* pi 0.5)) 
													(<= alfa_2 (* pi 1))
										 );and
									 );or
								 
								(setq uhel_pro_text (- uhel_pro_text (* pi 1.5))) 
								(setq uhel_pro_text (- uhel_pro_text (* pi 0.5)))
							 );if
						 
							 (setq uhel_pro_text (angtos uhel_pro_text))
							 
							);progn
						);if
					 
           ;POKUS - KONEC***********************************************************************************
					 
           (setq popis_lomu (rtos staniceni_celkem 2 2))
					 
           ;vlozit blok
           (setq oldosmode (getvar "osmode"))
				   (setvar "osmode" 0)
					 (setq popis_lomu (rtos (/ staniceni_celkem 1000) 2 (getvar "luprec")))
        
	         (if (= LOM_POPIS "")
						 (setq popis_lomu (strcat popis_lomu)) ;necisluje lomy
					   (setq popis_lomu (strcat LOM_POPIS (rtos (+ n lom_cislo) 2 0) " " popis_lomu)) ;cisluje lomy
					 );if
           ;(command "_-insert" lom_jmeno_bloku p2 "" "" uhel_pro_text popis_lomu)

	   (setvar "UCSFOLLOW" 0)
	   (command "_ucs" ""); pro vlozeni bloku nastavi USS na globalni
           (command "_-insert" lom_jmeno_bloku p2 "" "" uhel_pro_text popis_lomu)
	   (command "_ucs" "_p") ; vrati USS na predchozi

	   
	   (print (strcat "bod: " (rtos n 2 0)))
					 (setvar "osmode" oldosmode)
				   (setq n (+ n 1))
				);while
     );progn
    (print "Vybrana entita neni krivka")
	);if
			  
	;zpetne nastaveni
  (command "_undo" "_E")
  (setq *error* *old_error*)
  (setvar "cmdecho" old_cmdecho)
  (setvar "dimzin" olddimzin)
  (if (/= oldattreq nil)(setvar "attreq" oldattreq))
  (setvar "attdia" oldattdia)

	
  (print "Konec funkce....")
  (print)
);defun


;-------------------------------------
;ukaze staniceni na krivce - od KONCE krivky
(defun c:KL-ukaz_staniceni_na_krivce( / vybrana_entita p tot_len poloha_bodu vlaobj)

  (vl-load-com)
  
  (setq vybrana_entita (ssget "_:S" '((0 . "LWPOLYLINE"))))
 	;(setq vybrana_entita (CAR (entsel)))
	(if (/= vybrana_entita nil)
    (progn
	(setq vybrana_entita (ssname vybrana_entita 0))
        ;(command "_area" "_e" vybrana_entita)
        ;(setq tot_len (getvar "perimeter"))

        ;(setq tot_len (vlax-curve-getDistAtPoint vybrana_entita (vlax-curve-getEndPoint vybrana_entita)))

        (setq vlaobj (vlax-ename->vla-object vybrana_entita))
        ;(vlax-get en 'Length)
        (setq tot_len (vlax-get-property vlaobj 'Length))
	
        (setq p (getpoint "Klikni tam kde chces znat staniceni: "))
        
        (setq p (trans p 1 0))
        (setq poloha_bodu (vlax-curve-getDistAtPoint vybrana_entita p))
        (if (/= poloha_bodu nil)
					(progn
		        (print (strcat "Bod je:  " (rtos (- tot_len poloha_bodu) 2 2) " jednotek od `konce` krivky"))
						(print (strcat "Bod je:  " (rtos poloha_bodu 2 2) " jednotek od `zacatku` krivky"))
					);progn
          (print "Bod nelezi na krivce...")
        )
    );progn
		(progn
			(print "Nic nevybráno ...")

		);progn
	);if
  (print "Koncim...")
  (princ)
);defun
