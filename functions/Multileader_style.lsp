;=========================================================================
; Multileader_style.lsp
; Create by Jakub Tomecko
;
; Vytvorenie stylu multileadru
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;            Vytvorenie jednotlivych stylov multileadrov               ;;
;;----------------------------------------------------------------------;;

(defun c:JTMultileader()
  
  ;vytvorenie textoveho stylu DP_ISOCPEUR
  (TextStyleCreator)

  ;vyhodnotenie pouzitia stylu kot podla modu
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (msv_klasika)
    
      (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (msv_mierka)
      )
  )
  
  (princ "\nStyl multileadru bol vytvoreny!")
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Nastavenie multileadru - klasicky mod                  ;;
;;----------------------------------------------------------------------;;

(defun make_mleader_style_klasicky	(mleaderstylename
				 textcolor
				 leadercolor
				 /
				 adoc
				 mldrdict
				 newldrstyle
				 objcolor
				)
  (vl-load-com)
  (setq adoc (vla-get-activedocument (vlax-get-acad-object)))
  (setq	mldrdict
	 (vla-item (vla-get-dictionaries adoc) "ACAD_MLEADERSTYLE")
  )
  (setq	newldrstyle
	 (vlax-invoke
	   mldrdict
	   'addobject
	   mleaderstylename
	   "AcDbMLeaderStyle"
	 )
  )
  (setq	objcolor (vla-getinterfaceobject
		   (vlax-get-acad-object)
		   (strcat "AutoCAD.AcCmColor."
			   (substr (getvar "acadver") 1 2)
		   )
		 )
  )
  (vla-put-colorindex objcolor textcolor)
  (vla-put-textcolor newldrstyle objcolor)
  (vla-put-colorindex objcolor leadercolor)
  (vla-put-leaderlinecolor newldrstyle objcolor)


  (foreach item
	   (list
	     '("AlignSpace" 4)
	     (list
	       "ArrowSize"
	        (/ (vla-get-arrowsize (vla-item mldrdict "Standard"))
		       1.5
		    )
	     )
	     '("BitFlags" 0)
	     '("BlockConnectionType" 1)
	     '("BlockRotation" 0.0)
	     '("BlockScale" 1.0)
	     '("BreakSize" 0.05)
	     '("ContentType" 2)		;nastavenie mtextu
	     '("Description" "My Style Description")
	     '("DoglegLength" 0.1)
	     '("DrawLeaderOrderType" 0)
	     '("DrawMLeaderOrderType" 1)
	     '("EnableBlockRotation" -1)
	     '("EnableBlockScale" -1)
	     '("EnableDogleg" -1)
	     '("EnableFrameText" 0)
	     '("EnableLanding" -1)
	     '("FirstSegmentAngleConstraint" 0)
	     (list "LandingGap"
		   (/ (vla-get-landinggap (vla-item mldrdict "Standard")) 40)
	     )
	     '("LeaderLineType" 1)
	     '("LeaderLineTypeId" "ByBlock")
	     '("LeaderLineTypeId" "ByBlock")
	     '("LeaderLineWeight" -3)
	     '("MaxLeaderSegmentsPoints" 2)
	     '("ScaleFactor" 1.0)
	     '("SecondSegmentAngleConstraint" 0)
	     '("TextAlignmentType" 0)
	     '("TextAngleType" 0)
	     '("TextHeight" 0.125)
	     '("TextLeftAttachmentType" 4)
	     '("TextRightAttachmentType" 4)
	     '("TextString" "Default\\PText")
	     '("TextStyle" "DP_ISOCPEUR")
	   )

    (vlax-put newldrstyle (car item) (cadr item))
  )
  newldrstyle
)

;;----------------------------------------------------------------------;;
;;                Nastavenie multileadru - mierka mod                   ;;
;;----------------------------------------------------------------------;;

