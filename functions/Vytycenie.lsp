;=========================================================================
; Vytycenie.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Program pre ulozenie udajov vytycenia do suboru CSV
;-------------------------------------------------------------------------

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
    
    ;nastavenie textu polylineInfoText
    (set_tile "polylineInfoText" polylineInfoText)
    
    ;definovanie tlacitla vybrat
    (action_tile "vybratPolyline"
      "(done_dialog 4)"
    )
    
    ;definovanie tlacidla cancel
    (action_tile "cancel"
      "(UkoncenieVytycenia)"
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
        (setq objectPolyline (vlax-ename->vla-object (car (entsel "Vyberte Polylinu:"))))
        (setq listOfCoordinates (vlax-get objectPolyline 'coordinates))
        (setq lengthOfCoordinates (length listOfCoordinates))
        (setq polylineInfoText (strcat (rtos (/ lengthOfCoordinates 2) 2 0) " bodov" " / " (rtos lengthOfCoordinates 2 0) " suradnic YX"))
      )
    )
    
    ;ak je stav rovny 5 spusti sa tento script (zapisanie suradnic)
    (if (= flag 5)
    (progn
     (setq cestaSuboru (getfiled "Text File" "" "csv" 1)) 
      (setq suborCSV (close (open cestaSuboru "w")))
      (setq suborCSV (open cestaSuboru "a"))

      (write-line "sep=;" suborCSV)
      (write-line "X;Y" suborCSV)
      
      (setq pocitadlo 0)
      (setq pocitadloX 0)
      (setq pocitadloY 1)
      (while
      (< pocitadlo (/ lengthOfCoordinates 2))
      (progn
        
      (setq suradnicaY (vl-string-subst "," "." (rtos (* (nth pocitadloY listOfCoordinates) -1))))
      (setq suradnicaX (vl-string-subst "," "." (rtos (* (nth pocitadloX listOfCoordinates) -1))))
      (setq suradnice (strcat suradnicaX ";" suradnicaY))
      (write-line suradnice suborCSV)

      )
      (setq pocitadlo (1+ pocitadlo))
      (setq pocitadloX (+ pocitadloX 2))
      (setq pocitadloY (+ pocitadloY 2))
      )
      
      (setq polylineInfoText "Subor ulozeny.")
    )
    )
  )
  
  ;unload dialogu
  (unload_dialog dcl_id)
   
  (princ)

)

;funkcia tlacidla zatvorit
(defun UkoncenieVytycenia()
  (done_dialog)
  (setq result nil)
  (princ "\nUkoncenie vytycenia.\n")
  (exit)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nVytycenie.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;










