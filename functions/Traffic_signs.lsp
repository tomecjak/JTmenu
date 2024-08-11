(defun c:JTTrafficSigns()
  

(command "._TPNAVIGATE" "_G" "Dopravne znacenie" "100" pause)
(princ)
  
)

;vloženie bloku NazovPohladuNAsic
(defun c:DZ101()

  ;prikaz na vlozenie blocku RezZvisly
  (if (= (getenv "GlobalnaDIMSCALEset") "Klasicky")
      (command "._insert" "101" "_S" (/ (atof (getenv "GlobalnaBlocksScale")) 1000) "_R" 0 pause)
    (if (= (getenv "GlobalnaDIMSCALEset") "Mierka")
        (command "._insert" "101" "_S" (getvar "dimscale") "_R" 0 pause)
    )
  )
  
  (princ)
  
)
