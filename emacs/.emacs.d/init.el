;;;; -*- lexical-binding: t; -*-
(setq custom-file "~/.emacs.d/custom.el")

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
      (defvar use-package-verbose nil)
      (require 'use-package)
      (package-initialize))))

(setq use-package-always-ensure t)
(setq use-package-verbose t)

(use-package org
  :ensure t
  :pin melpa
  :init
  (setq org-src-fontify-natively t
        org-src-tabs-act-natively t
        org-src-preserve-indentation nil
        org-catch-invisible-edits t)
  (setq org-capture-templates
        '(("j" "Journal Entry" plain
           (file+olp+datetree "~/git/org/journal.org")
           "%U\n\n%?" :empty-lines-before 1)
          ("w" "Log Work Task" entry
           (file+olp+datetree "~/git/org/worklog.org")
           "* TODO %^{Description} %^g\n\%?\n\nAdded: %U"
           :clock-in t
           :clock-keep t)))
  (setq org-todo-keyword-faces
        '(("TODO" . org-warning)
          ("DOING" . "orange")))
  :mode ("\\.org$" . org-mode)
  :config
  (add-hook 'after-init-hook '(lambda ()
                                (require 'org-indent)
                                (set-face-attribute 'org-indent nil :inherit 'fixed-pitch)))
  (add-hook 'org-mode-hook '(lambda ()
                              (variable-pitch-mode 1)
                              (setq line-spacing 2)
                              (company-mode 0)
                              (setq truncate-lines nil)
                              (set-face-attribute 'org-link nil :underline t)
                              (mapc (lambda (face)
                                      (set-face-attribute face nil :font "Work Sans" :height 1.5))
                                    (list 'org-level-1
                                          'org-level-2
                                          'org-level-3
                                          'org-level-4
                                          'org-level-5
                                          'org-level-6
                                          'org-level-7
                                          'org-level-8))
                              (mapc (lambda (face)
                                      (set-face-attribute face nil :inherit 'fixed-pitch :height 1.2))
                                    (list 'org-code
                                          'org-link
                                          'org-block
                                          'org-table
                                          'org-block-begin-line
                                          'org-block-end-line
                                          'org-meta-line
                                          'org-document-info-keyword)))))

;; We are going to use evil-collection instead
(setq evil-want-integration nil)

;; needed to source symlinked emacs.org
(setq vc-follow-symlinks t)
(org-babel-load-file "~/.emacs.d/emacs.org")
