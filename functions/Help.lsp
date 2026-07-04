;=========================================================================
; Help.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Prekliknutie na stránku Help
;-------------------------------------------------------------------------

;definovanie funkcie prikazu "JTHelp"
(defun c:JTHelp ()
  
  ;definovanie premenej "HelpURL" do ktorej je zapísana url adresa
  (setq HelpURL "https://tomecjak.notion.site/JTmenu-1c7f4a277c79442aada3d2f6fded23dc?source=copy_link")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" HelpURL)
  (princ)

  ;hlaska po skonceni programu
  (princ "\nHelp sa otvoril v internetovom prehliadaci. ")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nHelp.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;