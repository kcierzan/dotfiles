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
(use-package recentf
  :ensure nil
  :init
  (setq recentf-max-menu-items 100
        recentf-max-saved-items 100)
  (recentf-mode 1))

(global-auto-revert-mode 1)
(setq-default display-line-numbers-width 3)
(setq auto-window-vscroll nil
      scroll-preserve-screen-position t
      indicate-buffer-boundaries nil
      indicate-empty-lines nil
      frame-resize-pixelwise t
      window-resize-pixelwise nil
      comint-buffer-maximum-size 2048
      compile-always-kill t
      compilation-scroll-output 'first-error
      echo-keystrokes 0.02
      split-width-threshold 160
      split-height-threshold nil
      window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1
      line-spacing 2)
(window-divider-mode 1)
(tooltip-mode -1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'conf-mode-hook 'display-line-numbers-mode)
(add-hook 'compilation-filter-hook #'comint-truncate-buffer)
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
  :init
  (setq which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6)
  (which-key-mode 1)
  :config (setq which-key-idle-delay 0.3)
  (add-hook 'which-key-init-buffer-hook
            (lambda (&rest _) (setq-local line-spacing 6))))

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
  :init
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.18
        corfu-popupinfo-delay 1
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
  :after which-key
  :config
  (setq meow-keypad-ctrl-meta-prefix ?!
        meow-use-cursor-position-hack t
        meow-use-clipboard t)
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))
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

  ;; Cribbed from doom: this adds a C-i keybind as distict from
  ;; TAB. Emacs ordinarily considers them to be the same key to
  ;; avoid breaking compatibility with terminal emacs
  (define-key key-translation-map [?\C-i]
              (lambda (&rest _)
                (interactive)
                (if (let ((keys (this-single-command-raw-keys)))
                      (and keys
                           (not (cl-position 'tab keys))
                           (not (cl-position 'kp-tab keys))
                           (display-graphic-p)))
                    [C-i] [?\C-i])))

  (defvar my-prefix-map (make-sparse-keymap))

  (meow-normal-define-key '("C-o" . better-jumper-jump-backward))
  (meow-normal-define-key '("<C-i>" . better-jumper-jump-forward))
  (meow-normal-define-key '("C-r" . undo-redo))
  (define-key my-prefix-map (kbd ":") (cons "M-x" 'execute-extended-command))
  (define-key my-prefix-map (kbd ";") (cons "eval expression" 'eval-expression))

  (setq meow-keypad-meta-prefix nil
        meow-keypad-ctrl-meta-prefix nil
        meow-keypad-literal-prefix nil
        meow-keypad-start-keys nil)
  (define-key meow-normal-state-keymap (kbd "SPC") my-prefix-map)
  (define-key meow-motion-state-keymap (kbd "SPC") my-prefix-map)


  (defmacro bind-leader-keys (&rest args)
    (let* ((prefix (plist-get args :prefix))
           (keys (plist-get args :keys))
           (prefix-keymap (caddr prefix))
           (prefix-key (car prefix))
           (prefix-name (cadr prefix)))
      `(progn
         (defvar ,prefix-keymap (make-sparse-keymap))
         (define-key my-prefix-map
                     (kbd ,prefix-key)
                     (cons ,prefix-name ,prefix-keymap))
         ,@(mapcar (lambda (key)
                     `(define-key ,prefix-keymap
                                  (kbd ,(car key))
                                  (cons ,(cadr key) ,(caddr key))))
                   keys))))


  ;; search
  (bind-leader-keys :prefix ("s" "search" my-search-map)
                    :keys (("s" "search lines" #'consult-line)
                           ("g" "search in files" #'consult-ripgrep)
                           ("i" "search buffer symbols" #'consult-imenu)
                           ("I" "search all open buffer symbols" #'consult-imenu-multi)))

  ;; project prefix
  (bind-leader-keys :prefix ("p" "project" my-project-map)
                    :keys (("f" "find project file" #'project-find-file)
                           ("p" "switch project" #'project-switch-project)
                           ("b" "open project buffer" #'project-switch-to-buffer)
                           ("d" "find project directory" #'project-find-dir)
                           ("g" "search in project files" #'my/project-search)
                           ("a" "add project" #'project-remember-projects-under)
                           ("!" "run shell command in project" #'project-shell-command)
                           ("&" "run async shell command in project" #'project-async-shell-command)
                           ("*" "search project for symbol at point" #'my/search-project-for-symbol-at-point)))

  ;; open prefix
  (bind-leader-keys :prefix ("o" "open" my-open-map)
                    :keys (("-" "dired" #'dired-jump)
                           ("t" "terminal" #'vterm)))


  ;; buffer prefix
  (bind-leader-keys :prefix ("b" "buffer" my-buffer-map)
                    :keys (("b" "open buffers" #'consult-buffer)
                           ("l" "goto line" #'consult-goto-line)
                           ("d" "kill current buffer" #'kill-current)
                           ("r" "revert buffer" #'revert-buffer)
                           ("s" "save buffer" #'basic-save-buffer)))
  ;; file prefix
  (bind-leader-keys :prefix ("f" "files" my-file-map)
                    :keys (("r" "recent files" #'consult-recent-file)
                           ("y" "yank path to buffer file" #'my/yank-buffer-path)
                           ("g" "project search from cwd" #'my/project-search-from-cwd)
                           ("f" "search files" #'consult-fd)))

  ;; git prefix
  (bind-leader-keys :prefix ("g" "git" my-git-map)
                    :keys (("g" "status" #'magit-status)
                           ("F" "fetch" #'magit-fetch)
                           ("R" "revert" #'vc-revert)
                           ("L" "log buffer file" #'magit-log-buffer-file)
                           ("b" "checkout" #'magit-branch-checkout)
                           ("]" "next hunk" #'diff-hl-next-hunk)
                           ("[" "previous hunk" #'diff-hl-previous-hunk)))

  ;; window prefix
  (defun my/split-right-and-select-new-window ()
    "Split the selected window and move point to the new window."
    (interactive)
    (select-window (split-window-right))
    (balance-windows))

  (defun my/split-down-and-select-new-window ()
    "Split the selected window vertically and move point to the new window."
    (interactive)
    (select-window (split-window-vertically))
    (balance-windows))

  (bind-leader-keys :prefix ("w" "window" my-window-map)
                    :keys (("h" "move left" #'windmove-left)
                           ("l" "move right" #'windmove-right)
                           ("j" "move down" #'windmove-down)
                           ("k" "move up" #'windmove-up)
                           ("q" "delete" #'delete-window)
                           ("D" "kill buffer and window" #'kill-buffer-and-window)
                           ("v" "split right" #'my/split-right-and-select-new-window)
                           ("s" "split down" #'my/split-down-and-select-new-window)
                           ("o" "delete other windows" #'delete-other-windows)
                           ("=" "balance windows" #'balance-windows)))

  ;; help prefix
  (bind-leader-keys :prefix ("h" "help" my-help-map)
                    :keys (("f" "function" #'helpful-function)
                           ("c" "callable" #'helpful-callable)
                           ("m" "macro" #'helpful-macro)
                           ("k" "key" #'helpful-key)
                           ("v" "variable" #'helpful-variable)
                           ("p" "at point" #'helpful-at-point)))

  ;; quit prefix
  (defun my/really-quit-emacs ()
    "Quo vadis?"
    (interactive)
    (when (y-or-n-p "Really quit Emacs?")
      (save-buffers-kill-terminal)))

  (bind-leader-keys :prefix ("q" "quit" my-quit-map)
                    :keys (("q" "quit" #'my/really-quit-emacs)))

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

(use-package vterm
  :commands (vterm)
  :init (setq vterm-kill-buffer-on-exit t
              vterm-max-scrollback 10000))

(use-package project
  :ensure nil
  :init
  (defun my/magit-project ()
    (interactive)
    (magit-status (project-root (project-current t))))
  (setq project-switch-commands '((project-find-file "Find file" "f")
                                  (my/project-search "Search" "s")
                                  (my/magit-project "Magit" "g"))))

(use-package helpful
  :ensure (:host github
           :repo "Wilfred/helpful")
  :commands (helpful-callable
             helpful-function
             helpful-macro
             helpful-command
             helpful-key
             helpful-variable
             helpful-at-point)
  :init
  (setq apropos-do-all t)
  (global-set-key [remap describe-function] #'helpful-callable)
  (global-set-key [remap describe-command]  #'helpful-command)
  (global-set-key [remap describe-variable] #'helpful-variable)
  (global-set-key [remap describe-key]      #'helpful-key)
  (global-set-key [remap describe-symbol]   #'helpful-symbol))

(use-package dired
  :ensure nil
  :commands dired-jump
  :init
  (setq dired-dwim-target t
        dired-hide-details-hide-symlink-targets t
        ;; don't prompt for reverts
        dired-auto-revert-buffer #'dired-buffer-stale-p
        ;; copy and delete recursively
        dired-recursive-copies 'always))

(use-package diff-hl
  :ensure (:host github
           :repo "dgutov/diff-hl")
  :init
  (global-diff-hl-mode 1))

(use-package pulsar
  :ensure (:host github
           :repo "protesilaos/pulsar")
  :init
  (setq pular-pulse t
        pulsar-iterations 15)
  (add-hook 'consult-after-jump-hook #'pulsar-recenter-center)
  (with-eval-after-load 'meow
    (advice-add #'meow-visit :after (lambda (&rest _) (pulsar-pulse-line))))
  (pulsar-global-mode 1))

(require 'lsp-booster)
(require 'rails)
(require 'search)
(require 'files)
;;; init.el ends here
