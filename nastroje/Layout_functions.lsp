;=========================================================================
; LayoutFunctions.lsp
; (c) Copyright 2022 Tomecko Jakub
;
; Zistenie mierol viewportov, zistenie poctu A4 layoutu
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                Zistenie poctu A4 vykresy v layoute                   ;;
;;----------------------------------------------------------------------;;

(defun JTSheetSize(/ ctr ss1)
  
  ;funkcia pre ziskanie rozmerov layoutu
  (GetPaperSize)
  
  ;funkcia pre ziskanie poctu A4
  (CountSheetA4)
  
  ;vytvorenie premennej s hodnotou poctu A4
  (setq LayoutA4 (* CountLayoutWidth HeightA4))
  (setq NumberOfA4 (strcat (rtos LayoutA4 2 0) "xA4"))
  

  ;vlozenie udejov o pocte A4 do tagu POCETA4 bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "FORMAT" NumberOfA4 (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                Zistenie poctu a mierok viewportov                    ;;
;;----------------------------------------------------------------------;;

(defun JTSheetScale( / ssVP ListOfLayout cnt ListOfScale LayoutCountList ctr ss1)

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

(defun JTSheetRename()
  
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

(defun c:DPRozpiska (/ ctr ss1)
  
  ;ak existuje rozpiska, skopiruj jej tag hodnoty
  (if (setq ss (ssget "X" '((2 . "DPRozpiska"))))
    (RospiskaTagsDown)
  )
  
  ;vymazanie bloku DPRozpiska
  (BlockDelete "DPRozpiska")
  
  ;ziskanie rozmeru Layoutu
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
  
  ;vlozenie hodnout do tagu rozpisky
  (RospiskaTagsUp)

  ;navrat na predchadzajucu hladiny a nastavenie skupiny hladiny na "All"
  (NavratNaPoslednuHladinu)
  
  ;hlaska po skonceni programu
  (princ "\nRozpiska bola vlozena do vykresu. ")
  (princ)
  
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
;;         Pomocne funkcie pre citanie a zapis hodnot Rozpisky          ;;
;;----------------------------------------------------------------------;;

(defun RospiskaTagsDown ()
  ;vytvorenie premennej a zapis hodnoty tagu rospisky
  (setq RozpiskaTagVypracoval (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "VYPRACOVAL"))
  (setq RozpiskaTagZop (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "ZOP"))
  (setq RozpiskaTagHip (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "HIP"))
  (setq RozpiskaTagKontroloval (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "KONTROLOVAL"))
  (setq RozpiskaTagOkresStavby (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "OKRES_STAVBY"))
  (setq RozpiskaTagObjednavatel (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "OBJEDNAVATEL"))
  (setq RozpiskaTagStupen (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "STUPEN"))
  (setq RozpiskaTagFormat (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "FORMAT"))
  (setq RozpiskaTagCisloZakazky (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "CISLO_ZAKAZKY"))
  (setq RozpiskaTagDatum (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "DATUM"))
  (setq RozpiskaTagMierka (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "MIERKA"))
  (setq RozpiskaTagCisloArchivne (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "CISLO_ARCHIVNE"))
  (setq RozpiskaTagObjekt (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "OBJEKT"))
  (setq RozpiskaTagNazovVykresu (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "NAZOV_VYKRESU"))
  (setq RozpiskaTagNazovZakazky (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "NAZOV_ZAKAZKY"))
  (setq RozpiskaTagCisloVykresu (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "CISLO_VYKRESU"))
  (setq RozpiskaTagCisloObjektu (getpropertyvalue (ssname (ssget "_X" '((0 . "INSERT") (2 . "DPRozpiska"))) 0) "CISLO_OBJEKTU"))
)

(defun RospiskaTagsUp (/ ctr ss1)
  ;vlozenie udejov do tagu VYPRACOVAL bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "VYPRACOVAL" RozpiskaTagVypracoval (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu ZOP bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "ZOP" RozpiskaTagZop (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu HIP bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "HIP" RozpiskaTagHip (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu KONTROLOVAL bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "KONTROLOVAL" RozpiskaTagKontroloval (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu OKRES_STAVBY bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "OKRES_STAVBY" RozpiskaTagOkresStavby (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu OBJEDNAVATEL bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "OBJEDNAVATEL" RozpiskaTagObjednavatel (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu STUPEN bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "STUPEN" RozpiskaTagStupen (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu FORMAT bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "FORMAT" RozpiskaTagFormat (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu CISLO_ZAKAZKY bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "CISLO_ZAKAZKY" RozpiskaTagCisloZakazky (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu DATUM bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "DATUM" RozpiskaTagDatum (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu MIERKA bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "MIERKA" RozpiskaTagMierka (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu CISLO_ARCHIVNE bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "CISLO_ARCHIVNE" RozpiskaTagCisloArchivne (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu OBJEKT bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "OBJEKT" RozpiskaTagObjekt (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu NAZOV_VYKRESU bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "NAZOV_VYKRESU" RozpiskaTagNazovVykresu (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu NAZOV_ZAKAZKY bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "NAZOV_ZAKAZKY" RozpiskaTagNazovZakazky (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu CISLO_VYKRESU bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "CISLO_VYKRESU" RozpiskaTagCisloVykresu (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udejov do tagu CISLO_OBJEKTU bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "CISLO_OBJEKTU" RozpiskaTagCisloObjektu (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
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
;;          Pomocna funkcia pre pre zistenie cisla objektu              ;;
;;----------------------------------------------------------------------;;


(defun JTObjectNumber (/ ctr ss1)

  ;nastavenie premenej nazvu dwg
  (setq NazovDWG (getvar "dwgname"))
  
  ;nastavenie premenej cisla objektu
  (setq CisloObjektu (substr NazovDWG 1 6))
  
  ;vlozenie udejov o cisle objektu do tagu CISLO_OBJEKTU bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "CISLO_OBJEKTU" CisloObjektu (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;            Pomocna funkcia pre zistenie cisla vykresu                ;;
;;----------------------------------------------------------------------;;

(defun JTSheetNumber (/ ctr ss1)

  ;nastavenie premenej nazvu dwg
  (setq NazovDWG (getvar "dwgname"))
  
  ;nastavenie premenej cisla vykresu
  (setq CisloVykresu (substr NazovDWG 8 (+ 2 FormatovanieCislovaniaPosun)))

  
  ;vlozenie udejov o cisle vykresu do tagu CISLO_VYKRESU bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "CISLO_VYKRESU" CisloVykresu (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;             Pomocna funkcia pre zistenie nazvu vykresu               ;;
;;----------------------------------------------------------------------;;

(defun JTSheetName (/ ctr ss1)

  ;nastavenie premenej nazvu dwg
  (if (= vykresNazovUppercase "0")
    (setq NazovDWG (getvar "dwgname"))
    (setq NazovDWG (strcase (getvar "dwgname")))
  )
  
  ;zistenie poctu pismen v prvku
  (if (= (getenv "GlobalnyFormatCislaVykresu") "0")
    (setq DlzkaNazvuDWG (- (strlen NazovDWG) 14))
    (setq DlzkaNazvuDWG (- (strlen NazovDWG) 15))
  )
  
  ;nastavenie premenej nazvu vykresu
  (setq NazovVykresu (substr NazovDWG (+ 11 FormatovanieCislovaniaPosun) DlzkaNazvuDWG))
  
  ;vlozenie udejov onazve vykresu do tagu NAZOV_VYKRESU bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "NAZOV_VYKRESU" NazovVykresu (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;                  Hlavna funkcia JTTitleBlockUpdate                   ;;
;;----------------------------------------------------------------------;;

(defun c:JTTitleBlockUpdate ()
  
  ;ukoncenie programu ak nieje vykres este ulozeny + hlaska
  (if (= (getvar "dwgtitled") 0)
    (progn
      (princ "\nSubor je potrebne najprv ulozit!\n")
      (exit)
    )
  )

  ;nastavenie cesty do korenoveho adresara vykresu
  (setq CestaPlnaSuboru (findfile (getvar "dwgname")))
  (setq CestaNazovSuboru (getvar "dwgname"))
  (setq CestaSkratenaSuboru (substr CestaPlnaSuboru 1 (- (strlen CestaPlnaSuboru) (strlen CestaNazovSuboru))))
  (setq CestaTitleBlockData (strcat CestaSkratenaSuboru "TitleBlockData.dat"))
  
  ;definovanie listu formatu cisla vykresu
  (setq CisloFormatList (list "01" "001"))
  
  ;nacitanie dialogoveho okna
  (setq dcl_id (load_dialog "Layout_update.dcl"))
  
  ;test existenice dialogu
  (if (not (new_dialog "Layout_update" dcl_id))
    (exit)
  )
  
  ;spustenie a naplnenie listu formatok
  (start_list "formatCislovania")
  (mapcar 'add_list CisloFormatList)
  (end_list)
  
  ;nastavenie prepinaca formatu cislovania vykresu
  (if (= (getenv "GlobalnyFormatCislaVykresu") "0")
    ;splnena podmienka
    (set_tile "formatCislovania" "0")
    ;nesplnena podmienka
    (set_tile "formatCislovania" "1")
  )
  
  ;nastavenie mena vyhotovotela vykresu
  (if (= (getenv "GlobalneVyhotovilVykres") "Meno")
    ;splnena podmienka
    (set_tile "vykresVypracoval" "Meno")
    ;nesplnena podmienka
    (set_tile "vykresVypracoval" (getenv "GlobalneVyhotovilVykres"))
  )
  
  ;podmienka ak neexistuje subor TitleBlockData.dat
  (if (= (open CestaTitleBlockData "r") nil)
    ;nastavenie oznamovacej hlasky
    (set_tile "oznamovaciaHlaska" "Data nenacitane, ulozte data pomoccou \"Ulozit\"")
    (progn
      ;nastavenie oznamovacie hlasky
      (set_tile "oznamovaciaHlaska" "Data uspesne nacitane.")
      ;nacitanie udajov zo suboru TitleBlockData.dat
      (setq file (open CestaTitleBlockData "r"))
      (set_tile "vykresZodpovednyProjektant" (read-line file))
      (set_tile "vykresHlavnyInzinierProjektu" (read-line file))
      (set_tile "vykresKontroloval" (read-line file))
      (set_tile "vykresOkresStavby" (read-line file))
      (set_tile "vykresObjednavatel" (read-line file))
      (set_tile "vykresNazovZakazky" (read-line file))
      (set_tile "vykresNazovObjektu" (read-line file))
      (set_tile "vykresArchivneCislo" (read-line file))
      (set_tile "vykresStupenDokumentacie" (read-line file))
      (set_tile "vykresDatum" (read-line file))
      (set_tile "vykresCisloZakzky" (read-line file))
      (close file)
    )  
  )
    
  ;definovanie tlacidla oznacit vsetko
  (action_tile "oznacitVsetko"
    "(OznacitVsetkoFunkcia)"
  )
  
  ;definovanie tlacidla odznacit vsekto
  (action_tile "odznacitVsetko"
    "(OdznacitVsetkoFunkcia)"
  )
  
  ;definovanie tlacidla ulozit
  (action_tile "ulozitUdajeRozpisky"
    "(UlozitDataRozpisky)"
  )
  
  ;definovanie tlacidla cancel 
  (action_tile "cancel"
    "(done_dialog)(exit)"
  )
  
  ;definovanie tlacitla aktualizovat
  (action_tile "aktualizovat"
    "(LayoutSettingAktualizacia)(done_dialog)"
  )
  
  ;spustenie dialogu
  (start_dialog)
  
  ;unload dialogu
  (unload_dialog dcl_id)
  
  ;spustenie jednotlivych funkcii po zavreti dialogoveho okna
  (if (= formatCislovaniaVyber "1")
    (setenv "GlobalnyFormatCislaVykresu" "1")
    (setenv "GlobalnyFormatCislaVykresu" "0")
  )
  
   (if (= formatCislovaniaVyber "1")
    (setq FormatovanieCislovaniaPosun 1)
    (setq FormatovanieCislovaniaPosun 0)
  )
  
  (if (/= vykresVypracoval "Meno")
    (setenv "GlobalneVyhotovilVykres" vykresVypracoval)
    (setenv "GlobalneVyhotovilVykres" "Meno")
  )
  
  ;aktualizacia cisla objektu
  (if (= cisloObjektu "1")
    (JTObjectNumber)
  )
  ;aktualizacia velkosti vykresu
  (if (= velkostVykresu "1")
    (JTSheetSize)
  )
  ;aktualizacia mierky vykresu
  (if (= mierkaVykresu "1")
    (JTSheetScale)
  )
  ;aktualizacia nazov vykresu
  (if (= nazovVykresu "1")
    (JTSheetName)
  )
  ;aktualizacia cislo vykresu
  (if (= cisloVykresu "1")
    (JTSheetNumber)
  )
  ;aktualizacia vyhotovil
  (if (= vykresVypracovalAktualizacia "1")
    (JTSheetCreate)
  )
  ;aktualizacia premenovanie layoutu
  (if (= layoutRename "1")
    (JTSheetRename)
  )
  ;aktualizacia externych udajov rozpisky
  (if (= vykresExterneDataAktualizovat "1")
    (JTUpdateRozpiska)
  )
  
  (princ)

)

;funkcia tlacidla oznacit vsetko
(defun OznacitVsetkoFunkcia ()
  (set_tile "cisloObjektu" "1")
  (set_tile "velkostVykresu" "1")
  (set_tile "mierkaVykresu" "1")
  (set_tile "nazovVykresu" "1")
  (set_tile "cisloVykresu" "1")
  (set_tile "vykresVypracovalAktualizacia" "1")
  (set_tile "vykresNazovUppercase" "1")
  (set_tile "layoutRename" "1")
  (set_tile "zakazkaNazovUppercase" "1")
  (set_tile "vykresExterneDataAktualizovat" "1")
)

;funkcia tlacidla odznacit vsetko
(defun OdznacitVsetkoFunkcia ()
  (set_tile "cisloObjektu" "0")
  (set_tile "velkostVykresu" "0")
  (set_tile "mierkaVykresu" "0")
  (set_tile "nazovVykresu" "0")
  (set_tile "cisloVykresu" "0")
  (set_tile "vykresVypracovalAktualizacia" "0")
  (set_tile "vykresNazovUppercase" "0")
  (set_tile "layoutRename" "0")
  (set_tile "zakazkaNazovUppercase" "0")
  (set_tile "vykresExterneDataAktualizovat" "0")
)

;funkcia tlacidla aktualizovat
(defun LayoutSettingAktualizacia ()
  ;definovanie premenych pre vyhodnotenie
  (setq cisloObjektu (get_tile "cisloObjektu"))
  (setq velkostVykresu (get_tile "velkostVykresu"))
  (setq mierkaVykresu (get_tile "mierkaVykresu"))
  (setq nazovVykresu (get_tile "nazovVykresu"))
  (setq cisloVykresu (get_tile "cisloVykresu"))
  (setq formatCislovaniaVyber (get_tile "formatCislovania"))
  (setq vykresVypracoval (get_tile "vykresVypracoval"))
  (setq vykresVypracovalAktualizacia (get_tile "vykresVypracovalAktualizacia"))
  (setq vykresNazovUppercase (get_tile "vykresNazovUppercase"))
  (setq layoutRename (get_tile "layoutRename"))
  ;definovnaie premenych pre vyhodnotenie z externeho uloziska
  (setq vykresExterneDataAktualizovat (get_tile "vykresExterneDataAktualizovat"))
  (setq vykresZodpovednyProjektant (get_tile "vykresZodpovednyProjektant"))
  (setq vykresHlavnyInzinierProjektu (get_tile "vykresHlavnyInzinierProjektu"))
  (setq vykresKontroloval (get_tile "vykresKontroloval"))
  (setq vykresOkresStavby (get_tile "vykresOkresStavby"))
  (setq vykresObjednavatel (get_tile "vykresObjednavatel"))
  (setq vykresNazovZakazky (get_tile "vykresNazovZakazky"))
  (setq vykresNazovObjektu (get_tile "vykresNazovObjektu"))
  (setq vykresArchivneCislo (get_tile "vykresArchivneCislo"))
  (setq vykresStupenDokumentacie (get_tile "vykresStupenDokumentacie"))
  (setq vykresDatum (get_tile "vykresDatum"))
  (setq vykresCisloZakzky (get_tile "vykresCisloZakzky"))
  ;spojenie cisla objektu a nazvu objektu
  (setq cisloObjektuAvykresNazovObjektu (strcat (substr (getvar "dwgname") 1 6) " " vykresNazovObjektu))
)

(defun JTSheetCreate ()
  ;vlozenie udajov o mene vyhotovil do tagu VYPRACOVAL bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "VYPRACOVAL" (getenv "GlobalneVyhotovilVykres") (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
(princ)
)

(defun JTUpdateRozpiska ()
  ;vlozenie udajov o mene vyhotovil do tagu ZOP bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "ZOP" vykresZodpovednyProjektant (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu HIP bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "HIP" vykresHlavnyInzinierProjektu (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu KONTROLOVAL bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "KONTROLOVAL" vykresKontroloval (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu OKRES_STAVBY bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "OKRES_STAVBY" vykresOkresStavby (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu OBJEDNAVATEL bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "OBJEDNAVATEL" vykresObjednavatel (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu NAZOV_ZAKAZKY bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "NAZOV_ZAKAZKY" vykresNazovZakazky (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu OBJEKT bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "OBJEKT" cisloObjektuAvykresNazovObjektu (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu CISLO_ARCHIVNE bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "CISLO_ARCHIVNE" vykresArchivneCislo (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu STUPEN bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "STUPEN" vykresStupenDokumentacie (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu DATUM bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "DATUM" vykresDatum (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  ;vlozenie udajov o mene vyhotovil do tagu CISLO_ZAKAZKY bloku DPRozpiska
  (setq ctr 0
    ss1 (ssget "_x" '((0 . "insert") (2 . "DPRozpiska")))) ;nazov bloku
  (repeat (sslength ss1) (BlockTagEditor "CISLO_ZAKAZKY" vykresCisloZakzky (ssname ss1 ctr)) (setq ctr (1+ ctr))) ; nazov tagu a jeho hodnota
  
  (princ)

)

;funkcie pre tlacidlo Ulozit
(defun UlozitDataRozpisky()
  ;definovanie premenych
  (setq vykresZodpovednyProjektant (get_tile "vykresZodpovednyProjektant"))
  (setq vykresHlavnyInzinierProjektu (get_tile "vykresHlavnyInzinierProjektu"))
  (setq vykresKontroloval (get_tile "vykresKontroloval"))
  (setq vykresOkresStavby (get_tile "vykresOkresStavby"))
  (setq vykresObjednavatel (get_tile "vykresObjednavatel"))
  (setq vykresNazovZakazky (get_tile "vykresNazovZakazky"))
  (setq vykresNazovObjektu (get_tile "vykresNazovObjektu"))
  (setq vykresArchivneCislo (get_tile "vykresArchivneCislo"))
  (setq vykresStupenDokumentacie (get_tile "vykresStupenDokumentacie"))
  (setq vykresDatum (get_tile "vykresDatum"))
  (setq vykresCisloZakzky (get_tile "vykresCisloZakzky"))
  
  ;ulozenie udajov do suboru TitleBlockData.dat
  (setq file (open CestaTitleBlockData "w"))
  (write-line vykresZodpovednyProjektant file)
  (write-line vykresHlavnyInzinierProjektu file)
  (write-line vykresKontroloval file)
  (write-line vykresOkresStavby file)
  (write-line vykresObjednavatel file)
  (write-line vykresNazovZakazky file)
  (write-line vykresNazovObjektu file)
  (write-line vykresArchivneCislo file)
  (write-line vykresStupenDokumentacie file)
  (write-line vykresDatum file)
  (write-line vykresCisloZakzky file)
  (close file)
  
  ;nastavenie oznamovacie hlasky
  (set_tile "oznamovaciaHlaska" "Data uspesne ulozene.")
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