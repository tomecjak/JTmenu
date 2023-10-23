;=========================================================================
; Slope.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Vytvorenie ciary v sklone v % alebo pomere x:x
;-------------------------------------------------------------------------

(defun c:JTSlope ()

  ;vybratie pociatocneho bodu ciary
  (setq pointOne (getpoint "\n Prvy bod ciary:"))
  ;ziskanie suradnice X a Y pociatocneho bodu
  (setq pointOne_X (nth 0 pointOne))
  (setq pointOne_Y (nth 1 pointOne))

  ;zadanie dlzky ciary
  (setq length_X (getreal "\n Dlzka ciary:"))
  ;zadanie sklonu v % alebo v pomere x:x
  (setq slope (getstring "\n Sklon ciary:"))
  ;zistenie ci existuje ":" a ak ano ziskanie jeho polohy
  (setq slope_status (vl-string-search ":" slope))
  
  ;rozhodnutie ci sa pouzije pomer alebo %
  (if (= slope_status NIL)
  
    ;ak je podmienka splnena
    (progn
      ;vypocitanie vysky sklonu
      (setq length_Y (* (/ (atof slope) 100) (abs length_X)))
    )

    ;ak nie je podmienka splnena
    (progn
      ;ziskanie hodnoty pred ":"
      (setq slopeRatioLeft (substr slope 1 slope_status))
      (setq slopeRatioLeftEdit (/ (atof slopeRatioLeft) (abs (atof slopeRatioLeft))))
      ;ziskanie hodnoty za ":"
      (setq slopeRatioRight (substr slope (+ slope_status 2)))
      (setq slopeRatioRightEdit (abs (/ (atof slopeRatioRight) (atof slopeRatioLeft))))
      ;vypocitanie vysky sklonu
      (setq length_Y (/ (* (abs length_X) slopeRatioLeftEdit) slopeRatioRightEdit))
    )

  )
  
  ;vytvorenie suradnic koncoveho bodu ciary
  (setq pointTwo (list (+ pointOne_X length_X) (+ pointOne_Y length_Y)))
  ;vytvorenie ciary 
  (command "line" pointOne pointTwo "")
  (princ "Ciara v sklone vytvorena.")

)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nSlope.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;