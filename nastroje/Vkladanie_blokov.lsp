;=========================================================================
; Vkladanie_blokov.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.1
;-------------------------------------------------------------------------


(defun c:DPSmer ()
  (prompt "\nUrcite bod vlozenia znacky smeru:")
  (command "_insert" "DPSmer" "_S" (getvar "dimscale") "_R" 0)
)

(defun c:DPSmer2 ()
  (prompt "\nUrcite bod vlozenia znacky smeru:")
  (command "_insert" "DPSmer2" "_S" (getvar "dimscale") "_R" 0)
)

(defun c:DPSeverka ()
  (prompt "\nUrcite bod vlozenia znacky smeru:")
  (command "_insert" "DPSmer" "_S" (getvar "dimscale") "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) )
)