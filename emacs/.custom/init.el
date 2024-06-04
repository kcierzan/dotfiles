;;; init.el --- emacs config               -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Kyle Cierzan

;; Author: Kyle Cierzan
(setq load-prefer-newer noninteractive)

(add-to-list 'load-path "~/.custom/lisp/")

;; need this to allow emacs to find libgccjit for native compilation
(setenv "LIBRARY_PATH"
        (string-join
         '("/opt/homebrew/opt/gcc/lib/gcc/14"
           "/opt/homebrew/opt/libgccjit/lib/gcc/14"
           "/opt/homebrew/opt/gcc/lib/gcc/14/gcc/aarch64-apple-darwin22/14")
         ":"))

(require 'elpaca-bootstrap)
(elpaca elpaca-use-package
        (elpaca-use-package-mode))


(scroll-bar-mode -1)
(tool-bar-mode -1)
(recentf-mode 1)
(tooltip-mode -1)
(setq byte-compile-warnings
      '(not free-vars unresolved noruntime lexical make-local))

(setq create-lockfiles nil
      auto-revert-interval 1
      inhibit-startup-message t
      make-backup-files nil
      global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

(setq-default ring-bell-function 'ignore
              idle-update-delay 0.5
              inhibit-startup-screen t
              inhibit-startup-echo-area-message user-login-name
              inhibit-default-init t
              initial-scratch-message nil
              indent-tabs-mode nil
              hl-line-sticky-flag nil
              sentence-end-double-space nil)

(setq mac-command-modifier 'super
      mac-option-modifier 'meta)

(defalias 'yes-or-no-p 'y-or-n-p)

(advice-add 'custom-save-all :override #'ignore)
(advice-add 'custom-set-variables :override #'ignore)
(advice-add 'custom-set-faces :override #'ignore)

(set-face-attribute 'default nil :font "MonaspiceNe Nerd Font" :weight 'medium :height 170)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(defun +setup-ielm-bindings ()
  "Configure custom bindings for `ielm-mode'"
  (define-key ielm-map (kbd "C-<return>") #'ielm-return))

(add-hook 'ielm-mode-hook #'+setup-ielm-bindings)

(use-package which-key
  :init (which-key-mode 1)
  :ensure t
  :config  (setq which-key-idle-delay 0.3))

(use-package vertico
  :ensure t
  :init
  (setq vertico-resize nil
        vertico-count 17
        vertico-cycle t)
  (setq-default completion-in-region-function
                (lambda (&rest args)
                  (apply (if vertico-mode
                             #'consult-completion-in-region
                           #'completion--in-region)
                         args)))
  (vertico-mode 1))

(use-package consult
  :ensure t
  :defer t
  :preface
  (dolist (mapping '(([remap bookmark-jump] . #'consult-bookmark)
                     ([remap goto-line] . #'consult-goto-line)
                     ([remap imenu] . #'consult-imenu)
                     ([remap Info-search] . #'consult-info)
                     ([remap locate] . #'consult-locate)
                     ([remap load-theme] . #'consult-theme)
                     ([remap man] . #'consult-man)
                     ([remap recentf-open-files] . #'consult-recent-file)
                     ;; TODO: fix package loading issue causing the argument type error without the lambda
                     ([remap switch-to-buffer] . (lambda () (interactive) (consult-buffer)))
                     ([remap switch-to-buffer-other-window] . #'consult-buffer-other-window)
                     ([remap switch-to-buffer-other-frame] . #'consult-buffer-other-frame)
                     ([remap yank-pop] . #'consult-yank-pop)))
    (global-set-key (car mapping) (cdr mapping)))
  :config
  (setq consult-line-numbers-widen t
        consult-narrow-key "<"
        consult-async-min-input 2
        consult-async-refresh-delay 0.15
        consult-async-input-throttle 0.2
        consult-async-input-debounce 0.1
        consult-fd-args
        '("fd" "--color=never"
          "--full-path --absolute-path"
          "--hidden --exclude .git"))
  (consult-customize consult-ripgrep
                     consult-git-grep
                     consult-grep
                     consult-bookmark
                     consult-recent-file
                     consult--source-recent-file
                     consult--source-project-recent-file
                     consult--source-bookmark
                     :preview-key "C-SPC"))

(use-package orderless
  :ensure t
  :config
  (defun +vertico-orderless-dispatch (pattern _index _total)
    (cond
     ;; Ensure $ works with Consult commands, which add disambiguation suffixes
     ((string-suffix-p "$" pattern)
      `(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x200000-\x300000]*$")))
     ;; Ignore single !
     ((string= "!" pattern) `(orderless-literal . ""))
     ;; Without literal
     ((string-prefix-p "!" pattern) `(orderless-without-literal . ,(substring pattern 1)))
     ;; Annotation
     ((string-prefix-p "&" pattern) `(orderless-annotation . ,(substring pattern 1)))
     ((string-suffix-p "&" pattern) `(orderless-annotation . ,(substring pattern 0 -1)))
     ;; Character folding
     ((string-prefix-p "%" pattern) `(char-fold-to-regexp . ,(substring pattern 1)))
     ((string-suffix-p "%" pattern) `(char-fold-to-regexp . ,(substring pattern 0 -1)))
     ;; Initialism matching
     ((string-prefix-p "`" pattern) `(orderless-initialism . ,(substring pattern 1)))
     ((string-suffix-p "`" pattern) `(orderless-initialism . ,(substring pattern 0 -1)))
     ;; Literal matching
     ((string-prefix-p "=" pattern) `(orderless-literal . ,(substring pattern 1)))
     ((string-suffix-p "=" pattern) `(orderless-literal . ,(substring pattern 0 -1)))
     ;; Flex matching
     ((string-prefix-p "~" pattern) `(orderless-flex . ,(substring pattern 1)))
     ((string-suffix-p "~" pattern) `(orderless-flex . ,(substring pattern 0 -1)))))
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        orderless-style-dispatchers '(+vertico-orderless-dispatch)
        orderless-component-separator #'orderless-escapable-split-on-space)
  (set-face-attribute 'completions-first-difference nil :inherit nil))

(use-package modus-themes
  :ensure t
  :pin melpa
  :init
  (load-theme 'modus-vivendi-tinted t))

(use-package wgrep
  :ensure t
  :commands wgrep-change-to-wgrep-mode
  :config (setq wgrep-auto-save-buffer t))

(use-package vertico-posframe
  :ensure (:host github
           :repo "tumashu/vertico-posframe"
           :ref "2e0e09e5bbd6ec576ddbe566ab122575ef051fab"))

(use-package fennel-mode
  :ensure t
  :mode "\\.fnl\\'")

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode . enable-paredit-mode)
         (lisp-mode . enable-paredit-mode)
         (ielm-mode . enable-paredit-mode)
         (fennel-mode . enable-paredit-mode)))

(use-package treesit-auto
  :ensure t
  :init (setq treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package org
  :ensure (:host github
           :repo "emacs-straight/org-mode"
           :files (:defaults "etc")
           :autoloads ("lisp/org-loaddefs.el")
           :main "lisp/org.el"
           :pre-build ("make")
           :build t))

(use-package corfu
  :ensure t
  :init (global-corfu-mode 1)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.18
        corfu-auto-prefix 2
        global-corfu-modes '((not erc-mode
                              circe-mode
                              help-mode
                              gud-mode
                              vterm-mode)
                             t)
        corfu-cycle t
        corfu-preselect 'prompt
        corfu-max-width 120
        corfu-on-exact-match nil
        corfu-quit-at-boundary 'separator
        tab-always-indent 'complete)
  (add-to-list 'corfu-auto-commands #'lispy-colon))

(use-package cape
  :ensure t
  :init
  (defconst +corfu-buffer-scanning-size-limit (* 1024 1024)) ; 1 MB
  (add-hook 'prog-mode-hook
            (defun +corfu-add-cape-file-h ()
              (add-hook 'completion-at-point-functions #'cape-file -10 t)))
  (setq cape-dabbrev-check-other-buffers t)
  (defun +dabbrev-friend-buffer-p (other-buffer)
    (< (buffer-size other-buffer) +corfu-buffer-scanning-size-limit))
  (defun +corfu-add-cape-dabbrev-h ()
    (add-hook 'completion-at-point-functions #'cape-dabbrev 20 t))
  (with-eval-after-load 'dabbrev
    (setq dabbrev-friend-buffer-function #'+dabbrev-friend-buffer-p
          dabbrev-ignored-buffer-regexps
          '("\\` "
            "\\(TAGS\\|tags\\|ETAGS\\|etags\\|GTAGS\\|GRTAGS\\|GPATH\\)\\(<[0-9]+>\\)?")
          dabbrev-upcase-means-case-search t))
  (add-hook 'prog-mode-hook #'+corfu-add-cape-dabbrev-h)
  (add-hook 'text-mode-hook #'+corfu-add-cape-dabbrev-h)
  (add-hook 'conf-mode-hook #'+corfu-add-cape-dabbrev-h)
  (add-hook 'comint-mode-hook #'+corfu-add-cape-dabbrev-h)
  (add-hook 'eshell-mode-hook #'+corfu-add-cape-dabbrev-h)
  (advice-add #'pcomplete-completions-at-point :around #'cape-wrap-nonexclusive))

(defvar my-prefix-map (make-sparse-keymap)
  "Keymap for `S-SPC` prefix commands.")

(define-key global-map (kbd "S-SPC") my-prefix-map)
(define-key my-prefix-map (kbd "f") #'recentf-open)
(define-key my-prefix-map (kbd "p") #'project-switch-project)
(define-key my-prefix-map (kbd "b") #'consult-buffer)
(define-key my-prefix-map (kbd "s") #'consult-line)
(define-key my-prefix-map (kbd "g") #'consult-ripgrep)
