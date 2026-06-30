;=========================================================================
; Traffic_signs.lsp
; Create by Jakub Tomecko
;
; Dopravne znacenie
;
; Prikazy DZxxx sa generuju datovo zo zoznamu *JT:SignCodes* - pre kazdy
; kod sa vytvori prikaz c:DZxxx, ktory vlozi blok "ZDZ_xxx" v aktualnej
; mierke dopravneho znacenia. Prikazy ostavaju volatelne z toolpalety
; (makra ^C^CDZ101 a pod.) presne ako predtym.
;-------------------------------------------------------------------------

(vl-load-com)

;;----------------------------------------------------------------------;;
;;                Zapnutie panulu nastrojov zo znackami                 ;;
;;----------------------------------------------------------------------;;

(defun c:JTTrafficSigns ( )
  ;zapnutie postraneho panelu dopravneho znacenia
  (command "._TPNAVIGATE" "_G" "Dopravne znacenie" "100" pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;          Vlozenie bloku dopravneho znacenia (zdielana funkcia)       ;;
;;----------------------------------------------------------------------;;

;; blk - presny nazov bloku (napr. "ZDZ_101")
;; JT:SignScale je definovana v JT_lib.lsp
(defun JT:InsertSign ( blk )
  (command "._insert" blk "_S" (JT:SignScale) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;             Zoznam kodov dopravneho znacenia (1xx - 5xx)             ;;
;;----------------------------------------------------------------------;;

(setq *JT:SignCodes*
  (list
    "DZ101" "DZ110" "DZ111" "DZ112" "DZ113" "DZ114" "DZ115" "DZ116" "DZ120" "DZ121"
    "DZ122" "DZ125" "DZ126" "DZ130" "DZ131" "DZ132" "DZ135" "DZ136" "DZ140" "DZ141"
    "DZ142" "DZ143" "DZ145" "DZ146" "DZ151" "DZ152" "DZ153" "DZ201" "DZ202" "DZ203"
    "DZ210" "DZ211" "DZ212" "DZ213" "DZ215" "DZ216" "DZ220" "DZ221" "DZ222" "DZ223"
    "DZ224" "DZ225" "DZ230" "DZ231" "DZ232" "DZ233" "DZ234" "DZ235" "DZ240" "DZ241"
    "DZ242" "DZ243" "DZ244" "DZ245" "DZ248" "DZ249" "DZ250" "DZ251" "DZ253" "DZ254"
    "DZ255" "DZ256" "DZ260" "DZ261" "DZ263" "DZ264" "DZ265" "DZ267" "DZ268" "DZ269"
    "DZ270" "DZ271" "DZ272" "DZ273" "DZ275" "DZ276" "DZ277" "DZ278" "DZ280" "DZ281"
    "DZ282" "DZ283" "DZ301" "DZ302" "DZ303" "DZ304" "DZ305-50" "DZ305-51" "DZ305-52" "DZ305-60"
    "DZ305-61" "DZ305-62" "DZ305-70" "DZ306-50" "DZ306-51" "DZ306-52" "DZ306-60" "DZ306-61" "DZ306-62" "DZ306-70"
    "DZ307-50" "DZ307-51" "DZ307-52" "DZ307-60" "DZ307-61" "DZ307-62" "DZ308-50" "DZ308-51" "DZ308-52" "DZ308-60"
    "DZ308-61" "DZ308-62" "DZ309" "DZ310" "DZ311" "DZ312" "DZ313" "DZ314" "DZ315" "DZ316"
    "DZ317" "DZ318" "DZ319" "DZ320" "DZ321" "DZ322" "DZ323" "DZ324" "DZ325" "DZ326"
    "DZ327" "DZ328" "DZ330" "DZ331" "DZ332" "DZ333" "DZ334" "DZ335" "DZ336" "DZ340-50"
    "DZ340-51" "DZ340-52" "DZ340-53" "DZ340-60" "DZ340-61" "DZ340-62" "DZ340-70" "DZ340-71" "DZ340-72" "DZ340-80"
    "DZ340-81" "DZ340-82" "DZ341" "DZ342" "DZ343" "DZ344" "DZ350" "DZ351" "DZ352" "DZ353"
    "DZ355-50" "DZ355-60" "DZ355-70" "DZ390" "DZ391" "DZ392" "DZ393-30" "DZ393-32" "DZ394" "DZ394-50"
    "DZ394-55" "DZ394-6x" "DZ395" "DZ396" "DZ397" "DZ401" "DZ402" "DZ403" "DZ404" "DZ411"
    "DZ412" "DZ413" "DZ414" "DZ421" "DZ422" "DZ423" "DZ424" "DZ431" "DZ432" "DZ441"
    "DZ442" "DZ443" "DZ444" "DZ445" "DZ451" "DZ453" "DZ455" "DZ457" "DZ459" "DZ501"
    "DZ501-60" "DZ502" "DZ502-60" "DZ503" "DZ504" "DZ505" "DZ506" "DZ506-100" "DZ506-101" "DZ506-102"
    "DZ506-110" "DZ506-111" "DZ506-120" "DZ506-121" "DZ506-139" "DZ506-141" "DZ506-142" "DZ507" "DZ507-100" "DZ507-101"
    "DZ507-102" "DZ507-120" "DZ507-121" "DZ507-139" "DZ507-141" "DZ507-142" "DZ507-143" "DZ508" "DZ509-50" "DZ509-51"
    "DZ509-52" "DZ509-53" "DZ509-54" "DZ509-55" "DZ509-56" "DZ509-57" "DZ509-58" "DZ509-60" "DZ509-62" "DZ509-63"
    "DZ509-70" "DZ509-72" "DZ509-73" "DZ509-74" "DZ509-75" "DZ509-76" "DZ509-77" "DZ509-80" "DZ509-81" "DZ509-87"
    "DZ509-88" "DZ509-89" "DZ509-90" "DZ509-91" "DZ509-92" "DZ509-93" "DZ509-94" "DZ509-97" "DZ509-100" "DZ509-101"
    "DZ509-102" "DZ510" "DZ511" "DZ512" "DZ513" "DZ514" "DZ515" "DZ515-100" "DZ515-101" "DZ515-102"
    "DZ520" "DZ520hx" "DZ521" "DZ522" "DZ525" "DZ526" "DZ527" "DZ530" "DZ531" "DZ532"
    "DZ533"
  )
)

;;----------------------------------------------------------------------;;
;;          Vygenerovanie prikazov c:DZxxx zo zoznamu kodov             ;;
;;----------------------------------------------------------------------;;

;; Pre kod "DZ101" vznikne prikaz c:DZ101 -> (JT:InsertSign "ZDZ_101").
;; Blok = "ZDZ_" + kod bez uvodneho "DZ" (rovnaky vzorec aj pre pomlckove
;; varianty, napr. "DZ305-50" -> "ZDZ_305-50").
(foreach code *JT:SignCodes*
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
        "\nTraffic_signs.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
