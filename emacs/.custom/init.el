;;; init.el --- emacs config               -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Kyle Cierzan

;; Author: Kyle Cierzan
(recentf-mode 1)

(set-face-attribute 'default nil :font "BerkeleyMono Nerd Font" :weight 'regular :height 180)

(defun +setup-ielm-bindings ()
  "Configure custom bindings for `ielm-mode'"
  (define-key ielm-map (kbd "C-<return>") #'ielm-return))

(add-hook 'ielm-mode-hook #'+setup-ielm-bindings)

;; up elapaca package manager and enable use-package integration
(require 'elpaca-bootstrap)
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(use-package gcmh
  :init (setq gcmh-idle-delay 'auto
              gcmh-auto-idle-delay-factor 10
              gcmh-high-cons-threshold (* 32 1024 1024))
  (gcmh-mode 1))

(use-package which-key
  :init (which-key-mode 1)
  :config  (setq which-key-idle-delay 0.3))

(use-package vertico
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
  :commands
  (consult-bookmark
   consult-goto-line
   consult-imenu
   consult-locate
   consult-theme
   consult-man
   consult-recent-file
   consult-buffer
   consult-buffer-yank-pop)
  :init
  (setq consult-ripgrep-args
          (concat "rg -uu "
                  "--null --line-buffered --color=never --max-columns=1000 "
                  "--path-separator /   --smart-case --no-heading "
                  "--with-filename --line-number --search-zip "
                  "--hidden -g !.git -g !.svn -g !.hg"))
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
  :ensure (:host github
           :repo "protesilaos/modus-themes")
  :init
  (load-theme 'modus-vivendi-tinted t))

(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :config (setq wgrep-auto-save-buffer t))

(use-package fennel-mode
  :mode "\\.fnl\\'")

(use-package paredit
  :hook ((emacs-lisp-mode . enable-paredit-mode)
         (lisp-mode . enable-paredit-mode)
         (janet-mode . enable-paredit-mode)
         (ielm-mode . enable-paredit-mode)
         (fennel-mode . enable-paredit-mode)))

(use-package treesit-auto
  :init (setq treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :init
  (setq org-startup-indented t
        org-hide-leading-stars t)
  :ensure (:host github
           :repo "emacs-straight/org-mode"
           :files (:defaults "etc")
           :autoloads ("lisp/org-loaddefs.el")
           :main "lisp/org.el"
           :pre-build ("make")
           :build t))

(use-package corfu
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
        corfu-quit-no-match corfu-quit-at-boundary
        tab-always-indent 'complete)
  (add-to-list 'corfu-auto-commands #'lispy-colon))

(use-package cape
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

(use-package inf-ruby
  :autoload (inf-ruby-console-run)
  :init
  ;; switch to inf-ruby when a breakpoint is hit
  (add-hook 'compilation-filter-hook #'inf-ruby-auto-enter))

(use-package janet-mode
  :mode "\\.janet\\'")

(use-package transient
  :commands (magit-status magit-blame)
  :ensure (:host github
           :repo "magit/transient"
           :ref "bf2901927dce31d5522db95c6ab22a93f7738a09"))

(use-package magit
  :after transient
  :ensure (:host github
           :repo "magit/magit"
           :ref "8b2d4b03ecf9635c165d1c0f90cd6f2eb415cafa")
  :init
  (setq magit-auto-revert-mode nil)
  :config
  (setq transient-default-level 5 ; controls how many levels of magit menus we see
        magit-diff-refine-hook t
        magit-save-repository-buffers nil
        magit-revision-insert-related-refs nil))

(use-package forge
  :after magit
  :init
  ;; limit to 100 open topics and zero closed topics
  (setq forge-topic-list-limit '(100 . 0))
  :ensure (:host github
           :repo "magit/forge"
           :ref "8ab77ca4671d8a7f373f3b829ef94bacaee21b3a"))

(use-package ultra-scroll-mac
  :if (eq window-system 'mac)
  :ensure (:host github
           :repo "jdtsmith/ultra-scroll-mac")
  :init (setq scroll-conservatively 101
              scroll-margin 0)
  :config
  (ultra-scroll-mac-mode 1))

(use-package dumb-jump
  :ensure (:host github
           :repo "jacktasia/dumb-jump")
  :init
  (setq dumb-jump-force-searcher 'rg
        xref-show-definitions-function #'xref-show-definitions-completing-read)
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package rspec-mode
  :ensure (:host github
           :repo "pezra/rspec-mode")
  :hook (ruby-ts-mode . rspec-mode)
  :init (setq compilation-scroll-output t))

(use-package lsp-mode
  :ensure (:host github
           :repo "emacs-lsp/lsp-mode")
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-disabled-clients '(semgrep-ls rubocop-ls)
        lsp-keep-workspace-alive t
        lsp-enable-folding nil
        lsp-enable-text-document-color nil
        lsp-headerline-breadcrumb-enable nil
        lsp-diagnostics-provider :flymake
        lsp-completion-provider :none)
  :hook (ruby-ts-mode . lsp-deferred)
  :config
  (with-eval-after-load 'lsp-mode
    (progn
      (add-to-list 'lsp-language-id-configuration '(".*\\.html\\.erb$" . "html"))
      (lsp-register-client
       (make-lsp-client :new-connection (lsp-stdio-connection (list "rubocop" "--lsp"))
                        :major-modes '(ruby-ts-mode)
                        :priority 0
                        :add-on? t
                        :server-id 'addon-rubocop-ls))
      (lsp-register-client
       (make-lsp-client :new-connection (lsp-stdio-connection "ruby-lsp")
                        :major-modes '(ruby-ts-mode)
                        :multi-root t
                        :priority 100
                        :server-id 'ruby-lsp-ls))))
  (add-hook 'lsp-mode-hook #'lsp-completion-mode))

(use-package consult-lsp
  :after 'lsp
  :init
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols))

;; emacs-lsp-booster
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

(use-package avy
  :ensure (:host github
           :repo "abo-abo/avy")
  :init (global-set-key (kbd "C-'") #'avy-goto-char-timer)
  (setq avy-timeout-seconds 0.3)
  :commands (avy-goto-char-timer))

(require 'rails)

(defvar my-prefix-map (make-sparse-keymap)
  "Keymap for `S-SPC` prefix commands.")

;; TODO: There are a few modes where S-SPC is bound... 
(define-key global-map (kbd "S-SPC") my-prefix-map)
(define-key my-prefix-map (kbd "SPC") #'execute-extended-command)
(define-key my-prefix-map (kbd "r") #'consult-recent-file)
(define-key my-prefix-map (kbd "f") #'project-find-file)
(define-key my-prefix-map (kbd "p") #'project-switch-project)
(define-key my-prefix-map (kbd "b") #'consult-buffer)
(define-key my-prefix-map (kbd "s") #'consult-line)
(define-key my-prefix-map (kbd "l") #'consult-goto-line)
(define-key my-prefix-map (kbd "g") #'consult-ripgrep)
