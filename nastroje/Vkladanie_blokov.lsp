;=========================================================================
; Vkladanie_blokov.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.1
;-------------------------------------------------------------------------


(defun c:DPSmer ()
  (prompt "\nUrcite bod vlozenia znacky smeru:")
  (command "_insert" "DPSmer" pause (getvar "dimscale")(getvar "dimscale") 0 pause)
)