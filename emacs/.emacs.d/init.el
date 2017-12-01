;;;; -*- lexical-binding: t; -*-

(setq custom-file "~/.emacs.d/custom.el")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-to-list 'default-frame-alist '(font . "InputMonoNarrow Nerd Font"))

(when window-system
  (set-frame-height (selected-frame) 48)
  (set-frame-width (selected-frame) 160)
  (set-frame-position (selected-frame) 750 250))


(package-initialize)
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

(setq package-enable-at-startup nil)

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)
    (package-initialize)))

(use-package evil
  :ensure t
  :pin melpa
  :config 
  (evil-mode 1))

(use-package all-the-icons
  :ensure t
  :pin melpa)
  
(use-package doom-themes
  :ensure t
  :pin melpa
  :after all-the-icons
  :config (load-theme 'doom-tomorrow-night t))

(use-package powerline
  :ensure t
  :pin melpa
  :config (powerline-default-theme))

(use-package mode-icons
  :ensure t
  :config (mode-icons-mode))

(use-package diminish
  :ensure t
  :pin melpa
  :config
  (diminish 'undo-tree-mode))

(use-package which-key
  :ensure t
  :pin melpa
  :config
  (which-key-setup-side-window-right-bottom)
  (which-key-mode))

(use-package helm
  :ensure t
  :pin melpa
  :bind (("M-x" . helm-M-x)
	 ("M-y" . helm-show-kill-ring)
	 ("C-x b" . helm-mini)
	 ("C-x C-b" . helm-buffers-list)
	 ("C-x X-f" . helm-find-files)
	 ("C-x C-r" . helm-recentf)
	 ("C-x c o" . helm-occur))
  :config (progn
	    (require 'helm-config)
		     (helm-mode 1)
		     (add-hook 'eshell-mode-hook
			       (lambda ()
				 (define-key eshell-mode-map (kbd "TAB") 'helm-esh-pcomplete)
				 (define-key eshell-mode-map (kbd "C-c C-l") 'helm-eshell-history)))))

(use-package helm-descbinds
  :ensure t
  :pin melpa
  :bind (("C-h b" . helm-descbinds)
	 ("C-h w" . helm-descbinds)))
