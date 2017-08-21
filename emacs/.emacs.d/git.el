;;; -*- lexical-binding: t; -*-

;;; Git

;; Version control all the things

;; TODO: Close magit diff buffers with evil
(use-package magit
  :ensure t
  :pin melpa
  :commands
  (magit-status)
  ; :general
  ; (git-leader "s" 'magit-status)
  :config
  (setq auto-revert-check-vc-info t))

(use-package evil-magit
  :after magit
  :ensure t
  :pin melpa)

;; TODO: Use those dumb patched fonts unicode characters
(use-package git-gutter
  :ensure t
  :pin melpa
  :config
  (global-git-gutter-mode 1)
  (setq git-gutter:added-sign " +")
  (setq git-gutter:modified-sign " =")
  (setq git-gutter:deleted-sign " -"))
