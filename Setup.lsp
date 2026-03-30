(defun c:Setup ( / SelectedFolderPath files FileSupportPath )
  (vl-load-com)

  (setq SelectedFolderPath
    (LM:browseforfolder "Vyberte priecinok kde mate ulozene JTmenu." "" 0)
  )

  (if SelectedFolderPath
    (progn
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
        )
      )

      (setq files (vla-get-files (vla-get-preferences (vlax-get-acad-object))))
      (vla-put-SupportPath files FileSupportPath)

      (if (findfile (strcat SelectedFolderPath "\\JTmenu\\JTmenu.cuix"))
        (vla-load (vla-get-menugroups (vlax-get-acad-object))
                  (strcat SelectedFolderPath "\\JTmenu\\JTmenu.cuix"))
      )
    )
    (princ "\nVyber priecinok bol zruseny.")
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