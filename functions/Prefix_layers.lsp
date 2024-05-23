;=========================================================================
; Prexif_layers.lsp
; Create by "BlackBox" from https://www.theswamp.org/index.php?topic=49447.0
; Edit by Jakub Tomecko
;
; Vymazanie prexifu alebo subfixu z nazvu hladin
;-------------------------------------------------------------------------

(defun C:JTLayerPrexifRemove (/ *error* old new acDoc oLayers i oldName newName)
 
  (defun *error* (msg)
    (if acDoc (vla-endundomark acDoc))
    (cond ((not msg))                                                   ; Klasicke vypnutie
          ((member msg '("Funkcia bola zrusena.")))    ; <esc> alebo (quit)
          ((princ (strcat "\n** Error: " msg " ** ")))                  ; Fatal error, zobrazenie
    )
    (princ)
  )
 
  (if (and (setq old (getstring T "\nZadajte prefix alebo subfix k vymazaniu: "))
           (setq new "")
      )
    (progn
      (vla-startundomark
        (setq acDoc (vla-get-activedocument (vlax-get-acad-object)))
      )
      (setq oLayers (vla-get-layers acDoc))
      (setq i 0)
      (vlax-for x oLayers
        (if (vl-string-search old (setq oldName (vla-get-name x)))
          (if
            (tblsearch "layer"
                       (setq newName (vl-string-subst new old oldName))
            )
             (prompt
               (strcat
                 "\nHladina \"" newName "\" uz existuje. "
                 "Presunte vsetky objekty, potom vymazte hladinu \"" oldName "\" "
                )
             )
             (progn
               (vla-put-name x newName)
               (setq i (1+ i))
             )
          )
        )
      )
      (prompt
        (strcat "\n" (itoa i) " hladin" (if (= 1 i) "s " " ") "zmenenych. ")
      )    
    )
  )
 
  (*error* nil)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nPrefix_layers.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;