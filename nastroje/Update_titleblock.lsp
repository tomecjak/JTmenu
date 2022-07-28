;=========================================================================
; Update_titleblock.lsp
; (c) Copyright 2011 Lee Mac
; Prelozil Jakub Tomecko
; Verzia: 1.9
;
; Aktualizacia parametrov v blokoch napriec vykresmi (nie len titulnom)
;-------------------------------------------------------------------------

;;--------------------=={ Aktualizacia atributov }==--------------------;;
;;                                                                      ;;
;;  Precita subor CSV obsahujuci udaje atributov a ak sa nazov          ;;
;;  aktualneho vykresu objavi v prvom stlpci zoznamu vykresov CSV,      ;;
;;  program bude pokracovat v aktualizacii atributov bloku.             ;;
;;  Aktualizovane budu atributy zo znackami zodpovedajucimi hlavickam   ;;
;;  stlpcov CSV. Tieto budu aktualizovane hodnotami z riadku, v ktorom  ;;
;;  je uvedeny subor vykresu.
;;                                                                      ;;
;;  -------------------------------------                               ;;
;;  Priklad formatu suboru CSV                                          ;;
;;  -------------------------------------                               ;;
;;                                                                      ;;
;;  +------------+-----------+-----------+----------+-----+----------+  ;;
;;  |    DWG     |  Layout*  |   Block*  |   TAG1   | ... |   TAGN   |  ;;
;;  +------------+-----------+-----------+----------+-----+----------+  ;;
;;  |  Drawing1  |  Layout1  |   Block1  |  Value1  | ... |  ValueN  |  ;;
;;  +------------+-----------+-----------+----------+-----+----------+  ;;
;;  |  Drawing1  |  Layout2  |   Block1  |  Value1  | ... |  ValueN  |  ;;
;;  +------------+-----------+-----------+----------+-----+----------+  ;;
;;  |  Drawing2  |  Layout1  |   Block2  |  Value1  | ... |  ValueN  |  ;;
;;  +------------+-----------+-----------+----------+-----+----------+  ;;
;;  |    ...     |    ...    |    ...    |    ...   | ... |    ...   |  ;;
;;  +------------+-----------+-----------+----------+-----+----------+  ;;
;;                                                                      ;;
;;  *Layout & Nazov Bloku su volitelne parametre.                       ;;
;;                                                                      ;;
;;  -------------------------------------                               ;;
;;  Mezne varovania:                                                    ;;
;;  -------------------------------------                               ;;
;;  -  Bez filtra blokov alebo stlpca s nazvom bloku kod aktualizuje    ;;
;;     vsetky priradene bloky pomocou atributov uvedenych               ;;
;;     v hlavicke CSV.                                                  ;;
;;                                                                      ;;
;;  -  Momentalne navrhnutie na spusenie pri starte - pridat bud do     ;;
;;     Startup-Suite alebo ACADDOC.lsp aby sa aktualizovali bloky pri   ;;
;;     otvoreni vykresu. Ak chcete zakazat spusenie kodu pri nacitani   ;;
;;     odstrante (c:utb) zo spodnej casti kodu.                         ;;
;;                                                                      ;;
;;----------------------------------------------------------------------;;

