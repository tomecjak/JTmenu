;=========================================================================
; JTmenuload.lsp - Bundle loader  
; (c) Copyright 2023 Tomecko Jakub
;-------------------------------------------------------------------------
(vl-load-com)

(defun jt:load-menu ( / cuix-path src)
  ;; *load-path* obsahuje cestu k aktuálne načítavanému súboru
  (setq src      (vl-filename-directory (car (vl-bb-ref '*load-path*)))
        cuix-path (strcat src "JTMenu.cuix"))
  (if (not (menugroup "JTMENU"))
    (if (findfile cuix-path)
      (command "_CUILOAD" cuix-path)
      ;; fallback - skús findfile v support path (pre manuálne spustenie)
      (if (findfile "JTMenu.cuix")
        (command "_CUILOAD" (findfile "JTMenu.cuix"))
        (princ "\nJTmenu WARNING: JTMenu.cuix nebol najdeny!")
      )
    )
  )
)

(jt:load-menu)
(princ)