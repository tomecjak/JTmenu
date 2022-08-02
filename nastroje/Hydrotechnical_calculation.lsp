;=========================================================================
; Hydrotechnical_calculation.lsp
; (c) Copyright 2022 Tomecko Jakub
; Verzia: 0.9 beta
;
; Hydrotechnicky vypocet koryta pre storocnu vodu (Q100) podla xxx
;-------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------------
; c:MyPickButton - Dialog example for hiding a dialog and picking an object and
; returning the information of the object selected.
; Syntax: MyPickButton
;----------------------------------------------------------------------------------------------------------
(defun c:MyPickButton (/ Dcl_Id% EntIns$ EntLayer$ EntList@ EntName^ EntPick@
  EntType$ EntXpt$ EntYpt$ Found Item Return# Text1$ Text2$ Text3$)
  (princ "\nMyPickButton")(princ)
  ; Set Default Variables
  (if (not *MyPickButton@);Unique global variable name to store dialog info
    (setq *MyPickButton@ (list nil "" "" ""))
  );if
  ; Load Dialog
  (setq Dcl_Id% (load_dialog "Hydrotechnical_calculation.dcl"))
  (setq Return# 2)
  (while (/= Return# 1)
    (new_dialog "Hydrotechnical_calculation" Dcl_Id%)
    ; Set Variables and Dialog Initial Settings
    (setq Text1$ (nth 1 *MyPickButton@)
          Text2$ (nth 2 *MyPickButton@)
          Text3$ (nth 3 *MyPickButton@)
    );setq
    (set_tile "Title" " My Pick Button")
    (select_pick);*Included
    (set_tile "Prompt" "Select an object")
    (set_tile "Text1" Text1$)
    (set_tile "Text2" Text2$)
    (set_tile "Text3" Text3$)
    ; Dialog Actions
    (action_tile "select_pick" "(done_dialog 2)")
    (action_tile "accept" "(done_dialog 1)")
    (setq Return# (start_dialog))
    (if (= Return# 2)
      (if (setq EntPick@ (entsel))
        (progn
          (setq EntName^ (car EntPick@)
                EntList@ (entget EntName^)
                EntType$ (cdr (assoc 0 EntList@))
                EntLayer$ (cdr (assoc 8 EntList@))
                EntXpt$ (rtos (nth 1 (assoc 10 EntList@)) 2 3)
                EntYpt$ (rtos (nth 2 (assoc 10 EntList@)) 2 3)
                EntIns$ (strcat EntXpt$ "," EntYpt$)
                Found t
          );setq
          (setq *MyPickButton@ (list Found
                   (strcat "Object Type: " EntType$)
                   (strcat "Object Layer: " EntLayer$)
                   (strcat "Insertion point: " EntIns$))
          );setq
          (foreach Item EntList@
            (princ "\n")(princ Item)
          );foreach
          (princ "\n")
        );progn
        (progn
          (setq Found (nth 0 *MyPickButton@))
          (setq *MyPickButton@ (list Found "" "\t    No object selected" ""))
          (setq EntList@ nil)
        );progn
      );if
    );if
  );while
  ; Unload Dialog
  (unload_dialog Dcl_Id%)
  (if (nth 0 *MyPickButton@)
    (textscr)
  );if
  (setq *MyPickButton@ (list nil "" "" ""))
  (princ)
);defun c:MyPickButton

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\n:: Hydrotechnical_calculation.lsp | Version 0.9 beta | Vyrobil: Jakub Tomecko "
        (menucmd "m=$(edtime,0,yyyy) ::")
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;