;=========================================================================
; Trafficsignshorizontal.lsp
; Create by Jakub Tomecko
;
; Dopravne znacenie
;
; Prikazy DZxxx sa generuju datovo zo zoznamu *JT:SignCodes* - pre kazdy
; kod sa vytvori prikaz c:DZxxx, ktory vlozi blok "ZDZxxx" v aktualnej
; mierke dopravneho znacenia. Prikazy ostavaju volatelne z toolpalety
; (makra ^C^CDZ101 a pod.) presne ako predtym.
;-------------------------------------------------------------------------

(vl-load-com)

;;----------------------------------------------------------------------;;
;;                Zapnutie panulu nastrojov zo znackami                 ;;
;;----------------------------------------------------------------------;;

(defun c:JTTrafficSignsHorizontal ( )
  ;zapnutie postraneho panelu vodorovneho dopravneho znacenia
  (command ".TPNAVIGATE" "G" "Vodorovne dopravne znacenie" "600" pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;             Zoznam kodov dopravneho znacenia (1xx - 5xx)             ;;
;;----------------------------------------------------------------------;;

(setq *JT:SignCodesHorizontal*
  (list
    "VDZ604" "VDZ605" "VDZ610" "VDZ611" "VDZ612" "VDZ622" "VDZ630-10" "VDZ630-11" "VDZ630-12" "VDZ630-13" "VDZ630-14"
    "VDZ630-23" "VDZ630-24" "VDZ630-30" "VDZ630-31" "VDZ630-32" "VDZ631-10" "VDZ631-25" "VDZ635" "VDZ645" "VDZ650-50" "VDZ650-51"
    "VDZ650-52" "VDZ650-55" "VDZ650-56" "VDZ650-57" "VDZ650-60" "VDZ651" "VDZ652-51" "VDZ654-50" "VDZ654-51" "VDZ657-52"
    "VDZ657-80" "VDZ657-81" "VDZ657-84" "VDZ657-85" "VDZ657-88" "VDZ657-89" "VDZ657-97" "VDZ659" "VDZ663" "VDZ664"
    "VDZ665" "VDZ666" "VDZ667" "VDZ668"
  )
)

;;----------------------------------------------------------------------;;
;;          Vygenerovanie prikazov c:DZxxx zo zoznamu kodov             ;;
;;----------------------------------------------------------------------;;

;; Pre kod "DZ101" vznikne prikaz c:DZ101 -> (JT:InsertSign "ZDZ101").
;; Blok = "ZDZ" + kod bez uvodneho "DZ" (rovnaky vzorec aj pre pomlckove
;; varianty, napr. "DZ305-50" -> "ZDZ305-50").
(foreach code *JT:SignCodesHorizontal*
  (eval
    (list 'defun (read (strcat "c:" code)) '()
      (list 'JT:InsertSign (strcat "VDZ_" (substr code 4)))
    )
  )
)

;;----------------------------------------------------------------------;;

(load "JTmenuversion" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTrafficsignshorizontal.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
