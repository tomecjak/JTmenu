;=========================================================================
; Folders_scheme.lsp
; Create by Jakub Tomecko
;
; Vytvorenie struktry priecinkov projektu
;-------------------------------------------------------------------------

(defun c:JTFolder ()
  (LM:createdirectory "C:\\Users\\jakubtomecko\\Documents\\Folder1\\Folder2")
)

;;----------------------------------------------------------------------;;
;;              Pomocna funkcia pre vytvorenie priecinkov               ;;
;;----------------------------------------------------------------------;;

;; Create Directory  -  Lee Mac
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