;=========================================================================
; Rebar_layers_manager.lsp
; Create by Jakub Tomecko
;
; Sprava hladin vystuze - zoznam hladin <PREFIX>-B XX / <PREFIX>-BS XX
; s poctom prvkov v modeli, oznacenie prvkov vybranej hladiny,
; nastavenie aktualnej hladiny, vytvaranie novych hladin vystuze,
; vlozenie hladin od zadaneho cisla s posunom vyssich hladin
; a precislovanie celej rady od 1 po koniec.
;-------------------------------------------------------------------------

;;-------------=={ Sprava hladin vystuze }==----------------------------;;
;;                                                                      ;;
;;  Dialog zobrazi vsetky hladiny vystuze (-B) a spon (-BS) vo vykrese  ;;
;;  spolu s poctom objektov, ktore su v nich umiestnene v model space   ;;
;;  (spolu / bloky / polyliny) a s priemerom vystuze v hladine.         ;;
;;  Priemer sa berie z prepinaca viditelnosti "Priemer" na blokoch a    ;;
;;  z global width polylin; pri nezhode sa vypise "chyba".              ;;
;;  Vyberom riadku a tlacidlom "Oznacit prvky" (alebo dvojklikom) sa    ;;
;;  vsetky prvky danej hladiny oznacia a zobrazia (zoom object).        ;;
;;  Sucastou dialogu je aj vytvaranie novych hladin vystuze, a to bud   ;;
;;  za poslednu polozku (rovnaka logika ako prikaz JTRebarLayers),      ;;
;;  alebo od zadaneho cisla - vtedy sa existujuce hladiny s rovnakym    ;;
;;  a vyssim cislom precisluju o zadany pocet vyssie. Samostatne sa da  ;;
;;  cele cislovanie zvoleneho typu precislovat od 1 po koniec, cim sa   ;;
;;  zaplnia medzery po zmazanych polozkach.                             ;;
;;                                                                      ;;
;;  Cela praca dialogu je zabalena do jednej Undo skupiny, takze sa da  ;;
;;  vratit jednym prikazom U.                                           ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarLayerManager

  (/ *error* dcl_id data sel res renlog
     _fill _info _setcur _mode _madeText _create _renum _select)

  (vl-load-com)

  ;definovanie chybovej hlasky v programe
  (defun *error* (errmsg)
    (if (and dcl_id (> dcl_id 0)) (unload_dialog dcl_id))
    (setvar "cmdecho" 1)
    (LM:endundo (LM:acdoc))
    (if (and errmsg (not (wcmatch (strcase errmsg) "*BREAK,*CANCEL*,*EXIT*")))
      (princ (strcat "\nProgram Rebar_layers_manager.lsp sa ukoncil: " errmsg))
    )
    (princ)
  )

  ;;------------------------------------------------------------------;;
  ;;                     Pomocne funkcie dialogu                       ;;
  ;;------------------------------------------------------------------;;

  ;naplnenie zoznamu hladin, 'wanted' je nazov hladiny ktora sa ma predvybrat
  (defun _fill (wanted / i idx)
    (setq data (JT:RebarLayerList))

    ;hlavicka sa berie z kniznice, aby vzdy sedela so sirkami stlpcov riadkov
    (set_tile "hdr" (JT:RebarLayerHeader))

    (start_list "lay_list")
    (foreach x data (add_list (JT:RebarLayerRow x)))
    (end_list)

    ;najdenie indexu pozadovanej hladiny
    (setq idx nil i 0)
    (foreach x data
      (if (and (null idx) wanted (= (strcase (car x)) (strcase wanted)))
        (setq idx i)
      )
      (setq i (1+ i))
    )
    (if (and (null idx) data) (setq idx 0))

    (setq sel idx)
    (if idx (set_tile "lay_list" (itoa idx)))
    (_info nil)
  )

  ;vypis informacneho riadku pod zoznamom
  (defun _info (msg)
    (set_tile "info"
      (cond
        (msg msg)
        ((null data) "Vo vykrese nie su ziadne hladiny vystuze.")
        (T (strcat "Pocet hladin vystuze: " (itoa (length data))
                   " | Aktualna hladina: " (getvar "CLAYER")))
      )
    )
  )

  ;nastavenie vybranej hladiny ako aktualnej
  (defun _setcur ( / nm)
    (cond
      ((or (null sel) (null (nth sel data)))
        (_info "Najprv vyberte hladinu zo zoznamu.")
      )
      ((JT:LayerFrozen (setq nm (car (nth sel data))))
        (_info (strcat "Hladina " nm " je zmrazena - nemozno ju nastavit."))
      )
      (T
        (if (vl-catch-all-error-p
              (vl-catch-all-apply 'setvar (list "CLAYER" nm))
            )
          (_info (strcat "Hladinu " nm " sa nepodarilo nastavit."))
          (_info (strcat "Aktualna hladina je teraz: " nm))
        )
      )
    )
  )

  ;prepnutie rezimu cislovania - pole "od cisla" ma zmysel len v druhom rezime
  (defun _mode ( / odCisla)
    (setq odCisla (= "1" (get_tile "r_num")))
    (mode_tile "odcisla" (if odCisla 0 1))
    (if odCisla (mode_tile "odcisla" 2))
    (set_tile "hint"
      (if odCisla
        "Existujuce hladiny s rovnakym a vyssim cislom sa posunu o zadany pocet."
        "Nove hladiny sa pridaju za poslednu existujucu polozku."
      )
    )
  )

  ;strucny popis vytvorenych hladin do informacneho riadku
  (defun _madeText (made)
    (cond
      ((null made) "ziadna (uz existuju)")
      ((= 1 (length made)) (car made))
      (T (strcat (car made) " ... " (last made)))
    )
  )

  ;vytvorenie novych hladin vystuze priamo z dialogu
  (defun _create ( / tag pocet num r made renamed)
    (setq tag   (if (= "1" (get_tile "t_bs")) "BS" "B"))
    (setq pocet (atoi (get_tile "pocet")))
    (setq num   (atoi (get_tile "odcisla")))

    (cond
      ((<= pocet 0)
        (_info "Pocet hladin musi byt kladne cele cislo.")
      )

      ;rezim od zadaneho cisla - existujuce hladiny sa precisluju
      ((= "1" (get_tile "r_num"))
        (if (<= num 0)
          (_info "Zadajte cislo polozky, od ktoreho sa ma zacat.")
          (progn
            (setq r       (JT:RebarInsertLayers tag num pocet)
                  made    (car r)
                  renamed (cadr r)
            )

            ;zapis premenovani do logu, vypise sa po zatvoreni dialogu
            (foreach x renamed
              (setq renlog (cons (strcat (car x) " -> " (cdr x)) renlog))
            )

            (_fill (car made))
            (_info
              (strcat "Vytvorene hladiny: " (_madeText made)
                      " | posunutych hladin: " (itoa (length renamed))
              )
            )
          )
        )
      )

      ;rezim od poslednej polozky - nic sa neprecisluje
      (T
        (setq made (JT:RebarCreateLayers tag pocet))
        (_fill (car made))
        (_info (strcat "Vytvorene hladiny: " (_madeText made)))
      )
    )
  )

  ;precislovanie hladin zvoleneho typu od 1 po koniec (zaplnenie medzier)
  (defun _renum ( / tag cur renamed pair)
    (setq tag (if (= "1" (get_tile "t_bs")) "BS" "B"))

    ;zapamatanie vybranej hladiny, aby ostala vybrana aj po premenovani
    (setq cur (if (and sel (nth sel data)) (car (nth sel data))))

    (setq renamed (JT:RebarRenumberLayers tag))

    ;zapis premenovani do logu, vypise sa po zatvoreni dialogu
    (foreach x renamed
      (setq renlog (cons (strcat (car x) " -> " (cdr x)) renlog))
    )

    (if (and cur (setq pair (assoc cur renamed)))
      (setq cur (cdr pair))
    )

    (_fill cur)
    (_info
      (if renamed
        (strcat "Precislovanych hladin: " (itoa (length renamed)))
        "Cislovanie je uz suvisle, nic sa nezmenilo."
      )
    )
  )

  ;oznacenie a zobrazenie vsetkych prvkov vybranej hladiny (po zatvoreni dialogu)
  ;pozn.: (command ...) sa nesmie volat cez apply/vl-catch-all-apply, preto sa
  ;       ZOOM vola priamo a moznost jeho spustenia sa overi vopred
  (defun _select (nm / ss zoomOk)
    (setq ss (ssget "_X" (list (cons 8 nm) (cons 410 "Model"))))
    (cond
      ((null ss)
        (princ (strcat "\nV hladine " nm " nie su v modeli ziadne prvky."))
      )
      (T
        ;zoomovat na prvky modelu sa da len na karte Model alebo v plavajucom viewporte
        (setq zoomOk
          (or (= 1 (getvar "TILEMODE"))
              (/= 1 (getvar "CVPORT"))
          )
        )

        (if (not zoomOk)
          (princ "\nPozor: ste v papierovom priestore, zoom na prvky modelu sa nevykonal.")
        )

        ;ZOOM sa musi vykonat pred nastavenim vyberu, prikaz by pickfirst zrusil
        (if zoomOk
          (progn
            (setvar "cmdecho" 0)
            (command "_.ZOOM" "_Object" ss "")
            (setvar "cmdecho" 1)
          )
        )

        (sssetfirst nil ss)
        (princ
          (strcat "\nOznacenych " (itoa (sslength ss))
                  " prvkov v hladine " nm "."
          )
        )
      )
    )
  )

  ;;------------------------------------------------------------------;;
  ;;                        Nacitanie dialogu                          ;;
  ;;------------------------------------------------------------------;;

  (setq dcl_id (load_dialog "Rebar_layers_manager.dcl"))

  ;vsetky zmeny dialogu (vytvorenie a premenovanie hladin) tvoria jednu Undo skupinu
  (LM:startundo (LM:acdoc))

  (cond
    ((< dcl_id 0)
      (princ "\nSubor Rebar_layers_manager.dcl sa nenasiel!")
    )

    ((not (new_dialog "Rebar_layers_manager" dcl_id))
      (unload_dialog dcl_id)
      (princ "\nDialog Rebar_layers_manager sa nepodarilo otvorit!")
    )

    (T
      ;naplnenie zoznamu hladin a nastavenie rezimu cislovania
      (_fill nil)
      (_mode)

      ;vyber riadku v zozname (dvojklik = oznacenie prvkov)
      (action_tile "lay_list"
        "(setq sel (atoi $value)) (if (= $reason 4) (done_dialog 2) (_info nil))"
      )

      ;oznacenie prvkov vybranej hladiny
      (action_tile "accept"
        "(if sel (done_dialog 2) (_info \"Najprv vyberte hladinu zo zoznamu.\"))"
      )

      ;nastavenie vybranej hladiny ako aktualnej
      (action_tile "setcur" "(_setcur)")

      ;prepnutie rezimu cislovania novych hladin
      (action_tile "r_end" "(_mode)")
      (action_tile "r_num" "(_mode)")

      ;vytvorenie novych hladin (na koniec alebo od zadaneho cisla)
      (action_tile "create" "(_create)")

      ;precislovanie hladin zvoleneho typu od 1 po koniec
      (action_tile "renum" "(_renum)")

      ;obnovenie zoznamu a poctov prvkov
      (action_tile "refresh"
        "(_fill (if sel (car (nth sel data)))) (_info \"Zoznam bol obnoveny.\")"
      )

      ;zatvorenie dialogu
      (action_tile "cancel" "(done_dialog 0)")

      (setq res (start_dialog))
      (unload_dialog dcl_id)

      ;vypis premenovanych hladin do prikazoveho riadku
      (if renlog
        (progn
          (princ (strcat "\nPremenovanych hladin: " (itoa (length renlog))))
          (foreach s (reverse renlog) (princ (strcat "\n  " s)))
        )
      )

      ;po zatvoreni dialogu sa vykona oznacenie prvkov
      (if (and (= res 2) sel (nth sel data))
        (_select (car (nth sel data)))
      )
    )
  )

  (LM:endundo (LM:acdoc))

  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
  (strcat
    "\nRebar_layers_manager.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
    (menucmd "m=$(edtime,0,yyyy)")
  )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
