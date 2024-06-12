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

(setq package-enable-at-startup nil
      create-lockfiles nil
      read-process-output-max (* 64 1024) ; 64KB
      redisplay-skip-fontification-on-input t ; helps a little with scrolling
      highlight-nonselected-windows nil
      fast-but-imprecise-scrolling t
      auto-revert-interval 1
      inhibit-startup-message t
      auto-revert-interval 1
      auth-sources '("~/.authinfo.gpg")
      inhibit-startup-message t
      frame-title-format "emacs"
      backup-directory-alist '(("." . "~/.custom/backups/"))
      auto-save-default t
      auto-save-include-big-deletions t
      auto-save-list-file-prefix "~/.custom/autosave/"
      ;; auto-save-file-name-transforms '((".*" . auto-save-list-file-prefix t))
      make-backup-files nil
      mac-command-modifier 'super
      mac-option-modifier 'meta
      global-auto-revert-non-file-buffers t
      auto-revert-verbose nil
      use-package-always-ensure t
      load-prefer-newer noninteractive)

(setq byte-compile-warnings
      '(not free-vars unresolved noruntime lexical make-local))

(setq-default ring-bell-function 'ignore
              idle-update-delay 0.5
              inhibit-startup-screen t
              inhibit-startup-echo-area-message user-login-name
              inhibit-default-init t
              initial-scratch-message nil
              indent-tabs-mode nil
              hl-line-sticky-flag nil
              sentence-end-double-space nil)

(eval-and-compile
  (setq gc-cons-threshold (* 32 1024 1024)))

(defconst envvar-file "~/.custom/env")

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
  (add-hook 'emacs-startup-hook #'teardown-init-perf))

(configure-init-perf)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

(set-language-environment "UTF-8")

(defun load-envvars-file (file &optional noerror)
  "Read and set envvars from FILE.
If NOERROR is non-nil, don't throw an error if the file doesn't exist or is
unreadable. Returns the names of envvars that were changed."
  (if (null (file-exists-p file))
      (unless noerror
        (signal 'file-error (list "No envvar file exists" file)))
    (with-temp-buffer
      (insert-file-contents file)
      (when-let (env (read (current-buffer)))
        (let ((tz (getenv-internal "TZ")))
          (setq-default
           process-environment
           (append env (default-value 'process-environment))
           exec-path
           (append (split-string (getenv "PATH") path-separator t)
                   (list exec-directory))
           shell-file-name
           (or (getenv "SHELL")
               (default-value 'shell-file-name)))
          (when-let (newtz (getenv-internal "TZ"))
            (unless (equal tz newtz)
              (set-time-zone-rule newtz))))
        env))))

(load-envvars-file envvar-file)

(add-to-list 'load-path "~/.custom/lisp/")

;; Emacs requires libgccjit for native compilation
(setenv "LIBRARY_PATH"
        (string-join
         '("/opt/homebrew/opt/gcc/lib/gcc/14"
           "/opt/homebrew/opt/libgccjit/lib/gcc/14"
           "/opt/homebrew/opt/gcc/lib/gcc/14/gcc/aarch64-apple-darwin22/14")
         ":"))

(defalias 'yes-or-no-p 'y-or-n-p)

(advice-add 'custom-save-all :override #'ignore)
(advice-add 'custom-set-variables :override #'ignore)
(advice-add 'custom-set-faces :override #'ignore)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;;; early-init.el ends here
