;;; -*- lexical-binding: t; -*-

;;; Editor

;;  Global configuration for text modes

;; TODO: Install yasnippet

(global-hl-line-mode 1)
;; (global-linum-mode 1)
(electric-pair-mode -1)             ; smartparens should handle this
(electric-indent-mode 1)

(setq-default indent-tabs-mode nil
              vc-follow-symlinks t
              save-interprogram-paste-before-kill t
              fill-column 79
              sentence-end-double-space nil
              word-wrap t
              hscroll-margin 4
              hscroll-step 1
              scroll-conservatively 1001
              scroll-margin 0
              scroll-preserve-screen-position t
              indent-tabs-mode nil  ; spaces
              require-final-newline t
              tab-always-indent nil
              truncate-lines t
              truncate-partial-width-windows)

(use-package avy
  :ensure t
  :pin melpa-stable
  :commands
  (avy-goto-char-timer
   avy-goto-line)
  :general
  (general-define-key "s" 'avy-goto-char-timer)
  (jump-leader "l" 'avy-goto-line)
  :config
  (setq avy-timeout-seconds 0.35)
  (set-face-background 'avy-lead-face "#df8c8c")
  (set-face-background 'avy-goto-char-timer-face "#f2c38f")
  (setq avy-background t)) 

;; This is basically for modeline info
(use-package evil-anzu
  :ensure t
  :pin melpa-stable
  :config
  (global-anzu-mode 1)
  (setq anzu-cons-mode-line-p t
        anzu-minimum-input-length 1
        anzu-search-threshold 250)
  (add-hook 'isearch-mode-end-hook #'anzu--reset-status t)
  (add-hook '+evil-esc-hook #'anzu--reset-status t)
  (add-hook 'iedit-mode-end-hook #'anzu--reset-status))

(use-package swiper
  :ensure t
  :commands
  (swiper)
  :general
  (find-leader "l" 'swiper)
  :pin melpa)

;; TODO: is this baked in?
(use-package gtags
  :ensure t
  :pin melpa-stable)

;; TODO: Make bindings for edit leader
(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  (show-smartparens-global-mode t)
  (setq-default sp-highlight-pair-overlay nil
                sp-hybrid-kill-entire-symbol t)) 

(use-package wgrep
  :ensure t
  :pin melpa-stable)

;; OPTIMIZE: Make me a lot faster :(
(use-package flycheck
  :ensure t
  :pin melpa-stable
  :after exec-path-from-shell
  :init
  (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (flycheck-add-next-checker 'python-flake8 'python-pylint))

;; OPTIMIZE: Make popup just a bit faster
(use-package company
  :ensure t
  :pin melpa-stable
  :general
  (:keymaps 'company-active-map
            "C-w" nil
            "C-n" 'company-select-next
            "C-p" 'company-select-previous
            "C-S-h" 'company-show-doc-buffer
            "C-S-s" 'company-search-candidates
            "C-s" 'company-filter-candidates
            "C-h" 'company-quickhelp-manual-begin
            [tab] 'company-complete-common-or-cycle
            [backtab] 'company-select-previous)
  :config
  (global-company-mode 1)
  (setq company-idle-delay 0))
 
;; TODO: Set up bindings for edit leader
(use-package expand-region
  :ensure t
  :pin melpa-stable
  :general
  (general-define-key :states '(visual)
                      :keymaps 'global
                      "v" 'er/expand-region
                      "V" 'er/contract-region)) 

;; TODO: Set up keybindings for jump leader
(use-package smart-forward
  :ensure t
  :pin melpa
  :general
  ("C-c h" 'smart-backward)
  ("C-c j" 'smart-down)
  ("C-c k" 'smart-up)
  ("C-c l" 'smart-forward)) 

;; TODO: Set up keybindings for find leader
(use-package wgrep
  :ensure t
  :pin melpa-stable)

;; TODO Set up keybindings for MC leader
;;      Install evil-multiedit?        
(use-package evil-mc
  :ensure t
  :pin melpa-stable
  :commands
  (evil-mc-make-cursor-here
   evil-mc-make-all-cursors
   evil-mc-undo-all-cursors
   evil-mc-pause-cursors
   evil-mc-resume-cursors
   evil-mc-make-and-goto-first-cursor
   evil-mc-make-and-goto-last-cursor
   evil-mc-make-cursor-here
   evil-mc-make-cursor-move-next-line
   evil-mc-make-cursor-move-prev-line
   evil-mc-make-cursor-at-pos
   evil-mc-has-cursors-p
   evil-mc-make-and-goto-next-cursor
   evil-mc-skip-and-goto-next-cursor
   evil-mc-make-and-goto-prev-cursor
   evil-mc-skip-and-goto-prev-cursor
   evil-mc-make-and-goto-next-match
   evil-mc-skip-and-goto-next-match
   evil-mc-skip-and-goto-next-match
   evil-mc-make-and-goto-prev-match
   evil-mc-skip-and-goto-prev-match)
  :config
  (global-evil-mc-mode 1))

;; (use-package aggressive-indent
;;   :ensure t
;;   :pin melpa
;;   :config
;;   (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
;;   (add-hook 'python-mode-hook #'aggressive-indent-mode))