(defun make_mleader_style_mierka	(mleaderstylename
				 textcolor
				 leadercolor
				 /
				 adoc
				 mldrdict
				 newldrstyle
				 objcolor
				)
  (vl-load-com)
  (setq adoc (vla-get-activedocument (vlax-get-acad-object)))
  (setq	mldrdict
	 (vla-item (vla-get-dictionaries adoc) "ACAD_MLEADERSTYLE")
  )
  (setq	newldrstyle
	 (vlax-invoke
	   mldrdict
	   'addobject
	   mleaderstylename
	   "AcDbMLeaderStyle"
	 )
  )
  (setq	objcolor (vla-getinterfaceobject
		   (vlax-get-acad-object)
		   (strcat "AutoCAD.AcCmColor."
			   (substr (getvar "acadver") 1 2)
		   )
		 )
  )
  (vla-put-colorindex objcolor textcolor)
  (vla-put-textcolor newldrstyle objcolor)
  (vla-put-colorindex objcolor leadercolor)
  (vla-put-leaderlinecolor newldrstyle objcolor)


  (foreach item
	   (list
	     '("AlignSpace" 4)
	     (list
	       "ArrowSize"
	        (/ (vla-get-arrowsize (vla-item mldrdict "Standard"))
		       1.6
		    )
	     )
	     '("BitFlags" 0)
	     '("BlockConnectionType" 1)
	     '("BlockRotation" 0.0)
	     '("BlockScale" 1.0)
	     '("BreakSize" 1.0)
	     '("ContentType" 2)		;nastavenie mtextu
	     '("Description" "My Style Description")
	     '("DoglegLength" 2.0)
	     '("DrawLeaderOrderType" 0)
	     '("DrawMLeaderOrderType" 1)
	     '("EnableBlockRotation" -1)
	     '("EnableBlockScale" -1)
	     '("EnableDogleg" -1)
	     '("EnableFrameText" 0)
	     '("EnableLanding" -1)
	     '("FirstSegmentAngleConstraint" 0)
	     (list "LandingGap"
		   (/ (vla-get-landinggap (vla-item mldrdict "Standard")) 2)
	     )
	     '("LeaderLineType" 1)
	     '("LeaderLineTypeId" "ByBlock")
	     '("LeaderLineTypeId" "ByBlock")
	     '("LeaderLineWeight" -3)
	     '("MaxLeaderSegmentsPoints" 2)
	     '("ScaleFactor" 1.0)
	     '("SecondSegmentAngleConstraint" 0)
	     '("TextAlignmentType" 0)
	     '("TextAngleType" 0)
	     '("TextHeight" 2.5)
	     '("TextLeftAttachmentType" 4)
	     '("TextRightAttachmentType" 4)
	     '("TextString" "Default\\PText")
	     '("TextStyle" "DP_ISOCPEUR")
	   )

    (vlax-put newldrstyle (car item) (cadr item))
  )
  newldrstyle
)

;;----------------------------------------------------------------------;;
;;               Vytvorenie multileadru - klasicky mod                  ;;
;;----------------------------------------------------------------------;;

(defun msv_klasika (/ *error* ms)
  
  (vl-load-com)

  (defun *error* (msg)
    (command "_undo" "_e")

    (if	(and msg
	     (not (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*"))
	)
      (princ (strcat "\nError: " msg))
    ) 
    (princ)
  )
  (command "_undo" "_be")

  (if (vl-catch-all-error-p
	(vl-catch-all-apply
	  '(lambda ()
	     (setq ms (make_mleader_style_klasicky "DP_Multileader" 0 0))
	   )
	) 
      )
    (alert "Problem s vytvorenim stylu multileadru!")
    (setvar "CMLEADERSTYLE" "DP_Multileader")
  ) 
  (if (vl-catch-all-error-p
	(vl-catch-all-apply
	  '(lambda () (vla-put-arrowsymbol ms "_Origin2"))
	) 
      )
    (not
      (vl-catch-all-error-p
	(vl-catch-all-apply
	  '(lambda () (vla-put-arrowsymbol ms acarrowdefault))
	)
      ) 
    ) 
  ) 
  (princ)
) 

;;----------------------------------------------------------------------;;
;;                Vytvorenie multileadru - mierka mod                   ;;
;;----------------------------------------------------------------------;;

;; Test
(defun msv_mierka (/ *error* ms)
  
  (vl-load-com)

  (defun *error* (msg)
    (command "_undo" "_e")

    (if	(and msg
	     (not (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*"))
	)
      (princ (strcat "\nError: " msg))
    ) 
    (princ)
  ) 
  (command "_undo" "_be")

  (if (vl-catch-all-error-p
	(vl-catch-all-apply
	  '(lambda ()
	     (setq ms (make_mleader_style_mierka "DP_Multileader" 0 0))
	   ) 
	) 
      ) 
    (alert "Problem s vytvorenim stylu multileadru!")
    (setvar "CMLEADERSTYLE" "DP_Multileader")
  ) 
  (if (vl-catch-all-error-p
	(vl-catch-all-apply
	  '(lambda () (vla-put-arrowsymbol ms "_Origin2"))
	)
      ) 
    (not
      (vl-catch-all-error-p
	(vl-catch-all-apply
	  '(lambda () (vla-put-arrowsymbol ms acarrowdefault))
	)
      )
    ) 
  ) 
  (princ)
) 

;;----------------------------------------------------------------------;;
;;              Vytvorenie textoveho stylu DP_ISOCPEUR                  ;;
;;----------------------------------------------------------------------;;

(defun TextStyleCreator ()
  (entmakex
  '(
    (0 . "STYLE")
    (100 . "AcDbSymbolTableRecord")
    (100 . "AcDbTextStyleTableRecord")
    (2 . "DP_ISOCPEUR")
    (70 . 0)
    (40 . 0.0);<- definovanie vysky textu
    (41 . 1.0)
    (50 . 0.0)
    (71 . 0)
    (42 . 2.0)
    (3 . "isocpeur.ttf")
    (4 . "")
  )
  )
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nMultileader_style.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;