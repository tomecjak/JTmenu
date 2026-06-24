;=========================================================================
; Coordinates_symbol.lsp
; Create by Jakub Tomecko
;
; Vlozenie blocku suradnic
;-------------------------------------------------------------------------

;;------------------=={ Vlozenie blocku suradnic }==--------------------;;
;;                                                                      ;;
;;  Tento program umoznuje vlozit block suradnic do autocadu. Suradnice ;;
;;  su autmaticky priradene a aktualizovane podla UCS World. Zdrojovy   ;;
;;  blok sa taha z priecinku "bloky". Pri vlozeni blocku sa automaticky ;;
;;  vytvori hladina, ktora sa zaradi do skupiny hladin                  ;;
;;  s nazvom "DP Layers".                                               ;;
;;----------------------------------------------------------------------;;

;;----------------------------------------------------------------------;;
;;                Vyhodnotenie GlovalnaHladinaBlokov                    ;;
;;----------------------------------------------------------------------;;

(defun LayerSetting ( / oldLayer VytvorenieHladinyPopisu rec lay found )
  (setq oldLayer (getvar "CLAYER"))
  (setq VytvorenieHladinyPopisu (getenv "GlobalnaHladinaBlokov"))
  (setq found nil)

  (cond
    ((= VytvorenieHladinyPopisu "Popis")
     (setq rec (tblnext "LAYER" T))
     (while (and rec (not found))
       (setq lay (cdr (assoc 2 rec)))
       (if (wcmatch (strcase lay) "*POPIS")
         (setq found lay)
       )
       (setq rec (tblnext "LAYER"))
     )
     (if found
       (setvar "CLAYER" found)
       (setvar "CLAYER" "0")
     )
    )

    ((= VytvorenieHladinyPopisu "0")
     (setvar "CLAYER" "0")
    )
  )

  oldLayer
)

;;----------------------------------------------------------------------;;
;;               Hlavna funkcia vlozenia bloku Suradnice                ;;
;;----------------------------------------------------------------------;;

;vlozenie bloku Suradnice
(defun c:JTCoordinates ()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;prikaz na vlozenie blocku suradnic
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku suradnic z JTmenu
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" "Suradnice" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) pause)
        (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
          (command "._insert" "Suradnice" "_S" (* (getvar "dimscale") 20) "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) pause)
        )
      )
    )
    ;prikaz na vlozenie blocku suradnic z DPPtools
    (progn
      (command "._insert" "Suradnice" "_S" 1 "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) pause)
      (princ)
    )
  )
      
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (setvar "CLAYER" oldLayer)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nCoordinates_symbol.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;