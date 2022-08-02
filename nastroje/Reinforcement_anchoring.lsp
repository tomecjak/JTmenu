;=========================================================================
; Reinforcement_anchoring.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.9 beta
;
; Vypocet dlzky presahu alebo kotvenia vystuze podla priemeru a betonu
;-------------------------------------------------------------------------

; Definicia premenej a deklarovanie premenych
(defun C:TEST_DCL ()
  
  ; Definovanie premenej listu hodnot tiedy betonu
  (setq NazvyTriedBetonu '("C12/15" "C16/20" "C20/25" "C25/30" "C30/37" "C35/45" "C40/50" "C45/55" "C50/60" "C60/75" "C70/85" "C80/95" "C90/105"))
  (setq NazvyParcialnychSucinitelov '("Trvale a docasne navrhove situacie" "Mimoriadne navrhove situacia"))
  
  ; Nacitanie dialogovho okna a nastavenie odkazu
  (setq dcl_id (load_dialog "Reinforcement_anchoring.dcl"))
  
  ; Nacitanie dialogu a overenie jeho existenie
  (if (not (new_dialog "Reinforcement_anchoring" dcl_id))
  
    ; Zatvorenie programu ak definicia dialogoveho okna neexistuje
    (exit)
    
  ) ; Koniec if
  
  ; Spustenie popup listu
  (start_list "ConcreteSelections")
  ; Naplnenie popup listu hodnotami
  (mapcar 'add_list NazvyTriedBetonu)
  ; Skoncenie popup listu
  (end_list)
  
  ; Spustenie popup listu
  (start_list "ParcialSelections")
  ; Naplnenie popup listu hodnotami
  (mapcar 'add_list NazvyParcialnychSucinitelov)
  ; Skoncenie popup listu
  (end_list)
  
  ; Ak uzivatel vyberie dlazdicu, ktorej nazov je "cancel" postupuj takto
  (action_tile "cancel"
    ; Zatvorenie dialogu a nastavnie flagu
    "(done_dialog) (setq TriedaBetonuClick nil) (setq ParcialnySucinitelClick nil)"
  )
  
  ; Ak uzivatel vyberie dlazdicu, ktorej nazov je "count" postupuj takto
  (action_tile "count"
    (strcat
      "(progn(setq TriedaBetonuVyber (atof (get_tile \"ConcreteSelections\")))" ; zisaknie vyberu listu
      " (setq TriedaBetonuClick T)" ; nastavenie flagu
    )
  )
  
  ; Zaciatok dialogu
  (start_dialog)
  ; Odnacitanie dialogu z pamate
  (unload_dialog dcl_id)
  
  ; kontrola ci vyber je v poriadku
  (if TriedaBetonuClick
    (progn
      (setq TriedaBetonuVyber (fix TriedaBetonuVyber)) ; konvertovanie na integer
      (setq TriedaBetonuVyber (nth TriedaBetonuVyber NazvyTriedBetonu)) ; ziskanie velkosti
    )
  )
  
   ; kontrola ci vyber je v poriadku
  (if ParcialnySucinitelClick
    (progn
      (setq ParcialnySucinitelVyber (fix ParcialnySucinitelVyber)) ; konvertovanie na integer
      (setq ParcialnySucinitelVyber (nth ParcialnySucinitelVyber NazvyParcialnychSucinitelov)) ; ziskanie velkosti
    )
  )
  
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