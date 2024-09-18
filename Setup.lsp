(defun c:Setup()
  
    ;nastavenie cesty kde kopirovat subory
  (setq SelectedFolderPathx (LM:browseforfolder "Vyberte cestu pre instalaciu JTmenu" ""0))
  
  ;nastavenie cesty kde kopirovat subory
  (setq SelectedFolderPath (LM:browseforfolder "Vyberte cestu pre instalaciu JTmenu" ""0))
  
  ;kopirovanie priecinku JTmenu - pociatocna cesta, koncova cesta, povolenie nahradit
  (LM:CopyFolder SelectedFolderPathx (strcat SelectedFolderPath "\\JTmenu") T)
  
  
  ;nastavenie premennej FileSupportPath
  (setq FilePath (vla-get-files (vla-get-preferences (vlax-get-Acad-object))))
  
  ;nastavenie Support file path
  ;
  (setq FileSupportPathExisting (vla-get-SupportPath FilePath))
  (setq FileSupportPath (strcat SelectedFolderPath "\\JTmenu;"))
  (setq FileSupportPathNew (strcat FileSupportPath FileSupportPathExisting))
  (vla-put-SupportPath FilePath FileSupportPathNew)
  
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
        "\nSetup.lsp | "  " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;