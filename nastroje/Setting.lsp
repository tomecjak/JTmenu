;=========================================================================
; Setting.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
;
; Nastavenie pre JTmenu
;-------------------------------------------------------------------------

(defun C:JTsetting()
  
  ;vytvorenie premenej SettingMenu pre vyber polozky nastavenia
  (setq SettingMenu
    (getstring "\nCo chcete nastavit? [Hladinu blokov/Mierku blokov] <Hladinu blokov>: ")
  )
  
  ;vyhodnotenie vyberu nastavenia
  (if (or (= SettingMenu "") (= SettingMenu "H") (= SettingMenu "h"))
    ;nastavenie zmeny hladiny blokov
    (NastavenieHladinyBlokov)
  
    (if (or (= SettingMenu "M") (= SettingMenu "m"))
    ;nastavenie zmeny mierky blokov a kot
    (NastavenieDIMSCALE)
    (princ)
    )
  )

)

;;----------------------------------------------------------------------;;
;;                      Nastavenie hladiny blokov                       ;;
;;----------------------------------------------------------------------;;

(defun NastavenieHladinyBlokov()

  ;vytvorenie premenej VyberBlockHladina pre vyber hladiny pre vlozene bloky
  (setq VyberBlockHladina
    (getstring "\nV akej hladine chcete vkladat bloky? [DP_Popis/Nula] <DP_Popis>: ")
  )
  
  ;vyhodnotenie vyberu hladiny pre bloky
  (if (or (= VyberBlockHladina "") (= VyberBlockHladina "D") (= VyberBlockHladina "d"))
    ;nastavenie hladinu na DP_Popis
    (setenv "GlobalnaHladinaBlokov" "DP_Popis")
  
    (if (or (= VyberBlockHladina "N") (= VyberBlockHladina "n"))
    ;nastavenie hladinu na O
    (setenv "GlobalnaHladinaBlokov" "0")
    (princ)
    )
  )
  
  ;hlaska o nastavenej hladine vkladanych blokoch
  (princ (strcat "\nNastavily ste hladinu " (getenv "GlobalnaHladinaBlokov") " pre vkladane bloky!"))
  (princ)

)

;;----------------------------------------------------------------------;;
;;                      Nastavenie DIMSCALE                             ;;
;;----------------------------------------------------------------------;;

(defun NastavenieDIMSCALE()

  ;vytvorenie premenej VyberDIMSCALE pre vyber modu pre vlozene bloky a koty
  (setq VyberDIMSCALE
    (getstring "\nV ako mode chcete pouzivat bloky a koty? [Klacicky/Mierka] <Klasicky>: ")
  )
  
  ;vyhodnotenie vyberu modu pre bloky
  (if (or (= VyberDIMSCALE "") (= VyberDIMSCALE "K") (= VyberDIMSCALE "k"))
    ;nastavenie modu na Klasicky
    (setenv "GlobalnaDIMSCALEset" "Klasicky")
  
    (if (or (= VyberDIMSCALE "M") (= VyberDIMSCALE "m"))
    ;nastavenie modu na Mierka
    (setenv "GlobalnaDIMSCALEset" "Mierka")
    (princ)
    )
  )
  
  ;hlaska o nastaveneho modu vkladanych blokoch
  (princ (strcat "\nNastavily ste mod na " (getenv "GlobalnaDIMSCALEset") " pre vkladane bloky a koty!"))
  (princ)

)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nSetting.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
