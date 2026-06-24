;=========================================================================
; Oblique_dimension.lsp
; (c) Copyright 2026 Tomecko Jakub
;
; Nastavenie symbolov pre sikme a kolme kóty
;-------------------------------------------------------------------------

(defun c:JTDimOblique (/ mode pre suf ss i en obj)
  (vl-load-com)

  (initget "Sikma Kolma")
  (setq mode (getkword "\nTyp kóty [Sikma/Kolma] <Sikma>: "))
  (if (null mode) (setq mode "Sikma"))

  ;kolma -> ∟1500∠
  ;sikma -> ∠1500∟
  (cond
    ((= mode "Kolma")
      (setq pre "∟"
            suf " ∠"))
    ((= mode "Sikma")
      (setq pre "∠"
            suf " ∟"))
  )

  (prompt
    (strcat
      "\nVyber koty. Vysledny text bude napr.: "
      pre "1500" suf
    )
  )

  ;vyber iba "dimension" entit
  (setq ss (ssget '((0 . "DIMENSION"))))

  (if ss
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq en  (ssname ss i)
              obj (vlax-ename->vla-object en))

        ;nastavenie vlastnosti Dim prefix / Dim suffix
        (vl-catch-all-apply
          'vla-put-TextPrefix (list obj pre))
        (vl-catch-all-apply
          'vla-put-TextSuffix (list obj suf))

        (setq i (1+ i))
      )
      (princ
        (strcat
          "\nHotovo. Prefix = \"" pre "\" a suffix = \""
          suf "\" boli nastavene na "
          (itoa (sslength ss))
          " kot."
        )
      )
    )
    (prompt "\nNeboli vybrane ziadne koty.")
  )

  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nOblique_dimension.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;