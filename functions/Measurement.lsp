;=========================================================================
; Measurement.lsp
; Create by Jakub Tomecko
;
; Meranie dlzky, sirky, vysky a uhlu medzi dvomi bodmi
;-------------------------------------------------------------------------

(defun c:JTMeasurement ()
  (princ "Work in progress!")
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