(defun c:testtest()
  
  (vl-load-com)

(setq lay (vla-get-activelayout (vla-get-activedocument (vlax-get-acad-object))))
(setq papersize (vla-getpapersize lay 'w 'h))
(print (strcat 'w))


)