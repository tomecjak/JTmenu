;=========================================================================
; JT_commands.lsp
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
;;    Nastavenie premennej JTMenuScale, pre zmenu DIMSCALE a TEXTSIZE   ;;
;;----------------------------------------------------------------------;;

(defun c:JTMenuScale()
  (setenv "GlobalnaJTMenuScale" (getstring "Zadajte mierku 1:"))
  (setvar "DIMSCALE" (/ (atof (getenv "GlobalnaJTMenuScale")) 1000))
  (setvar "TEXTSIZE" (* 2.5 (/ (atof (getenv "GlobalnaJTMenuScale")) 1000)))
  (princ "Nastavena mierka je 1:" (getenv "GlobalnaJTMenuScale"))
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
  
  (princ "Preview mod je nastaveny na: " (getenv "GlobalnaPreviewMode"))
  (princ)

)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nJT_commands.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;