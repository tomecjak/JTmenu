;=========================================================================
; Help.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: beta
;
; Prekliknutie na stránku Help
;-------------------------------------------------------------------------

;definovanie funkcie prikazu "JTHelp"
(defun c:JTHelp ()
  
  ;definovanie premenej "HelpURL" do ktorej je zapísana url adresa
  (setq HelpURL "https://glib-dish-9f2.notion.site/JTmenu-1c7f4a277c79442aada3d2f6fded23dc")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" HelpURL)

  ;hlaska po skonceni programu
  (princ "\nHelp sa otvoril v internetovom prehliadači. ")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\nMaps.lsp | beta | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;