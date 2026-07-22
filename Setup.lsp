(defun c:JTMenuSetup ( / SelectedFolderPath SupportList TrustedList CuiPath )

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
      (if (and p
               (vl-file-directory-p p)
               (not (JT:PathExistsInVar p envValue))
          )
        (setq envValue
          (strcat
            (vl-string-right-trim ";" envValue)
            (if (> (strlen (vl-string-right-trim ";" envValue)) 0) ";" "")
            p
          )
        )
      )
    )

    (setenv envName envValue)
    envValue
  )

  (defun JT:AddToTrustedPaths (pathList / tp p)
    (setq tp (getvar "TRUSTEDPATHS"))
    (if (null tp) (setq tp ""))

    (foreach p pathList
      (setq p (JT:NormalizePath p))
      (if (and p
               (vl-file-directory-p p)
               (not (JT:PathExistsInVar p tp))
          )
        (setq tp
          (strcat
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

  (setq SelectedFolderPath
    (LM:browseforfolder "Vyberte priecinok kde mate ulozene JTmenu." "" 0)
  )

  (if SelectedFolderPath
    (progn
      (setq SelectedFolderPath (JT:NormalizePath SelectedFolderPath))

      (setq SupportList
        (list
          SelectedFolderPath
          (strcat SelectedFolderPath "\\functions")
          (strcat SelectedFolderPath "\\functions\\content")
          (strcat SelectedFolderPath "\\icons")
          (strcat SelectedFolderPath "\\resource")
          (strcat SelectedFolderPath "\\resource\\blocks")
          (strcat SelectedFolderPath "\\resource\\blocks\\CZK")
          (strcat SelectedFolderPath "\\resource\\blocks\\ENG")
          (strcat SelectedFolderPath "\\resource\\blocks\\SVK")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\1xx")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\2xx")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\3xx")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\4xx")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\5xx")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\6xx")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\1xx_J")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\2xx_J")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\3xx_J")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\4xx_J")
          (strcat SelectedFolderPath "\\resource\\blocks\\KnihovnaZDZ\\5xx_J")
          (strcat SelectedFolderPath "\\resource\\documents")
          (strcat SelectedFolderPath "\\resource\\lines")
        )
      )

      (setq TrustedList
        (list
          SelectedFolderPath
          (strcat SelectedFolderPath "\\functions")
          (strcat SelectedFolderPath "\\functions\\content")
        )
      )

      (JT:AddToEnvPath "ACAD" SupportList)
      (JT:AddToTrustedPaths TrustedList)

      (setq CuiPath (strcat SelectedFolderPath "\\JTmenu.cuix"))

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

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nSetup.lsp | " "Pre instalaciu zadajte prikaz JTMenuSetup" " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;