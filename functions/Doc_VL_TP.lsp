;=========================================================================
; Doc_VL_TP.lsp
; (c) Copyright 2023 Tomecko Jakub
;
; Otvorenie vzorovych listov alebo technickych podmienok
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                           Vzorove list 01                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL01 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL01.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL01_1 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL01_1.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 02                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL02 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL02.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL02_1 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL02_1.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL02_2 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL02_2.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL02_3 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL02_3.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL022 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL02.2.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 04                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL04 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL04.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 05                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL05 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL05.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL061 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL06.1.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL061V () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL06.1_V.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL062 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL06.2.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL062V () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL06.2_V.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL063 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL06.3.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL063V () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL06.3_V.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL064 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL06.4.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

(defun c:VL064V () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL06.4_V.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 10                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL10 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "VL/VL10.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)


;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 113                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP113 () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq PDFFileName (findfile "TP/TP113.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" PDFFileName)
  (princ)  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nDoc_VL_TP.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;