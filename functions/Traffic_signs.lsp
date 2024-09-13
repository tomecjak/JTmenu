;=========================================================================
; Traffic_signs.lsp
; Create by Jakub Tomecko
;
; Dopravne znacenie
;-------------------------------------------------------------------------

;;----------------------------------------------------------------------;;
;;                Zapnutie panulu nastrojov zo znackami                 ;;
;;----------------------------------------------------------------------;;

(defun c:JTTrafficSigns()
  
;zapnutie postraneho panelu dopravneho znacenia  
(command "._TPNAVIGATE" "_G" "Dopravne znacenie" "100" pause)
  
(princ)
  
)

;;----------------------------------------------------------------------;;
;;               Vlozenie bloku dopravneho znacenia 1xx                 ;;
;;----------------------------------------------------------------------;;

(defun c:DZ101()
  (command "._insert" "ZDZ_101" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ110()
  (command "._insert" "ZDZ_110" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ111()
  (command "._insert" "ZDZ_111" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ112()
  (command "._insert" "ZDZ_112" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ113()
  (command "._insert" "ZDZ_113" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ114()
  (command "._insert" "ZDZ_114" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ115()
  (command "._insert" "ZDZ_115" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ116()
  (command "._insert" "ZDZ_116" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ120()
  (command "._insert" "ZDZ_120" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ121()
  (command "._insert" "ZDZ_121" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ122()
  (command "._insert" "ZDZ_122" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ125()
  (command "._insert" "ZDZ_125" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ126()
  (command "._insert" "ZDZ_126" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ130()
  (command "._insert" "ZDZ_130" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ131()
  (command "._insert" "ZDZ_131" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ132()
  (command "._insert" "ZDZ_132" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ135()
  (command "._insert" "ZDZ_135" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ136()
  (command "._insert" "ZDZ_136" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ140()
  (command "._insert" "ZDZ_140" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ141()
  (command "._insert" "ZDZ_141" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ142()
  (command "._insert" "ZDZ_142" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ143()
  (command "._insert" "ZDZ_143" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ145()
  (command "._insert" "ZDZ_145" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ146()
  (command "._insert" "ZDZ_146" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ151()
  (command "._insert" "ZDZ_151" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ152()
  (command "._insert" "ZDZ_152" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ153()
  (command "._insert" "ZDZ_153" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Vlozenie bloku dopravneho znacenia 2xx                 ;;
;;----------------------------------------------------------------------;;

(defun c:DZ201()
  (command "._insert" "ZDZ_201" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ202()
  (command "._insert" "ZDZ_202" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ203()
  (command "._insert" "ZDZ_203" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ210()
  (command "._insert" "ZDZ_210" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ211()
  (command "._insert" "ZDZ_211" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ212()
  (command "._insert" "ZDZ_212" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ213()
  (command "._insert" "ZDZ_213" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ215()
  (command "._insert" "ZDZ_215" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ216()
  (command "._insert" "ZDZ_216" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ220()
  (command "._insert" "ZDZ_220" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ221()
  (command "._insert" "ZDZ_221" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ222()
  (command "._insert" "ZDZ_222" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ223()
  (command "._insert" "ZDZ_223" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ224()
  (command "._insert" "ZDZ_224" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ225()
  (command "._insert" "ZDZ_225" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ230()
  (command "._insert" "ZDZ_230" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ231()
  (command "._insert" "ZDZ_231" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ232()
  (command "._insert" "ZDZ_232" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ233()
  (command "._insert" "ZDZ_233" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ234()
  (command "._insert" "ZDZ_234" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ235()
  (command "._insert" "ZDZ_235" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ240()
  (command "._insert" "ZDZ_240" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ241()
  (command "._insert" "ZDZ_241" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ242()
  (command "._insert" "ZDZ_242" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ243()
  (command "._insert" "ZDZ_243" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ244()
  (command "._insert" "ZDZ_244" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ245()
  (command "._insert" "ZDZ_245" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ248()
  (command "._insert" "ZDZ_248" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ249()
  (command "._insert" "ZDZ_249" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ250()
  (command "._insert" "ZDZ_250" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ251()
  (command "._insert" "ZDZ_251" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ253()
  (command "._insert" "ZDZ_253" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ254()
  (command "._insert" "ZDZ_254" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ255()
  (command "._insert" "ZDZ_255" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ256()
  (command "._insert" "ZDZ_256" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ260()
  (command "._insert" "ZDZ_260" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ261()
  (command "._insert" "ZDZ_261" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ263()
  (command "._insert" "ZDZ_263" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ264()
  (command "._insert" "ZDZ_264" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ265()
  (command "._insert" "ZDZ_265" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ267()
  (command "._insert" "ZDZ_267" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ268()
  (command "._insert" "ZDZ_268" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ269()
  (command "._insert" "ZDZ_269" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ270()
  (command "._insert" "ZDZ_270" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ271()
  (command "._insert" "ZDZ_271" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ272()
  (command "._insert" "ZDZ_272" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ273()
  (command "._insert" "ZDZ_273" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ275()
  (command "._insert" "ZDZ_275" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ276()
  (command "._insert" "ZDZ_276" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ277()
  (command "._insert" "ZDZ_277" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ278()
  (command "._insert" "ZDZ_278" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ280()
  (command "._insert" "ZDZ_280" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ281()
  (command "._insert" "ZDZ_281" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ282()
  (command "._insert" "ZDZ_282" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ283()
  (command "._insert" "ZDZ_283" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Vlozenie bloku dopravneho znacenia 3xx                 ;;
;;----------------------------------------------------------------------;;

(defun c:DZ301()
  (command "._insert" "ZDZ_301" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ302()
  (command "._insert" "ZDZ_302" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ303()
  (command "._insert" "ZDZ_303" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ304()
  (command "._insert" "ZDZ_304" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-50()
  (command "._insert" "ZDZ_305-50" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-51()
  (command "._insert" "ZDZ_305-51" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-52()
  (command "._insert" "ZDZ_305-52" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-60()
  (command "._insert" "ZDZ_305-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-61()
  (command "._insert" "ZDZ_305-61" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-62()
  (command "._insert" "ZDZ_305-62" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ305-70()
  (command "._insert" "ZDZ_305-70" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-50()
  (command "._insert" "ZDZ_306-50" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-51()
  (command "._insert" "ZDZ_306-51" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-52()
  (command "._insert" "ZDZ_306-52" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-60()
  (command "._insert" "ZDZ_306-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-61()
  (command "._insert" "ZDZ_306-61" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-62()
  (command "._insert" "ZDZ_306-62" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ306-70()
  (command "._insert" "ZDZ_306-70" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-50()
  (command "._insert" "ZDZ_307-50" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-51()
  (command "._insert" "ZDZ_307-51" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-52()
  (command "._insert" "ZDZ_307-52" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-60()
  (command "._insert" "ZDZ_307-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-61()
  (command "._insert" "ZDZ_307-61" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ307-62()
  (command "._insert" "ZDZ_307-62" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-50()
  (command "._insert" "ZDZ_308-50" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-51()
  (command "._insert" "ZDZ_308-51" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-52()
  (command "._insert" "ZDZ_308-52" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-60()
  (command "._insert" "ZDZ_308-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-61()
  (command "._insert" "ZDZ_308-61" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ308-62()
  (command "._insert" "ZDZ_308-62" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ309()
  (command "._insert" "ZDZ_309" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ310()
  (command "._insert" "ZDZ_310" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ311()
  (command "._insert" "ZDZ_311" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ312()
  (command "._insert" "ZDZ_312" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ313()
  (command "._insert" "ZDZ_313" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ314()
  (command "._insert" "ZDZ_314" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ315()
  (command "._insert" "ZDZ_315" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ316()
  (command "._insert" "ZDZ_316" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ317()
  (command "._insert" "ZDZ_317" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ318()
  (command "._insert" "ZDZ_318" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ319()
  (command "._insert" "ZDZ_319" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ320()
  (command "._insert" "ZDZ_320" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ321()
  (command "._insert" "ZDZ_321" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ322()
  (command "._insert" "ZDZ_322" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ323()
  (command "._insert" "ZDZ_323" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ324()
  (command "._insert" "ZDZ_324" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ325()
  (command "._insert" "ZDZ_325" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ326()
  (command "._insert" "ZDZ_326" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ327()
  (command "._insert" "ZDZ_327" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ328()
  (command "._insert" "ZDZ_328" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ330()
  (command "._insert" "ZDZ_330" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ331()
  (command "._insert" "ZDZ_331" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ332()
  (command "._insert" "ZDZ_332" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ333()
  (command "._insert" "ZDZ_333" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ334()
  (command "._insert" "ZDZ_334" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ335()
  (command "._insert" "ZDZ_335" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ336()
  (command "._insert" "ZDZ_336" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-50()
  (command "._insert" "ZDZ_340-50" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ304-51()
  (command "._insert" "ZDZ_304_51" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-52()
  (command "._insert" "ZDZ_340-52" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-53()
  (command "._insert" "ZDZ_340-53" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-60()
  (command "._insert" "ZDZ_340-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-61()
  (command "._insert" "ZDZ_340-61" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-62()
  (command "._insert" "ZDZ_304-62" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-70()
  (command "._insert" "ZDZ_340-70" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-71()
  (command "._insert" "ZDZ_340-71" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-72()
  (command "._insert" "ZDZ_340-72" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-80()
  (command "._insert" "ZDZ_340-80" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-81()
  (command "._insert" "ZDZ_340-81" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ340-82()
  (command "._insert" "ZDZ_340-82" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ341()
  (command "._insert" "ZDZ_341" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ344()
  (command "._insert" "ZDZ_344" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ350()
  (command "._insert" "ZDZ_350" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ351()
  (command "._insert" "ZDZ_351" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ352()
  (command "._insert" "ZDZ_352" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ353()
  (command "._insert" "ZDZ_353" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ355-50()
  (command "._insert" "ZDZ_355-50" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ355-60()
  (command "._insert" "ZDZ_355-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ355-70()
  (command "._insert" "ZDZ_355-70" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ390()
  (command "._insert" "ZDZ_390" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ391()
  (command "._insert" "ZDZ_391" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ392()
  (command "._insert" "ZDZ_392" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ393-30()
  (command "._insert" "ZDZ_393-30" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ393-32()
  (command "._insert" "ZDZ_393-32" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ394()
  (command "._insert" "ZDZ_394" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ394-50()
  (command "._insert" "ZDZ_394-50" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ394-55()
  (command "._insert" "ZDZ_394-55" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ394-6x()
  (command "._insert" "ZDZ_394-6x" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ395()
  (command "._insert" "ZDZ_395" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ396()
  (command "._insert" "ZDZ_396" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ397()
  (command "._insert" "ZDZ_397" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Vlozenie bloku dopravneho znacenia 4xx                 ;;
;;----------------------------------------------------------------------;;

(defun c:DZ401()
  (command "._insert" "ZDZ_401" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ402()
  (command "._insert" "ZDZ_402" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ403()
  (command "._insert" "ZDZ_403" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ404()
  (command "._insert" "ZDZ_404" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ411()
  (command "._insert" "ZDZ_411" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ412()
  (command "._insert" "ZDZ_412" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ413()
  (command "._insert" "ZDZ_413" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ414()
  (command "._insert" "ZDZ_414" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ421()
  (command "._insert" "ZDZ_421" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ422()
  (command "._insert" "ZDZ_422" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ423()
  (command "._insert" "ZDZ_423" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ424()
  (command "._insert" "ZDZ_424" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ431()
  (command "._insert" "ZDZ_431" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ441()
  (command "._insert" "ZDZ_441" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ442()
  (command "._insert" "ZDZ_442" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ443()
  (command "._insert" "ZDZ_443" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ444()
  (command "._insert" "ZDZ_444" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ445()
  (command "._insert" "ZDZ_445" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ451()
  (command "._insert" "ZDZ_451" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ453()
  (command "._insert" "ZDZ_453" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ101()
  (command "._insert" "ZDZ_101" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ101()
  (command "._insert" "ZDZ_101" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ455()
  (command "._insert" "ZDZ_455" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ457()
  (command "._insert" "ZDZ_457" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ459()
  (command "._insert" "ZDZ_459" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

;;----------------------------------------------------------------------;;
;;               Vlozenie bloku dopravneho znacenia 5xx                 ;;
;;----------------------------------------------------------------------;;

(defun c:DZ501()
  (command "._insert" "ZDZ_501" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ501-60()
  (command "._insert" "ZDZ_501-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ502()
  (command "._insert" "ZDZ_502" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ502-60()
  (command "._insert" "ZDZ_502-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ503()
  (command "._insert" "ZDZ_503" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ504()
  (command "._insert" "ZDZ_504" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ505()
  (command "._insert" "ZDZ_505" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506()
  (command "._insert" "ZDZ_506" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-100()
  (command "._insert" "ZDZ_506-100" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-101()
  (command "._insert" "ZDZ_506-101" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-102()
  (command "._insert" "ZDZ_506-102" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-110()
  (command "._insert" "ZDZ_506-110" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-111()
  (command "._insert" "ZDZ_506-111" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-120()
  (command "._insert" "ZDZ_506-120" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-121()
  (command "._insert" "ZDZ_506-121" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-139()
  (command "._insert" "ZDZ_506-139" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-141()
  (command "._insert" "ZDZ_506-141" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ506-142()
  (command "._insert" "ZDZ_506-142" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507()
  (command "._insert" "ZDZ_507" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-100()
  (command "._insert" "ZDZ_507-100" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-101()
  (command "._insert" "ZDZ_507-101" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-102()
  (command "._insert" "ZDZ_507-102" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-120()
  (command "._insert" "ZDZ_507-120" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-121()
  (command "._insert" "ZDZ_507-121" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-139()
  (command "._insert" "ZDZ_507-139" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-141()
  (command "._insert" "ZDZ_507-141" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-142()
  (command "._insert" "ZDZ_507-142" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ507-143()
  (command "._insert" "ZDZ_507-143" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ508()
  (command "._insert" "ZDZ_508" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-50()
  (command "._insert" "ZDZ_509-50" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-51()
  (command "._insert" "ZDZ_509-51" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-52()
  (command "._insert" "ZDZ_509-52" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-53()
  (command "._insert" "ZDZ_509-53" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-54()
  (command "._insert" "ZDZ_509-54" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-55()
  (command "._insert" "ZDZ_509-55" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-56()
  (command "._insert" "ZDZ_509-56" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-57()
  (command "._insert" "ZDZ_509-57" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-58()
  (command "._insert" "ZDZ_509-58" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-60()
  (command "._insert" "ZDZ_509-60" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-62()
  (command "._insert" "ZDZ_509-62" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-63()
  (command "._insert" "ZDZ_509-63" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-70()
  (command "._insert" "ZDZ_509-70" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-72()
  (command "._insert" "ZDZ_509-72" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-73()
  (command "._insert" "ZDZ_509-73" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-74()
  (command "._insert" "ZDZ_509-74" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-75()
  (command "._insert" "ZDZ_509-75" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-76()
  (command "._insert" "ZDZ_509-76" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-77()
  (command "._insert" "ZDZ_509-77" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-80()
  (command "._insert" "ZDZ_509-80" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-81()
  (command "._insert" "ZDZ_509-81" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-87()
  (command "._insert" "ZDZ_509-87" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-88()
  (command "._insert" "ZDZ_509-88" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-89()
  (command "._insert" "ZDZ_509-89" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-90()
  (command "._insert" "ZDZ_509-90" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-91()
  (command "._insert" "ZDZ_509-91" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-92()
  (command "._insert" "ZDZ_509-92" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-93()
  (command "._insert" "ZDZ_509-93" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-94()
  (command "._insert" "ZDZ_509-94" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-97()
  (command "._insert" "ZDZ_509-97" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-100()
  (command "._insert" "ZDZ_509-100" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-101()
  (command "._insert" "ZDZ_509-101" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ509-102()
  (command "._insert" "ZDZ_509-102" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ510()
  (command "._insert" "ZDZ_510" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ511()
  (command "._insert" "ZDZ_511" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ512()
  (command "._insert" "ZDZ_512" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ513()
  (command "._insert" "ZDZ_513" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ514()
  (command "._insert" "ZDZ_514" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ515()
  (command "._insert" "ZDZ_515" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ515-100()
  (command "._insert" "ZDZ_515-100" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ515-101()
  (command "._insert" "ZDZ_515-101" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ515-102()
  (command "._insert" "ZDZ_515-102" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ520()
  (command "._insert" "ZDZ_520" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ520.hx()
  (command "._insert" "ZDZ_520.hx" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ521()
  (command "._insert" "ZDZ_521" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ522()
  (command "._insert" "ZDZ_522" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ525()
  (command "._insert" "ZDZ_525" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ526()
  (command "._insert" "ZDZ_526" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ527()
  (command "._insert" "ZDZ_527" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ530()
  (command "._insert" "ZDZ_530" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ531()
  (command "._insert" "ZDZ_531" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ532()
  (command "._insert" "ZDZ_532" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

(defun c:DZ533()
  (command "._insert" "ZDZ_533" "_S" (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) "_R" 0 pause)
  (princ)
)

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

(defun c:DZ340-70_J)
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
;;          Zapnutie panulu nastrojov zo jestujucimi znackami           ;;
;;----------------------------------------------------------------------;;

(defun c:JTSignsCanceled()
  
  ;oznacenie bloku dopravneho znacenia
  (setq VyberBloku (nentsel "Vyberte dopravne znacenie:"))

  ;vypocet suradnic vybraneho bloku a jeho natocenie
  (setq Tmatrix (nth 2 VyberBloku))
  (setq blk_pt (nth 3 Tmatrix))
  (setq ang (/ (* 180.0 (angle '(0 0 0) (nth 0 Tmatrix))) pi))
  (setq xscale (nth 0 blk_pt))
  (setq yscale (nth 1 blk_pt))
  (princ xscale)
  (princ yscale)  

  ;vlozenie bloku krizika k dopravnej znacke
  (command "._insert" "KrizikDopravnehoZnacenia" (strcat (rtos xscale 2 2) "," (rtos yscale 2 2)) (/ (atof (getenv "GlobalnaSignBlocksScale")) 1000) ang pause)
  
  (princ)
  
)

;;----------------------------------------------------------------------;;
;;          Zapnutie panulu nastrojov zo jestujucimi znackami           ;;
;;----------------------------------------------------------------------;;

(defun c:JTSignsScale()
  
  ;zapis hodnoty parametru mierku dopravneho znacenia
  (setq signBlocksScale (getstring "Mierka dopravneho znacenia 1:"))

  ;nastavenie globalneho parametru
  (setenv "GlobalnaSignBlocksScale" signBlocksScale)
    
  ;hlaska o nastavenych parametroch
  (princ (strcat "\nNastavily ste mierku 1:" (getenv "GlobalnaSignBlocksScale") " pre vkladane bloky dopravneho znacenia!"))
    
  (princ)

)

;;----------------------------------------------------------------------;;

(vl-load-com)
(load "Version" "\nVerzia nenacitana!")
(princ
    (strcat
        "\nTraffic_signs.lsp | " (JTmenuVersion) " | Jakub Tomecko | "
        (menucmd "m=$(edtime,0,yyyy)")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;