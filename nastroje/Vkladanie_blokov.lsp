;=========================================================================
; Vkladanie_blokov.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.1
;-------------------------------------------------------------------------


(defun c:DPSmer ()
  (prompt "\nUrcite bod vlozenia znacky smeru:")
  (command "_insert" "DPSmer" "_S" (getvar "dimscale") "_R" 0)
)