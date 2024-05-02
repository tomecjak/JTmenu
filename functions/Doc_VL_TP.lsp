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

(defun c:TP010 () 
  ;definovanie premenej "URL_TP010" do ktorej je zapísana url adresa
  (setq URL_TP010 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_010_2019.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP010)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;              Technicke podmienky 010 - dodatok c. 1                  ;;
;;----------------------------------------------------------------------;;

(defun c:TP010_1 () 
  ;definovanie premenej "URL_TP010_1" do ktorej je zapísana url adresa
  (setq URL_TP010_1 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_010_dodatok_1.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP010_1)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 019                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP019 () 
  ;definovanie premenej "URL_TP019" do ktorej je zapísana url adresa
  (setq URL_TP019 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_019_2021.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP019)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                Technicke podmienky 019 - komentar                    ;;
;;----------------------------------------------------------------------;;

(defun c:TP019_K () 
  ;definovanie premenej "URL_TP019_K" do ktorej je zapísana url adresa
  (setq URL_TP019_K "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_019_2021_komentar.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP019_K)
  (princ)  
)


;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 037                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP037 () 
  ;definovanie premenej "URL_TP037" do ktorej je zapísana url adresa
  (setq URL_TP037 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_037_2019.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP037)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 063                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP063 () 
  ;definovanie premenej "URL_TP063" do ktorej je zapísana url adresa
  (setq URL_TP063 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_063.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP063)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 068                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP068 () 
  ;definovanie premenej "URL_TP068" do ktorej je zapísana url adresa
  (setq URL_TP068 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_068.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP068)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;              Technicke podmienky 068 - dodatok c. 1                  ;;
;;----------------------------------------------------------------------;;

(defun c:TP068_1 () 
  ;definovanie premenej "URL_TP068_1" do ktorej je zapísana url adresa
  (setq URL_TP068_1 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_068_dodatok_1_2022.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP068_1)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 075                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP075 () 
  ;definovanie premenej "URL_TP075" do ktorej je zapísana url adresa
  (setq URL_TP075 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_075.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP075)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 104                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP104 () 
  ;definovanie premenej "URL_TP104" do ktorej je zapísana url adresa
  (setq URL_TP104 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp%20104_2023.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP104)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 108                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP108 () 
  ;definovanie premenej "URL_TP108" do ktorej je zapísana url adresa
  (setq URL_TP108 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_108_2019.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP108)
  (princ)  
)

;;----------------------------------------------------------------------;;
;;                       Technicke podmienky 113                        ;;
;;----------------------------------------------------------------------;;

(defun c:TP113 () 
  ;definovanie premenej "URL_TP113" do ktorej je zapísana url adresa
  (setq URL_TP113 "https://www.ssc.sk/files/documents/technicke-predpisy/tp/tp_113_2019.pdf")

  ;spustenie prikazu browser z vlozenou url
  (command "browser" URL_TP113)
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