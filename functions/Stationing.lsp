;=========================================================================
; Stationing.lsp
; Create by Lee Mac from https://www.lee-mac.com
; Edit by Jakub Tomecko
;
; Zobrazenie stanicenia na krivke od zaciatku a konca
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                          Funkcia stanicenia                          ;;
;;----------------------------------------------------------------------;;

(defun c:JTStationing( / vybrana_entita p tot_len poloha_bodu vlaobj)
  
  ;definovanie chybovej hlasky v programe
  (defun *error* (errmsg)
    (princ)
    (princ "\nProgram Stationing.lsp sa ukoncil. ")
    (terpri)
    (prompt errmsg)
    (princ)
  )
  
  (setq pociatocne_stanicenie (atof (getstring "\nAke je pociatocne stanicenie? <0>: ")))
  
  (setq vybrana_entita (ssget "_:S" '((0 . "LWPOLYLINE"))))

	(if (/= vybrana_entita nil)
    (progn
	(setq vybrana_entita (ssname vybrana_entita 0))

        (setq vlaobj (vlax-ename->vla-object vybrana_entita))

        (setq tot_len (vlax-get-property vlaobj 'Length))
	
        (setq p (getpoint "Klikni tam, kde chces poznat stanicenie: "))
        
        (setq p (trans p 1 0))
        (setq poloha_bodu (vlax-curve-getDistAtPoint vybrana_entita p))
        (if (/= poloha_bodu nil)
					(progn
              ;vyber rezimu zobrazenia stanicenia
		          (setq vyber_rezimu
                (getstring "\nHodnotu ukazat alebo zapisat? [Ukazat/Zapisat] <Ukazat>: ")
              )
              ;vyhodnotenie rezimu zobrazenia stanicenia
              (if (or (= vyber_rezimu "") (= vyber_rezimu "U") (= vyber_rezimu "u"))
                ;do konzoly sa vypise stanicenie bodu
                (print (strcat "Bod je: " (JT:FormatNumber (+ pociatocne_stanicenie poloha_bodu) (getvar "luprec")) " metrov od zaciatku stanicenia!"))
                  (if (or (= vyber_rezimu "Z") (= vyber_rezimu "z"))
                    ;stanicenie sa zapise do blocku alebo textu
                    (progn
                      (layoutfield
                        '(lambda ( objekt_pre_zapis )
                          (vla-put-textstring objekt_pre_zapis (strcat "km " (JT:FormatNumber (/ (+ pociatocne_stanicenie poloha_bodu) 1000.0) 6)))
                        )               
                      ) 
                    )
                  )
              )
					)
          (print "Bod nelezi na krivke!")
        )
    )
		(progn
			(print "Nic nevybrate.")
		)
	)
  (princ)
)


;;----------------------------------------------------------------------;;
;;       Pomocne funkcia pre pridanie medzi v cisle po tisickach        ;;
;;----------------------------------------------------------------------;;

(defun JT:FormatNumber (value prec / s sign pos int frac len out count ch
                              lenf frac-out c)

  (setq s   (rtos value 2 prec) ; 2 = decimal
        ch  " "                 ; oddeľovač tisícok v celej časti
        sign ""
  )

  ;; znamienko
  (if (= (substr s 1 1) "-")
    (progn
      (setq sign "-")
      (setq s (substr s 2))
    )
  )

  ;; oddelenie celej a desatinnej časti
  (setq pos (vl-string-search "." s))
  (if pos
    (progn
      (setq int  (substr s 1 pos))
      (setq frac (substr s (+ pos 2)))
    )
    (progn
      (setq int  s)
      (setq frac "")
    )
  )

  ;; ----- formátovanie CELEJ časti (skupiny po 3 z prava) -----
  (setq len   (strlen int)
        out   ""
        count 0
  )
  (while (> len 0)
    (setq out   (strcat (substr int len 1) out)
          len   (1- len)
          count (1+ count)
    )
    (if (and (> len 0) (= (rem count 3) 0))
      (setq out (strcat ch out))
    )
  )

  ;; ----- formátovanie DESATINNEJ časti (skupiny po 3 z ľava) -----
  (if (> (strlen frac) 3)
    (progn
      (setq lenf     (strlen frac)
            frac-out ""
            count    0
      )
      (foreach c (vl-string->list frac)
        (setq frac-out (strcat frac-out (chr c))
              count    (1+ count)
        )
        (if (and (= (rem count 3) 0) (< count lenf))
          (setq frac-out (strcat frac-out " "))
        )
      )
      (setq frac frac-out)
    )
  )

  ;; zloženie výsledku – desatinná ČIARKA
  (if (> (strlen frac) 0)
    (strcat sign out "," frac)
    (strcat sign out)
  )
)

;;----------------------------------------------------------------------;;
;;     Pomocne funkcie pre zapis stringu to textu/blocku [Lee-Mac]      ;;
;;----------------------------------------------------------------------;;

(defun layoutfield ( fld / *error* ent )
    
    (defun *error* ( msg )
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
    
    (while
        (progn (setvar 'errno 0) (setq ent (nentsel "\nSelect text or attribute: "))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nMissed, try again.")
                )
                (   (null ent) nil)
                (   (or (< 2 (length ent))
                        (not (wcmatch (cdr (assoc 0 (entget (setq ent (car ent))))) "TEXT,MTEXT,ATTRIB"))
                    )
                    (princ "\nInvalid object selected.")
                )
            )
        )
    )
    (if ent
        (progn
            (LM:startundo (LM:acdoc))
            (apply fld (list (vlax-ename->vla-object ent)))
            (if (= "ATTRIB" (cdr (assoc 0 (entget ent))))
                (vla-regen (LM:acdoc) acactiveviewport)
            )
            (LM:endundo (LM:acdoc))
        )
    )
    (princ)
)
(defun layoutfield:layout ( objekt_pre_zapis )
    (if (and (vlax-property-available-p objekt_pre_zapis 'islayout) (= :vlax-true (vla-get-islayout objekt_pre_zapis)))
        (vla-get-layout objekt_pre_zapis)
        (layoutfield:layout (LM:owner objekt_pre_zapis))
    )
)

;; Owner -  Lee Mac
;; A wrapper for the objectidtoobject method & ownerid property to enable
;; compatibility with 32-bit & 64-bit systems
 
(defun LM:owner ( objekt_pre_zapis )
    (eval
        (list 'defun 'LM:owner '( objekt_pre_zapis )
            (if (vlax-method-applicable-p objekt_pre_zapis 'ownerid32)
                (list 'vla-objectidtoobject32 (LM:acdoc) '(vla-get-ownerid32 objekt_pre_zapis))
                (list 'vla-objectidtoobject   (LM:acdoc) '(vla-get-ownerid   objekt_pre_zapis))
            )
        )
    )
    (LM:owner objekt_pre_zapis)
)

;; ObjectID  -  Lee Mac
;; Returns a string containing the ObjectID of a supplied VLA-Object
;; Compatible with 32-bit & 64-bit systems
 
(defun LM:objectid ( objekt_pre_zapis )
    (eval
        (list 'defun 'LM:objectid '( objekt_pre_zapis )
            (if (vlax-method-applicable-p (vla-get-utility (LM:acdoc)) 'getobjectidstring)
                (list 'vla-getobjectidstring (vla-get-utility (LM:acdoc)) 'objekt_pre_zapis ':vlax-false)
               '(itoa (vla-get-objectid objekt_pre_zapis))
            )
        )
    )
    (LM:objectid objekt_pre_zapis)
)

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.

(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Closes an Undo Group.

(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object

(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nStationing.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;

