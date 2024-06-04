;;; early-init.el --- Run Elisp before the GUI starts -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024 Kyle Cierzan
;;
;; Author: Kyle Cierzan
;; Maintainer: Kyle Cierzan
;; Created: May 31, 2024
;; Modified: May 31, 2024
;; Version: 0.0.1
;; Keywords: lisp
;; Homepage: https://github.com/kcierzan/early-init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
(require 'cl-lib)

(setq package-enable-at-startup nil)

(eval-and-compile
  (setq gc-cons-threshold (* 16 1024 1024)))

(defvar original-gc-cons-threshold-backup nil
  "Variable to hold a backup of `gc-cons-threshold'.")

(defvar original-file-name-handler-alist nil
  "Variable to hold a backup of `file-name-handler-alist'.")

(defun teardown-init-perf ()
  "Reset the performance hacks set in `configure-init-perf'."
  (setq file-name-handler-alist (cl-union original-file-name-handler-alist
                                          file-name-handler-alist
                                          :test #'equal))
  (when (= gc-cons-threshold most-positive-fixnum)
    (setq gc-cons-threshold original-gc-cons-threshold))
  (setq original-file-name-handler-alist nil
        original-gc-cons-threshold-backup nil))

(defun configure-init-perf ()
  "Setup vars and behavior only for initialization process"
  (setq original-gc-cons-threshold-backup gc-cons-threshold
        original-file-name-handler-alist file-name-handler-alist)
  (setq gc-cons-threshold most-positive-fixnum
        file-name-handler-alist nil)
  (add-hook 'emacs-startup-hook #'quicken-teardown))

(add-function :after after-focus-change-function 'garbage-collect)

;;; early-init.el ends here
