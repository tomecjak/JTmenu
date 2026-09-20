;=========================================================================
; JTmenu_lib.lsp
; Create by Jakub Tomecko
;
; Zdielana kniznica pomocnych funkcii pre JTmenu.
; Tento subor sa nacitava ako prvy v JTmenu.mnl, takze vsetky tu
; definovane funkcie su dostupne globalne pre ostatne moduly.
; Cielom je odstranit duplicitu (Lee Mac helpery boli predtym
; nadefinovane vo viacerych suboroch) a zjednotit opakovane vzorce.
;-------------------------------------------------------------------------

(vl-load-com)

;;----------------------------------------------------------------------;;
;;                     Mierka pre vkladane bloky                        ;;
;;----------------------------------------------------------------------;;

;; Mierka pre bezne bloky z globalnej premennej GlobalnaBlocksScale.
;; Povodne sa vsade opakoval vzorec:
;;   (/ (atof (getenv "GlobalnaBlocksScale")) 1000)
(defun JT:BlockScale ( )
  (/ (atof (getenv "GlobalnaBlocksScale")) 1000.0)
)

;; Mierka pre bloky dopravneho znacenia z GlobalnaSignBlocksScale.
(defun JT:SignScale ( )
  (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000.0)
)

;;----------------------------------------------------------------------;;
;;                  Lee Mac - praca s Undo a dokumentom                 ;;
;;----------------------------------------------------------------------;;

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Closes an Undo Group.
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)

;;----------------------------------------------------------------------;;
;;                       Lee Mac - matematika                           ;;
;;----------------------------------------------------------------------;;

;; Round to Multiple  -  Lee Mac
;; Rounds 'n' to the nearest multiple of 'm'
(defun LM:roundm ( n m )
  (* m (fix ((if (minusp n) - +) (/ n (float m)) 0.5)))
)

;;----------------------------------------------------------------------;;
;;    Tool palety - kontrola/ponuka rucneho importu (xtp/xpg suborov)   ;;
;;----------------------------------------------------------------------;;
;; AutoCAD nevie ani jednotlive palety (.xtp), ani skupiny paliet (.xpg)
;; naimportovat sam - jedina cesta je rucny Import v dialogu Customize
;; Palettes (potvrdene aj priamo Autodeskom - ziadne API pre to nema ani
;; LISP, ani bundle Autoloader). Uz naimportovane palety si ale AutoCAD
;; uklada ako *.atc subory do "Tool Palette File Location", takze vieme
;; (nie 100% isto - ziadne oficialne API na overenie neexistuje, ide o
;; prehladanie textoveho obsahu tychto suborov) skusit zistit, ci uz boli
;; naimportovane, a ak ano, hlasku uz nezobrazovat.

;; Vrati zoznam priecinkov nastavenych v Options > Files > Tool Palette
;; File Locations (ToolPalettePath moze obsahovat viac ciest oddelenych ;).
(defun JT:ToolPaletteFolders ( / raw lst pos p )
  (setq raw (vla-get-ToolPalettePath (vla-get-Files (vla-get-Preferences (vlax-get-acad-object)))))
  (setq lst nil)
  (if (and raw (> (strlen raw) 0))
    (while (> (strlen raw) 0)
      (setq pos (vl-string-search ";" raw))
      (setq p (if pos (substr raw 1 pos) raw))
      (setq raw (if pos (substr raw (+ pos 2)) ""))
      (if (> (strlen p) 0) (setq lst (cons p lst)))
    )
  )
  (reverse lst)
)

;; T, ak niektory ".atc" subor v priecinkoch Tool Palette File Location
;; obsahuje niektore z mien z Names ako obsah XML tagu (napr. ">100<").
;; Ide o heuristiku (text-match), nie o oficialne overenie cez API.
(defun JT:ToolPaletteEvidence ( Names / folder fname f line found n )
  (setq found nil)
  (foreach folder (JT:ToolPaletteFolders)
    (if (and (not found) (vl-file-directory-p folder))
      (foreach fname (vl-directory-files folder "*.atc" 1)
        (if (not found)
          (progn
            (setq f (open (strcat folder "\\" fname) "r"))
            (if f
              (progn
                (while (and (not found) (setq line (read-line f)))
                  (foreach n Names
                    (if (and (not found) (vl-string-search (strcat ">" n "<") line))
                      (setq found T)
                    )
                  )
                )
                (close f)
              )
            )
          )
        )
      )
    )
  )
  found
)

;; Jednorazova (kym sa nenajde dokaz o uz spravenom importe) ponuka na
;; rucny import paliet dopravneho znacenia - otvori priecinok s .xtp/.xpg
;; a vysvetli postup. EnvFlag - nazov Globalnej premennej, kam sa
;; zapamata "uz ponuknute" (aby sa hlaska neopakovala kazde spustenie).
;; GroupName - nazov skupiny/.xpg suboru. XtpNames - zoznam nazvov
;; jednotlivych paliet (.xtp) v tejto skupine. Force=T vynuti zobrazenie
;; bez ohladu na EnvFlag aj na najdenu evidenciu (rucne znovuspustenie).
(defun JT:OfferToolPaletteImport ( Force EnvFlag GroupName XtpNames / XpgFile XpgFolder XtpList n )
  (if (or Force (= (getenv EnvFlag) nil))
    (if (and (not Force) (JT:ToolPaletteEvidence (cons GroupName XtpNames)))
      (setenv EnvFlag "1")
      (progn
        (setq XpgFile (findfile (strcat GroupName ".xpg")))
        (if XpgFile
          (progn
            (setq XpgFolder (vl-filename-directory XpgFile))
            (setq XtpList "")
            (foreach n XtpNames
              (setq XtpList (strcat XtpList (if (= XtpList "") "" ", ") n ".xtp"))
            )
            (alert
              (strcat
                "JTmenu - palety dopravneho znacenia (" GroupName ")\n"
                "sa musia (jednorazovo) naimportovat rucne - AutoCAD to inak\n"
                "neumoznuje automatizovat.\n\n"
                "Otvori sa priecinok s temito subormi:\n"
                "  - jednotlive palety: " XtpList "\n"
                "  - cela skupina naraz: " GroupName ".xpg\n\n"
                "Postup (staci jeden z nich):\n"
                "A) Tool Palettes (CTRL+3) > klik pravym na zalozky >\n"
                "   Customize Palettes... > Palette Groups > klik pravym >\n"
                "   Import... > " GroupName ".xpg  (prinesie naraz aj vsetky palety)\n"
                "B) Customize Palettes... > klik pravym na zoznam paliet >\n"
                "   Import... > vyberte konkretne .xtp subory jednotlivo.\n\n"
                "Ak to teraz preskocite, skusi sa to znova pri buducom\n"
                "zapnuti tohto panelu."
              )
            )
            (startapp "explorer.exe" XpgFolder)
          )
        )
        (setenv EnvFlag "1")
      )
    )
  )
  (princ)
)

;;----------------------------------------------------------------------;;

(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nJTmenu_lib.lsp | " (JTmenuVersion) " | Lee Mac, Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
