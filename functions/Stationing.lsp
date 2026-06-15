;=========================================================================
; Stationing.lsp
; Create by Lee Mac from https://www.lee-mac.com
; Edit by Jakub Tomecko
;
; Zobrazenie stanicenia na krivke od zaciatku a konca
; Uprava:
; - pamatanie posledneho pociatocneho stanicenia
; - moznost Kopirovat do schranky
;-------------------------------------------------------------------------


;;----------------------------------------------------------------------;;
;;                         Funkcia stanicenia                            ;;
;;----------------------------------------------------------------------;;

(defun c:JTStationing
  (
    / vybrana_entita p tot_len poloha_bodu vlaobj
      env_name env_val predvolene_stanicenie
      vstup pociatocne_stanicenie
      txt_pre_ukazanie txt_pre_zapis
      vyber_rezimu
  )

  ; definovanie chybovej hlasky v programe
  (defun *error* (errmsg)
    (princ)
    (princ "\nProgram Stationing.lsp sa ukoncil. ")
    (terpri)
    (if errmsg (prompt errmsg))
    (princ)
  )

  ;; nazov pre ulozenie poslednej hodnoty
  (setq env_name "JTStationing_Start")

  ;; nacitanie poslednej hodnoty, ak neexistuje tak 0
  (setq env_val (getenv env_name))
  (setq predvolene_stanicenie
    (if env_val
      (atof env_val)
      0.0
    )
  )

  ;; zadanie pociatocneho stanicenia s pamatou poslednej hodnoty
  (setq vstup
    (getstring
      (strcat
        "\nAke je pociatocne stanicenie? <"
        (JT:FormatNumber predvolene_stanicenie (getvar "luprec"))
        ">: "
      )
    )
  )

  (setq pociatocne_stanicenie
    (if (= vstup "")
      predvolene_stanicenie
      (atof vstup)
    )
  )

  ;; ulozenie poslednej zadanej hodnoty
  (setenv env_name (rtos pociatocne_stanicenie 2 16))

  (setq vybrana_entita (ssget "_:S" '((0 . "LWPOLYLINE"))))

  (if (/= vybrana_entita nil)
    (progn
      (setq vybrana_entita (ssname vybrana_entita 0))
      (setq vlaobj (vlax-ename->vla-object vybrana_entita))
      (setq tot_len (vlax-get-property vlaobj 'Length))

      (setq p (getpoint "\nKlikni tam, kde chces poznat stanicenie: "))
      (setq p (trans p 1 0))
      (setq poloha_bodu (vlax-curve-getDistAtPoint vybrana_entita p))

      (if (/= poloha_bodu nil)
        (progn
          ;; text pre ukazanie
          (setq txt_pre_ukazanie
            (strcat
              "Bod je: "
              (JT:FormatNumber (+ pociatocne_stanicenie poloha_bodu) (getvar "luprec"))
              " metrov od zaciatku stanicenia!"
            )
          )

          ;; text pre zapis
          (setq txt_pre_zapis
            (strcat
              "km "
              (JT:FormatNumber (/ (+ pociatocne_stanicenie poloha_bodu) 1000.0) 6)
            )
          )
          
          ;; text pre kopirovanie
          (setq txt_pre_kopirovanie
            (strcat
              (JT:FormatNumber (/ (+ pociatocne_stanicenie poloha_bodu) 1000.0) 6)
            )
          )

          ;; vyber rezimu
          (initget "Ukazat Zapisat Kopirovat")
          (setq vyber_rezimu
            (getkword
              "\nHodnotu ukazat, zapisat alebo kopirovat? [Ukazat/Zapisat/Kopirovat] <Ukazat>: "
            )
          )

          ;; predvolena moznost
          (if (null vyber_rezimu)
            (setq vyber_rezimu "Ukazat")
          )

          ;; vyhodnotenie rezimu
          (cond
            ((= vyber_rezimu "Ukazat")
              (print txt_pre_ukazanie)
            )

            ((= vyber_rezimu "Zapisat")
              (layoutfield
                (function
                  (lambda (objekt_pre_zapis)
                    (vla-put-textstring objekt_pre_zapis txt_pre_zapis)
                  )
                )
              )
            )

            ((= vyber_rezimu "Kopirovat")
              (if (JT:CopyToClipboard txt_pre_kopirovanie)
                (print (strcat "\nDo schranky bolo skopirovane: " txt_pre_kopirovanie))
                (print "\nText sa nepodarilo skopirovat do schranky.")
              )
            )
          )
        )
        (print "\nBod nelezi na krivke!")
      )
    )
    (print "\nNic nevybrate.")
  )
  (princ)
)



;;----------------------------------------------------------------------;;
;;        Pomocna funkcia pre kopirovanie textu do schranky             ;;
;;----------------------------------------------------------------------;;

(defun JT:CopyToClipboard (txt / html result)
  (setq result nil)
  (if
    (and
      (= (type txt) 'STR)
      (not
        (vl-catch-all-error-p
          (setq html (vl-catch-all-apply 'vlax-create-object (list "htmlfile")))
        )
      )
    )
    (progn
      (setq result
        (not
          (vl-catch-all-error-p
            (vl-catch-all-apply
              'vlax-invoke
              (list
                (vlax-get
                  (vlax-get html 'ParentWindow)
                  'ClipBoardData
                )
                'SetData
                "Text"
                txt
              )
            )
          )
        )
      )
      (vlax-release-object html)
    )
  )
  result
)


;;----------------------------------------------------------------------;;
;;     Pomocne funkcia pre pridanie medzier v cisle po tisickach        ;;
;;----------------------------------------------------------------------;;

(defun JT:FormatNumber (value prec / s sign pos int frac len out count ch
                              lenf frac-out c)

  (setq s    (rtos value 2 prec)
        ch   " "
        sign ""
  )

  ;; znamienko
  (if (= (substr s 1 1) "-")
    (progn
      (setq sign "-")
      (setq s (substr s 2))
    )
  )

  ;; oddelenie celej a desatinnej casti
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

  ;; formatovanie celej casti
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

  ;; formatovanie desatinnej casti
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

  ;; zlozenie vysledku – desatinna ciarka
  (if (> (strlen frac) 0)
    (strcat sign out "," frac)
    (strcat sign out)
  )
)


;;----------------------------------------------------------------------;;
;;      Pomocne funkcie pre zapis stringu do textu/blocku [Lee-Mac]     ;;
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
        (progn
          (setvar 'errno 0)
          (setq ent (nentsel "\nSelect text or attribute: "))
          (cond
            ((= 7 (getvar 'errno))
              (princ "\nMissed, try again.")
            )
            ((null ent) nil)
            ((or (< 2 (length ent))
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
    (if (and (vlax-property-available-p objekt_pre_zapis 'islayout)
             (= :vlax-true (vla-get-islayout objekt_pre_zapis)))
        (vla-get-layout objekt_pre_zapis)
        (layoutfield:layout (LM:owner objekt_pre_zapis))
    )
)


;; Owner - Lee Mac
;; A wrapper for the objectidtoobject method & ownerid property to enable
;; compatibility with 32-bit & 64-bit systems

(defun LM:owner ( objekt_pre_zapis )
    (eval
        (list 'defun 'LM:owner '( objekt_pre_zapis )
            (if (vlax-method-applicable-p objekt_pre_zapis 'ownerid32)
                (list 'vla-objectidtoobject32 (LM:acdoc) '(vla-get-ownerid32 objekt_pre_zapis))
                (list 'vla-objectidtoobject   (LM:acdoc) '(vla-get-ownerid objekt_pre_zapis))
            )
        )
    )
    (LM:owner objekt_pre_zapis)
)


;; ObjectID - Lee Mac
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


;; Start Undo - Lee Mac
;; Opens an Undo Group.

(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)


;; End Undo - Lee Mac
;; Closes an Undo Group.

(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)


;; Active Document - Lee Mac
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
;;                              End of File                              ;;
;;----------------------------------------------------------------------;;