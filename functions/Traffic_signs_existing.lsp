;=========================================================================
; Traffic_signs_existing.lsp
; Create by Jakub Tomecko
;
; Jestvujuce dopravne znacenie
;
; Prikazy DZxxx_J sa generuju datovo zo zoznamu *JT:SignCodesExisting* -
; pre kazdy kod vznikne prikaz c:DZxxx_J, ktory vlozi blok "ZDZ_xxx_J"
; v aktualnej mierke dopravneho znacenia. Prikazy ostavaju volatelne
; z toolpalety (makra ^C^CDZ101_J a pod.) presne ako predtym.
;-------------------------------------------------------------------------

(vl-load-com)

;;----------------------------------------------------------------------;;
;;                Zapnutie panulu nastrojov zo znackami                 ;;
;;----------------------------------------------------------------------;;

(defun c:JTTrafficSignsExisting ( )
  ;zapnutie postraneho panelu jestvujuceho dopravneho znacenia
  (command "._TPNAVIGATE" "_G" "Jestujuce dopravne znacenie" "J100" pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;        Zoznam kodov jestvujuceho dopravneho znacenia (1xx - 5xx)     ;;
;;----------------------------------------------------------------------;;

(setq *JT:SignCodesExisting*
  (list
    "DZ101_J" "DZ110_J" "DZ111_J" "DZ112_J" "DZ113_J" "DZ114_J" "DZ115_J" "DZ116_J" "DZ120_J" "DZ121_J"
    "DZ122_J" "DZ125_J" "DZ126_J" "DZ130_J" "DZ131_J" "DZ132_J" "DZ135_J" "DZ136_J" "DZ140_J" "DZ141_J"
    "DZ142_J" "DZ143_J" "DZ145_J" "DZ146_J" "DZ151_J" "DZ152_J" "DZ153_J" "DZ201_J" "DZ202_J" "DZ203_J"
    "DZ210_J" "DZ211_J" "DZ212_J" "DZ213_J" "DZ215_J" "DZ216_J" "DZ220_J" "DZ221_J" "DZ222_J" "DZ223_J"
    "DZ224_J" "DZ225_J" "DZ230_J" "DZ231_J" "DZ232_J" "DZ233_J" "DZ234_J" "DZ235_J" "DZ240_J" "DZ241_J"
    "DZ242_J" "DZ243_J" "DZ244_J" "DZ245_J" "DZ248_J" "DZ249_J" "DZ250_J" "DZ251_J" "DZ253_J" "DZ254_J"
    "DZ255_J" "DZ256_J" "DZ260_J" "DZ261_J" "DZ263_J" "DZ264_J" "DZ265_J" "DZ267_J" "DZ268_J" "DZ269_J"
    "DZ270_J" "DZ271_J" "DZ272_J" "DZ273_J" "DZ275_J" "DZ276_J" "DZ277_J" "DZ278_J" "DZ280_J" "DZ281_J"
    "DZ282_J" "DZ283_J" "DZ301_J" "DZ302_J" "DZ303_J" "DZ304_J" "DZ305-50_J" "DZ305-51_J" "DZ305-52_J" "DZ305-60_J"
    "DZ305-61_J" "DZ305-62_J" "DZ305-70_J" "DZ306-50_J" "DZ306-51_J" "DZ306-52_J" "DZ306-60_J" "DZ306-61_J" "DZ306-62_J" "DZ306-70_J"
    "DZ307-50_J" "DZ307-51_J" "DZ307-52_J" "DZ307-60_J" "DZ307-61_J" "DZ307-62_J" "DZ308-50_J" "DZ308-51_J" "DZ308-52_J" "DZ308-60_J"
    "DZ308-61_J" "DZ308-62_J" "DZ309_J" "DZ310_J" "DZ311_J" "DZ312_J" "DZ313_J" "DZ314_J" "DZ315_J" "DZ316_J"
    "DZ317_J" "DZ318_J" "DZ319_J" "DZ320_J" "DZ321_J" "DZ322_J" "DZ323_J" "DZ324_J" "DZ325_J" "DZ326_J"
    "DZ327_J" "DZ328_J" "DZ330_J" "DZ331_J" "DZ332_J" "DZ333_J" "DZ334_J" "DZ335_J" "DZ336_J" "DZ340-50_J"
    "DZ340-51_J" "DZ340-52_J" "DZ340-53_J" "DZ340-60_J" "DZ340-61_J" "DZ340-62_J" "DZ340-70_J" "DZ340-71_J" "DZ340-72_J" "DZ340-80_J"
    "DZ340-81_J" "DZ340-82_J" "DZ341_J" "DZ342_J" "DZ343_J" "DZ344_J" "DZ350_J" "DZ351_J" "DZ352_J" "DZ353_J"
    "DZ355-50_J" "DZ355-60_J" "DZ355-70_J" "DZ390_J" "DZ391_J" "DZ392_J" "DZ393-30_J" "DZ393-32_J" "DZ394_J" "DZ394-50_J"
    "DZ394-55_J" "DZ394-6x_J" "DZ395_J" "DZ396_J" "DZ397_J" "DZ401_J" "DZ402_J" "DZ403_J" "DZ404_J" "DZ411_J"
    "DZ412_J" "DZ413_J" "DZ414_J" "DZ421_J" "DZ422_J" "DZ423_J" "DZ424_J" "DZ431_J" "DZ432_J" "DZ441_J"
    "DZ442_J" "DZ443_J" "DZ444_J" "DZ445_J" "DZ451_J" "DZ453_J" "DZ455_J" "DZ457_J" "DZ459_J" "DZ501_J"
    "DZ501-60_J" "DZ502_J" "DZ502-60_J" "DZ503_J" "DZ504_J" "DZ505_J" "DZ506_J" "DZ506-100_J" "DZ506-101_J" "DZ506-102_J"
    "DZ506-110_J" "DZ506-111_J" "DZ506-120_J" "DZ506-121_J" "DZ506-139_J" "DZ506-141_J" "DZ506-142_J" "DZ507_J" "DZ507-100_J" "DZ507-101_J"
    "DZ507-102_J" "DZ507-120_J" "DZ507-121_J" "DZ507-139_J" "DZ507-141_J" "DZ507-142_J" "DZ507-143_J" "DZ508_J" "DZ509-50_J" "DZ509-51_J"
    "DZ509-52_J" "DZ509-53_J" "DZ509-54_J" "DZ509-55_J" "DZ509-56_J" "DZ509-57_J" "DZ509-58_J" "DZ509-60_J" "DZ509-62_J" "DZ509-63_J"
    "DZ509-70_J" "DZ509-72_J" "DZ509-73_J" "DZ509-74_J" "DZ509-75_J" "DZ509-76_J" "DZ509-77_J" "DZ509-80_J" "DZ509-81_J" "DZ509-87_J"
    "DZ509-88_J" "DZ509-89_J" "DZ509-90_J" "DZ509-91_J" "DZ509-92_J" "DZ509-93_J" "DZ509-94_J" "DZ509-97_J" "DZ509-100_J" "DZ509-101_J"
    "DZ509-102_J" "DZ510_J" "DZ511_J" "DZ512_J" "DZ513_J" "DZ514_J" "DZ515_J" "DZ515-100_J" "DZ515-101_J" "DZ515-102_J"
    "DZ520_J" "DZ520hx_J" "DZ521_J" "DZ522_J" "DZ525_J" "DZ526_J" "DZ527_J" "DZ530_J" "DZ531_J" "DZ532_J"
    "DZ533_J"
  )
)

;;----------------------------------------------------------------------;;
;;        Vygenerovanie prikazov c:DZxxx_J zo zoznamu kodov             ;;
;;----------------------------------------------------------------------;;

;; Pre kod "DZ101_J" vznikne prikaz c:DZ101_J -> (JT:InsertSign "ZDZ_101_J").
;; Blok = "ZDZ_" + kod bez uvodneho "DZ". JT:InsertSign je definovana
;; v Traffic_signs.lsp, ktory sa nacitava skor.
(foreach code *JT:SignCodesExisting*
  (eval
    (list 'defun (read (strcat "c:" code)) '()
      (list 'JT:InsertSign (strcat "ZDZ_" (substr code 3)))
    )
  )
)

;;----------------------------------------------------------------------;;

(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTraffic_signs_existing.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
