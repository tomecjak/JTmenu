;=========================================================================
; Traffic_signs_tools.lsp
; Create by Jakub Tomecko
;
; Nastroje pre dopravne znacenie
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;          Zapnutie panulu nastrojov zo jestujucimi znackami           ;;
;;----------------------------------------------------------------------;;

(defun c:JTTrafficSignsCanceled()
  
  ;oznacenie bloku dopravneho znacenia
  (setq VyberBloku (nentsel "Vyberte dopravne znacenie:" ))

  ;vypocet suradnic vybraneho bloku a jeho natocenie
  (setq Tmatrix (nth 2 VyberBloku))
  (setq blk_pt (nth 3 Tmatrix))
  (setq ang (/ (* 180.0 (angle '(0 0 0) (nth 0 Tmatrix))) pi))
  (setq xscale (nth 0 blk_pt))
  (setq yscale (nth 1 blk_pt))
  (princ xscale)
  (princ yscale)  

  ;vlozenie bloku krizika k dopravnej znacke
  (command "._insert" "KrizikDopravnehoZnacenia" (strcat (rtos xscale 2 2) "," (rtos yscale 2 2)) (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) ang pause)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;          Zapnutie panulu nastrojov zo jestujucimi znackami           ;;
;;----------------------------------------------------------------------;;

(defun c:JTTrafficSignsScale()
  
  ;zapis hodnoty parametru mierku dopravneho znacenia
  (setq signBlocksScale (getstring "Mierka dopravneho znacenia 1:"))

  ;nastavenie globalneho parametru
  (setenv "GlobalnaSignBlocksScale" signBlocksScale)
    
  ;hlaska o nastavenych parametroch
  (princ (strcat "\nNastavily ste mierku 1:" (getenv "GlobalnaSignBlocksScale") " pre vkladane bloky dopravneho znacenia!"))
    
  (princ)

)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTraffic_signs_tools.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;

 