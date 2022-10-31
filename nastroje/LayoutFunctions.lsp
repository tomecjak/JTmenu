;=========================================================================
; LayoutFunctions.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Zistenie mierol viewportov, zistenie poctu A4 layoutu
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                Zistenie poctu A4 vykresy v layoute                   ;;
;;----------------------------------------------------------------------;;

(defun c:JTSheetSize(/ ctr ss1)
  
  ;funkcia pre ziskanie rozmerov layoutu
  (GetPaperSize)
  
  ;funkcia pre ziskanie poctu A4
  (CountSheetA4)
  
  ;vytvorenie premennej s hodnotou poctu A4
  (setq LayoutA4 (* CountLayoutWidth HeightA4))
  (setq NumberOfA4 (strcat "Pocet A4 vykresu je: " (rtos LayoutA4 2 0) "xA4"))
  

  ;vlozenie udejov o pocete A4 do tagu POCETA4 bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "POCETA4" NumberOfA4 (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                Zistenie poctu a mierok viewportov                    ;;
;;----------------------------------------------------------------------;;

(defun C:JTSheetScale( / ssVP ListOfLayout cnt ListOfScale LayoutCountList ctr ss1)

  ;zistenie poctu viewportov nachadzajucich sa v layoute a vytvorenie listu
  (foreach X (layoutlist)
    (if (setq ssVP (ssget "_X" '((0 . "VIEWPORT")
                                  (-4 . "<AND")
                                    (-4 . "<NOT") (410 . "Model") (-4 . "NOT>")
                                    (-4 . ">") (69 . 1)
                                  (-4 . "AND>")
                                )))
      (repeat (setq cnt (sslength ssVP))
        (setq ListOfLayout (cons (ssname ssVP (setq cnt (1- cnt))) ListOfLayout))
      )
    )
  )
  
  ;zistenie poctu poloziek v ListOfLayout
  (setq LayoutListLength (length ListOfLayout))
  
  ;vytvorenie listu s hodnotami podla listu LayoutListLength
  (setq LayoutCaunt 0)
	(repeat LayoutListLength
    (setq LayoutCountList (cons LayoutCaunt LayoutCountList))
    (setq LayoutCaunt (1+ LayoutCaunt))
	)

  ;vytvorenie ListOfScale s mierkami jednotlivých layoutov
  (foreach i LayoutCountList
    (setq ListOfScale (cons (vla-get-CustomScale (vlax-ename->vla-object (nth i ListOfLayout))) ListOfScale))
  )

  ;vymazanie duplicitnych poloziek v ListOfScale
  (setq ListOfScale (ListDupliceRemote ListOfScale 1))
  
  ;zistenie poctu poloziek v ListOfScale
  (setq ListOfScaleLength (length ListOfScale))
  
  ;zoradanie ListOfScale od najvacieho a vymazanie duplicitnych poloziek
  (setq ListOfScale (vl-sort ListOfScale '<))
  
  ;vytvorenie premenych prvej az tretej mierky
  (setq ScaleN1 (nth 0 ListOfScale))
  (setq ScaleN2 (nth 1 ListOfScale))
  (setq ScaleN3 (nth 2 ListOfScale))
  
  ;vytvorenie premennej s hodnotou mierok
  (if (= ListOfScaleLength 1) 
    (setq ViewportScale (strcat "1:" (rtos (/ 1000 ScaleN1) 2 0)))
    (if (= ListOfScaleLength 2)
      (setq ViewportScale (strcat "1:" (rtos (/ 1000 ScaleN1) 2 0) ", 1:" (rtos (/ 1000 ScaleN2) 2 0)))
      (setq ViewportScale (strcat "1:" (rtos (/ 1000 ScaleN1) 2 0) ", 1:" (rtos (/ 1000 ScaleN2) 2 0) ", 1:" (rtos (/ 1000 ScaleN3) 2 0)))
      )
    )
  
  ;vlozenie udejov o mierke do tagu MIERKA bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "MIERKA" ViewportScale (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota

  (princ)

)

;;----------------------------------------------------------------------;;
;;                Premenovanie layoutu podla rozmeru                    ;;
;;----------------------------------------------------------------------;;

(defun c:JTSheetRename()
  
;funkcia pre ziskanie rozmerov layoutu
(GetPaperSize)
  
;funkcia pre ziskanie poctu A4
(CountSheetA4)
  
;vytvorenie premennej s hodnotou poctu A4
(setq LayoutA4 (* CountLayoutWidth HeightA4))
  
(setq SheetName (strcat (rtos LayoutHeight 2 0) "x" (rtos LayoutWidth 2 0) "_" (rtos LayoutA4 2 0) "xA4"))

(command "layout" "rename" "" SheetName)

(setvar "cmdecho" 1)
  
(princ)
  
)

;;----------------------------------------------------------------------;;
;;       Pomocna funkcia pre zistenie vysky a dlzky layoutu             ;;
;;----------------------------------------------------------------------;;

(defun GetPaperSize()
  
  (vl-load-com)

  (setq LayoutSice (vla-get-activelayout (vla-get-activedocument (vlax-get-acad-object))))
  (setq PaperSize (vla-getpapersize LayoutSice 'LayoutHeight 'LayoutWidth))

)

;;----------------------------------------------------------------------;;
;;              Pomocna funkcia pre vypocet poctu A4                    ;;
;;----------------------------------------------------------------------;;

(defun CountSheetA4()

  ;predelenie dlzky a vysky layoutu na pocet A4
  (setq CountLayoutHeight (/ LayoutHeight 297))
  (setq CountLayoutWidth (/ LayoutWidth 210))
  
  ;priradenie poctu A4 na vysku layoutu
  (if (<= CountLayoutHeight 1)
    (setq HeightA4 1)
      (if (<= CountLayoutHeight 2)
        (setq HeightA4 2)
          (if (<= CountLayoutHeight 3)
            (setq HeightA4 3)
          )
      )
  )

)

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

;;----------------------------------------------------------------------;;
;;     Pomocna funkcia pre vymazanie duplicitnych poloziek s listu      ;;
;;----------------------------------------------------------------------;;

(defun ListDupliceRemote (In_List FuzFac / Out_List NthVal Countr)
  (setq Out_List (list (car In_List)) In_List (cdr In_List))
  (reverse
    (foreach ForElm In_List
      (if (vl-position ForElm Out_List)
        Out_List
        (progn
          (setq Countr 0)
          (while (and Countr (setq NthVal (nth Countr Out_List)))
            (if (equal ForElm NthVal FuzFac)
              (setq Countr nil)
              (setq Countr (1+ Countr))
            )
          )
          (if NthVal
             Out_List
            (setq Out_List (cons ForElm Out_List))
          )
        )
      )
    )
  )
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nLayoutFunctions.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
