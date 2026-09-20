;=========================================================================
; JTmenu_commands.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Rozne prikazy pre ovladanie premennych v JTmenu
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;          Nastavenie globalnej premennej pre mierku blokov            ;;
;;----------------------------------------------------------------------;;

(defun c:JTBlockScaleVar()
  (setenv "GlobalnaBlocksScale" (getstring "Zadajte mierku pre vkladane bloky 1:"))
  (princ (strcat "Nastavena mierka je 1:" (getenv "GlobalnaBlocksScale") " pre vkladane bloky!"))
  (princ)
)

;;----------------------------------------------------------------------;;
;;                 Nastavenie premennej JTPreviewMode                   ;;
;;----------------------------------------------------------------------;;

;pre zmenu TRIMEXTENDMODE, HPQUICKPREVIEW a COMMANDPREVIEW
(defun c:JTPreviewMode()

  ;vytvorenie premenej VyberPreviewMode
  (initget "Zapnut Vypnut")
  (setq VyberPreviewMode (getkword "\nPreviewu mod autocadu: [Zapnut/Vypnut] <Zapnut>: "))
  (if (null VyberPreviewMode) (setq VyberPreviewMode "Zapnut"))
  
  ;vyhodnotenie vyberu Preview modu
  (cond
    ((= VyberPreviewMode "Zapnut")
      ;zapnutie modu
      (progn
        (setenv "GlobalnaPreviewMode" "Zap.")
        (setvar "TRIMEXTENDMODE" 1)
        (setvar "HPQUICKPREVIEW" 1)
        (setvar "COMMANDPREVIEW" 1)
      )
    )
    ((= VyberPreviewMode "Vypnut")
      ;vypnutie modu
      (progn
        (setenv "GlobalnaPreviewMode" "Vyp.")
        (setvar "TRIMEXTENDMODE" 0)
        (setvar "HPQUICKPREVIEW" 0)
        (setvar "COMMANDPREVIEW" 0)
      )
    )
  )

)

;;----------------------------------------------------------------------;;
;;   Znovuspustenie hlasky o (rucnom) importe paliet dopravn. znacenia  ;;
;;----------------------------------------------------------------------;;
;; Pre pripad, ze ju uzivatel predtym preskocil, alebo si chce znova
;; pozriet postup. JT:OfferToolPaletteImport je v JTmenu_lib.lsp.

(defun c:JTToolPaletteImportInfo ()
  (JT:OfferToolPaletteImport T "GlobalnaPaletyDZ" "Dopravne znacenie" (list "100" "200" "300" "400" "500"))
  (JT:OfferToolPaletteImport T "GlobalnaPaletyDZJ" "Jestujuce dopravne znacenie" (list "100J" "200J" "300J" "400J" "500J"))
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nJTmenu_commands.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;