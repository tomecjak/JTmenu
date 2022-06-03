;=========================================================================
; Vlozenie_kriziky.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.1
;-------------------------------------------------------------------------

(defun c:DPKriziky ()
  (prompt "\nUrcite bod vlozenia znacky smeru:")
  (command "_insert" "DPKriziky" "0,0" (getvar "dimscale")(getvar "dimscale") 0)
)