;=========================================================================
; Rebar_scheme.lsp
; Create by Jakub Tomecko
;
; Prepinanie farebnosti hladin vystuze
;-------------------------------------------------------------------------

;;-------------=={ Prepinanie farebnosti hladin vystuze }==-------------;;
;;                                                                      ;;
;;  Tento program umoznuje preponit farebnost hladin vystuze pre pracu  ;;
;;  a pre finalne pouzitie vo vykrese.                                  ;;
;;----------------------------------------------------------------------;;

(defun c:JTRebarScheme ()
  
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
  (command "_.layer" "_color" 181 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_06") "")
  (command "_.layer" "_color" 221 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_07") "")
  (command "_.layer" "_color" 11 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_08") "")
  (command "_.layer" "_color" 31 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_10") "")
  (command "_.layer" "_color" 51 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_12") "")
  (command "_.layer" "_color" 81 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_14") "")
  (command "_.layer" "_color" 121 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_16") "")
  (command "_.layer" "_color" 161 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_18") "")
  (command "_.layer" "_color" 201 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_20") "")
  (command "_.layer" "_color" 241 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_22") "")
  (command "_.layer" "_color" 21 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_25") "")
  (command "_.layer" "_color" 41 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_26") "")
  (command "_.layer" "_color" 61 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_28") "")
  (command "_.layer" "_color" 101 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_30") "")
  (command "_.layer" "_color" 141 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_32") "")
  (setvar "cmdecho" 1)
  ;hlaska po skonceni programu
  (princ "\nFarebna schema vystuze zapnuta. ")
)

;zmena farby hladin pre vystuz pre finalny rezim
(defun RezimVystuzeVypnuty ()
  (setvar "cmdecho" 0)
  (command "_.layer" "_color" 1 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_06") "")
  (command "_.layer" "_color" 2 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_07") "")
  (command "_.layer" "_color" 3 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_08") "")
  (command "_.layer" "_color" 4 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_10") "")
  (command "_.layer" "_color" 5 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_12") "")
  (command "_.layer" "_color" 6 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_14") "")
  (command "_.layer" "_color" 1 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_16") "")
  (command "_.layer" "_color" 2 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_18") "")
  (command "_.layer" "_color" 3 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_20") "")
  (command "_.layer" "_color" 4 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_22") "")
  (command "_.layer" "_color" 5 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_25") "")
  (command "_.layer" "_color" 6 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_26") "")
  (command "_.layer" "_color" 1 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_28") "")
  (command "_.layer" "_color" 2 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_30") "")
  (command "_.layer" "_color" 3 (strcat (getenv "GlobalnaPrefixHladiny") "Vystuz_32") "")
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

