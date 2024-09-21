;=========================================================================
; Traffic_signs_existing.lsp
; Create by Jakub Tomecko
;
; Dopravne znacenie jestujuce
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;          Zapnutie panulu nastrojov zo jestujucimi znackami           ;;
;;----------------------------------------------------------------------;;

(defun c:JTTrafficSignsExisting()
  
  ;zapnutie postraneho panelu dopravneho znacenia  
  (command "._TPNAVIGATE" "_G" "Jestujuce dopravne znacenie" "J100" pause)
    
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;          Vlozenie bloku dopravneho znacenia jestujuceho 1xx          ;;
;;----------------------------------------------------------------------;;

(defun c:DZ101_J()
  (command "._insert" "ZDZ_101_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ110_J()
  (command "._insert" "ZDZ_110_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ111_J()
  (command "._insert" "ZDZ_111_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ112_J()
  (command "._insert" "ZDZ_112_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ113_J()
  (command "._insert" "ZDZ_113_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ114_J()
  (command "._insert" "ZDZ_114_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ115_J()
  (command "._insert" "ZDZ_115_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ116_J()
  (command "._insert" "ZDZ_116_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ120_J()
  (command "._insert" "ZDZ_120_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ121_J()
  (command "._insert" "ZDZ_121_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ122_J()
  (command "._insert" "ZDZ_122_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ125_J()
  (command "._insert" "ZDZ_125_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ126_J()
  (command "._insert" "ZDZ_126_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ130_J()
  (command "._insert" "ZDZ_130_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ131_J()
  (command "._insert" "ZDZ_131_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ132_J()
  (command "._insert" "ZDZ_132_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ135_J()
  (command "._insert" "ZDZ_135_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ136_J()
  (command "._insert" "ZDZ_136_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ140_J()
  (command "._insert" "ZDZ_140_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ141_J()
  (command "._insert" "ZDZ_141_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ142_J()
  (command "._insert" "ZDZ_142_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ143_J()
  (command "._insert" "ZDZ_143_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ145_J()
  (command "._insert" "ZDZ_145_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ146_J()
  (command "._insert" "ZDZ_146_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ151_J()
  (command "._insert" "ZDZ_151_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ152_J()
  (command "._insert" "ZDZ_152_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ153_J()
  (command "._insert" "ZDZ_153_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;          Vlozenie bloku dopravneho znacenia jestujuceho 2xx          ;;
;;----------------------------------------------------------------------;;

(defun c:DZ201_J()
  (command "._insert" "ZDZ_201_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ202_J()
  (command "._insert" "ZDZ_202_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ203_J()
  (command "._insert" "ZDZ_203_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ210_J()
  (command "._insert" "ZDZ_210_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ211_J()
  (command "._insert" "ZDZ_211_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ212_J()
  (command "._insert" "ZDZ_212_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ213_J()
  (command "._insert" "ZDZ_213_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ215_J()
  (command "._insert" "ZDZ_215_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ216_J()
  (command "._insert" "ZDZ_216_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ220_J()
  (command "._insert" "ZDZ_220_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ22_J1()
  (command "._insert" "ZDZ_221_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ222_J()
  (command "._insert" "ZDZ_222_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ223_J()
  (command "._insert" "ZDZ_223_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ224_J()
  (command "._insert" "ZDZ_224_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ225_J()
  (command "._insert" "ZDZ_225_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ230_J()
  (command "._insert" "ZDZ_230_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ231_J()
  (command "._insert" "ZDZ_231_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ232_J()
  (command "._insert" "ZDZ_232_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ233_J()
  (command "._insert" "ZDZ_233_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ234_J()
  (command "._insert" "ZDZ_234_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ235_J()
  (command "._insert" "ZDZ_235_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ240_J()
  (command "._insert" "ZDZ_240_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ241_J()
  (command "._insert" "ZDZ_241_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ242_J()
  (command "._insert" "ZDZ_242_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ243_J()
  (command "._insert" "ZDZ_243_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ244_J()
  (command "._insert" "ZDZ_244_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ245_J()
  (command "._insert" "ZDZ_245_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ248_J()
  (command "._insert" "ZDZ_248_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ249_J()
  (command "._insert" "ZDZ_249_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ250_J()
  (command "._insert" "ZDZ_250_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ251_J()
  (command "._insert" "ZDZ_251_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ253_J()
  (command "._insert" "ZDZ_253_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ254_J()
  (command "._insert" "ZDZ_254_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ255_J()
  (command "._insert" "ZDZ_255_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ256_J()
  (command "._insert" "ZDZ_256_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ260_J()
  (command "._insert" "ZDZ_260_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ261_J()
  (command "._insert" "ZDZ_261_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ263_J()
  (command "._insert" "ZDZ_263_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ264_J()
  (command "._insert" "ZDZ_264_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ265_J()
  (command "._insert" "ZDZ_265_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ267_J()
  (command "._insert" "ZDZ_267_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ268_J()
  (command "._insert" "ZDZ_268_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ269_J()
  (command "._insert" "ZDZ_269_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ270_J()
  (command "._insert" "ZDZ_270_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ271_J()
  (command "._insert" "ZDZ_271_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ272_J()
  (command "._insert" "ZDZ_272_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ273_J()
  (command "._insert" "ZDZ_273_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ275_J()
  (command "._insert" "ZDZ_275_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ276_J()
  (command "._insert" "ZDZ_276_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ277_J()
  (command "._insert" "ZDZ_277_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ278_J()
  (command "._insert" "ZDZ_278_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ280_J()
  (command "._insert" "ZDZ_280_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ281_J()
  (command "._insert" "ZDZ_281_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ282_J()
  (command "._insert" "ZDZ_282_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ283_J()
  (command "._insert" "ZDZ_283_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;          Vlozenie bloku dopravneho znacenia jestujuceho 3xx          ;;
;;----------------------------------------------------------------------;;

(defun c:DZ301_J()
  (command "._insert" "ZDZ_301_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ302_J()
  (command "._insert" "ZDZ_302_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ303_J()
  (command "._insert" "ZDZ_303_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ304_J()
  (command "._insert" "ZDZ_304_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-50_J()
  (command "._insert" "ZDZ_305-50_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-51_J()
  (command "._insert" "ZDZ_305-51_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-52_J()
  (command "._insert" "ZDZ_305-52_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-60_J()
  (command "._insert" "ZDZ_305-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-61_J()
  (command "._insert" "ZDZ_305-61_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-62_J()
  (command "._insert" "ZDZ_305-62_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-70_J()
  (command "._insert" "ZDZ_305-70_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-50_J()
  (command "._insert" "ZDZ_306-50_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-51_J()
  (command "._insert" "ZDZ_306-51_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-52_J()
  (command "._insert" "ZDZ_306-52_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-60_J()
  (command "._insert" "ZDZ_306-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-61_J()
  (command "._insert" "ZDZ_306-61_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-62_J()
  (command "._insert" "ZDZ_306-62_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-70_J()
  (command "._insert" "ZDZ_306-70_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-50_J()
  (command "._insert" "ZDZ_307-50_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-51_J()
  (command "._insert" "ZDZ_307-51_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-52_J()
  (command "._insert" "ZDZ_307-52_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-60_J()
  (command "._insert" "ZDZ_307-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-61_J()
  (command "._insert" "ZDZ_307-61_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-62_J()
  (command "._insert" "ZDZ_307-62_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-50_J()
  (command "._insert" "ZDZ_308-50_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-51_J()
  (command "._insert" "ZDZ_308-51_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-52_J()
  (command "._insert" "ZDZ_308-52_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-60_J()
  (command "._insert" "ZDZ_308-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-61_J()
  (command "._insert" "ZDZ_308-61_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-62_J()
  (command "._insert" "ZDZ_308-62_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ309_J()
  (command "._insert" "ZDZ_309_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ310_J()
  (command "._insert" "ZDZ_310_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ311_J()
  (command "._insert" "ZDZ_311_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ312_J()
  (command "._insert" "ZDZ_312_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ313_J()
  (command "._insert" "ZDZ_313_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ314_J()
  (command "._insert" "ZDZ_314_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ315_J()
  (command "._insert" "ZDZ_315_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ316_J()
  (command "._insert" "ZDZ_316_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ317_J()
  (command "._insert" "ZDZ_317_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ318_J()
  (command "._insert" "ZDZ_318_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ319_J()
  (command "._insert" "ZDZ_319_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ320_J()
  (command "._insert" "ZDZ_320_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ321_J()
  (command "._insert" "ZDZ_321_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ322_J()
  (command "._insert" "ZDZ_322_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ323_J()
  (command "._insert" "ZDZ_323_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ324_J()
  (command "._insert" "ZDZ_324_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ325_J()
  (command "._insert" "ZDZ_325_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ326_J()
  (command "._insert" "ZDZ_326_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ327_J()
  (command "._insert" "ZDZ_327_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ328_J()
  (command "._insert" "ZDZ_328_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ330_J()
  (command "._insert" "ZDZ_330_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ331_J()
  (command "._insert" "ZDZ_331_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ332_J()
  (command "._insert" "ZDZ_332_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ333_J()
  (command "._insert" "ZDZ_333_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ334_J()
  (command "._insert" "ZDZ_334_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ335_J()
  (command "._insert" "ZDZ_335_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ336_J()
  (command "._insert" "ZDZ_336_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-50_J()
  (command "._insert" "ZDZ_340-50_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ304-51_J()
  (command "._insert" "ZDZ_304_51_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-52_J()
  (command "._insert" "ZDZ_340-52_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-53_J()
  (command "._insert" "ZDZ_340-53_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-60_J()
  (command "._insert" "ZDZ_340-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-61_J()
  (command "._insert" "ZDZ_340-61_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-62_J()
  (command "._insert" "ZDZ_304-62_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-70_J()
  (command "._insert" "ZDZ_340-70_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-71_J()
  (command "._insert" "ZDZ_340-71_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-72_J()
  (command "._insert" "ZDZ_340-72_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-80_J()
  (command "._insert" "ZDZ_340-80_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-81_J()
  (command "._insert" "ZDZ_340-81_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-82_J()
  (command "._insert" "ZDZ_340-82_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ341_J()
  (command "._insert" "ZDZ_341_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ342_J()
  (command "._insert" "ZDZ_342_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ343_J()
  (command "._insert" "ZDZ_343_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ344_J()
  (command "._insert" "ZDZ_344_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ350_J()
  (command "._insert" "ZDZ_350_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ351_J()
  (command "._insert" "ZDZ_351_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ352_J()
  (command "._insert" "ZDZ_352_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ353_J()
  (command "._insert" "ZDZ_353_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ355-50_J()
  (command "._insert" "ZDZ_355-50_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ355-60_J()
  (command "._insert" "ZDZ_355-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ355-70_J()
  (command "._insert" "ZDZ_355-70_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ390_J()
  (command "._insert" "ZDZ_390_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ391_J()
  (command "._insert" "ZDZ_391_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ392_J()
  (command "._insert" "ZDZ_392_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ393-30_J()
  (command "._insert" "ZDZ_393-30_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ393-32_J()
  (command "._insert" "ZDZ_393-32_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ394_J()
  (command "._insert" "ZDZ_394_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ394-50_J()
  (command "._insert" "ZDZ_394-50_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ394-55_J()
  (command "._insert" "ZDZ_394-55_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ394-6x_J()
  (command "._insert" "ZDZ_394-6x_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ395_J()
  (command "._insert" "ZDZ_395_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ396_J()
  (command "._insert" "ZDZ_396_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ397_J()
  (command "._insert" "ZDZ_397_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;          Vlozenie bloku dopravneho znacenia jestujuceho 4xx          ;;
;;----------------------------------------------------------------------;;

(defun c:DZ401_J()
  (command "._insert" "ZDZ_401_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ402_J()
  (command "._insert" "ZDZ_402_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ403_J()
  (command "._insert" "ZDZ_403_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ404_J()
  (command "._insert" "ZDZ_404_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ411_J()
  (command "._insert" "ZDZ_411_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ412_J()
  (command "._insert" "ZDZ_412_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ413_J()
  (command "._insert" "ZDZ_413_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ414_J()
  (command "._insert" "ZDZ_414_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ421_J()
  (command "._insert" "ZDZ_421_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ422_J()
  (command "._insert" "ZDZ_422_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ423_J()
  (command "._insert" "ZDZ_423_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ424_J()
  (command "._insert" "ZDZ_424_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ431_J()
  (command "._insert" "ZDZ_431_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ441_J()
  (command "._insert" "ZDZ_441_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ442_J()
  (command "._insert" "ZDZ_442_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ443_J()
  (command "._insert" "ZDZ_443_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ444_J()
  (command "._insert" "ZDZ_444_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ445_J()
  (command "._insert" "ZDZ_445_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ451_J()
  (command "._insert" "ZDZ_451_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ453_J()
  (command "._insert" "ZDZ_453"_J "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ455_J()
  (command "._insert" "ZDZ_455_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ457_J()
  (command "._insert" "ZDZ_457_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ459_J()
  (command "._insert" "ZDZ_459_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;          Vlozenie bloku dopravneho znacenia jestujuceho 5xx          ;;
;;----------------------------------------------------------------------;;

(defun c:DZ501_J()
  (command "._insert" "ZDZ_501_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ501-60_J()
  (command "._insert" "ZDZ_501-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ502_J()
  (command "._insert" "ZDZ_502_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ502-60_J()
  (command "._insert" "ZDZ_502-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ503_J()
  (command "._insert" "ZDZ_503_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ504_J()
  (command "._insert" "ZDZ_504_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ505_J()
  (command "._insert" "ZDZ_505_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506_J()
  (command "._insert" "ZDZ_506_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-100_J()
  (command "._insert" "ZDZ_506-100_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-101_J()
  (command "._insert" "ZDZ_506-101_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-102_J()
  (command "._insert" "ZDZ_506-102_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-110_J()
  (command "._insert" "ZDZ_506-110_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-111_J()
  (command "._insert" "ZDZ_506-111_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-120_J()
  (command "._insert" "ZDZ_506-120_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-121_J()
  (command "._insert" "ZDZ_506-121_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-139_J()
  (command "._insert" "ZDZ_506-139_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-141_J()
  (command "._insert" "ZDZ_506-141_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-142_J()
  (command "._insert" "ZDZ_506-142_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507_J()
  (command "._insert" "ZDZ_507_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-100_J()
  (command "._insert" "ZDZ_507-100_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-101_J()
  (command "._insert" "ZDZ_507-101_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-102_J()
  (command "._insert" "ZDZ_507-102_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-120_J()
  (command "._insert" "ZDZ_507-120_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-121_J()
  (command "._insert" "ZDZ_507-121_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-139_J()
  (command "._insert" "ZDZ_507-139_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-141_J()
  (command "._insert" "ZDZ_507-141_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-142_J()
  (command "._insert" "ZDZ_507-142_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-143_J()
  (command "._insert" "ZDZ_507-143_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ508_J()
  (command "._insert" "ZDZ_508_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-50_J()
  (command "._insert" "ZDZ_509-50_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-51_J()
  (command "._insert" "ZDZ_509-51_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-52_J()
  (command "._insert" "ZDZ_509-52_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-53_J()
  (command "._insert" "ZDZ_509-53_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-54_J()
  (command "._insert" "ZDZ_509-54_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-55_J()
  (command "._insert" "ZDZ_509-55_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-56_J()
  (command "._insert" "ZDZ_509-56_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-57_J()
  (command "._insert" "ZDZ_509-57_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-58_J()
  (command "._insert" "ZDZ_509-58_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-60_J()
  (command "._insert" "ZDZ_509-60_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-62_J()
  (command "._insert" "ZDZ_509-62_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-63_J()
  (command "._insert" "ZDZ_509-63_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-70_J()
  (command "._insert" "ZDZ_509-70_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-72_J()
  (command "._insert" "ZDZ_509-72_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-73_J()
  (command "._insert" "ZDZ_509-73_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-74_J()
  (command "._insert" "ZDZ_509-74_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-75_J()
  (command "._insert" "ZDZ_509-75_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-76_J()
  (command "._insert" "ZDZ_509-76_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-77_J()
  (command "._insert" "ZDZ_509-77_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-80_J()
  (command "._insert" "ZDZ_509-80_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-81_J()
  (command "._insert" "ZDZ_509-81_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-87_J()
  (command "._insert" "ZDZ_509-87_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-88_J()
  (command "._insert" "ZDZ_509-88_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-89_J()
  (command "._insert" "ZDZ_509-89_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-90_J()
  (command "._insert" "ZDZ_509-90_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-91_J()
  (command "._insert" "ZDZ_509-91_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-92_J()
  (command "._insert" "ZDZ_509-92_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-93_J()
  (command "._insert" "ZDZ_509-93_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-94_J()
  (command "._insert" "ZDZ_509-94_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-97_J()
  (command "._insert" "ZDZ_509-97_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-100_J()
  (command "._insert" "ZDZ_509-100_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-101_J()
  (command "._insert" "ZDZ_509-101_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-102_J()
  (command "._insert" "ZDZ_509-102_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ510_J()
  (command "._insert" "ZDZ_510_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ511_J()
  (command "._insert" "ZDZ_511_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ512_J()
  (command "._insert" "ZDZ_512_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ513_J()
  (command "._insert" "ZDZ_513_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ514_J()
  (command "._insert" "ZDZ_514_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ515_J()
  (command "._insert" "ZDZ_515_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ515-100_J()
  (command "._insert" "ZDZ_515-100_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ515-101_J()
  (command "._insert" "ZDZ_515-101_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ515-102_J()
  (command "._insert" "ZDZ_515-102_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ520_J()
  (command "._insert" "ZDZ_520_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ520.hx_J()
  (command "._insert" "ZDZ_520.hx_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ521_J()
  (command "._insert" "ZDZ_521_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ522_J()
  (command "._insert" "ZDZ_522_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ525_J()
  (command "._insert" "ZDZ_525_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ526_J()
  (command "._insert" "ZDZ_526_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ527_J()
  (command "._insert" "ZDZ_527_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ530_J()
  (command "._insert" "ZDZ_530_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ531_J()
  (command "._insert" "ZDZ_531_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ532_J()
  (command "._insert" "ZDZ_532_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ533_J()
  (command "._insert" "ZDZ_533_J" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTraffic_signs_existing.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;