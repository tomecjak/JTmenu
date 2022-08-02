;=========================================================================
; Reinforcement_anchoring.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.9 beta
;
; Vypocet dlzky presahu alebo kotvenia vystuze podla priemeru a betonu
;-------------------------------------------------------------------------

; Definicia premenej a deklarovanie premenych
(defun C:TEST_DCL ()

  ; Nacitanie dialogovho okna a nastavenie odkazu
  (setq dcl_id (load_dialog "Reinforcement_anchoring.dcl"))
  
  ; Nacitanie dialogu a overenie jeho existenie
  (if (not (new_dialog "Reinforcement_anchoring" dcl_id))
  
    ; Zatvorenie programu ak definicia dialogoveho okna neexistuje
    (exit)
    
  ) ; Koniec if
  
  ; Ak uzivatel vyberie dlazdicu, ktorej nazov je "accept" postupuj takto
  (action_tile "accept"
  
    ; Zatvorenie dialogu
    "(done_dialog)"
  
  )
  
  ; Zaciatok dialogu
  (start_dialog)
  ; Odnacitanie dialogu z pamate
  (unload_dialog dcl_id)
  
  (princ)
  
)

(princ)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\n:: Reinforcement_anchoring.lsp | Version 0.9 beta | Vyrobil: Jakub Tomecko "
        (menucmd "m=$(edtime,0,yyyy) ::")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;