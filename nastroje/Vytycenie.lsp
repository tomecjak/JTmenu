(defun C:JTVytycenie()

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Vytycenie.dcl"))
  
  ;test existencie dialogu
  (if (not (new_dialog "Vytycenie" dcl_id))
    (exit)
  )
  
  ;definovanie tlacitla vybrat
  (action_tile "vybratPolyline"
    "()"
  )
  
  ;definovanie tlacidla cancel
  (action_tile "cancel"
    "(done_dialog)"
  )
  
  ;definovanie tlacidla ulozti
  (action_tile "ulozit"
    "()(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
  
  
  
  (princ)

)