(defun C:JTsettings()
  
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

