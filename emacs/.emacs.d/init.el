;;;; -*- lexical-binding: t; -*-

;; TODO:
;; evil help
;; elisp-slime-nav
;; org-mode
;; python import magic bindings
;; python eldoc
;; evil-org
;; multi-term
;; major mode map bindings
;; shackle buffers

(setq custom-file "~/.emacs.d/custom.el")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(recentf-mode 1)
(global-hl-line-mode 1)

;; UTF-8 please
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)

(setq-default
 create-lockfiles nil
 ring-bell-function 'ignore
 recentf-max-menu-item 25
 line-spacing 5
 history-length 500
 make-backup-files nil
 auto-save-default nil
 idle-update-delay 2
 inhibit-startup-screen t)

(defalias 'yes-or-no-p 'y-or-n-p)
(add-to-list 'default-frame-alist '(font . "InputMonoNarrow Nerd Font"))
(defun kyle//change-font-size ()
  "Change the font after init"
  (set-face-attribute 'default nil :height 130))
(add-hook 'window-setup-hook 'kyle//change-font-size)
(add-hook 'text-mode-hook 'hl-line-mode)
(global-eldoc-mode -1)
(add-hook 'python-mode-hook 'eldoc-mode)

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
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

(use-package which-key
  :ensure t
  :pin melpa
  :diminish which-key-mode
  :config
  (which-key-setup-side-window-right-bottom)
  (which-key-mode))

(use-package evil
  :ensure t
  :pin melpa
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

(use-package evil-surround
  :ensure t
  :pin melpa
  :after evil
  :config (global-evil-surround-mode 1))

(use-package doom-themes
  :ensure t
  :pin melpa
  :config (load-theme 'doom-one t))

(use-package powerline
  :ensure t
  :pin melpa-stable
  :config
  (powerline-default-theme)
  (setq powerline-height 22))

(use-package flycheck
  :ensure t
  :pin melpa
  :config
  (global-flycheck-mode)
  (flycheck-add-next-checker 'python-flake8 'python-pylint)
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

(use-package diminish
  :ensure t
  :pin melpa)

; TODO: replace `:bind' with `general' mapping
(use-package helm
  :ensure t
  :pin melpa
  :diminish helm-mode
  :config
  (progn
    (require 'helm-config)
    (helm-mode 1)
    (add-hook 'eshell-mode-hook
	(lambda ()
	(define-key eshell-mode-map (kbd "TAB") 'helm-esh-pcomplete)
	(define-key eshell-mode-map (kbd "C-c C-l") 'helm-eshell-history))))
    :bind (("M-x" . helm-M-x)
	    ("M-y" . helm-show-kill-ring)
	    ("C-x b" . helm-mini)
	    ("C-x C-b" . helm-buffers-list)
	    ("C-x C-f" . helm-find-files)
	    ("C-x C-r" . helm-recentf)
	    ("C-x c o" . helm-occur)
	    ("C-M-n" . helm-next-source)
	    ("C-M-p" . helm-previous-source)))

 (use-package helm-descbinds
   :ensure t
   :after helm
   :pin melpa
   :bind (("C-h b" . helm-descbinds)
 	  ("C-h w" . helm-descbinds)))

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

(use-package helm-swoop
  :ensure t
  :pin melpa
  :after helm
  :commands (helm-swoop)
  :config
  (progn
    (setq helm-swoop-speed-or-color 1
	    helm-swoop-use-fuzzy-match 1)
    ;; disable swoop-thing-at-point
    (setq helm-swoop-pre-input-function
	    (lambda () ""))))

(use-package projectile
  :ensure t
  :pin melpa-stable
  :diminish projectile-mode
  :config (projectile-mode t))

(use-package magit
  :ensure t
  :commands (magit)
  :pin melpa)

(use-package evil-magit
  :ensure t
  :after magit
  :pin melpa)

(use-package autorevert
  :diminish auto-revert-mode)

(use-package git-gutter-fringe
  :ensure t
  :diminish git-gutter-mode
  :pin melpa
  :config (git-gutter-mode))

(use-package pyenv-mode
  :ensure t
  :pin melpa)

(use-package helm-projectile
  :ensure t
  :after (:all projectile helm)
  :pin melpa
  :config (helm-projectile-on))

(use-package undo-tree
  :diminish undo-tree-mode)

(use-package anaconda-mode
  :ensure t
  :pin melpa
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'eldoc-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(use-package importmagic
  :ensure t
  :pin melpa
  :config (add-hook 'python-mode-hook 'importmagic-mode))

(use-package pip-requirements
  :ensure t
  :pin melpa)

(use-package evil-matchit
  :ensure t
  :pin melpa
  :after evil)

(use-package company
  :ensure t
  :diminish company-mode
  :pin melpa
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.1)
  (add-hook 'after-init-hook 'global-company-mode))


(use-package php-extras
  :ensure t
  :pin marmalade
  :config
  (with-eval-after-load 'company
    (add-hook 'php-mode-hook
		(lambda ()
		(set (make-local-variable 'company-backends)
		    '((php-extras-company company-etags company-dabbrev-code) company-capf company-files))))))

(use-package company-anaconda
  :ensure t
  :pin melpa
  :after company
  :config
  (add-hook 'python-mode-hook
	    (lambda ()
	      (set (make-local-variable 'company-backends)
		   '((company-anaconda company-etags company-dabbrev-code) company-capf company-files)))))

(use-package magit
  :ensure t
  :pin melpa)

(use-package evil-magit
  :ensure t
  :pin melpa)

(use-package autorevert
  :diminish auto-revert-mode)

(use-package git-gutter-fringe
  :ensure t
  :pin melpa
  :config (global-git-gutter-mode 1))

;; TODO: intelligent pyenv switching based on project
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

(use-package web-mode
  :ensure
  :pin melpa
  :mode (("\\.html?$" . web-mode)
	 ("\\.thtml$" . web-mode)
	 ("\\.phtml$" . web-mode)))

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

(use-package company-php
  :ensure t
  :commands (company-ac-php-backend)
  :config
  (unless (executable-find "phpctags")
    (warn "php-mode: phpctags isn't installed, auto-completion will be gimped")))

(use-package avy
  :ensure t
  :pin melpa)

(use-package switch-window
  :ensure t
  :pin melpa)

(use-package airline-themes
  :ensure t
  :pin melpa
  :after powerline
  :config
  (load-theme 'airline-doom-one t))

(use-package org
  :ensure t
  :pin melpa)

(use-package evil-org
  :ensure t
  :pin melpa
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
	    (lambda ()
	      (evil-org-set-key-theme))))

(use-package multi-term
  :ensure t
  :pin melpa
  :config (setq multi-term-program "/usr/local/bin/zsh"))

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
  ;; (defun kyle//jump-to-tag-now ()
  ;;   "Jump to the tag under point without the prompt"
  ;;   (interactive)
  ;;   (find-tag (find-tag-default)))
  ;; (add-hook 'evil-normal-state-entry-hook '(define-key evil-normal-state-map "g C-]" 'kyle//jump-to-tag-now))
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
		      "m" '(describe-mode :wk "describe mode")))
