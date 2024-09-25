;=========================================================================
; Doc_VL_TP.lsp
; Create by Jakub Tomecko
;
; Otvorenie vzorovych listov alebo technickych podmienok
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                           Vzorove list 01                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL01 () 
  ;definovanie premenej "URL_VL01" do ktorej je zapísana url adresa
  (setq URL_VL01 "https://www.ssc.sk/files/documents/technicke-predpisy/vl/vl1_2019.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL01)
  (princ)  
)

(defun c:VL01_1 () 
  ;definovanie premenej "URL_VL01_1" do ktorej je zapísana url adresa
  (setq URL_VL01_1 "https://www.ssc.sk/files/documents/technicke-predpisy/vl/dodatok_1_2021_vl_1.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL01_1)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 02                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL022 () 
  ;definovanie premenej "URL_VL022" do ktorej je zapísana url adresa
  (setq URL_VL022 "https://www.ssc.sk/files/documents/technicke-predpisy/vl/vl_2_2_2021.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL022)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 04                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL04 () 
  ;definovanie premenej "URL_VL04" do ktorej je zapísana url adresa
  (setq URL_VL04 "https://www.ssc.sk/files/documents/technicke-predpisy/vl/vl4_2021.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL04)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                    Vzorove list 04 - dodatok 1                       ;;
;;----------------------------------------------------------------------;;

(defun c:VL04_1 () 
  ;definovanie premenej "URL_VL04_1" do ktorej je zapísana url adresa
  (setq URL_VL04_1 "https://www.ssc.sk/files/documents/technicke-predpisy/vl/dodatok_1_2023_vl_4.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL04_1)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 05                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL05 () 
  ;definovanie premenej "URL_VL05" do ktorej je zapísana url adresa
  (setq URL_VL05 "https://www.ssc.sk/files/documents/technicke-predpisy/vl/vl5_2022_tunely.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL05)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                           Vzorove list 10                            ;;
;;----------------------------------------------------------------------;;

(defun c:VL10 () 
  ;definovanie premenej "URL_VL10" do ktorej je zapísana url adresa
  (setq URL_VL10 "https://www.ssc.sk/files/documents/technicke-predpisy/vl/vl-10_2018.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_VL10)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 010                        ;;
;;----------------------------------------------------------------------;;

(defun c:JTTP () 
  ;definovanie premenej "URL_TP" do ktorej je zapísana url adresa
  (setq URL_TP "https://www.ssc.sk/sk/technicke-predpisy-rezortu/zoznam-tp.ssc")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP)
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