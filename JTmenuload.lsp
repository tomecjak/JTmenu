;=========================================================================
; Autoload JTmenu.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.1
;-------------------------------------------------------------------------

(if (not(menugroup "JTMENU"))(command "_CUILOAD" (findfile "JTmenu.cuix")))(princ)