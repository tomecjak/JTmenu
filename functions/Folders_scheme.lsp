;=========================================================================
; Folders_scheme.lsp
; Create by Jakub Tomecko
;
; Vytvorenie struktry priecinkov projektu
;-------------------------------------------------------------------------

(defun c:JTFolder ()
  ;vybratie suboru z priecinku
  (setq FilePath (getfiled "Vyberte subor" "" "txt" 4))
  ;otvorenie suboru a vytvorenie prazdneho listu
  (setq FilePathOpen (open FilePath "r") ListOfPath'())
  ;zapis kazdeho riadku do listu
  (while (setq ListLine (read-line FilePathOpen))
    (setq ListOfPath (cons ListLine ListOfPath))
  )
  ;zavretie suboru
  (close FilePathOpen)
  ;nastavenie cesty vytvorenia suborov
  (setq SelectedFolderPath (LM:browseforfolder "Select a folder" "C:\\" 0))
  ;vytvorenie priecinkov
  (setq CreateFolderPath (strcat SelectedFolderPath "\\Folder1\\Folder2\\Test"))
  (LM:createdirectory CreateFolderPath)
)

;;----------------------------------------------------------------------;;
;;              Pomocna funkcia pre vytvorenie priecinkov               ;;
;;----------------------------------------------------------------------;;

;; Create Directory  -  Lee Mac
;; https://lee-mac.com/createdirectory.html
;; dir - [str] directory to create ("C:\\Folder1\\Folder2")
;; Returns:  T if directory creation is successful, else nil

(defun LM:createdirectory ( dir )
    (   (lambda ( fun )
            (   (lambda ( lst ) (fun (car lst) (cdr lst)))
                (vl-remove "" (LM:str->lst (vl-string-translate "/" "\\" dir) "\\"))
            )
        )
        (lambda ( root lst / dir )
            (if lst
                (if (or (vl-file-directory-p (setq dir (strcat root "\\" (car lst)))) (vl-mkdir dir))
                    (fun dir (cdr lst))
                )
            )
        )
    )
    (vl-file-directory-p dir)
)

;; String to List  -  Lee Mac
;; Separates a string using a given delimiter
;; str - [str] string to process
;; del - [str] delimiter by which to separate the string

(defun LM:str->lst ( str del / pos )
    (if (setq pos (vl-string-search del str))
        (cons (substr str 1 pos) (LM:str->lst (substr str (+ pos 1 (strlen del))) del))
        (list str)
    )
)

;; Browse for Folder  -  Lee Mac
;; Displays a dialog prompting the user to select a folder.
;; https://lee-mac.com/directorydialog.html
;; msg - [str] message to display at top of dialog
;; dir - [str] [optional] root directory (or nil)
;; bit - [int] bit-coded flag specifying dialog display settings
;; Returns: [str] Selected folder filepath, else nil.
 
(defun LM:browseforfolder ( msg dir bit / err fld pth shl slf )
    (setq err
        (vl-catch-all-apply
            (function
                (lambda ( / app hwd )
                    (if (setq app (vlax-get-acad-object)
                              shl (vla-getinterfaceobject app "shell.application")
                              hwd (vl-catch-all-apply 'vla-get-hwnd (list app))
                              fld (vlax-invoke-method shl 'browseforfolder (if (vl-catch-all-error-p hwd) 0 hwd) msg bit dir)
                        )
                        (setq slf (vlax-get-property fld 'self)
                              pth (vlax-get-property slf 'path)
                              pth (vl-string-right-trim "\\" (vl-string-translate "/" "\\" pth))
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
        "\nFolders_scheme.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;