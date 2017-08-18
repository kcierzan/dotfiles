;;; -*- lexical-binding: t; -*-

;;; Evil

;;  Evil is the product of the
;;  ability of humans to make abstract
;;  that which is concrete.

;; Many functions shamelessly lifted from https://github.com/hlissner/.emacs.d
;; TODO: Implement mutlicursor packages found in hlissner's .emacs.d

(autoload 'goto-last-change "goto-chg")
(autoload 'goto-last-change-reverse "goto-chg")

(use-package evil
  :ensure t
  :pin melpa
  :init
  (setq evil-want-C-u-scroll t
        evil-want-visual-char-semi-exclusive t
        evil-want-Y-yank-to-eol t
        evil-magic t
        evil-echo-state t
        evil-indent-convert-tabs t
        evil-ex-search-vim-style-regexp t
        evil-ex-substitute-global t
        evil-ex-visual-char-range t
        evil-insert-skip-empty-lines t
        evil-mode-line-format 'nil
        evil-symbol-word-search t
        shift-select-mode nil)
  :general
  (buffer-leader "n" 'evil-buffer-new)
  (moon-leader ";" 'evil-ex
               ":" 'execute-extended-command
               "w" 'evil-window-map
               "q" 'save-buffers-kill-terminal)
  :config
  (evil-select-search-module 'evil-select-search-module 'evil-search)
  (evil-mode t))

(defvar +evil-esc-hook '(t)
"A hook run after ESC is pressed in normal mode (invoked by
`evil-force-normal-state'). If a hook returns non-nil, all hooks after it are
ignored.")

(defun +evil*attach-escape-hook ()
  "Run the `+evil-esc-hook'."
  (cond ((minibuffer-window-active-p (minibuffer-window))
         ;; quit the minibuffer if open.
         (abort-recursive-edit))
        ((evil-ex-hl-active-p 'evil-ex-search)
         ;; disable ex search buffer highlights.
         (evil-ex-nohighlight))
        (t
         ;; Run all escape hooks. If any returns non-nil, then stop there.
         (run-hook-with-args-until-success '+evil-esc-hook))))
(advice-add #'evil-force-normal-state :after #'+evil*attach-escape-hook)

(defun +evil*restore-normal-state-on-windmove (orig-fn &rest args)
  "If in anything but normal or motion mode when moving to another window,
restore normal mode. This prevents insert state from bleeding into other modes
across windows."
  (unless (memq evil-state '(normal motion emacs))
    (evil-normal-state +1))
  (apply orig-fn args))
(advice-add #'windmove-do-window-select :around #'+evil*restore-normal-state-on-windmove)

(defun +evil*static-reindent (orig-fn &rest args)
  "Don't move cursor on indent."
  (save-excursion (apply orig-fn args)))
(advice-add #'evil-indent :around #'+evil*static-reindent)

;; Move to new split -- setting `evil-split-window-below' &
;; `evil-vsplit-window-right' to non-nil mimics this, but that doesn't update
;; window history. That means when you delete a new split, Emacs leaves you on
;; the 2nd to last window on the history stack, which is jarring.
(defun +evil*window-follow (&rest _)  (evil-window-down 1))
(defun +evil*window-vfollow (&rest _) (evil-window-right 1))
(advice-add #'evil-window-split  :after #'+evil*window-follow)
(advice-add #'evil-window-vsplit :after #'+evil*window-vfollow)

(use-package evil-commentary
  :ensure t
  :pin melpa-stable
  :config
  (evil-commentary-mode 1))

(use-package evil-smartparens
  :ensure t
  :pin melpa-stable
  :config
  (evil-smartparens-mode)
  (add-hook 'smartparens #'evil-smartparens-mode))

(use-package evil-surround
  :ensure t
  :pin melpa-stable
  :commands
  (global-evil-surround-mode
   evil-surround-edit
   evil-Surround-edit
   evil-surround-region)
  :config(global-evil-surround-mode 1))

(use-package evil-args
  :ensure t
  :pin melpa-stable
  :commands
  (evil-inner-arg
   evil-outer-arg
   evil-forward-arg
   evil-backward-arg
   evil-jump-out-arg))

(use-package evil-indent-plus
  :ensure t
  :pin melpa
  :commands
  (evil-indent-plus-i-indent
   evil-indent-plus-a-indent
   evil-indent-plus-i-indent-up
   evil-indent-plus-a-indent-up
   evil-indent-plus-i-indent-up-down
   evil-indent-plus-a-indent-up-down))

(use-package evil-textobj-anyblock
  :ensure t
  :pin melpa-stable
  :commands (evil-textobj-anyblock-inner-block
             evil-textobj-anyblock-a-block))

(use-package evil-lion
  :ensure t
  :pin melpa
  :config
  (evil-lion-mode))

(use-package evil-escape
  :ensure t
  :pin melpa
  :general
  (:states '(insert visual operator replace)
           "C-g" 'evil-escape)
  :config
  (setq evil-escape-excluded-states '(normal visual multiedit emacs motion))
  (evil-escape-mode))
