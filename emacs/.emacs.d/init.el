;;;; -*- lexical-binding: t; -*-

;; TODO:
;; nose.el
;; pylookup
;; org mode

(setq custom-file "~/.emacs.d/custom.el")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(recentf-mode 1)
(defalias 'yes-or-no-p' #'y-or-n-p)
(add-to-list 'default-frame-alist '(font . "Knack Nerd Font"))

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
  ;; escape escapes the minibuffer
  (defun minibuffer-keyboard-quit ()
    "Abort recursive edit.
   In Delete selection mode, if mark is active, just deactivate it;
   then if takes a second \\[keyboard-quit] to abort the minibuffer."
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
  :diminish evil-commentary-mode
  :config (evil-commentary-mode))

(use-package evil-surround
  :ensure t
  :pin melpa
  :after evil
  :config (global-evil-surround-mode 1))

(use-package all-the-icons
  :ensure t
  :pin melpa)
  
(use-package doom-themes
  :ensure t
  :pin melpa
  :after all-the-icons
  :config (load-theme 'doom-one t))

(use-package powerline
  :ensure t
  :pin melpa-stable
  :config (powerline-default-theme))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (global-flycheck-mode)
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
    ;; disable swoop-thing-at-point
    (setq helm-swoop-pre-input-function
	    (lambda () ""))))

(use-package projectile
  :ensure t
  :pin melpa-stable
  :diminish projectile-mode
  :config (projectile-mode t))

(use-package helm-projectile
  :ensure t
  :after (:all projectile helm)
  :pin melpa
  :config (helm-projectile-on))

(use-package undo-tree
  :diminish undo-tree-mode)

(use-package helm-gtags
  :ensure t
  :diminish helm-gtags-mode
  :pin melpa
  :config (helm-gtags-mode))

(use-package anaconda-mode
  :ensure t
  :pin melpa
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(use-package evil-matchit
  :ensure t
  :pin melpa
  :after evil)

(use-package company
  :ensure t
  :diminish company-mode
  :pin melpa
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-anaconda
  :ensure t
  :pin melpa
  :after company
  :config
  (add-to-list 'company-backends '(company-anaconda :with company-capf)))

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
  :config (git-gutter-mode))

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

(use-package general
  :ensure t
  :pin melpa
  :config
  (general-evil-setup)
  ;; Non-Prefixed Commands
  (general-define-key :keymaps 'evil-normal-state-map
		      "C-;" 'helm-M-x)
  (general-define-key :keymaps 'global "C-u" nil)
  (general-define-key :keymaps 'evil-motion-state-map "C-u" 'evil-scroll-up)
  (general-define-key :keymaps 'global "S-ESC" 'universal-argument)
  (general-define-key :keymaps 'evil-normal-state-map
		      "gd" '(helm-gtags-dwim :keymap helm-gtags-mode-map
					     :package helm-gtags))
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
		      "b k" '(:ignore t :wk "Buffer Kill")
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
		      "kt" '(kill-this-buffer :wk "kill this buffer")
		      "s" '(evil-write :wk "write buffer")
		      "b" '(helm-mini :wk "list buffers")
		      "kl" '(kill-buffer :wk "kill a buffer"))
  ;; Elisp
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC e"
		      "e b" '(eval-buffer :wk "eval buffer")
		      "e d" '(eval-defun :wk "eval defun")
		      "e :" '(eval-expression :wk "eval expression"))
  ;; Jump
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC j"
		      "t" '(helm-gtags-dwim :keymap helm-gtags-mode-map
					    :package helm-gtags
					    :wk "smart tag"))
  ;; Help
  (general-define-key :keymaps 'evil-normal-state-map
		      :prefix "SPC h"
		      "f" '(describe-function :wk "describe function")
		      "v" '(describe-variable :wk "describe variable")
		      "p" '(describe-package :wk "describe package")
		      "m" '(describe-mode :wk "describe mode")))
