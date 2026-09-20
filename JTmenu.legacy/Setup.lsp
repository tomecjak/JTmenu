(defun c:JTMenuSetup (/ SelectedFolderPath ContentsPath SupportList TrustedList 
                      CuiPath
                     ) 

  (vl-load-com)

  (defun JT:NormalizePath (p) 
    (if p 
      (vl-string-right-trim "\\" (vl-string-translate "/" "\\" p))
    )
  )

  (defun JT:PathExistsInVar (p varString / token) 
    (setq token (strcat ";" (strcase (JT:NormalizePath p)) ";"))
    (vl-string-search 
      token
      (strcat ";" (strcase (vl-string-right-trim ";" varString)) ";")
    )
  )

  (defun JT:AddToEnvPath (envName pathList / envValue p) 
    (setq envValue (getenv envName))
    (if (null envValue) (setq envValue ""))

    (foreach p pathList 
      (setq p (JT:NormalizePath p))
      (if 
        (and p 
             (vl-file-directory-p p)
             (not (JT:PathExistsInVar p envValue))
        )
        (setq envValue (strcat 
                         (vl-string-right-trim ";" envValue)
                         (if (> (strlen (vl-string-right-trim ";" envValue)) 0) 
                           ";"
                           ""
                         )
                         p
                       )
        )
      )
    )

    (setenv envName envValue)
    envValue
  )

  (defun JT:AddToToolPalettePath (pathList / filesObj tpp p) 
    (setq filesObj (vla-get-Files (vla-get-Preferences (vlax-get-acad-object))))
    (setq tpp (vla-get-ToolPalettePath filesObj))
    (if (null tpp) (setq tpp ""))

    (foreach p pathList 
      (setq p (JT:NormalizePath p))
      (if 
        (and p 
             (vl-file-directory-p p)
             (not (JT:PathExistsInVar p tpp))
        )
        (setq tpp (strcat 
                    (vl-string-right-trim ";" tpp)
                    (if (> (strlen (vl-string-right-trim ";" tpp)) 0) ";" "")
                    p
                  )
        )
      )
    )

    (vla-put-ToolPalettePath filesObj tpp)
    tpp
  )

  (defun JT:AddToTrustedPaths (pathList / tp p) 
    (setq tp (getvar "TRUSTEDPATHS"))
    (if (null tp) (setq tp ""))

    (foreach p pathList 
      (setq p (JT:NormalizePath p))
      (if 
        (and p 
             (vl-file-directory-p p)
             (not (JT:PathExistsInVar p tp))
        )
        (setq tp (strcat 
                   (vl-string-right-trim ";" tp)
                   (if (> (strlen (vl-string-right-trim ";" tp)) 0) ";" "")
                   p
                 )
        )
      )
    )

    (setvar "TRUSTEDPATHS" tp)
    tp
  )

  ;; Poznamka: Toto je NAHRADNY (rucny) sposob instalacie, ktory sa pouzije
  ;; iba ak nie je mozne pouzit standardny JTmenu.bundle (ApplicationPlugins) -
  ;; pozri README.md. Vyberte priecinok "JTmenu.bundle" (obsahuje podpriecinok
  ;; "Contents").
  (setq SelectedFolderPath (LM:browseforfolder 
                             "Vyberte priecinok JTmenu.bundle (kde mate ulozene JTmenu)."
                             ""
                             0
                           )
  )

  (if SelectedFolderPath 
    (progn 
      (setq SelectedFolderPath (JT:NormalizePath SelectedFolderPath))
      (setq ContentsPath (strcat SelectedFolderPath "\\Contents"))

      (setq SupportList (list 
                          ContentsPath
                          (strcat ContentsPath "\\functions")
                          (strcat ContentsPath "\\functions\\content")
                          (strcat ContentsPath "\\icons")
                          (strcat ContentsPath "\\resource")
                          (strcat ContentsPath "\\resource\\blocks")
                          (strcat ContentsPath "\\resource\\blocks\\CZK")
                          (strcat ContentsPath "\\resource\\blocks\\ENG")
                          (strcat ContentsPath "\\resource\\blocks\\SVK")
                          (strcat ContentsPath "\\resource\\blocks\\KnihovnaZDZ")
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\1xx"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\2xx"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\3xx"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\4xx"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\5xx"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\1xx_J"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\2xx_J"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\3xx_J"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\4xx_J"
                          )
                          (strcat ContentsPath 
                                  "\\resource\\blocks\\KnihovnaZDZ\\5xx_J"
                          )
                          (strcat ContentsPath "\\resource\\documents")
                          (strcat ContentsPath "\\resource\\lines")
                          (strcat ContentsPath "\\resource\\toolpallete")
                        )
      )

      (setq TrustedList (list 
                          ContentsPath
                          (strcat ContentsPath "\\functions")
                          (strcat ContentsPath "\\functions\\content")
                        )
      )

      (JT:AddToEnvPath "ACAD" SupportList)
      (JT:AddToTrustedPaths TrustedList)
      (JT:AddToToolPalettePath 
        (list (strcat ContentsPath "\\resource\\toolpallete"))
      )

      (setq CuiPath (strcat ContentsPath "\\JTMenu.cuix"))

      (if (and (findfile CuiPath) (not (menugroup "JTmenu"))) 
        (vla-load 
          (vla-get-menugroups (vlax-get-acad-object))
          CuiPath
        )
      )

      (princ "\nInstalacia JTmenu bola uspesna.")
    )
    (princ "\nVyber priecinka bol zruseny.")
  )

  (princ)
)



