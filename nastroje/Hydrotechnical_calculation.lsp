;=========================================================================
; Hydrotechnical_calculation.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.9 beta
;
; Hydrotechnicky vypocet koryta pre storocnu vodu (Q100) podla xxx
;-------------------------------------------------------------------------


(defun c:div3 (/ e)
 (if (and (setq e (car (entsel "\nPick line..\n")))
   (vlax-property-available-p (setq e (vlax-ename->vla-object e)) 'length)
   ) 
   (princ (rtos (vla-get-length e)2 3))
   (princ "\noops.. ")
   ) 
 (princ) 
 ) 
(vl-load-com)

(defun c:div4 (/ a)
 (if (and (setq a (car (entsel "\nPick line..\n")))
   (vlax-property-available-p (setq a (vlax-ename->vla-object a)) 'area)
   ) 
   (princ (rtos (vla-get-area a)2 3))
   (princ "\noops.. ")
   ) 
 (princ) 
 ) 
(vl-load-com)




;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;