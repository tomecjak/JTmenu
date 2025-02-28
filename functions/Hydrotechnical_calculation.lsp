;=========================================================================
; Hydrotechnical_calculation.lsp
; Create by Jakub Tomecko
;
; Hydrotechnicky vypocet kapacity koryta
;-------------------------------------------------------------------------

(defun c:JTHydrotechnical ()

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Hydrotechnical_calculation.dcl"))

  ;test existencie dialogu
  (if (not (new_dialog "Hydrotechnical_calculation" dcl_id))
    (exit)
  )
  
  ;definovanie tlacidla cancel
  (action_tile "cancel"
    "(UkoncenieHydrotechnicalCalculation)"
  )
  
  ;definovanie tlacidla vypocitaj
  (action_tile "vypocitaj"
    "(VypocetHydrotechnicalCalculation)"
  )
  
  ;definovanie tlacidla report
  (action_tile "report"
    "(ReportHydrotechnicalCalculation)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
 
  (princ)

)