;=========================================================================
; Multileader_style.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Vytvorenie stylu multileadru
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;           Vytvorenie jednotlivych stylov multileadrov                ;;
;;----------------------------------------------------------------------;;

(defun c:JTMultileader()
  
  ;vytvorenie textoveho stylu DP_ISOCPEUR
  (TextStyleCreator)
  
  ;vyhodnotenie pouzitia stylu multileadru podla modu
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (MultileaderKlacickyMod)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (MultileaderMierkaMod)
    )
  )
  
  (princ "\nStyly multileadru boli vytvorene!")
  (princ)
)

;;----------------------------------------------------------------------;;
;;                         Multileader - klasicky                       ;;
;;----------------------------------------------------------------------;;

(defun MultileaderKlacickyMod ()
  (Multileader)
)

;;----------------------------------------------------------------------;;
;;                          Multileader - mierka                        ;;
;;----------------------------------------------------------------------;;

(defun MultileaderMierkaMod ()
  (MultileaderMierka)
)

;;----------------------------------------------------------------------;;
;;                          Multileader -                       ;;
;;----------------------------------------------------------------------;;

(defun Multileader ()

  (MultileaderCreator)
  
)

;;----------------------------------------------------------------------;;
;;                          Multileader mierka -                       ;;
;;----------------------------------------------------------------------;;

(defun MultileaderMierka ()

  (MultileaderCreator)
  
)

;;----------------------------------------------------------------------;;
;;             Pevne nastavenia pre vsetky multileadre                  ;;
;;----------------------------------------------------------------------;;

(defun MultileaderCreator ()
       
)

;;----------------------------------------------------------------------;;
;;              Vytvorenie textoveho stylu DP_ISOCPEUR                  ;;
;;----------------------------------------------------------------------;;

(defun TextStyleCreator ()
  (entmakex
  '(
    (0 . "STYLE")
    (100 . "AcDbSymbolTableRecord")
    (100 . "AcDbTextStyleTableRecord")
    (2 . "DP_ISOCPEUR")
    (70 . 0)
    (40 . 0.0);<- definovanie vysky textu
    (41 . 1.0)
    (50 . 0.0)
    (71 . 0)
    (42 . 2.0)
    (3 . "isocpeur.ttf")
    (4 . "")
  )
  )
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nMultileader_style.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;