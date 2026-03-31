;=========================================================================
; Polyline_export.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Program pre ulozenie udajov vytycenia do suboru CSV
;-------------------------------------------------------------------------

(defun C:JTPolylineExport ( / flag polylineInfoText dcl_id result
                             objectPolyline listOfCoordinates lengthOfCoordinates
                             cestaSuboru suborCSV
                             pocitadlo pocitadloX pocitadloY
                             suradnicaX suradnicaY suradnice
                             jtUcsOpt jtExportCS jtUcsName jtTmpUcsName jtNeedRestore
                             ptW ptOut
                           )

  ;; ------------------------------------------------------------
  ;; Vyber UCS
  ;; jtExportCS: 0 = export vo WCS, 1 = export v aktuálnom UCS
  ;; ------------------------------------------------------------
  (setq jtExportCS 1)          ; default: aktuálny UCS
  (setq jtNeedRestore nil)

  (initget "WCS Aktualny Nazvany")
  (setq jtUcsOpt (getkword "\nExportovat suradnice v [WCS/Aktualny] <Aktualny>: "))
  (if (null jtUcsOpt) (setq jtUcsOpt "Aktualny"))

  (cond
    ((= jtUcsOpt "WCS")
      (setq jtExportCS 0)
    )
    ((= jtUcsOpt "Aktualny")
      (setq jtExportCS 1)
    )
  )

  ;; ------------------------------------------------------------
  ;; POVODNY KOD
  ;; ------------------------------------------------------------

  ;nastavenie stavu na 4
  (setq flag 5)
  ;nastavenie polylineInfoText
  (setq polylineInfoText "")

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Polyline_export.dcl"))

  ;spustenie loopu
  (while (> flag 2)

    ;test existencie dialogu
    (if (not (new_dialog "Polyline_export" dcl_id))
      (exit)
    )

    ;nastavenie textu polylineInfoText
    (set_tile "polylineInfoText" polylineInfoText)

    ;definovanie tlacitla vybrat
    (action_tile "vybratPolyline"
      "(done_dialog 4)"
    )

    ;definovanie tlacidla cancel
    (action_tile "cancel"
      "(UkoncenieVytycenia)"
    )

    ;definovanie tlacidla ulozti
    (action_tile "ulozit"
      "(done_dialog 5)(setq result T)"
    )

    ;spustenie dialogu s nastavenim stavom
    (setq flag (start_dialog))

    ;ak je stav rovny 4 spusti sa tento script
    (if (= flag 4)
      (progn
        (setq objectPolyline (vlax-ename->vla-object (car (entsel "Vyberte Polylinu:"))))
        (setq listOfCoordinates (vlax-get objectPolyline 'coordinates))
        (setq lengthOfCoordinates (length listOfCoordinates))
        (setq polylineInfoText (strcat (rtos (/ lengthOfCoordinates 2) 2 0) " bodov" " / " (rtos lengthOfCoordinates 2 0) " suradnic YX"))
      )
    )

    ;ak je stav rovny 5 spusti sa tento script (zapisanie suradnic)
    (if (= flag 5)
      (progn
        (setq cestaSuboru (getfiled "Text File" "" "csv" 1))
        (setq suborCSV (close (open cestaSuboru "w")))
        (setq suborCSV (open cestaSuboru "a"))

        (write-line "sep=;" suborCSV)
        (write-line "X;Y" suborCSV)

        (setq pocitadlo 0)
        (setq pocitadloX 0)
        (setq pocitadloY 1)
        (while
          (< pocitadlo (/ lengthOfCoordinates 2))
          (progn
            ;; bod v "objektovych" suradniciach z Coordinates (berieme XY)
            (setq ptW (list (nth pocitadloX listOfCoordinates) (nth pocitadloY listOfCoordinates) 0.0))

            ;; ak uzivatel chce UCS, transformuj z WCS(0) do UCS(1)
            (setq ptOut (if (= jtExportCS 0) ptW (trans ptW 0 1)))

            ;; zachovavam tvoju logiku: -1 a poradie X;Y
            (setq suradnicaY (vl-string-subst "," "." (rtos (* (cadr ptOut) -1))))
            (setq suradnicaX (vl-string-subst "," "." (rtos (* (car  ptOut) -1))))
            (setq suradnice (strcat suradnicaX ";" suradnicaY))
            (write-line suradnice suborCSV)
          )
          (setq pocitadlo (1+ pocitadlo))
          (setq pocitadloX (+ pocitadloX 2))
          (setq pocitadloY (+ pocitadloY 2))
        )

        (setq polylineInfoText "Subor ulozeny.")
        (close suborCSV)
      )
    )
  )

  ;unload dialogu
  (unload_dialog dcl_id)

  (princ)
)


;funkcia tlacidla zatvorit
(defun UkoncenieVytycenia()
  (done_dialog)
  (setq result nil)
  (princ "\nUkoncenie vytycenia.\n")
  (exit)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nPolyline_export.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;










