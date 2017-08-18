;;; -*- lexical-binding: t; -*-

;;; Python Mode

;; This is snek

(use-package company-anaconda
  :ensure t
  :after (company)
  :pin melpa-stable
  :config (add-to-list 'company-backends 'company-anaconda))

(use-package pyenv-mode
  :ensure t
  :pin melpa-stable
  :config
  (add-hook 'python-mode-hook 'pyenv-mode))

(use-package anaconda-mode
  :ensure t
  :pin melpa-stable
  :init (add-hook 'python-mode-hook 'anaconda-mode))
