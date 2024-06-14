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
  
  ;vypocitanie sirky medzi bodmi
  (setq sirkaMedziBodmi (abs (- pointTwo_X pointOne_X)))
  
  ;vypocitanie vysky medzi bodmi
  (setq vyskaMedziBodmi (abs (- pointTwo_Y pointOne_Y)))
  
  ;vypocitanie vzdialenosti medzi bodmi
  (setq dlzkaMedziBodmi (distance pointOne pointTwo))
  
  ;vypocitanie sklonu medzi bodmi v percentach
  (setq sklonMedziBodmiPercenta (abs (* (/ vyskaMedziBodmi sirkaMedziBodmi) 100)))
  
  ;vypocitanie sklonu medzi bodmi v pomere
  (setq sklonMedziBodmiPomer (abs (/ sirkaMedziBodmi vyskaMedziBodmi)))
  
  ;vytvorenie popisku
  (princ (strcat "\nSirka: " (rtos sirkaMedziBodmi 2 (getvar "LUPREC")) " | Vyska: " (rtos vyskaMedziBodmi 2 (getvar "LUPREC")) " | Dlzka: " (rtos dlzkaMedziBodmi 2 (getvar "LUPREC")) " | Sklon: " (rtos sklonMedziBodmiPercenta 2 2) "% / 1:" (rtos sklonMedziBodmiPomer 2 1)))
  (princ)
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