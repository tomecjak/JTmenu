(defun c:Setup()
  
  ;nastavenie cesty skade kopirovat subory JTmenu
  (setq SelectedFolderPathx (LM:browseforfolder "Vyberte priecinok z JTmenu." "" 0))
  
  ;nastavenie cesty kde kopirovat subory JTmenu
  (setq SelectedFolderPath (LM:browseforfolder "Vyberte cestu kde chceta nainstalovat JTmenu." "" 0))
  
  ;kopirovanie priecinku JTmenu - pociatocna cesta, koncova cesta, povolenie nahradit
  (LM:CopyFolder SelectedFolderPathx (strcat SelectedFolderPath "\\JTmenu") T)
  
  
  ;nastavenie premennej FileSupportPath
  (setq FilePath (vla-get-files (vla-get-preferences (vlax-get-Acad-object))))
  
  ;ziskanie jestujucich Support path 
  (setq FileSupportPathExisting (vla-get-SupportPath FilePath))
  ;nastavenie a spojenie jednotlivych ciest pre Support path
  (setq FileSupportPath 
    (strcat
      SelectedFolderPath "\\JTmenu;"
      SelectedFolderPath "\\JTmenu\\functions;"
      SelectedFolderPath "\\JTmenu\\functions\\content;"
      SelectedFolderPath "\\JTmenu\\icons;"
      SelectedFolderPath "\\JTmenu\\resource;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\CZK;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\ENG;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\SVK;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\1xx;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\2xx;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\3xx;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\4xx;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\5xx;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\1xx_J;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\2xx_J;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\3xx_J;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\4xx_J;"
      SelectedFolderPath "\\JTmenu\\resource\\blocks\\KnihovnaZDZ\\5xx_J;"
      SelectedFolderPath "\\JTmenu\\resource\\documents;"
      SelectedFolderPath "\\JTmenu\\resource\\lines;"
    ))
  ;spojenie novej cesty pre JTmenu a jestvujucich ciest
  (setq FileSupportPathNew (strcat FileSupportPath FileSupportPathExisting))
  ;vlozenie ciest do Suppurt Path
  (vla-put-SupportPath FilePath FileSupportPathNew)
  
  ;vytvorenie premenej VyberTemplatePath pre vyber instalacie template suboru
  (setq VyberTemplatePath
    (getstring "\nChcete si naistalovat aj JTmenu template subor? [Ano/Nie] <Ano>: ")
  )
  
  ;vyhodnotenie VyberTemplatePath
  (if (or (= VyberTemplatePath "A") (= VyberTemplatePath "a"))
    ;nastavenie TemplatePath - True
    (vla-put-QnewTemplateFile FilePath (strcat SelectedFolderPath "\\JTmenu\\template\\JTmenu_template.dwt"))

    ;nastavenie TemplatePath - False
    (if (or (= VyberTemplatePath "") (= VyberTemplatePath "N") (= VyberTemplatePath "n"))
    ;bez zmeny
    (princ)
    )    
  )
  
  ;nacitanie menu JTmenu.cuix
  (vla-load (vla-get-menugroups (vlax-get-acad-object)) "JTmenu.cuix")
  
)

;;----------------------------------------------------------------------;;
;;                  Funkcia na kopirovanie priecinku                    ;;
;;----------------------------------------------------------------------;;

(defun LM:CopyFolder ( src des ovr / fso rtn )
    (if (setq fso (vlax-create-object "scripting.filesystemobject"))
        (progn
            (setq rtn
                (not
                    (or (zerop (vlax-invoke fso 'folderexists src))
                        (vl-catch-all-error-p
                            (vl-catch-all-apply 'vlax-invoke
                                (list fso 'copyfolder src des (if ovr :vlax-true :vlax-false))
                            )
                        )
                    )
                )
            )
            (vlax-release-object fso)
            rtn
        )
    )
)
(vl-load-com)

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

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nSetup.lsp | " "Pre instalaciu zadajte prikaz Setup" " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;