;;; -*- lexical-binding: t; -*-

;;; Python Mode

;; This is snek

(use-package company-anaconda
  :ensure t
  :after (company)
  :pin melpa
  :config (add-to-list 'company-backends 'company-anaconda))

(use-package pyenv-mode
  :ensure t
  :pin melpa
  :config
  (add-hook 'python-mode-hook 'pyenv-mode))

(use-package anaconda-mode
  :ensure t
  :pin melpa
  :init (add-hook 'python-mode-hook 'anaconda-mode))
