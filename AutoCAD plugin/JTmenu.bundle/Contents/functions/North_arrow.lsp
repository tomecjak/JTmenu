;=========================================================================
; North_arrow.lsp
; Create bu Jakub Tomecko
;
; Vlozenie severky podla UCS World
;-------------------------------------------------------------------------

;;---------------=={ Vlozenie severky podla UCS World }==---------------;;
;;                                                                      ;;
;;  Tento program umoznuje vlozit severu do modelu a jej automaticke    ;;
;;  natocenie na sever podla UCS World.                                 ;;
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
;;                    Hlavna funkcia vlozenia severky                   ;;
;;----------------------------------------------------------------------;;

(defun c:JTNorthArrow ()
  
  ;nastavenie hladiny
  (setq oldLayer (LayerSetting))
  
  ;nastavenie prepinaca jazyku blokov podla GlobalnaBlocksLanguage
  (if (= (getenv "GlobalnaBlocksLanguage") "SVK")
    ;splnena podmienka
    (setq blockType "SeverkaSVK")
      ;nesplnena podmienka
      (if (= (getenv "GlobalnaBlocksLanguage") "CZK")
      ;splnena podmienka
      (setq blockType "SeverkaCZK")
      ;nesplnena podmienka
      (setq blockType "SeverkaENG")
      )
  )
  
  (if (= (getenv "GlobalnaBlocksType") "JTmenu")
    ;prikaz na vlozenie blocku severky
    (progn
      (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
          (command "._insert" blockType "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) pause)
        
          (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
            (command "._insert" blockType "_S" (* (getvar "dimscale") 1) "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) pause)
          )
      )
      (princ "\nUrcite bod vlozenia znacky severky.")
    )
    ;prikaz na vlozenie blocku DPP_Severka DPPtools
    (progn
      (command "._-insert" "DPP_Severka" "_S" 1 "_R" (* 180.0 (/ (- 0.0 (angle '(0 0 0) (getvar 'UCSXDIR))) pi)) pause)
      (princ "Vlozeny symbol DPP_Severka!")
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
        "\nNorth_arrow.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;