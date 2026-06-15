;; Pomocná funkcia – vráti hodnotu atribútu s daným TAG-om
(defun GetAttr (blk tag / e att val)
  (setq tag (strcase tag T)) ; porovnávame v upper-case
  (setq e blk
        val nil
  )
  (while (and (null val) (setq e (entnext e)))
    (setq att (entget e))
    (if (= (cdr (assoc 0 att)) "ATTRIB")
      (if (= tag (strcase (cdr (assoc 2 att)) T))
        (setq val (cdr (assoc 1 att)))
      )
    )
  )
  val
)

(defun c:ExportPopisVystuze ( / ss cnt blk
                               paramCislo paramPopis
                               priemer dlzka kusy
                               slashPos minusPos rest kusyPart
                               csvPath csvFile rows)

  (vl-load-com)

  ;; dialóg – užívateľ si vyberie / zadá CSV
  (setq csvPath
        (getfiled
          "Ulozit CSV subor"
          (strcat (getvar "DWGPREFIX") "PopisVystuze_export.csv")
          "csv"
          1
        )
  )

  (if (not csvPath)
    (progn
      (princ "\nZrusene uzivatelom.")
      (princ)
    )
    (progn
      ;; zoznam riadkov: (("Cislo" "Priemer" "Dlzka" "Kusy" "Popis") ...)
      (setq rows '())

      ;; výber blokov PopisVystuze
      (setq ss (ssget "_X" '((0 . "INSERT") (2 . "PopisVystuze"))))

      (if ss
        (progn
          (setq cnt 0)
          (while (< cnt (sslength ss))
            (setq blk (ssname ss cnt))

            ;; ziskaj hodnoty atribútov podľa TAGu
            ;; ak máš iné Tagy, zmeň "CISLO" a "POPIS" na svoje
            (setq paramCislo (GetAttr blk "CISLO"))
            (setq paramPopis (GetAttr blk "POPIS"))

            ;; defaulty
            (setq priemer ""
                  dlzka  ""
                  kusy   ""
            )

            ;; parsuj Popis: "14/5725-20ks"
            (if (and paramPopis (> (strlen paramPopis) 0))
              (progn
                ;; pozícia "/"
                (setq slashPos (vl-string-search "/" paramPopis))
                (if slashPos
                  (progn
                    ;; priemer = pred "/"
                    (setq priemer (substr paramPopis 1 slashPos))

                    ;; zvyšok za "/"
                    (setq rest (substr paramPopis (+ slashPos 2)))

                    ;; pozícia "-" v zbytku
                    (setq minusPos (vl-string-search "-" rest))
                    (if minusPos
                      (progn
                        ;; dlzka = pred "-"
                        (setq dlzka (substr rest 1 minusPos))

                        ;; kusy + "ks" = za "-"
                        (setq kusyPart (substr rest (+ minusPos 2)))
                        (if kusyPart
                          (setq kusy (vl-string-right-trim "ks" kusyPart))
                        )
                      )
                    )
                  )
                )
              )
            )

            ;; pridaj riadok do zoznamu, nil -> ""
            (setq rows
                  (cons
                    (list
                      (if paramCislo paramCislo "")
                      priemer
                      dlzka
                      kusy
                      (if paramPopis paramPopis "")
                    )
                    rows
                  )
            )

            (setq cnt (1+ cnt))
          )

          ;; zotried podľa Cislo vzostupne (numericky)
          (setq rows
                (vl-sort
                  rows
                  (function
                    (lambda (a b)
                      (< (atoi (car a)) (atoi (car b)))
                    )
                  )
                )
          )

          ;; otvor CSV a zapíš
          (setq csvFile (open csvPath "w"))

          (if (not csvFile)
            (princ "\nNepodarilo sa otvorit CSV subor na zapis.")
            (progn
              ;; hlavička
              (write-line "Cislo;Priemer_mm;Dlzka_mm;Pocet_kusov;Popis" csvFile)

              ;; každá položka rows je '("Cislo" "Priemer" "Dlzka" "Kusy" "Popis")
              (foreach row rows
                (write-line
                  (strcat
                    (nth 0 row) ";"  ; Cislo
                    (nth 1 row) ";"  ; Priemer_mm
                    (nth 2 row) ";"  ; Dlzka_mm
                    (nth 3 row) ";"  ; Pocet_kusov
                    (nth 4 row)      ; Popis (original)
                  )
                  csvFile
                )
              )

              (close csvFile)
              (princ (strcat "\nCSV export ukonceny: " csvPath))
            )
          )
        )
        (princ "\nNenasli sa ziadne bloky 'PopisVystuze'.")
      )
    )
  )

  (princ)
)




(defun c:TestPopisTags ( / ss blk e att)
  (vl-load-com)

  (setq ss (ssget "_X" '((0 . "INSERT") (2 . "PopisVystuze"))))

  (if (and ss (> (sslength ss) 0))
    (progn
      (setq blk (ssname ss 0)) ; prvý nájdený blok
      (setq e blk)
      (while (setq e (entnext e))
        (setq att (entget e))
        (if (= (cdr (assoc 0 att)) "ATTRIB")
          (princ
            (strcat
              "\nTAG = "  (cdr (assoc 2 att))
              "    VALUE = " (cdr (assoc 1 att))
            )
          )
        )
      )
    )
    (princ "\nNenasiel sa ziadny blok PopisVystuze.")
  )
  (princ)
)