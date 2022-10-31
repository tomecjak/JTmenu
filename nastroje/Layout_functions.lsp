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
  (setq NumberOfA4 (strcat (rtos LayoutA4 2 0) "xA4"))
  

  ;vlozenie udejov o pocete A4 do tagu POCETA4 bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "FORMAT" NumberOfA4 (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
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

  (if (= LayoutListLength 0)
    ;hlaska o neexistujucom viewporte
    (princ "Vo vykresy nie su ziadne viewporty!")
      (if (> LayoutListLength 1)
        ;vymazanie duplicitnych poloziek v ListOfScale
        (setq ListOfScale (ListDupliceRemote ListOfScale 1))
      )
  )
  
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
;;                     Vlozenie rozpisky do layoutu                     ;;
;;----------------------------------------------------------------------;;

(defun c:DPRozpiska ()
  
  (GetPaperSize)
    
  ;vytvorenie premenej VytvorenieHladinyPopisu pre vyber hladiny pre vlozene bloky
  (setq VytvorenieHladinyPopisu
    (getenv "GlobalnaHladinaBlokov")
  )
  
  ;vyhodnotenie vyberu hladiny pre bloky
  (if (= VytvorenieHladinyPopisu "DP_Popis")
    ;vytvorenie a nastavenie hladinu na DP_Popis
    (SetLayer)
  
    (if (= VytvorenieHladinyPopisu "0")
      ;bez vytvorenia hladiny a nastavenie na hladinu 0
      (command "._layer" "s" "0" "")
      (princ)
    )
  )
  
  ;nastavenie funkcnosti prikazu len v Layoute
  (cond
    ((/= 1 (getvar 'cvport))
      (princ "\nPrikaz nie je dostupny v modelovom priestore.")
      (princ)
    )
    
    (
      ;prikaz na vlozenie blocku rozpisky
      (command "_insert" "DPRozpiska" (strcat (rtos LayoutWidth 2 0) ",0") 1 1 0 0)
    )
  )
  
  ;hlaska po skonceni programu
  (princ "\nRozpiska bola vlozena do vykresu. ")
  (princ)
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
)

;;----------------------------------------------------------------------;;
;;                   Vlozenie krizikov do vykresu                       ;;
;;----------------------------------------------------------------------;;

(defun c:JTSheetCross (/ ctr ss1)
  
  ;vymazanie bloku DPKriziky
  (BlockDelete "DPKriziky")
  
  ;nacitanie velkosty Layoutu
  (GetPaperSize)
    
  ;vytvorenie premenej VytvorenieHladinyPopisu pre vyber hladiny pre vlozene bloky
  (setq VytvorenieHladinyPopisu
    (getenv "GlobalnaHladinaBlokov")
  )
  
  ;vyhodnotenie vyberu hladiny pre bloky
  (if (= VytvorenieHladinyPopisu "DP_Popis")
    ;vytvorenie a nastavenie hladinu na DP_Popis
    (SetLayer)
  
    (if (= VytvorenieHladinyPopisu "0")
      ;bez vytvorenia hladiny a nastavenie na hladinu 0
      (command "._layer" "s" "0" "")
      (princ)
    )
  )
  
  ;nastavenie funkcnosti prikazu len v Layoute
  (cond
    ((/= 1 (getvar 'cvport))
      (princ "\nPrikaz nie je dostupny v modelovom priestore.")
      (princ)
    )
    
    (
      ;prikaz na vlozenie blocku krizikov
      (command "_insert" "DPKriziky" "0,0" 1 1 0)
    )
  )
  
  ;nastavenie tagu DLZKA
  (LM:setdynpropvalue (vlax-ename->vla-object (entlast)) "DLZKA" LayoutWidth)
  ;nastavenie tagu VYSKA
  (LM:setdynpropvalue (vlax-ename->vla-object (entlast)) "VYSKA" LayoutHeight)
  
  ;hlaska po skonceni programu
  (princ "\nKriziky vykresu boli vlozene. ")
  (princ)
  
  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)

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
;;    Pomocna funkcia pre vkladanie ciselnych hodnoy do tagov blokov    ;;
;;----------------------------------------------------------------------;;

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

;;----------------------------------------------------------------------;;
;;                 Pomocna funkcia pre mazanie blokov                   ;;
;;----------------------------------------------------------------------;;

(defun BlockDelete (bname / bobj)
(vlax-for blk (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object)))
 (if (= bname (vla-get-name blk))
  (setq bObj blk)
  (progn
   (vlax-for ent blk
    (if (and (= "AcDbBlockReference" (vla-get-objectname ent))
       (or (= (vla-get-name ent) bname)
        (and (vlax-property-available-p ent 'effectivename)
         (= (vla-get-effectivename ent) bname)
        )
       )
     )
     (vla-delete ent)
    )
   )
  )
 )
)
(if bObj (vla-delete bObj))
(vla-Regen (vla-get-ActiveDocument (vlax-get-acad-object)) acAllViewports)
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
;;                Pomocne funkcie pre vytvorenie hladin                 ;;
;;----------------------------------------------------------------------;;

;funkcia pre vytvárania hladin v modeli Nazov + farba + typ ciary + hrubka ciary
(defun CreateLayers(lyrname Color ltype lweight)
  
  ;funkcia pre vytvorenie hladiny
  (if (tblsearch "LAYER" lyrname)
    (command "._Layer" "_Thaw" lyrname "_On" lyrname "_UnLock" lyrname "_Set" lyrname "")
    (command "._Layer" "_Make" lyrname "_Color"
      (if (or (null color)(= Color "")) "_White" Color)
      lyrname "LT" (if (or (null ltype)(= ltype "")) "Continuous" ltype)
      lyrname "LW" (if (or (null lweight)(= lweight "")) "default" lweight) lyrname ""
    )
  )

)

;funkcia pre nastavenie hladiny DP_Popis
(defun SetLayer()
  (CreateLayers "DP_Rozpiska" 7 "CONTINUOUS" "DEFAULT")
  ;nastavenie hladiny pre blok pomocou GlobalnaHladinaBlokov nastavena v Setting.lsp
  (command "._layer" "s" "DP_Rozpiska" "")
  
  ;vytvorenie group layer filtru DP Layers 
  (command "_.LAYER" "_FILTER" "_Delete" "DP Layers" "")
    (if (> (getvar 'CMDACTIVE) 0) (command ""))
  (command "_.LAYER" "_FILTER" "_New" "_Group" "All" "0,Defpoints,DP_*,NS_*" "DP Layers")
    (if (> (getvar 'CMDACTIVE) 0) (command "")) 
)

;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
(defun NavratNaPoslednuHladinu()

  (command "_.layerp")
  (command "_-layer" "_filter" "_set" "All" "")

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
