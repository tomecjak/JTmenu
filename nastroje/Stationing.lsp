;=========================================================================
; Stationing.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
;
; Zobrazenie stanicenia na krivke od zaciatku a konca
;-------------------------------------------------------------------------

;;--------------------------=={ Stanicenie }==--------------------------;;
;;                                                                      ;;
;;  Program pre meranie stanicenia na krive od zaciatku a od konca.     ;;
;;----------------------------------------------------------------------;;

(defun c:Stationing( / vybrana_entita p tot_len poloha_bodu vlaobj)
  
  ;definovanie chybovej hlasky v programe
  (defun *error* (errmsg)
    (princ)
    (princ "\nProgram Stationing.lsp sa ukončil. ")
    (terpri)
    (prompt errmsg)
    (princ)
  )
  
  (setq vybrana_entita (ssget "_:S" '((0 . "LWPOLYLINE"))))

	(if (/= vybrana_entita nil)
    (progn
	(setq vybrana_entita (ssname vybrana_entita 0))

        (setq vlaobj (vlax-ename->vla-object vybrana_entita))

        (setq tot_len (vlax-get-property vlaobj 'Length))
	
        (setq p (getpoint "Klikni tam, kde chceš poznať staničenie: "))
        
        (setq p (trans p 1 0))
        (setq poloha_bodu (vlax-curve-getDistAtPoint vybrana_entita p))
        (if (/= poloha_bodu nil)
					(progn
		        (print (strcat "Bod je:  " (rtos (- tot_len poloha_bodu) 2 (getvar "luprec")) " jednotiek od konca krivky"))
						(print (strcat "Bod je:  " (rtos poloha_bodu 2 (getvar "luprec")) " jednotiek od začiatku krivky"))
					)
          (print "Bod neleží na krivke!")
        )
    )
		(progn
			(print "Nič nevybraté.")

		)
	)
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\nStationing.lsp | beta | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
