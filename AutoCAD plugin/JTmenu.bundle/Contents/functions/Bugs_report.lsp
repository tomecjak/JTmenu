;=========================================================================
; Bugs_report.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Prekliknutie na stránku Bugs report
;-------------------------------------------------------------------------

(defun c:JTBugsReport ()
  
  ;definovanie premenej "BugsReportURL" do ktorej je zapísana url adresa
  (setq BugsReportURL "https://glib-dish-9f2.notion.site/12becabd0095808e869dd8ccb23d4a99")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" BugsReportURL)
  (princ)

  ;hlaska po skonceni programu
  (princ "\nBugs report sa otvoril v internetovom prehliadaci. ")
  (princ)
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nBugs_report.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;