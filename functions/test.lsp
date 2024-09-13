(defun c:test()
  
(vl-load-com)
  


(setq VyberBloku (nentsel "Vyberte rozpisku:" ))
  
  
(setq BlockName (strcat "Zrusene " (vla-get-effectivename (vlax-ename->vla-object (car (last VyberBloku))))))

  

  

(setq Tmatrix (nth 2 VyberBloku))
(setq blk_pt (nth 3 Tmatrix))
(setq ang (/ (* 180.0 (angle '(0 0 0) (nth 0 Tmatrix))) pi))
(setq xscale (nth 0 blk_pt))
(setq yscale (nth 1 blk_pt))
(princ xscale)
(princ yscale)  


(command "._insert" "KrizikDopravnehoZnacenia" (strcat (rtos xscale 2 2) "," (rtos yscale 2 2)) (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) ang pause)

    ;vlozenie udejov do tagu VYPRACOVAL bloku Rozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "KrizikDopravnehoZnacenia")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "ZRUSENE_DZ" BlockName (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
)

(defun EffectiveName (en / ed d1 d2 d3 br)
 (setq ed (entget en))
 (setq d1 (entget (cdr (assoc 360 (member '(102 . "{ACAD_XDICTIONARY") ed)))))
 (setq d2 (entget (cdr (assoc 360 (member '(3 . "AcDbBlockRepresentation") d1)))))
 (setq d3 (entget (cdr (assoc 360 (member '(3 . "AcDbRepData") d2)))))
 (setq br (entget (cdr (assoc 340 d3))))
 (cdr (assoc 2 br))
)  



(defun c:test2()
  
(setq signBlocksScale (getstring "Mierka dopravneho znacenia 1:"))

(setenv "GlobalnaSignBlocksScale" signBlocksScale)
  
    ;hlaska o nastavenych parametroch
  (princ (strcat "\nNastavily ste mierku 1:" (getenv "GlobalnaSignBlocksScale") " pre vkladane bloky dopravneho znacenia!"))
  
  (princ)

)

 (defun c:GetBlkName  (/ ent)
(vl-load-com)
     (cond
           ((and
                  (setq ent (car (entsel "\nSelect Block Entity: ")))
                  (eq (cdr (assoc 0 (entget ent))) "INSERT")
                  (alert (strcat "Block Name:"
                                 (vla-get-effectivename
                                       (vlax-ename->vla-object ent)))))
            )))


;;----------------------------------------------------------------------;;
;;       Pomocna funkcia pre vkladanie udajov do tagov blokov           ;;
;;----------------------------------------------------------------------;;

(defun BlockTagEditor  (TagName TagValue BlockName / etdata)
    
  (mapcar '(lambda (x)
             (while (/= "SEQEND" (cdr (assoc 0 (setq etdata (entget (setq x (entnext x)))))))
               (and (= (cdr (assoc 0 etdata)) "ATTRIB")
                    (mapcar '(lambda (x y)
                               (and (= x (cdr (assoc 2 etdata))) (entmod (subst (cons 1 y) (assoc 1 etdata) etdata))))
                            (list TagName)
                            (list TagValue))))
           )
           
          (mapcar 'cadr (ssnamex (ssget "_x" (list '(0 . "insert") (assoc 2 (entget BlockName)) '(66 . 1)))))
  )
  
)




(defun c:test3()
  
  
(vl-load-com)

(LM:setdynpropvalue (vlax-ename->vla-object (car (entsel))) "OBJEKT" xxx)

)

(defun LM:setdynpropvalue ( blk prp val )
    (setq prp (strcase prp))
    (vl-some
       '(lambda ( x )
            (if (= prp (strcase (vla-get-propertyname x)))
                (progn
                    (vla-put-value x (vlax-make-variant val (vlax-variant-type (vla-get-value x))))
                    (cond (val) (t))
                )
            )
        )
        (vlax-invoke blk 'getdynamicblockproperties)
    )
)