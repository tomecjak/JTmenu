(defun c:testtest(/ ctr ss1)
  
  (GetPaperSize)
  
  (setq CountLayoutHeight (/ LayoutHeight 297))
  (setq CountLayoutWidth (/ LayoutWidth 210))
  
  (if (<= CountLayoutHeight 1)
    (setq HeightA4 1)
      (if (<= CountLayoutHeight 2)
        (setq HeightA4 2)
          (if (<= CountLayoutHeight 3)
            (setq HeightA4 3)
          )
      )
  )
  
  (setq LayoutA4 (* CountLayoutWidth HeightA4))
  (setq NumberOfA4 (strcat "Pocet A4 vykresu je: " (rtos LayoutA4 2 0) "xA4"))
  
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "POCETA4" NumberOfA4 (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  (princ)
  

)


(defun GetPaperSize()
  
  (vl-load-com)

  (setq LayoutSice (vla-get-activelayout (vla-get-activedocument (vlax-get-acad-object))))
  (setq PaperSize (vla-getpapersize LayoutSice 'LayoutHeight 'LayoutWidth))

)





(defun BlockTagEditor  (TagName TagValue BlockName / etdata)
  (mapcar '(lambda (x)
             (while (/= "SEQEND" (cdr (assoc 0 (setq etdata (entget (setq x (entnext x)))))))
               (and (= (cdr (assoc 0 etdata)) "ATTRIB")
                    (mapcar '(lambda (x y)
                               (and (= x (cdr (assoc 2 etdata))) (entmod (subst (cons 1 y) (assoc 1 etdata) etdata))))
                            (list TagName)
                            (list TagValue)))))
          (mapcar 'cadr (ssnamex (ssget "_x" (list '(0 . "insert") (assoc 2 (entget BlockName)) '(66 . 1))))))
)

(defun C:mierka()

(if
  (setq ss (ssget ":E:S" '((0 . "VIEWPORT"))))
  (princ ss)
  (vla-get-CustomScale (vlax-ename->vla-object (ssname ss 0)))
  )

)

(Defun C:test22( / ssVP vpList cnt)

  (foreach X (layoutlist)
  (if (setq ssVP (ssget "_X" '((0 . "VIEWPORT")
                                (-4 . "<AND")
                                  (-4 . "<NOT") (410 . "Model") (-4 . "NOT>")
                                  (-4 . ">") (69 . 1)
                                (-4 . "AND>")
                              )));list/ssget/setq
    (repeat (setq cnt (sslength ssVP))
      (setq vpList (cons (ssname ssVP (setq cnt (1- cnt))) vpList))
    );repeat
  );if
    )
  
  ;(princ vpList)
  
  
  
  (setq XxX (nth 0 vpList))  
  (vla-get-CustomScale (vlax-ename->vla-object XxX))
  


)