;=========================================================================
; Bugs_report.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Prekliknutie na stránku Bugs report
;-------------------------------------------------------------------------

(defun c:JTBugsReport ()
  
  ;definovanie premenej "BugsReportURL" do ktorej je zapísana url adresa
  (setq BugsReportURL "https://tomecjak.notion.site/Bugs-report-12becabd00958006aa56cf8f824c65d7?source=copy_link")

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