;=========================================================================
; Folders_scheme.lsp
; Create by Charles Alan Butler from www.theswamp.org
; Edit by Jakub Tomecko
;
; Vybratie objektov podla hladiny z vybrnaho objektu
;-------------------------------------------------------------------------
 
(defun c:JTSelectbylayer (/ ent lay ss lay:lst lay:prompt ss:first ent:lst)
 
  ;dostat cokolvek uz vybrate
  (setq ss:first (cadr(ssgetfirst))
  ss (ssadd))
  
  ;ziskat pouzivatelom vybrane vrstvy
  (if ss:first
    (setq lay:prompt "\nVyberte objekty a vrstvy ktore chcete zachovat.")
    (setq lay:prompt "\nVyberete objekt pre filtrovanie vtstiev.")
  )
  
  (while (setq ent (entsel lay:prompt)) 
    (setq ent:lst (cons (car ent) ent:lst))
    (setq lay:lst
      (cons (setq lay (cdr(assoc 8 (entget (car ent))))) lay:lst))
    (prompt (strcat "\nVybrana hladina: " lay))
  )
  
  ;zrusi zvyraznenie objektov
  (and ent:lst (mapcar '(lambda (x) (redraw x 4)) ent:lst))
  
  (if (> (length lay:lst) 0) ;vyberie hladiny na pracu
    (progn
      (setq lay "")
      (setq lay:lst (vl-sort lay:lst '<)) ;vymaze duplikaty
      (foreach itm  lay:lst
        (setq lay (strcat lay itm ",")))
      (setq lay (substr lay 1 (1- (strlen lay))))
    
      (if ss:first
        (while (setq ent (ssname ss:first 0))
          (if (member (cdr(assoc 8 (entget ent))) lay:lst) 
            (ssadd (ssname ss:first 0) ss)
          )
          (ssdel (ssname ss:first 0) ss:first)
        )
      
        (progn
          (prompt (strcat "\nVyberte objekty pre oznacenie alebo stlacte "    
            "ENTER pre vsetky objekty v hladine: " lay))    
          (if (null (setq ss (ssget (list (cons 8 lay)))))
            (setq ss (ssget "_X" (list (cons 8 lay))))
          )  
        )
      )
      
      (if (> (sslength ss) 0)
      
      (progn 
        (prompt (strcat "\n" (itoa (sslength ss))  
          " Objekty vybrane v hladine: " lay)
        )
        
        (sssetfirst nil ss)
      )
      
      (prompt "\nNic nevybrate!")
      
      )
    )
  )
  
  (princ)
 
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ 
  (strcat 
    "\nSelect_by_layer.lsp | "
    (JTmenuVersion)
    " | Jakub Tomecko | "
    (menucmd "m=$(edtime,0,yyyy)")
  )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;