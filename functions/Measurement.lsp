;=========================================================================
; Measurement.lsp
; Create by Jakub Tomecko
;
; Meranie dlzky, sirky, vysky a uhlu medzi dvomi bodmi
;-------------------------------------------------------------------------

(defun c:JTMeasurement ()
  
  ;vybratie prveho a druheho bodu
  (setq pointOne (getpoint "\n 1. bod merania"))
  (setq pointTwo (getpoint "\n 2. bod merania"))
  
  ;ziskanie suradnice X a Y z budov
  (setq pointOne_X (nth 0 pointOne))
  (setq pointOne_Y (nth 1 pointOne))
  (setq pointTwo_X (nth 0 pointTwo))
  (setq pointTwo_Y (nth 1 pointTwo))
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nMeasurement.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;