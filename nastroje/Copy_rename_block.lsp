;=========================================================================
; Copy_rename_block.lsp
; (c) Copyright 2013 Lee Mac
; Prelozil Jakub Tomecko
; Verzia: beta
;
; Kopirovanie bloku s nastavenim noveho nazvu
;-------------------------------------------------------------------------

;;------------=={ Kopirovat/premenovat referenciu bloku }==-------------;;
;;                                                                      ;;
;;  Tento program umoznuje uzivatelovi kopirovat a/alebo premenovat     ;;
;;  odkaz na jeden blok v pracovnom vykrese. Program je mozne spustit   ;;
;;  prikazom "CB" na vytvorenie premenovanej kopie vybraneho bloku      ;;
;;  alebo "RB" na jednoduche premenovanie vybraneho bloku.              ;;
;;----------------------------------------------------------------------;;

(defun c:CB nil (LM:RenameBlockReference   t))
(defun c:RB nil (LM:RenameBlockReference nil))

(defun LM:RenameBlockReference ( cpy / *error* abc app dbc dbx def doc dxf new old prp src tmp vrs )

    (defun *error* ( msg )
        (if (and (= 'vla-object (type dbx)) (not (vlax-object-released-p dbx)))
            (vlax-release-object dbx)
        )
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nChyba: " msg))
        )
        (princ)
    )
    
    (while
        (progn
            (setvar 'errno 0)
            (setq src (car (entsel (strcat "\nVyberte block na " (if cpy "copy & " "") "premenovanie: "))))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nChyba, skss to znova.")
                )
                (   (= 'ename (type src))
                    (setq dxf (entget src))
                    (cond
                        (   (/= "INSERT" (cdr (assoc 0 dxf)))
                            (princ "\nProsim vyberte referenciu bloku.")
                        )
                        (   (= 4 (logand 4 (cdr (assoc 70 (tblsearch "layer" (cdr (assoc 8 dxf)))))))
                            (princ "\nVybrany block je v uzamknutej hladine.")
                        )
                    )
                )
            )
        )
    )
    (if (= 'ename (type src))
        (progn
            (setq app (vlax-get-acad-object)
                  doc (vla-get-activedocument app)
                  src (vlax-ename->vla-object src)
                  old (vlax-get-property src (if (vlax-property-available-p src 'effectivename) 'effectivename 'name))
                  tmp 0
            )
            (while (tblsearch "block" (setq def (strcat (vl-string-left-trim "*" old) "_" (itoa (setq tmp (1+ tmp)))))))
            (while
                (and (/= "" (setq new (getstring t (strcat "\nZadajte novy nazov bloku <" def ">: "))))
                    (or (not (snvalid new))
                        (tblsearch "block" new)
                    )
                )
                (princ "\nNazov bloku je nespravny alebo uz existuje.")
            )
            (if (= "" new)
                (setq new def)
            )
            (setq dbx
                (vl-catch-all-apply 'vla-getinterfaceobject
                    (list app
                        (if (< (setq vrs (atoi (getvar 'acadver))) 16)
                            "objectdbx.axdbdocument"
                            (strcat "objectdbx.axdbdocument." (itoa vrs))
                        )
                    )
                )
            )
            (if (or (null dbx) (vl-catch-all-error-p dbx))
                (princ "\nNeda sa vytvorit rozhranie s ObjectDBX.")
                (progn
                    (setq abc (vla-get-blocks doc)
                          dbc (vla-get-blocks dbx)
                    )
                    (vlax-invoke doc 'copyobjects (list (vla-item abc old)) dbc)
                    (if (wcmatch old "`**")
                        (vla-put-name (vla-item dbc (1- (vla-get-count dbc))) new)
                        (vla-put-name (vla-item dbc old) new)
                    )
                    (vlax-invoke dbx 'copyobjects (list (vla-item dbc new)) abc)
                    (vlax-release-object dbx)
                    (if cpy (setq src (vla-copy src)))
                    (if
                        (and
                            (vlax-property-available-p src 'isdynamicblock)
                            (= :vlax-true (vla-get-isdynamicblock src))
                        )
                        (progn
                            (setq prp (mapcar 'vla-get-value (vlax-invoke src 'getdynamicblockproperties)))
                            (vla-put-name src new)
                            (mapcar
                               '(lambda ( a b )
                                    (if (/= "ORIGIN" (strcase (vla-get-propertyname a)))
                                        (vla-put-value a b)
                                    )
                                )
                                (vlax-invoke src 'getdynamicblockproperties) prp
                            )
                        )
                        (vla-put-name src new)
                    )
                    (if (= :vlax-true (vla-get-isxref (setq def (vla-item (vla-get-blocks doc) new))))
                        (vla-reload def)
                    )
                    (if cpy (sssetfirst nil (ssadd (vlax-vla-object->ename src))))
                )
            )
        )
    )
    ;hlaska po skonceni programu
    (princ "\nBlock bol premenovany. ")
    (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nCopy_rename_block.lsp | " (JTmenuVersion) " | Lee Mac, Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;