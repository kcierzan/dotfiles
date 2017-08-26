;;; -*- lexical-binding: t; -*-

;;; User Interface

;; Change the appearance of emacs

;; TODO: Edit modeline evil colors
;;       Diminish annoying minor modes 
;;       Build modeline segments
;;       Add all-the-icons to modeline
;;       Add padding to nlinum
;;       Change flycheck bitmaps (fringe helper)
(set-face-foreground 'highlight nil)
(set-face-attribute 'hl-line nil :underline nil)
(set-face-attribute 'default nil
                    :family "FuraCode Nerd Font" :height 140 :weight 'normal) 

;; Pad line numbers
(setq-default linum-format " %d "
              bidi-display-reordering nil
              cursor-in-non-selected-windows nil
              frame-inhibit-implied-resize t
              highlight-nonselected-windows nil
              indicate-buffer-boundaries nil
              indicate-empty-lines nil
              max-mini-window-height 0.3
              jit-lock-defer-time nil
              jit-lock-stealth-nice 0.1
              jit-lock-stealth-time 0.2
              jit-lock-stealth-verbose nil
              mode-line-default-help-echo nil
              mouse-yank-at-point t
              resize-mini-windows t
              show-help-function nil)

(defun moon/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))

(add-hook 'after-make-frame-functions 'moon/disable-scroll-bars)

(defun moon/set-frame-padding (pix)
  )
(use-package doom-themes
  :ensure t
  :pin melpa
  :config
  (setq
   doom-themes-enable-bold t
   doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (set-face-foreground 'speedbar-button-face "#a7cc8c")
  (set-face-foreground 'speedbar-file-face "#72bef2")
  (set-face-foreground 'speedbar-selected-face "#d291e4")
  (set-face-foreground 'speedbar-tag-face "#dbaa79")
  (set-face-background 'sp-show-pair-match-face nil)
  (set-frame-parameter nil 'internal-border-width 15)
  (add-hook 'before-make-frame-hook (set-frame-parameter nil 'internal-border-width 15)))

(use-package all-the-icons
  :ensure t
  :pin melpa)

(use-package spaceline
  :ensure t
  :pin melpa
  :init
  (setq powerline-default-separator nil)
  :config
  (require 'spaceline-config)
  (spaceline-emacs-theme)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state))

(use-package sublimity
  :ensure t
  :pin melpa
  :config
  (sublimity-mode 1)
  (require 'sublimity-scroll)
  (setq sublimity-scroll-weight 5
        sublimity-scroll-drift-length 10))

(use-package winum
  :ensure t
  :pin melpa
  :config
  (setq winum-auto-setup-mode-line nil)
  (winum-mode))

;; TODO: Setup toggle for relative number mode
(use-package nlinum-relative
  :ensure t
  :pin melpa
  :config
  (nlinum-relative-setup-evil))
  ; (add-hook 'prog-mode-hook 'nlinum-relative-mode))

(use-package nlinum-hl
  :ensure t
  :pin melpa
  :config
  (run-with-idle-timer 5 t #'nlinum-hl-flush-window)
  (run-with-idle-timer 30 t #'nlinum-hl-flush-all-windows))

;; TODO: Setup toggle for fringe
(use-package vi-tilde-fringe
  :ensure t
  :pin melpa
  :config
  (add-hook 'prog-mode-hook 'vi-tilde-fringe-mode))

(use-package rainbow-delimiters
  :ensure t
  :pin melpa
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package kurecolor
  :ensure t
  :pin melpa)

(use-package rainbow-mode
  :ensure t
  :pin gnu)
