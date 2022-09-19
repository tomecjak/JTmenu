;automatically create new dimension style
(defun c:jeff ()
    (setvar "DIMCLRD" "ByBlock")

    (command "dimstyle" "s" "Jeff50")

    (princ)
)