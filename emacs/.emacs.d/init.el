;;;; -*- lexical-binding: t; -*-

;;;TODO:
;; create general definer for mapping in evil normal state, info mode etc.
;; refactor general keybidings
;; move config to org-babel file
;; dired-k
;; smart-forward
;; expand-region
;; evil-multiedit
;; evil-mc
;; bind dumb-jump-go and dumb-jump-back
;; set up 'transient' state bindings with hydra
;; set up dired bindings

(setq-default explicit-shell-file-name "/usr/local/bin/zsh")
(setq-default shell-file-name "/usr/local/bin/zsh")
(setq custom-file "~/.emacs.d/custom.el")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(semantic-mode)
(recentf-mode 1)
(setq-default left-fringe-width 5)
(set-frame-parameter nil 'internal-border-width 2)
(set-window-buffer nil (current-buffer))
(setq sentence-end-double-space nil)
(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1)

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
 line-spacing 4
 history-length 500
 make-backup-files nil
 auto-save-default nil
 idle-update-delay 0.5
 inhibit-startup-screen t)

(setq dired-always-copies 'always
      dired-recursive-deletes 'top
      global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

(setq mac-redisplay-dont-reset-vscroll t
      mac-mouse-wheel-smooth-scroll t
      select-enable-primary t)

(defalias 'yes-or-no-p 'y-or-n-p)
(add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font"))
(defun kyle//change-font-size ()
  "Change the font after init,"
  (set-face-attribute 'default nil :height 130))
(add-hook 'window-setup-hook 'kyle//change-font-size)
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

(use-package ace-link
  :ensure t
  :pin melpa
  :config
  (ace-link-setup-default))

(use-package anaconda-mode
  :ensure t
  :pin melpa-stable
  :mode ("\\.py\\'" . python-mode)
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
  :mode ("\\.py\\'" . python-mode)
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

(use-package company-quickhelp
  :ensure t
  :pin melpa
  :config
  (setq company-quickhelp-delay nil)
  (company-quickhelp-mode 1))

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
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
  (evil-declare-change-repeat 'company-complete))

(use-package evil-collection
  :ensure t
  :pin melpa
  :custom (evil-collection-setup-minibuffer t)
  :config (evil-collection-init))

(use-package evil-commentary
  :ensure t
  :pin melpa
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
  :mode (("\\.org$" . org-mode))
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
	    (lambda ()
	      (evil-org-set-key-theme))))

(use-package evil-smartparens
  :ensure t
  :after smartparens
  :pin melpa
  :config
  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode))

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
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
   ;; because git-gutter is in the left fringe
  (setq flycheck-indication-mode 'right-fringe))

(use-package flycheck-pos-tip
  :ensure t
  :pin melpa
  :after flycheck
  :config
  (setq flycheck-pos-tip-timeout 10
	flycheck-display-errors-delay 0.5)
  (flycheck-pos-tip-mode 1))

(use-package fringe-helper
  :ensure t
  :pin melpa
  :after (:all flycheck git-gutter-fringe)
  :config
  ;; A non-descript, left-pointing arrow
  (fringe-helper-define 'flycheck-fringe-bitmap-double-arrow 'center
    "...X...."
    "..XX...."
    ".XXX...."
    "XXXX...."
    ".XXX...."
    "..XX...."
    "...X....")
  ;; thin fringe bitmaps
  (fringe-helper-define 'git-gutter-fr:added '(center repeated)
    "XXX.....")
  (fringe-helper-define 'git-gutter-fr:modified '(center repeated)
    "XXX.....")
  (fringe-helper-define 'git-gutter-fr:deleted 'bottom
    "X......."
    "XX......"
    "XXX....."
    "XXXX...."))

(use-package general
  :ensure t
  :pin melpa
  :config
  (general-evil-setup)
  (general-create-definer global-leader :keymaps '(evil-motion-state-map info-mode-map help-mode-map) :prefix "SPC")
  (general-create-definer buffer-leader :keymaps '(evil-motion-state-map info-mode-map help-mode-map) :prefix "SPC b")
  (general-create-definer help-leader :keymaps '(evil-motion-state-map info-mode-map help-mode-map) :prefix "SPC h")
  (general-create-definer elisp-leader :keymaps '(evil-motion-state-map info-mode-map help-mode-map) :prefix "SPC e")
  (general-create-definer find-leader :keymaps '(evil-motion-state-map info-mode-map help-mode-map) :prefix "SPC f")
  (general-create-definer projectile-leader :keymaps '(evil-motion-state-map info-mode-map help-mode-map) :prefix "SPC p")
  (general-create-definer git-leader :keymaps '(evil-motion-state-map info-mode-map help-mode-map) :prefix "SPC g")
  (general-create-definer window-leader :keymaps '(evil-motion-state-map info-mode-map help-mode-map) :prefix "SPC w")
  (global-leader "" '(nil :wk "Leader")
		 "f" '(:ignore t :wk "Find")
		 "g" '(:ignore t :wk "Git")
		 "p" '(:ignore t :wk "Projectile")
		 "b" '(:ignore t :wk "Buffers")
		 "e" '(:ignore t :wk "Elisp")
		 "h" '(:ignore t :wk "Help")
		 "w" '(:ignore t :wk "Window")
		 "j" '(:ignore t :wk "Jump"))
  (buffer-leader "d" 'kill-this-buffer
		 "s" 'evil-write
		 "b" 'helm-mini)
  (help-leader "f" 'describe-function
	       "k" 'describe-key
	       "w" 'helm-man-woman
	       "v" 'describe-variable
	       "p" 'describe-package
	       "a" 'describe-face
	       "m" 'describe-mode)
  (find-leader "r" 'helm-recentf
	       "o" 'helm-semantic-or-imenu
	       "g" 'helm-do-ag
	       "f" 'helm-find-files
	       "l" 'helm-swoop)
  (projectile-leader "g" 'helm-projectile-ag
		     "r" 'helm-projectile-recentf
		     "d" 'helm-projectile-find-dir
		     "f" 'helm-projectile-find-file
		     "s" 'helm-projectile-switch-project)
  (elisp-leader "e" 'eval-buffer)
  (git-leader "g" 'magit)
  (window-leader "s" 'switch-window)
  ;; motion state bindings
  (general-define-key :keymaps '(info-mode-map help-mode-map)
		      "SPC" nil)
  (general-mmap "C-;" 'helm-M-x
		"g C-'" 'anaconda-mode-find-definitions
		;; make window splitting behave more like vim
		"C-w v" '((lambda () (interactive) (evil-window-vsplit) (other-window 1)) :wk "evil-window-vsplit")
		"gl" 'evil-avy-goto-line
		"gs" 'evil-avy-goto-char-2
		"C-u" 'evil-scroll-up"C-w s" '((lambda () (interactive) (evil-window-split) (other-window 1)) :wk "evil-window-split")
		"g C-]" 'xref-find-definitions)
  ;; global bindings
  (general-define-key :keymaps 'global
		      "C-u" 'nil
		      "C-ESC" 'universal-argument
		      "M-RET" 'toggle-frame-fullscreen
		      "M-x" 'helm-M-x
		      "M-y" 'helm-show-kill-ring
		      "C-x b" 'helm-mini
		      "C-x C-b" 'helm-buffers-list
		      "C-x C-f" 'helm-find-files
		      "C-x C-r" 'helm-recent
		      "C-x c o" 'helm-occur
		      "C-M-n" 'helm-next-source
		      "C-M-p" 'helm-previous-source
		      "C-h b" 'helm-descbinds)
  ;; helm mappings
  (general-define-key :keymaps 'helm-map
		      "TAB" 'helm-execute-persistent-action
		      "C-t" 'helm-toggle-visible-mark)
  ;; fix company completion
  (general-define-key :keymaps 'company-active-map
		      "RET" 'company-complete-selection))

(use-package git-gutter-fringe
  :ensure t
  :diminish git-gutter-mode
  :pin melpa
  :config
  (global-git-gutter-mode)
  (setq-default fringes-outside-margins t))

;; add a bunch of autoload commands
(use-package helm
  :ensure t
  :pin melpa
  :diminish helm-mode
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
    (add-hook 'minibuffer-setup-hook 'set-helm-font-bigger)))
      
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
   :pin melpa)

(use-package helm-projectile
  :ensure t
  :after (:all projectile helm)
  :commands
  (helm-projectile-ag
  helm-projectile-recentf
  helm-projectile-find-dir
  helm-projectile-find-file
  helm-projectile-switch-project)
  :pin melpa
  :config (helm-projectile-on))

(use-package helm-swoop
  :ensure t
  :commands (helm-swoop)
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

(use-package imenu-anywhere
  :ensure t
  :pin melpa
  :commands (ido-menu-anywhere helm-imenu-anywhere)
  :config (setq imenu-anywhere-delimiter ": "))

(use-package imenu-list
  :ensure t
  :pin melpa
  :config
  (setq imenu-list-focus-after-activation t))

(use-package magit
  :ensure t
  :commands (magit)
  :pin melpa)

;; add autoload commands
(use-package multi-term
  :ensure t
  :commands (multi-term)
  :pin melpa
  :config (setq multi-term-program "/usr/local/bin/zsh"))

(use-package nlinum
  :ensure t
  :pin elpa
  :config
  (add-hook 'prog-mode-hook 'nlinum-mode))

(use-package org
  :ensure t
  :mode (("\\.org$" . org-mode))
  :pin melpa)

(use-package org-bullets
  :ensure t
  :pin melpa
  :after org
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
  :after php-mode
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

(use-package pos-tip
  :ensure t
  :pin melpa)

(use-package projectile
  :ensure t
  :pin melpa-stable
  :diminish projectile-mode
  :config
  (projectile-mode t)
  (projectile-discover-projects-in-directory "~/git"))

;; Possible replace with auto-virtualenv for fish compatibility
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

(use-package smartparens
  :ensure t
  :pin melpa
  :config
  (add-hook 'prog-mode-hook 'smartparens-strict-mode))

(use-package spaceline
  :ensure t
  :pin melpa
  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme)
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
  (spaceline-all-the-icons--setup-paradox)
  (setq spaceline-all-the-icons-icon-set-flycheck-slim 'dots)
  (set-face-attribute 'mode-line nil :height 130))

(use-package switch-window
  :ensure t
  :commands (switch-window)
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
