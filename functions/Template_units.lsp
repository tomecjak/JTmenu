;=========================================================================
; Template_units.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Vytvorenie....
;-------------------------------------------------------------------------

;definovanie funkcie prikazu "JTTemplateUnits"
(defun c:JTTemplateUnits()
  
  ;nastavenie jednotiek v modeli
  ;nastavenie length type na decimal
  (setvar "LUNITS" 2) 
  ;nastavenie length precision na 3 desatine miesta
  (setvar "LUPREC" 3)
  ;nastavenie angle type na decimal degrees
  (setvar "AUNITS" 0)
  ;nastavenie anglte precision na 1 desatine miesto
  (setvar "AUPREC" 1)
  ;nastavenie angle na counterclockwise
  (setvar "ANGDIR" 0)
  ;nastavenie base angel
  (setvar "ANGBASE" 0)
  ;nastavenie jednotiek na metre
  (setvar "INSUNITS" 6)

  ;hlaska po skonceni programu
  (princ "\nVsetky jednotky boli nastavene.")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTemplate_units.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;