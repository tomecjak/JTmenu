(defun C:JTVytycenie()

  ;nastavenie stavu na 4
  (setq flag 5)
  ;nastavenie polylineInfoText
  (setq polylineInfoText "")

  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Vytycenie.dcl"))
  
  ;spustenie loopu
  (while (> flag 2)
  
    ;test existencie dialogu
    (if (not (new_dialog "Vytycenie" dcl_id))
      (exit)
    )
    
    (set_tile "polylineInfoText" polylineInfoText)
    
    ;definovanie tlacitla vybrat
    (action_tile "vybratPolyline"
      "(done_dialog 4)"
    )
    
    ;definovanie tlacidla cancel
    (action_tile "cancel"
      "(done_dialog)(setq result nil)(exit)"
    )
    
    ;definovanie tlacidla ulozti
    (action_tile "ulozit"
      "(done_dialog 5)(setq result T)"
    )
    
    ;spustenie dialogu s nastavenim stavom
    (setq flag (start_dialog))
    
    ;ak je stav rovny 4 spusti sa tento script
    (if (= flag 4)
      (progn
        (setq objectPolyline (vlax-ename->vla-object (car (entsel "Vyberte Polyline!"))))
        (setq listOfCoordinates (vlax-get objectPolyline 'coordinates))
        (setq lengthOfCoordinates (length listOfCoordinates))
        (setq polylineInfoText (strcat (rtos (/ lengthOfCoordinates 2) 2 0) " bodov" " / " (rtos lengthOfCoordinates 2 0) " suradnic YX"))
      )
    )
    

    ;(princ listOfCoordinates)
    (if (= flag 5)
    (progn
     (setq cestaSuboru (getfiled "Text File" "" "csv" 1)) 
      (setq suborCSV (close (open cestaSuboru "w")))
      (setq suborCSV (open cestaSuboru "a"))
  
      (write-line "Y,X" suborCSV)
      
      (setq pocitadlo 0)
      (setq pocitadloX 0)
      (setq pocitadloY 1)
      (while
      (< pocitadlo (/ lengthOfCoordinates 2))
      (progn
        
      (setq suradnicaX (rtos (nth pocitadloX listOfCoordinates)))
      (setq suradnicaY (rtos (nth pocitadloY listOfCoordinates)))
      (setq suradnice (strcat suradnicaX "," suradnicaY))
      (write-line suradnice suborCSV)

      )
      (setq pocitadlo (1+ pocitadlo))
      (setq pocitadloX (+ pocitadloX 2))
      (setq pocitadloY (+ pocitadloY 2))
      )
    )
    )
  )
  
  ;unload dialogu
  (unload_dialog dcl_id)
   
  (princ)

)











