;=========================================================================
; Rebar_function_orchester.lsp
; Create by Jakub Tomecko
;
; Orchester pre funkcie vystuzovania
;-------------------------------------------------------------------------

(defun c:JTRebarFillet()
  (load "Rebar_functions")
  (load "Rebar_functions_layer")
  ;nastavenie prepinaca modov vystozovania
  (if (= (getenv "GlobalnaRebarType") "Layer")
    ;splnena podmienka
    (c:JTRebarFilletLayer)
    ;nesplnena podmienka
    (c:JTRebarFilletPolyline)
  )
  
)

(defun c:JTRebarWrite()
  (load "Rebar_functions")
  (load "Rebar_functions_layer")
  ;nastavenie prepinaca modov vystozovania
  (if (= (getenv "GlobalnaRebarType") "Layer")
    ;splnena podmienka
    (c:JTRebarWriteLayer)
    ;nesplnena podmienka
    (c:JTRebarWritePolyline)
  )
  
)

(defun c:JTRebarOffset()
  (load "Rebar_functions")
  (load "Rebar_functions_layer")
  ;nastavenie prepinaca modov vystozovania
  (if (= (getenv "GlobalnaRebarType") "Layer")
    ;splnena podmienka
    (c:JTRebarOffsetLayer)
    ;nesplnena podmienka
    (c:JTRebarOffsetPolyline)
  )
  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nRebar_function_orchester.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;