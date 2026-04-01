;=========================================================================
; Technical_documents.lsp
; Create by Jakub Tomecko
;
; Otvorenie vzorovych listov, echnickych podmienok alebo zakonov
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                           Vzorove list 01                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL01 () 
  ;definovanie premenej "URL_VL01" do ktorej je zapísana url adresa
  (setq URL_VL01 (findfile "VL_01.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL01)
  (princ)  
)

(defun c:VL01_1 () 
  ;definovanie premenej "URL_VL01_1" do ktorej je zapísana url adresa
  (setq URL_VL01_1 (findfile "VL_01-1.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL01_1)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 02                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL022 () 
  ;definovanie premenej "URL_VL022" do ktorej je zapísana url adresa
  (setq URL_VL022 (findfile "VL_02-2.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL022)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 04                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL04 () 
  ;definovanie premenej "URL_VL04" do ktorej je zapísana url adresa
  (setq URL_VL04 (findfile "VL_04.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL04)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                    Vzorove list 04 - dodatok 1                       ;;
;;----------------------------------------------------------------------;;

(defun c:VL04_1 () 
  ;definovanie premenej "URL_VL04_1" do ktorej je zapísana url adresa
  (setq URL_VL04_1 (findfile "VL_04-1.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL04_1)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 05                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL05 () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL05 (findfile "VL_05.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL05)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06-1T                         ;;
;;----------------------------------------------------------------------;;

(defun c:VL061T () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL061T (findfile "VL_06-1T.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL061T)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06-1V                         ;;
;;----------------------------------------------------------------------;;

(defun c:VL061V () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL061V (findfile "VL_06-1V.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL061V)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06-2T                         ;;
;;----------------------------------------------------------------------;;

(defun c:VL062T () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL062T (findfile "VL_06-2T.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL062T)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06-2V                         ;;
;;----------------------------------------------------------------------;;

(defun c:VL062V () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL062V (findfile "VL_06-2V.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL062V)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06-3T                         ;;
;;----------------------------------------------------------------------;;

(defun c:VL063T () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL063T (findfile "VL_06-3T.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL063T)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06-3V                         ;;
;;----------------------------------------------------------------------;;

(defun c:VL063V () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL063V (findfile "VL_06-3V.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL063V)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06-4T                         ;;
;;----------------------------------------------------------------------;;

(defun c:VL064T () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL064T (findfile "VL_06-4T.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL064T)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 06-4V                         ;;
;;----------------------------------------------------------------------;;

(defun c:VL064V () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL064V (findfile "VL_06-4V.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL064V)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 10                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL10 () 
  ;definovanie premenej "URL_VL10" do ktorej je zapísana url adresa
  (setq URL_VL10 (findfile "VL_10.pdf"))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL10)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Technicke podmienky                        ;;
;;----------------------------------------------------------------------;;

(defun c:JTTP () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq JTTPURL "https://www.ssc.sk/sk/technicke-predpisy-rezortu/zoznam-tp.ssc")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" JTTPURL)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                   Pomocna funkcia urcujuca aktualny datum            ;;
;;----------------------------------------------------------------------;;

(defun TodayDate ()

  ;ziskanie aktualneho datumu z systemovej premennej "CDATE"
  (setq datum (rtos (getvar "CDATE") 2 6))
  
  (setq rok (substr datum 1 4))
  (setq mesiac (substr datum 5 2))
  (setq den (substr datum 7 2))
  
)

;;----------------------------------------------------------------------;;
;;                           Zakon 25/2025 Z. z.                        ;;
;;----------------------------------------------------------------------;;

(defun c:JTZK25 () 
  
  ;ziskanie aktualneho datumu a jeho rozdelenie na den, mesiac a rok
  (TodayDate)
  
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq JTZK25URL (strcat "https://www.slov-lex.sk/ezbierky/pravne-predpisy/SK/ZZ/2025/25/?ucinnost=" den "." mesiac "." rok))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" JTZK25URL)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                         Vyhlaska 59/2025 Z. z.                       ;;
;;----------------------------------------------------------------------;;

(defun c:JTVL59 () 
  
  ;ziskanie aktualneho datumu a jeho rozdelenie na den, mesiac a rok
  (TodayDate)
  
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq JTVL59URL (strcat "https://www.slov-lex.sk/ezbierky/pravne-predpisy/SK/ZZ/2025/59/?ucinnost=" den "." mesiac "." rok))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" JTVL59URL)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                         Vyhlaska 60/2025 Z. z.                       ;;
;;----------------------------------------------------------------------;;

(defun c:JTVL60 () 
  
  ;ziskanie aktualneho datumu a jeho rozdelenie na den, mesiac a rok
  (TodayDate)
  
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq JTVL60URL (strcat "https://www.slov-lex.sk/ezbierky/pravne-predpisy/SK/ZZ/2025/60/?ucinnost=" den "." mesiac "." rok))

  ;spustenie prikazu browser z vlozenou url
  (command "browser" JTVL60URL)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                    Slovenske technicke podmienky                     ;;
;;----------------------------------------------------------------------;;

(defun c:TPSK () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq SKURL "https://www.ssc.sk/sk/technicke-predpisy-rezortu.ssc")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" SKURL)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                      Ceske technicke podmienky                       ;;
;;----------------------------------------------------------------------;;

(defun c:TPCZ () 
  ;definovanie premenej "PDFFileName" do ktorej je zapísana url adresa
  (setq CZURL "https://pjpk.rsd.cz/predpisy/")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" CZURL)
  (princ)  
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "JTmenu_version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTechnical_documents.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
        "\n"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;