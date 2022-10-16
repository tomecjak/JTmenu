;=========================================================================
; Rebar_scheme.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
;
; Prepinanie farebnosti hladin vystuze
;-------------------------------------------------------------------------

;;-------------=={ Prepinanie farebnosti hladin vystuze }==-------------;;
;;                                                                      ;;
;;  Tento program umoznuje preponit farebnost hladin vystuze pre pracu  ;;
;;  a pre finalne pouzitie vo vykrese.                                  ;;
;;----------------------------------------------------------------------;;

(defun c:RS ()
  
  ;definovanie chybovej hlasky v programe
  (defun *error* (errmsg)
    (princ)
    (princ "\nProgram Rebar_scheme.lsp sa ukoncil. ")
    (terpri)
    (prompt errmsg)
    (princ)
  )
  
  ;nastavenie premenej RezimVystuze pre vyber zpnutia/vypnutia
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

;zmena farby hladin pre vystuz pre pracovny rezim
(defun RezimVystuzeZapnuty ()
  (setvar "cmdecho" 0)
  (command "_.layer" "_color" 181 "DP_Vystuz_06" "")
  (command "_.layer" "_color" 221 "DP_Vystuz_07" "")
  (command "_.layer" "_color" 11 "DP_Vystuz_08" "")
  (command "_.layer" "_color" 31 "DP_Vystuz_10" "")
  (command "_.layer" "_color" 51 "DP_Vystuz_12" "")
  (command "_.layer" "_color" 81 "DP_Vystuz_14" "")
  (command "_.layer" "_color" 121 "DP_Vystuz_16" "")
  (command "_.layer" "_color" 161 "DP_Vystuz_18" "")
  (command "_.layer" "_color" 201 "DP_Vystuz_20" "")
  (command "_.layer" "_color" 241 "DP_Vystuz_22" "")
  (command "_.layer" "_color" 21 "DP_Vystuz_25" "")
  (command "_.layer" "_color" 41 "DP_Vystuz_26" "")
  (command "_.layer" "_color" 61 "DP_Vystuz_28" "")
  (command "_.layer" "_color" 101 "DP_Vystuz_30" "")
  (command "_.layer" "_color" 141 "DP_Vystuz_32" "")
  (setvar "cmdecho" 1)
  ;hlaska po skonceni programu
  (princ "\nFarebna schema vystuze zapnuta. ")
)

;zmena farby hladin pre vystuz pre finalny rezim
(defun RezimVystuzeVypnuty ()
  (setvar "cmdecho" 0)
  (command "_.layer" "_color" 1 "DP_Vystuz_06" "")
  (command "_.layer" "_color" 2 "DP_Vystuz_07" "")
  (command "_.layer" "_color" 3 "DP_Vystuz_08" "")
  (command "_.layer" "_color" 4 "DP_Vystuz_10" "")
  (command "_.layer" "_color" 5 "DP_Vystuz_12" "")
  (command "_.layer" "_color" 6 "DP_Vystuz_14" "")
  (command "_.layer" "_color" 1 "DP_Vystuz_16" "")
  (command "_.layer" "_color" 2 "DP_Vystuz_18" "")
  (command "_.layer" "_color" 3 "DP_Vystuz_20" "")
  (command "_.layer" "_color" 4 "DP_Vystuz_22" "")
  (command "_.layer" "_color" 5 "DP_Vystuz_25" "")
  (command "_.layer" "_color" 6 "DP_Vystuz_26" "")
  (command "_.layer" "_color" 1 "DP_Vystuz_28" "")
  (command "_.layer" "_color" 2 "DP_Vystuz_30" "")
  (command "_.layer" "_color" 3 "DP_Vystuz_32" "")
  (setvar "cmdecho" 1)
  ;hlaska po skonceni programu
  (princ "\nFarebna schema vystuze vypnuta. ")
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\Rebar_scheme.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;

