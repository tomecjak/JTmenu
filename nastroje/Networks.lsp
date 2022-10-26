(defun c:Siete ()

(vl-load-com)

(vla-load
  (vla-get-linetypes (vla-get-activedocument (vlax-get-acad-object)))
  "201"
  "Linetypes.lin"
)
  
  (princ)
  
)

