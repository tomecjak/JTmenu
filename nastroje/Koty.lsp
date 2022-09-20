;automatically create new dimension style
(defun c:jeff ()

  (Kota_50_milimetre)
  (Kota_100_milimetre)
  
  (princ)
  
)

;nastavenie pre kotu mierky 50 v milimetroch
(defun Kota_50_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.05)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.07)
  
  ;set tab Text
  (setvar "DIMTXT" 0.125)
  (setvar "DIMGAP" 0.045)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "Jeff50")

)

;nastavenie pre kotu mierky 100 v milimetroch
(defun Kota_100_milimetre ()

  (DimensionCreator)
  
  ;set tab Lines
  (setvar "DIMEXE" 0.1)
  
  ;set tab Symbols and Arrows
  (setvar "DIMASZ" 0.14)
  
  ;set tab Text
  (setvar "DIMTXT" 0.250)
  (setvar "DIMGAP" 0.090)
  
  ;set tab Primary Units
  (setvar "DIMDEC" 0)
  (setvar "DIMLFAC" 1000)

  (command "dimstyle" "s" "Jeff100")

)

;zakladne nastavenie pre vytvorenie koty
(defun DimensionCreator ()
       
  ;set tab Lines
  (setvar "DIMDLI" 0.38)
  (setvar "DIMCLRD" 0)
  (setvar "DIMLTYPE" "BYBLOCK")
  (setvar "DIMLWD" -2)
  (setvar "DIMDLE" 0)
  (setvar "DIMCLRE" 0)
  (setvar "DIMLTEX1" "BYBLOCK")
  (setvar "DIMLTEX2" "BYBLOCK")
  (setvar "DIMLWE" -2)
  (setvar "DIMEXO" 0)
  
  ;set tab Symbols and Arrows
  (setvar "DIMBLK1" "Oblique")
  (setvar "DIMBLK1" "Oblique")
  (setvar "DIMLDRBLK" "Oblique")
  (setvar "DIMARCSYM" 0)
  
  ;set tab Text
  (setvar "DIMTXSTY" "DP_ISOCPEUR")
  (setvar "DIMCLRT" 0)
  (setvar "DIMTFILL" 0)
  (setvar "DIMTAD" 1)
  (setvar "DIMJUST" 0)
  (setvar "DIMTXTDIRECTION" 0)
  
  ;set tab Fit
  (setvar "DIMATFIT" 3)
  (setvar "DIMTMOVE" 1)
  (setvar "DIMUPT" 0)
  
  ;set tab Primary Units
  (setvar "DIMLUNIT" 2)
  (setvar "DIMDSEP" ".")
  (setvar "DIMRND" 0)
  (setvar "DIMAUNIT" 0)
  (setvar "DIMADEC" 0)

)