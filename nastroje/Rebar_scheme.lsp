;=========================================================================
; Rebar_scheme.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.1
;-------------------------------------------------------------------------

(defun c:RS ()
  
  (setq RezimVystuze
    (getstring "\nZapnut rezim farebnej vystuze [Zapnut/Vypnut] <Zapnut>: ")
  )
    
  (if (or (= RezimVystuze "") (= RezimVystuze "Z") (= RezimVystuze "z"))
  (RezimVystuzeZapnuty)
    
    (if (or (= RezimVystuze "V") (= RezimVystuze "v"))
    (RezimVystuzeVypnuty)
      
    (princ "\nNeplatny vyber.")
    )
      
  )
  
(princ)
  
)

;zmena farby hladín pre výstuž pre pracovný režim
(defun RezimVystuzeZapnuty ()
  (setvar "cmdecho" 0)
  (command "_.layer" "_color" 181 "DP_Výstuž_06" "")
  (command "_.layer" "_color" 221 "DP_Výstuž_07" "")
  (command "_.layer" "_color" 11 "DP_Výstuž_08" "")
  (command "_.layer" "_color" 31 "DP_Výstuž_10" "")
  (command "_.layer" "_color" 51 "DP_Výstuž_12" "")
  (command "_.layer" "_color" 81 "DP_Výstuž_14" "")
  (command "_.layer" "_color" 121 "DP_Výstuž_16" "")
  (command "_.layer" "_color" 161 "DP_Výstuž_18" "")
  (command "_.layer" "_color" 201 "DP_Výstuž_20" "")
  (command "_.layer" "_color" 241 "DP_Výstuž_22" "")
  (command "_.layer" "_color" 21 "DP_Výstuž_25" "")
  (command "_.layer" "_color" 41 "DP_Výstuž_26" "")
  (command "_.layer" "_color" 61 "DP_Výstuž_28" "")
  (command "_.layer" "_color" 101 "DP_Výstuž_30" "")
  (command "_.layer" "_color" 141 "DP_Výstuž_32" "")
  (setvar "cmdecho" 1)
)

;zmena farby hladín pre výstuž pre finálny režim
(defun RezimVystuzeVypnuty ()
  (setvar "cmdecho" 0)
  (command "_.layer" "_color" 1 "DP_Výstuž_06" "")
  (command "_.layer" "_color" 2 "DP_Výstuž_07" "")
  (command "_.layer" "_color" 3 "DP_Výstuž_08" "")
  (command "_.layer" "_color" 4 "DP_Výstuž_10" "")
  (command "_.layer" "_color" 5 "DP_Výstuž_12" "")
  (command "_.layer" "_color" 6 "DP_Výstuž_14" "")
  (command "_.layer" "_color" 1 "DP_Výstuž_16" "")
  (command "_.layer" "_color" 2 "DP_Výstuž_18" "")
  (command "_.layer" "_color" 3 "DP_Výstuž_20" "")
  (command "_.layer" "_color" 4 "DP_Výstuž_22" "")
  (command "_.layer" "_color" 5 "DP_Výstuž_25" "")
  (command "_.layer" "_color" 6 "DP_Výstuž_26" "")
  (command "_.layer" "_color" 1 "DP_Výstuž_28" "")
  (command "_.layer" "_color" 2 "DP_Výstuž_30" "")
  (command "_.layer" "_color" 3 "DP_Výstuž_32" "")
  (setvar "cmdecho" 1)
)