(defun c:utb

    (
        /
        *error*
        ano
        bln bno
        csv
        ent
        flg fnb:fun
        inc
        lst
        sel str
        tag
        utb:blk utb:csv utb:ftr utb:lay
        val
    )

;;----------------------------------------------------------------------;;
;;  Umiestnenie zoznamu vykresov CSV (nastavene na nil, aby sa          ;;
;;  zobrazila vyzva).                                                   ;;
;;                                                                      ;;
;;  Ak sa subor CSV nachadza v ravnakom adresari ako vykres, vynechajte ;;
;;  cestu k suboru z umiestnanie suboru CSV a uvedte iba nazov suboru,  ;;
;;  napr.: "myfile.csv".                                                ;;
;;                                                                      ;;
;;  Ak je zadany iba nazov suboru, AutoCad najskor vyhlada tento subor  ;;
;;  v pracovnom adresari a az potom vyhlada "Support Paths".            ;;
;;----------------------------------------------------------------------;;
  
    (setq utb:csv nil) ;; napr.: (setq utb:csv "C:/myfolder/myfile.csv")

;;----------------------------------------------------------------------;;
;; Block Filter (moze pouzivat zastupne znaky a moze byt nil)           ;;
;;----------------------------------------------------------------------;;

    (setq utb:ftr nil)  ;; napr.: (setq utb:ftr "*BORDER")

;;----------------------------------------------------------------------;;
;; Layout Column (t alebo nil)                                          ;;
;;----------------------------------------------------------------------;;

    (setq utb:lay t)    ;; nastavte "t" ak CSV subor obsahuje Layout Column

;;----------------------------------------------------------------------;;
;; Block Name Column (t alebo n                                         ;;
;;----------------------------------------------------------------------;;

    (setq utb:blk nil)  ;; nastavte "t" ak CSV subor obsahuje Block Name Column

;;----------------------------------------------------------------------;;

    (defun *error* ( msg )
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nChyba: " msg))
        )
        (princ)
    )

    (setq fnb:fun
        (lambda ( s )
            (if (wcmatch (strcase s t) "*.dwg,*.dxf,*.dwt,*.dws")
                (vl-filename-base s) s
            )
        )
    )
    (cond
        (   (not (setq sel (ssget "_X" (vl-list* '(0 . "INSERT") '(66 . 1) (if utb:ftr (list (cons 2 (strcat "`*U*," utb:ftr))))))))
            (princ "\nVy vykrese sa nanasli ziadne priradene bloky.")
        )
        (   (and utb:csv (not (setq csv (findfile utb:csv))))
            (princ
                (strcat
                    "\n"
                    (vl-filename-base utb:csv)
                    (vl-filename-extension utb:csv)
                    " nenajdene."
                )
            )
        )
        (   (and csv (/= ".CSV" (strcase (vl-filename-extension csv))))
            (princ "\nSubor s udajmi atributov musi byt vo formate CSV.")
        )
        (   (not (or csv (setq csv (getfiled "Vyberte CSV subor" "" "csv" 16))))
            (princ "\n*Cancel*")
        )
        (   (not (setq lst (mapcar '(lambda ( x ) (cons (strcase (fnb:fun (car x))) (cdr x))) (LM:readcsv csv))))
            (princ
                (strcat
                    "\nZiadne data sa nenasli v "
                    (vl-filename-base csv)
                    ".csv subore."
                )
            )
        )
        (   (not
                (setq tag (mapcar 'strcase (cdar lst))
                      lst (LM:massoc (strcase (fnb:fun (getvar 'dwgname))) lst)
                )
            )
            (princ (strcat "\n" (fnb:fun (getvar 'dwgname)) " nenasiel sa v prvom sltpci suboru CSV."))
        )
        (   t
            (setq lst (mapcar '(lambda ( x ) (mapcar 'cons tag x)) lst)
                  ano 0
                  bno 0
            )
            (LM:startundo (LM:acdoc))
            (repeat (setq inc (sslength sel))
                (setq ent (ssname sel (setq inc (1- inc)))
                      bln (strcase (LM:al-effectivename ent))
                      val lst
                      flg nil
                )
                (if (or (null utb:ftr) (wcmatch bln (strcase utb:ftr)))
                    (progn
                        (if utb:lay
                            (setq val (mapcar '(lambda ( x ) (cons (strcase (cdar x)) (cdr x))) val)
                                  val (LM:massoc (strcase (cdr (assoc 410 (entget ent)))) val)
                            )
                        )
                        (if utb:blk
                            (setq val (mapcar '(lambda ( x ) (cons (strcase (cdar x)) (cdr x))) val)
                                  val (cdr (assoc bln val))
                            )
                            (setq val (car val))
                        )
                        (if val
                            (foreach att (vlax-invoke (vlax-ename->vla-object ent) 'getattributes)
                                (if
                                    (and
                                        (setq str (assoc (strcase (vla-get-tagstring att)) val))
                                        (progn
                                            (setq val (LM:remove1st str val))
                                            (/= (vla-get-textstring att) (cdr str))
                                        )
                                    )
                                    (progn
                                        (vla-put-textstring att (cdr str))
                                        (setq flg t
                                              ano (1+ ano)
                                        )
                                    )
                                )
                            )
                        )
                        (if flg (setq bno (1+ bno)))
                    )
                )
            )
            (if (zerop ano)
                (princ "\nVsetky atributy su aktualne.")
                (princ
                    (strcat
                        "\n"           (itoa ano) " attribute" (if (= 1 ano) "" "s")
                        " updated in " (itoa bno) " block"     (if (= 1 bno) "" "s") "."
                    )
                )
            )
            (LM:endundo (LM:acdoc))
        )
    )
    (princ)
)

;; Effective Block Name  -  Lee Mac
;; ent - [ent] Block Reference entity

(defun LM:al-effectivename ( ent / blk rep )
    (if (wcmatch (setq blk (cdr (assoc 2 (entget ent)))) "`**")
        (if
            (and
                (setq rep
                    (cdadr
                        (assoc -3
                            (entget
                                (cdr
                                    (assoc 330
                                        (entget
                                            (tblobjname "block" blk)
                                        )
                                    )
                                )
                               '("AcDbBlockRepBTag")
                            )
                        )
                    )
                )
                (setq rep (handent (cdr (assoc 1005 rep))))
            )
            (setq blk (cdr (assoc 2 (entget rep))))
        )
    )
    blk
)

;; Precitanie CSV  -  Lee Mac
;; Analyzuje subor CSV do maticoveho zoznamu hodnot buniek.
;; csv - [str] nazov suboru CSV na citanie
 
(defun LM:readcsv ( csv / des lst sep str )
    (if (setq des (open csv "r"))
        (progn
            (setq sep (cond ((vl-registry-read "HKEY_CURRENT_USER\\Control Panel\\International" "sList")) (",")))
            (while (setq str (read-line des))
                (setq lst (cons (LM:csv->lst str sep 0) lst))
            )
            (close des)
        )
    )
    (reverse lst)
)

;; CSV -> List  -  Lee Mac
;; Analyzuje riadok zo suboru CSV do zoznamu hodnot buniek.
;; str - [str] retazec nacitany zo suboru CSV
;; sep - [str] token odelovaca CSV
;; pos - [int] index pociatocnej polohy (vzdy nula)
 
(defun LM:csv->lst ( str sep pos / s )
    (cond
        (   (not (setq pos (vl-string-search sep str pos)))
            (if (wcmatch str "\"*\"")
                (list (LM:csv-replacequotes (substr str 2 (- (strlen str) 2))))
                (list str)
            )
        )
        (   (or (wcmatch (setq s (substr str 1 pos)) "\"*[~\"]")
                (and (wcmatch s "~*[~\"]*") (= 1 (logand 1 pos)))
            )
            (LM:csv->lst str sep (+ pos 2))
        )
        (   (wcmatch s "\"*\"")
            (cons
                (LM:csv-replacequotes (substr str 2 (- pos 2)))
                (LM:csv->lst (substr str (+ pos 2)) sep 0)
            )
        )
        (   (cons s (LM:csv->lst (substr str (+ pos 2)) sep 0)))
    )
)

(defun LM:csv-replacequotes ( str / pos )
    (setq pos 0)
    (while (setq pos (vl-string-search  "\"\"" str pos))
        (setq str (vl-string-subst "\"" "\"\"" str pos)
              pos (1+ pos)
        )
    )
    str
)

;; MAssoc  -  Lee Mac
;; Vrati vsetky asociacie kluca v zozname asociacii.

(defun LM:massoc ( key lst / item )
    (if (setq item (assoc key lst))
        (cons (cdr item) (LM:massoc key (cdr (member item lst))))
    )
)

;; Remove 1st  -  Lee Mac
;; Odstrani prvy vyskyt polozky zo zonamu.

(defun LM:remove1st ( itm lst / f )
    (setq f equal)
    (vl-remove-if '(lambda ( a ) (if (f a itm) (setq f (lambda ( a b ) nil)))) lst)
)

;; Start Undo  -  Lee Mac
;; Otvori Undo Group.

(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Zatvori Undo Group.

(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;; Active Document  -  Lee Mac
;; Vrati objekty VLA Active Document

(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\n:: Update_titleblock.lsp | Version 1.9 | Vyrobil: Lee Mac "
        (menucmd "m=$(edtime,0,yyyy)")
        " Prelozil: Jakub Tomecko ::"
        "\n:: Zadajte \"utb\" na vyvolanie ::\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;

;; (c:utb) ;; Zakaz automatickeho spustania (zmazat/okomentovat)        ;;

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;