;;----------------------------------------------------------------------;;
;;                       Vyber cesty k priecinku                        ;;
;;----------------------------------------------------------------------;;

(defun LM:browseforfolder (msg dir bit / err fld pth shl slf) 
  (setq err (vl-catch-all-apply 
              (function 
                (lambda (/ app hwd) 
                  (if 
                    (setq app (vlax-get-acad-object)
                          shl (vla-getinterfaceobject app "shell.application")
                          hwd (vl-catch-all-apply 'vla-get-hwnd (list app))
                          fld (vlax-invoke-method shl 
                                                  'browseforfolder
                                                  (if (vl-catch-all-error-p hwd) 
                                                    0
                                                    hwd
                                                  )
                                                  msg
                                                  bit
                                                  dir
                              )
                    )
                    (setq slf (vlax-get-property fld 'self)
                          pth (vlax-get-property slf 'path)
                          pth (vl-string-right-trim "\\" 
                                                    (vl-string-translate "/" 
                                                                         "\\"
                                                                         pth
                                                    )
                              )
                    )
                  )
                )
              )
            )
  )
  (if slf (vlax-release-object slf))
  (if fld (vlax-release-object fld))
  (if shl (vlax-release-object shl))
  (if (vl-catch-all-error-p err) 
    (prompt (vl-catch-all-error-message err))
    pth
  )
)

;;----------------------------------------------------------------------;;
;;      Vyzbieranie .atc suborov po jednorazovom importe xtp/xpg        ;;
;;----------------------------------------------------------------------;;
;; AutoCAD vie automaticky (bez rucneho Importu) nacitat iba "zive" .atc
;; palety z priecinkov v "Tool Palette File Location" (nastavene aj
;; s JTMenuSetup, aj cez PackageContents.xml/ToolPalettePath v bundli).
;; Nase .xtp/.xpg subory su ale iba EXPORT format - AutoCAD ich do palety
;; premeni na .atc az po rucnom Importe (Customize Palettes > Import).
;;
;; Postup pri aktualizacii paliet dopravneho znacenia:
;;  1. Raz rucne naimportujte vsetky .xtp/.xpg (ako doteraz).
;;  2. Spustite prikaz JTToolPaletteCollect - skopiruje vysledne .atc
;;     subory z aktualneho profilu do zvoleneho priecinka (napr. do
;;     JTmenu.bundle\Contents\resource\toolpallete v repozitari).
;;  3. Tieto .atc commitnite - odteraz sa palety pri instalacii bundlu
;;     nacitaju vsetkym pouzivatelom automaticky, bez ich rucneho importu.
;; Poznamka: zoskupenie paliet do skupin/tabov (.xpg) takto automatizovat
;; nejde - Autoloader podporuje iba jednotlive .atc palety.

(defun c:JTToolPaletteCollect (/ filesObj tpp firstPath DestFolder files f) 

  (vl-load-com)

  (setq filesObj (vla-get-Files (vla-get-Preferences (vlax-get-acad-object))))
  (setq tpp (vla-get-ToolPalettePath filesObj))

  (if (and tpp (> (strlen tpp) 0)) 
    (progn 
      (setq firstPath (if (vl-string-search ";" tpp) 
                        (substr tpp 1 (1- (vl-string-search ";" tpp)))
                        tpp
                      )
      )

      (if (vl-file-directory-p firstPath) 
        (progn 
          (setq files (vl-directory-files firstPath "*.atc" 1))
          (if files 
            (progn 
              (setq DestFolder (LM:browseforfolder 
                                 "Vyberte cielovy priecinok pre .atc subory (napr. JTmenu.bundle\\Contents\\resource\\toolpallete)"
                                 ""
                                 0
                               )
              )
              (if DestFolder 
                (progn 
                  (foreach f files 
                    (vl-file-copy 
                      (strcat firstPath "\\" f)
                      (strcat DestFolder "\\" f)
                    )
                  )
                  (princ 
                    (strcat "\nSkopirovanych " 
                            (itoa (length files))
                            " .atc suborov do "
                            DestFolder
                            "."
                    )
                  )
                )
                (princ "\nVyber cieloveho priecinka bol zruseny.")
              )
            )
            (princ 
              (strcat "\nV priecinku " firstPath " sa nenasli ziadne .atc subory.")
            )
          )
        )
        (princ 
          (strcat "\nPriecinok Tool Palette File Location neexistuje: " firstPath)
        )
      )
    )
    (princ "\nTool Palette File Location nie je v AutoCADe nastavene.")
  )

  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ 
  (strcat 
    "\nSetup.lsp | "
    "Pre instalaciu zadajte prikaz JTMenuSetup"
    " | Jakub Tomecko | "
    (menucmd "m=$(edtime,0,yyyy)")
  )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;