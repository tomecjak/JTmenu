;=========================================================================
; JTmenuload.lsp
; (c) Copyright 2023 Tomecko Jakub
;-------------------------------------------------------------------------

(if (not(menugroup "JTMENU"))(command "_CUILOAD" (findfile "JTmenu.cuix")))(princ)