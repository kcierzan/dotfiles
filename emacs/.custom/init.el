;;; Init.el --- Emacs config  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Kyle Cierzan

;; Author: Kyle Cierzan
;;; Commentary:
;; Custom Emacs config
;;
;;; Code:
(require 'cl-lib)
(require 'lib)

;; set up elapaca package manager and enable use-package integration
(require 'elpaca-bootstrap)
(elpaca elpaca-use-package
        (elpaca-use-package-mode))

;; This package must load as soon as possible to set paths
;; used by other packages to write files to disk
(use-package no-littering
  :ensure (:host github
           :wait t
           :repo "emacscollective/no-littering"))

;; These settings cannot be set in the early-init.el file.
(recentf-mode 1)
(global-auto-revert-mode 1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(set-face-attribute 'default nil
                    :font "BerkeleyMono Nerd Font"
                    :weight 'regular
                    :height (if (eq system-type 'darwin)
                                180
                              130))

(use-package ielm
  :ensure nil
  :init
  (defun my/setup-ielm-bindings ()
    "Configure custom bindings for `ielm-mode'"
    (define-key ielm-map (kbd "C-<return>") #'ielm-return))
  (add-hook 'ielm-mode-hook #'my/setup-ielm-bindings))

(use-package gcmh
  :init (setq gcmh-idle-delay 'auto
              gcmh-auto-idle-delay-factor 10
              gcmh-high-cons-threshold (* 32 1024 1024))
  (gcmh-mode 1))

(use-package which-key
  :init (which-key-mode 1)
  :config (setq which-key-idle-delay 0.3))

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
                "--hidden -g !.git -g !.svn -g !.hg")
        :preface)
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

(use-package marginalia
  :init
  (define-key minibuffer-local-map (kbd "M-A") #'marginalia-cycle)
  (marginalia-mode 1)
  :config
  (advice-add #'marginalia--project-root :override #'my/project-root)
  (pushnew! marginalia-command-categories
            '(my/project-search . project-file)
            '(my/project-search-from-cwd . project-file)
            '(project-find-file . project-file)
            '(project-switch-to-buffer . buffer)
            '(project-switch-project . project-file)))

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
           :build t)
  :config
  ;; overrides org-cycle-agenda-files
  (define-key org-mode-map (kbd "C-'") #'avy-goto-char-timer))

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
  (add-to-list 'corfu-auto-commands #'lispy-colon)
  (define-key corfu-map (kbd "<tab>") #'corfu-next)
  (define-key corfu-map (kbd "<backtab>") #'corfu-previous))

(use-package cape
  :init
  (defconst +corfu-buffer-scanning-size-limit (* 1024 1024)) ; 1 MB
  (add-hook 'prog-mode-hook
            (defun +corfu-add-cape-file-h ()
              (add-hook 'completion-at-point-functions #'cape-file 10 t)))
  (setq cape-dabbrev-check-other-buffers t)
  (defun +dabbrev-friend-buffer-p (other-buffer)
    (< (buffer-size other-buffer) +corfu-buffer-scanning-size-limit))
  (defun +corfu-add-cape-dabbrev-h ()
    (add-hook 'completion-at-point-functions #'cape-dabbrev 20 t))
  (defun +corfu-add-cape-elisp-symbol-h ()
    (add-hook 'completion-at-point-functions #'cape-elisp-symbol 0 t))
  (with-eval-after-load 'dabbrev
    (setq dabbrev-friend-buffer-function #'+dabbrev-friend-buffer-p
          dabbrev-ignored-buffer-regexps
          '("\\` "
            "\\(TAGS\\|tags\\|ETAGS\\|etags\\|GTAGS\\|GRTAGS\\|GPATH\\)\\(<[0-9]+>\\)?")
          dabbrev-upcase-means-case-search t))
  (add-hook 'emacs-lisp-mode-hook #'+corfu-add-cape-elisp-symbol-h)
  (add-hook 'prog-mode-hook #'+corfu-add-cape-dabbrev-h)
  (add-hook 'prog-mode-hook #'+corfu-add-cape-file-h)
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
        lsp-diagnostics-provider :flymake)
  :hook ((ruby-ts-mode . lsp-deferred)
         (bash-ts-mode . lsp-deferred))
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

(use-package avy
  :ensure (:host github
           :repo "abo-abo/avy")
  :init (global-set-key (kbd "C-'") #'avy-goto-char-timer)
  (setq avy-timeout-seconds 0.3)
  :commands (avy-goto-char-timer))

(use-package nerd-icons-completion
  :ensure (:host github
           :repo "rainstormstudio/nerd-icons-completion")
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package pcre2el
  :ensure (:host github
           :repo "joddie/pcre2el")
  :commands (rxt-quote-pcre))

(use-package better-jumper
  :ensure (:host github
           :repo "gilbertw1/better-jumper")
  :commands (better-jumper-set-jump))

(use-package browse-at-remote
  :ensure (:host github
           :repo "rmuslimov/browse-at-remote")
  :commands (browse-at-remote))

(use-package meow
  :ensure (:host github
           :repo "meow-edit/meow")
  :config
  (setq meow-keypad-ctrl-meta-prefix ?!)
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))
    (meow-leader-define-key
     ;; SPC j/k will run the original command in MOTION state.
     '("j" . "H-j")
     '("k" . "H-k")
     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-delete)
     '("D" . meow-backward-delete)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("n" . meow-search)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("q" . meow-quit)
     '("Q" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-kill)
     '("t" . meow-till)
     '("u" . meow-undo)
     '("U" . meow-undo-in-selection)
     '("v" . meow-visit)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . meow-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("'" . repeat)
     '("<escape>" . ignore)))
  (meow-setup)
  (meow-global-mode 1)

  (meow-normal-define-key '("C-o" . pop-global-mark))
  (meow-leader-define-key '(":" .  execute-extended-command))
  (meow-leader-define-key '(";" .  eval-expression))

  (defvar my-search-map (make-sparse-keymap)
    "Keymap for consult-based searching commands")

  (meow-leader-define-key (cons "s" my-search-map))
  (define-key my-search-map (kbd "s") #'consult-line)
  (define-key my-search-map (kbd "g") #'consult-ripgrep)
  (define-key my-search-map (kbd "i") #'consult-imenu)
  (define-key my-search-map (kbd "I") #'consult-imenu-multi)

  (defvar my-project-map (make-sparse-keymap)
    "Keymap for project commands")

  (meow-leader-define-key (cons "p" my-project-map))
  (define-key my-project-map (kbd "f") #'project-find-file)
  (define-key my-project-map (kbd "p") #'project-switch-project)
  (define-key my-project-map (kbd "b") #'project-switch-to-buffer)
  (define-key my-project-map (kbd "d") #'project-find-dir)
  (define-key my-project-map (kbd "g") #'my/project-search)
  (define-key my-project-map (kbd "D") #'project-remember-projects-under)
  (define-key my-project-map (kbd "!" ) #'project-shell-command)
  (define-key my-project-map (kbd "&") #'project-async-shell-command)
  (define-key my-project-map (kbd "*") #'my/search-project-for-symbol-at-point)

  (defvar my-open-map (make-sparse-keymap)
    "Keymap for open commands")

  (meow-leader-define-key (cons "o" my-open-map))
  (define-key my-open-map (kbd "-") #'dired-jump)

  (defvar my-buffer-map (make-sparse-keymap)
    "Keymap for buffer commands")

  (meow-leader-define-key (cons "b" my-buffer-map))
  (define-key my-buffer-map (kbd "b") #'consult-buffer)
  (define-key my-buffer-map (kbd "l") #'consult-goto-line)
  (define-key my-buffer-map (kbd "d") #'kill-current-buffer)
  (define-key my-buffer-map (kbd "r") #'revert-buffer)
  (define-key my-buffer-map (kbd "s") #'basic-save-buffer)

  (defvar my-file-map (make-sparse-keymap)
    "Keymap for file commands")

  (meow-leader-define-key (cons "f" my-file-map))
  (define-key my-file-map (kbd "r") #'consult-recent-file)
  (define-key my-file-map (kbd "y") #'my/yank-buffer-path)
  (define-key my-file-map (kbd "g") #'my/project-search-from-cwd)
  (define-key my-file-map (kbd "f") #'consult-fd)

  (defvar my-git-map (make-sparse-keymap)
    "Keymap for git commands")

  (meow-leader-define-key (cons "g" my-git-map))
  (define-key my-git-map (kbd "g") #'magit-status)
  (define-key my-git-map (kbd "F") #'magit-fetch)
  (define-key my-git-map (kbd "R") #'vc-revert)
  (define-key my-git-map (kbd "L") #'magit-log-buffer-file)
  (define-key my-git-map (kbd "b") #'magit-branch-checkout)

  (defvar my-window-map (make-sparse-keymap)
    "Keymap for window commands")

  (defun my/split-right-and-select-new-window ()
    "Split the selected window and move point to the new window."
    (interactive)
    (select-window (split-window-right)))

  (defun my/split-down-and-select-new-window ()
    "Split the selected window vertically and move point to the new window."
    (interactive)
    (select-window (split-window-vertically)))

  (meow-leader-define-key (cons "w" my-window-map))
  (define-key my-window-map (kbd "h") #'windmove-left)
  (define-key my-window-map (kbd "l") #'windmove-right)
  (define-key my-window-map (kbd "j") #'windmove-down)
  (define-key my-window-map (kbd "k") #'windmove-up)
  (define-key my-window-map (kbd "q") #'delete-window)
  (define-key my-window-map (kbd "Q") #'kill-buffer-and-window)
  (define-key my-window-map (kbd "v") #'my/split-right-and-select-new-window)
  (define-key my-window-map (kbd "s") #'my/split-down-and-select-new-window)
  (define-key my-window-map (kbd "o") #'delete-other-windows)

  (defun my/really-quit-emacs ()
    "Quo vadis?"
    (interactive)
    (when (y-or-n-p "Really quit Emacs?")
      (save-buffers-kill-terminal)))

  (defvar my-quit-map (make-sparse-keymap)
    "Keymap for quitting commands.")

  (meow-leader-define-key (cons "q" my-quit-map))
  (define-key my-quit-map (kbd "q") #'my/really-quit-emacs)

  (with-eval-after-load 'corfu
    (add-hook 'meow-insert-exit-hook #'corfu-quit)))

(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

(use-package super-save
  :ensure (:host github
           :repo "bbatsov/super-save")
  :init (setq super-save-auto-save-when-idle t)
  :config (super-save-mode 1))

(use-package posframe
  :ensure (:host github
           :repo "tumashu/posframe"))

(use-package flymake-posframe
  :ensure (:host github
           :repo "Ladicle/flymake-posframe")
  :hook (flymake-mode . flymake-posframe-mode)
  :config
  (defun my/flymake-posframe-set-faces ()
    (set-face-attribute 'flymake-posframe-foreground-face nil
                        :font (face-attribute 'default :font)
                        :foreground (face-attribute 'default :foreground)
                        :background (face-attribute 'default :background))
    (set-face-attribute 'flymake-posframe-background-face nil
                        :font (face-attribute 'default :font)
                        :foreground (face-attribute 'default :foreground)
                        :background (face-attribute 'default :background)))
  (add-hook 'flymake-posframe-mode-hook #'my/flymake-posframe-set-faces))

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode))

(use-package dtrt-indent
  :ensure (:host github
           :repo "jscheid/dtrt-indent")
  :hook (prog-mode . dtrt-indent-global-mode))

(use-package yasnippet
  :hook ((emacs-lisp-mode . yas-minor-mode)
         (ruby-ts-mode . yas-minor-mode))
  :commands (yas-minor-mode-on
             yas-expand
             yas-minor-mode
             yas-expand-snippet
             yas-lookup-snippet
             yas-insert-snippet
             yas-new-snippet
             yas-visit-snippet-file
             yas-activate-extra-mode
             yas-deactivate-extra-mode
             yas-maybe-expand-abbrev-key-filter)
  :init
  (add-hook 'meow-insert-exit-hook #'yas-abort-snippet)
  (defvar yas-verbosity 2)
  :config
  (yas-reload-all))

(use-package yasnippet-capf
  :ensure (:host github
           :repo "elken/yasnippet-capf")
  :after cape
  :config
  (defun my/add-yas-capf-h ()
    "Add yas to capfs."
    (add-hook 'completion-at-point-functions #'yasnippet-capf 10 t))
  (add-hook 'prog-mode-hook #'my/add-yas-capf-h)
  (defun my/add-yas-capf ()
    "Add super lsp capf to `completion-at-point-functions'"
    (push (cape-capf-super #'yasnippet-capf #'lsp-completion-at-point #'cape-dabbrev)
          completion-at-point-functions))
  (with-eval-after-load-all '(cape lsp-mode)
                            (add-hook 'lsp-completion-mode-hook #'my/add-yas-capf)))

(require 'lsp-booster)
(require 'rails)
(require 'search)
(require 'files)
;;; init.el ends here
