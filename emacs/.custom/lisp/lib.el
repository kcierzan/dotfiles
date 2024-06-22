;;; lib.el --- A collection of convenience functions and macros  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Kyle Cierzan

;; Author: Kyle Cierzan
;; Keywords: lisp

(defmacro pushnew! (place &rest values)
  "Push VALUES sequentially into PLACE, if they aren't already present.
This is a variadic `cl-pushnew'."
  (let ((var (make-symbol "result")))
    `(dolist (,var (list ,@values) (with-no-warnings ,place))
       (cl-pushnew ,var ,place :test #'equal))))

(defun with-eval-after-load-all (my-features form)
  "Run FORM after all MY-FEATURES are loaded.
See `eval-after-load' for the possible formats of FORM."
  (if (null my-features)
      (if (functionp form)
          (funcall form)
        (eval form))
    (with-eval-after-load (car my-features)
      `(lambda ()
         (with-eval-after-load-all
          (quote ,(cdr my-features))
          (quote ,form))))))

(provide 'lib)
;;; lib.el ends here
