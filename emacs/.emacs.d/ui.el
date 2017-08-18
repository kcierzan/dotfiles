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
                    :family "Iosevka Nerd Font" :height 140 :weight 'normal) 

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
  (set-face-background 'sp-show-pair-match-face nil))  

(use-package all-the-icons
  :ensure t
  :pin melpa-stable)

;; (use-package spaceline
;;   :ensure t
;;   :pin melpa
;;   :init
;;   (setq powerline-default-separator nil)
;;   :config
;;   (require 'spaceline-config)
;;   (spaceline-emacs-theme)
;;   (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state))

(use-package telephone-line
  :ensure t
  :pin melpa 
  :config
  (defface one-evil-normal '((t (:foreground "#282c34" :background "#51afef"))) "")
  (defface one-evil-insert '((t (:foreground "#282c34" :background "#98be65"))) "")
  (defface one-evil-visual '((t (:foreground "#282c34" :background "#c678dd"))) "")
  (defface one-evil-motion '((t (:foreground "#282c34" :background "#da8548"))) "")
  (defface one-evil-emacs '((t (:foreground "#282c34" :background "#ecbe7b"))) "")
  (defface one-evil-replace '((t (:foreground "#282c34" :background "#ff6c6b"))) "")
  (defface one-evil-operator '((t (:foreground "#282c34" :background "#5699af"))) "")
  (setq face-remapping-alist
        '((telephone-line-evil-normal . one-evil-normal)
          (telephone-line-evil-insert . one-evil-insert)
          (telephone-line-evil-visual . one-evil-visual)
          (telephone-line-evil-motion . one-evil-motion)
          (telephone-line-evil-emacs . one-evil-emacs)
          (telephone-line-evil-replace . one-evil-replace)
          (telephone-line-evil-operator . one-evil-operator)))
  (setq telephone-line-lhs
        '((evil . (telephone-line-evil-tag-segment))
          (accent .(telephone-line-vc-segment
                    telephone-line-erc-modified-channels-segment
                    telephone-line-process-segment))
          (nil . (telephone-line-minor-mode-segment
                  telephone-line-buffer-segment)))) 
  (setq telephone-line-rhs
        '((nil . (telephone-line-misc-info-segment))
          (accent . (telephone-line-major-mode-segment))
          (evil . (telephone-line-airline-position-segment))))
  (setq telephone-line-primary-left-separator     'telephone-line-nil
        telephone-line-primary-right-separator    'telephone-line-nil
        telephone-line-secondary-right-separator  'telephone-line-nil
        telephone-line-secondary-left-separator   'telephone-line-nil
        telephone-line-height 24)
  (telephone-line-evil-config)) 

(use-package sublimity
  :ensure t
  :pin melpa-stable
  :config
  (sublimity-mode 1)
  (require 'sublimity-scroll)
  (setq sublimity-scroll-weight 5
        sublimity-scroll-drift-length 10))

(use-package winum
  :ensure t
  :pin melpa-stable
  :config
  (setq winum-auto-setup-mode-line nil)
  (winum-mode))

;; TODO: Setup toggle for relative number mode
(use-package nlinum-relative
  :ensure t
  :pin melpa
  :config
  (nlinum-relative-setup-evil)
  (add-hook 'prog-mode-hook 'nlinum-relative-mode))

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
