;;;; -*- lexical-binding: t; -*-

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(eval-and-compile
  (unless (package-installed-p 'use-package)
    (progn
      (package-refresh-contents)
      (package-install 'use-package)
      (defvar use-package-verbose t)
      (require 'use-package)
      (package-initialize))))

(setq use-package-verbose t)

(use-package org
  :ensure t
  :pin melpa
  :init
  (setq org-src-fontify-natively t
	org-src-tabs-act-natively t
	org-src-preserve-indentation nil)
  :mode (("\\.org$" . org-mode))
  :config
  (add-hook 'after-init-hook
	    (lambda ()
	      (require 'org-indent)
	      (set-face-attribute 'org-indent nil :inherit 'fixed-pitch)))
  (add-hook 'org-mode-hook
	    '(lambda ()
	       (variable-pitch-mode 1)
	       (setq line-spacing 2)
	       (mapc
		(lambda (face)
		  (set-face-attribute face nil :inherit 'fixed-pitch :height 140))
		(list 'org-code
		      'org-link
		      'org-block
		      'org-block-background
		      'org-table
		      'org-block-begin-line
		      'org-block-end-line
		      'org-meta-line
		      'org-document-info-keyword)))))

;; needed to source symlinked emacs.org
(setq vc-follow-symlinks t)
(setq evil-want-integration nil)
(org-babel-load-file "~/.emacs.d/emacs.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-collection-setup-minibuffer t)
 '(package-selected-packages
   (quote
    (web-mode paradox imenu-list imenu-anywhere dired-k git-gutter-fringe multi-term php-extras company-php flycheck-pos-tip flycheck general helm-swoop helm-projectile helm-ag helm-descbinds org-bullets company-anaconda pyvenv pip-requirements anaconda-mode which-key vi-tilde-fringe switch-window spacemacs-theme rainbow-delimiters nlinum fringe-helper diminish beacon evil-snipe evil-visualstar evil-mc evil-multiedit projectile company-quickhelp company-statistics company dumb-jump ace-link evil-surround evil-smartparens evil-org evil-matchit evil-magit evil-goggles evil-commentary evil-collection evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))
