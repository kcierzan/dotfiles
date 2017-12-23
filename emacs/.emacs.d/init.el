;;;; -*- lexical-binding: t; -*-

(setq-default explicit-shell-file-name "/usr/local/bin/zsh")
(setq-default shell-file-name "/usr/local/bin/zsh")
(setq custom-file "~/.emacs.d/custom.el")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(semantic-mode)
(recentf-mode 1)
(setq-default left-fringe-width 15)
(set-frame-parameter nil 'internal-border-width 10)
(set-window-buffer nil (current-buffer))

;; UTF-8 please
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(setq scroll-conservatively 101)
(setq mouse-wheel-follow-mouse t
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(2 ((shift) . 4) ((control) . 6)))

(setq-default
 create-lockfiles nil
 ring-bell-function 'ignore
 recentf-max-menu-item 25
 line-spacing 5
 history-length 500
 make-backup-files nil
 auto-save-default nil
 idle-update-delay 0.5
 inhibit-startup-screen t)

(setq mac-redisplay-dont-reset-vscroll t
      mac-mouse-wheel-smooth-scroll t
      select-enable-primary t)

(defalias 'yes-or-no-p 'y-or-n-p)
(add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font"))
(defun kyle//change-font-size ()
  "Change the font after init,"
  (set-face-attribute 'default nil :height 150))
(add-hook 'window-setup-hook 'kyle//change-font-size)
(add-hook 'prog-mode-hook 'nlinum-mode)
(global-eldoc-mode -1)
(add-hook 'python-mode-hook 'eldoc-mode)

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)
    (require 'use-package)
    (package-initialize)))

(use-package anaconda-mode
  :ensure t
  :pin melpa-stable
  :diminish anaconda-mode
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'eldoc-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(use-package avy
  :ensure t
  :pin melpa)

(use-package beacon
  :ensure t
  :diminish beacon-mode
  :pin elpa
  :config
  (beacon-mode 1))

(use-package company
  :ensure t
  :diminish company-mode
  :pin melpa
  :config
  (setq company-minimum-prefix-length 2
	company-idle-delay 0.2
	company-dabbrev-downcase nil
	company-tooltip-limit 10
	company-dabbrev-ignore-case nil
	company-dabbrev-code-code-other-buffers t
	company-tooltip-align-annotations t
	company-require-match 'never
	company-global-modes '(not eshell-mode comint-mode erc-mode message-mode help-mode gud-mode)
	company-frontends '(company-pseudo-tooltip-frontend company-echo-metadata-frontend)
	company-backends '(company-capf company-dabbrev company-ispell)
	company-transformers '(company-sort-by-occurrence))
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-anaconda
  :ensure t
  :pin melpa
  :after company
  :config
  (add-hook 'python-mode-hook
	    (lambda ()
	      (set (make-local-variable 'company-backends)
		   '((company-anaconda company-etags company-dabbrev-code) company-capf company-files)))))

(use-package company-php
  :ensure t
  :commands (company-ac-php-backend)
  :config
  (unless (executable-find "phpctags")
    (warn "php-mode: phpctags isn't installed, auto-completion will be gimped")))

(use-package company-statistics
  :ensure t
  :after company
  :config
  (setq company-statistics-file "~/.emacs.d/company-stats-cache.el")
  (company-statistics-mode 1))

(use-package diminish
  :ensure t
  :pin melpa)

(use-package dumb-jump
  :ensure t
  :pin melpa
  :config
  (setq dumb-jump-force-searcher 'rg)
  (setq dumb-jump-selector 'helm))

(use-package evil
  :ensure t
  :pin melpa
  :diminish evil-mode
  :init (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map "s" 'evil-avy-goto-char-2)
  ;; escape escapes the minibuffer
  (defun minibuffer-keyboard-quit ()
    "Abort recursive edit.
   In Delete selection mode, if mark is active, just deactivate it;
   then it takes a second \\[keyboard-quit] to abort the minibuffer."
    (interactive)
    (if (and delete-selection-mode transient-mark-mode mark-active)
	(setq deactivate-mark t)
      (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
      (abort-recursive-edit)))
  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit))

(use-package evil-commentary
  :ensure t
  :pin melpa
  :after evil
  :commands
  (evil-commentary
   evil-commentary-line)
  :diminish evil-commentary-mode
  :config (evil-commentary-mode))

(use-package evil-goggles
  :ensure t
  :pin melpa
  :diminish evil-goggles-mode
  :config
  (evil-goggles-mode)
  (setq evil-goggles-duration 0.15)
  (evil-goggles-use-diff-faces))

(use-package evil-magit
  :ensure t
  :after magit
  :pin melpa)

(use-package evil-matchit
  :ensure t
  :pin melpa
  :after evil)

(use-package evil-org
  :ensure t
  :pin melpa
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
	    (lambda ()
	      (evil-org-set-key-theme))))

(use-package evil-surround
  :ensure t
  :pin melpa
  :after evil
  :config (global-evil-surround-mode 1))

(use-package flycheck
  :ensure t
  :pin melpa
  :config
  (global-flycheck-mode)
  (flycheck-add-next-checker 'python-flake8 'python-pylint)
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

(use-package general
  :ensure t
  :pin melpa
  :config
  (general-evil-setup)
  ;; Non-Prefixed Commands
  (general-define-key :keymaps 'evil-normal-state-map "C-;" 'helm-M-x)
  (general-define-key :keymaps 'global "C-u" nil)
  (general-define-key :keymaps 'evil-motion-state-map "gl" 'evil-avy-goto-line)
  (general-define-key :keymaps 'evil-motion-state-map "C-u" 'evil-scroll-up)
  (general-define-key :keymaps 'global "C-ESC" 'universal-argument)
  (general-define-key :keymaps 'helm-map "C-t" 'helm-toggle-visible-mark)
  (general-define-key :keymaps 'global "M-RET" 'toggle-frame-fullscreen)
  (define-key evil-normal-state-map (kbd "g C-]") 'xref-find-definitions)
  ;; Prefixes
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC"
		      "" '(nil :wk "Leader")
		      "f" '(:ignore t :wk "Find")
		      "g" '(:ignore t :wk "Git")
		      "p" '(:ignore t :wk "Projectile")
		      "b" '(:ignore t :wk "Buffers")
		      "e" '(:ignore t :wk "Elisp")
		      "e e" '(:ignore t :wk "Elisp Eval")
		      "h" '(:ignore t :wk "Help")
		      "w" '(:ignore t :wk "Window")
		      "j" '(:ignore t :wk "Jump"))
  ;; Find
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC f"
		      "l" '(helm-swoop :wk "line"
					:package helm-swoop)
		      "r" '(helm-recentf :wk "recent")
		      "o" '(helm-semantic-or-imenu :wk "definitions")
		      "f" '(helm-find-files :wk "files")
		      "g" '(helm-do-ag :wk "ag"
					:package helm-ag))
  ;; Git
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC g"
		      "g" '(magit :which-key "magit"))
  ;; Projectile
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC p"
		      "g" '(helm-projectile-ag :wk "ag")
		      "r" '(helm-projectile-recentf :wk "find recent")
		      "d" '(helm-projectile-find-dir :wk "find directory")
		      "f" '(helm-projectile-find-file :wk "find file")
		      "s" '(helm-projectile-switch-project :wk "switch project"))
  ;; Buffer
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC b"
		      "d" '(kill-this-buffer :wk "kill this buffer")
		      "s" '(evil-write :wk "write buffer")
		      "b" '(helm-mini :wk "list buffers"))
  ;; Window
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC w"
		      "s" '(switch-window :wk "switch window"
					  :package switch-window))
  ;; Elisp
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC e"
		      "e b" '(eval-buffer :wk "eval buffer")
		      "e d" '(eval-defun :wk "eval defun")
		      "e :" '(eval-expression :wk "eval expression"))
  ;; Jump
  (general-define-key :keymaps 'evil-normal-state-map "g C-'" '(anaconda-mode-find-definitions
								:wk "anaconda definition"))
  ;; Help
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC h"
		      "f" '(describe-function :wk "describe function")
		      "k" '(describe-key :wk "describe key")
		      "v" '(describe-variable :wk "describe variable")
		      "p" '(describe-package :wk "describe package")
		      "w" '(helm-man-woman :wk "man woman")
		      "a" '(describe-face :wk "describe face")
		      "m" '(describe-mode :wk "describe mode")))

(use-package git-gutter-fringe
  :ensure t
  :diminish git-gutter-mode
  :pin melpa
  :config (git-gutter-mode))

(use-package helm
  :ensure t
  :pin melpa
  :diminish helm-mode
  :general
  (helm-map "TAB" 'helm-execute-persistent-action)
  :config
  (progn
    (require 'helm-config)
    (helm-mode 1)
    (helm-autoresize-mode 1)
    (setq helm-autoresize-min-height 5)
    (setq helm-echo-input-in-header-line t)
    (defun set-helm-font-bigger ()
      (set (make-local-variable 'face-remapping-alist)
	   '((default :height 1.0))))
    (add-hook 'minibuffer-setup-hook 'set-helm-font-bigger))
    :bind (("M-x" . helm-M-x)
	    ("M-y" . helm-show-kill-ring)
	    ("C-x b" . helm-mini)
	    ("C-x C-b" . helm-buffers-list)
	    ("C-x C-f" . helm-find-files)
	    ("C-x C-r" . helm-recentf)
	    ("C-x c o" . helm-occur)
	    ("C-M-n" . helm-next-source)
	    ("C-M-p" . helm-previous-source)))
      
(use-package helm-ag
  :ensure t
  :commands (helm-ag)
  :pin melpa
  :after helm
  :config
  (setq helm-ag-base-command "ag --nocolor --nogroup --hidden"))

 (use-package helm-descbinds
   :ensure t
   :after helm
   :commands (helm-descbinds)
   :pin melpa
   :bind (("C-h b" . helm-descbinds)
 	  ("C-h w" . helm-descbinds)))

(use-package helm-projectile
  :ensure t
  :after (:all projectile helm)
  :pin melpa
  :config (helm-projectile-on))

(use-package helm-swoop
  :ensure t
  :pin melpa
  :after helm
  :config
  (progn
    (setq helm-swoop-speed-or-color 1
	    helm-swoop-use-fuzzy-match 1)
    (setq-default helm-swoop-split-direction 'split-window-vertically)
    (setq-default helm-swoop-split-with-multiple-windows t)
    ;; disable swoop-thing-at-point
    (setq helm-swoop-pre-input-function
	    (lambda () ""))))

(use-package magit
  :ensure t
  :commands (magit)
  :pin melpa)

(use-package multi-term
  :ensure t
  :pin melpa
  :config (setq multi-term-program "/usr/local/bin/zsh"))

(use-package org
  :ensure t
  :pin melpa)

(use-package org-bullets
  :ensure t
  :pin melpa
  :init
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package paradox
  :ensure t
  :pin melpa
  :config
  (paradox-enable))

(use-package php-extras
  :ensure t
  :pin marmalade
  :config
  (with-eval-after-load 'company
    (add-hook 'php-mode-hook
		(lambda ()
		(set (make-local-variable 'company-backends)
		    '((php-extras-company company-etags company-dabbrev-code) company-capf company-files))))))

(use-package php-mode
  :ensure t
  :pin melpa
  :config
  (add-hook 'php-mode-hook
	    (lambda ()
	      (set (make-local-variable 'company-backends)
		   '((company-ac-php-backend php-extras-company compand-dabbrev-code) company-capf company-files))))
  :mode (("\\.php$" . php-mode)
	 ("\\.inc$"  . php-mode)))

(use-package pip-requirements
  :ensure t
  :pin melpa)

(use-package projectile
  :ensure t
  :pin melpa-stable
  :diminish projectile-mode
  :commands
  (helm-projectile-switch-project
   helm-projectile-find-file
   helm-projectile-find-dir)
  :config
  (projectile-mode t)
  (projectile-discover-projects-in-directory "~/git"))

(use-package pyenv-mode
  :ensure t
  :pin melpa
  :config
  (pyenv-mode)
  (defun kyle//pyenv-mode-set-local-version ()
    "Set pyenv version from \".python-version\" by looking in parent directories"
    (interactive)
    (let ((root-path (locate-dominating-file default-directory
					     ".python-version")))
      (when root-path
	(let* ((file-path (expand-file-name ".python-version" root-path))
	       (version
		(with-temp-buffer
		  (insert-file-contents-literally file-path)
		  (buffer-substring-no-properties (line-beginning-position)
						  (line-end-position)))))
	  (if (member version (pyenv-mode-versions))
	      (pyenv-mode-set version)
	    (message "pyenv: version `%s' is not installed (set by %s)"
		     version file-path))))))
  (add-hook 'projectile-after-switch-project-hook 'kyle//pyenv-mode-set-local-version))

(use-package rainbow-delimiters
  :ensure t
  :pin melpa
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package spaceline
  :ensure t
  :pin melpa
  :config
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state))

(use-package spacemacs-theme
  :ensure t
  :defer t
  :pin melpa
  :init (load-theme 'spacemacs-dark t)
  :config
  (with-current-buffer (get-buffer " *Echo Area 0*")
    (setq-local face-remapping-alist '((default (:height  1.0) default)))))

(use-package spaceline-all-the-icons
  :after spaceline
  :ensure t
  :config (spaceline-all-the-icons-theme)
  (setq spaceline-all-the-icons-separator-type 'wave)
  (set-face-attribute 'mode-line nil :height 140))

(use-package switch-window
  :ensure t
  :pin melpa)

(use-package undo-tree
  :diminish undo-tree-mode)

(use-package vi-tilde-fringe
  :ensure t
  :diminish vi-tilde-fringe-mode
  :pin melpa
  :config
  (add-hook 'prog-mode-hook 'vi-tilde-fringe-mode))

(use-package web-mode
  :ensure
  :pin melpa
  :mode (("\\.html?$" . web-mode)
	 ("\\.thtml$" . web-mode)
	 ("\\.phtml$" . web-mode)))

(use-package which-key
  :ensure t
  :pin melpa
  :diminish which-key-mode
  :config
  (which-key-setup-side-window-right-bottom)
  (which-key-mode))
