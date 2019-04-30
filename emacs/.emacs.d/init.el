;;;; -*- lexical-binding: t; -*-
;; ██╗███╗   ██╗██╗████████╗███████╗██╗
;; ██║████╗  ██║██║╚══██╔══╝██╔════╝██║
;; ██║██╔██╗ ██║██║   ██║   █████╗  ██║
;; ██║██║╚██╗██║██║   ██║   ██╔══╝  ██║
;; ██║██║ ╚████║██║   ██║██╗███████╗███████╗
;; ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝╚══════╝╚══════╝

 (eval-and-compile
   (setq gc-cons-threshold (* 1024 1024 1024)
         gc-cons-percentage 10)
   (add-hook 'focus-out-hook 'garbage-collect))

(eval-and-compile
  (setq load-prefer-newer t
        package-user-dir "~/.emacs.d/elpa"
        package--init-file-ensured t
        package-enable-at-startup nil))

(unless (file-directory-p package-user-dir)
  (make-directory package-user-dir t))

(setq use-package-always-defer t
      use-package-verbose t)

(eval-and-compile
  (setq load-path (append load-path (directory-files package-user-dir t "^[^.]" t)))
  (setq load-path (append (directory-files package-user-dir t "^flymake" t) load-path)))

(setq custom-file "~/.emacs.d/custom.el")

(eval-and-compile
  (require 'package)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
  (add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
  (add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
  (package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)
    (require 'use-package)
    (setq use-package-always-ensure t)))


(setq monospace-font "Iosevka Nerd Font"
      string-font "Iosevka Slab"
      nerd-font "Iosevka Nerd Font"
      variable-pitch-font "Roboto")

;; we configure org mode early - the rest of the config is loaded via org-babel
(use-package org
  :demand t
  :ensure org-plus-contrib
  :init
  (setq org-ellipsis "  ")
  (setq org-agenda-files '("~/git/org/todo.org" "~/git/org/worklog.org" "~/git/org/gcal.org"))
  (setq org-use-fast-todo-selection t)
  (setq org-directory "~/git/org")
  (setq org-src-fontify-natively t
        org-src-tabs-act-natively t
        org-src-preserve-indentation nil
        org-src-window-setup 'other-window
        org-catch-invisible-edits t)
  (setq org-todo-keywords
        '((sequence "TODO" "IN PROGRESS" "|" "DONE" "CANCELLED")))
  ;; For beorg setup, make todo.org a symbolic link to ~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/todo.org
  (setq org-capture-templates
        '(("t" "Todo" entry (file "~/git/org/todo.org")
           "* TODO %^{Todo}\n%U\nDEADLINE: %^{Deadline}T\n%?"
           :clock-resume t)
          ("T" "Code TODO" entry (file "~/git/org/todo.org")
           "* TODO %?\n%U\n%a\n"
           :clock-resume t)
          ("r" "Respond" entry (file "~/git/org/refile.org")
           "* NEXT Respond to $:from on $:subject\nSCHEDULED: %t\n%U\n%a\n"
           :clock-in t
           :clock-resume t
           :immediate-finish t)
          ("n" "Note" entry (file+datetree "~/git/org/notes.org")
           "* %? :NOTE:\n%U\n%a\n"
           :clock-resume t)
          ("l" "Log" entry
           (file+olp+datetree "~/git/org/worklog.org")
           "* TODO %^{Description} %^g\n\%?\n\nAdded: %U"
           :clock-in t
           :clock-keep t)
          ("e" "Event" entry (file "~/git/org/gcal.org")
           "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n")))
  (setq org-todo-keyword-faces
        '(("TODO" . org-warning)
          ("DOING" . "orange")))
  ;; org refile targets
  (setq org-refile-targets (quote ((nil :maxlevel . 5)
                                   (org-agenda-files :maxlevel . 5))))
  ;; use full outline paths for refile targets - file directly with helm
  (setq org-refile-use-outline-path t)
  ;; Targets complete with helm
  (setq org-outline-path-complete-in-steps nil)
  ;; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))
  ;; Don't use ido
  (setq org-completion-use-ido nil)
  ;; Exclude DONE state tasks from refile targets
  (defun kyle/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))
  (setq org-refile-target-verify-function 'kyle/verify-refile-target)
  :mode ("\\.org$" . org-mode)
  :config
  (with-eval-after-load 'company
    (add-hook 'org-mode-hook
              (lambda ()
                (set (make-local-variable 'company-backends)
                     '((company-yasnippet company-dabbrev company-files))))))
  (add-hook 'after-init-hook '(lambda ()
                                (require 'org-indent)
                                (set-face-attribute 'org-indent nil :inherit 'fixed-pitch)))
  (add-hook 'org-mode-hook '(lambda ()
                              (variable-pitch-mode 1)
                              (setq line-spacing 1)
                              (company-mode 0)
                              (setq truncate-lines nil)
                              (set-face-attribute 'org-link nil :underline t)
                              (mapc (lambda (face)
                                      (set-face-attribute face nil :family monospace-font :height 0.85))
                                    (list 'org-code
                                          'org-warning
                                          'org-special-keyword
                                          'org-property-value
                                          'org-verbatim
                                          'org-link
                                          'org-block
                                          'org-done
                                          'org-date
                                          'org-todo
                                          'org-table
                                          'org-tag
                                          'org-block-begin-line
                                          'org-block-end-line
                                          'org-meta-line
                                          'org-document-info-keyword))))
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((shell . t)
                                 (python . t)
                                 (js . t)
                                 (sql . t)
                                 (emacs-lisp . t)
                                 (ditaa . t)
                                 (plantuml . t)
                                 (http . t)
                                 (org . t)
                                 (ruby . t)))
  (setq org-confirm-babel-evaluate nil
        org-plantuml-jar-path (expand-file-name "/usr/local/bin/plantuml/plantuml.jar")))

;; evil-collection will handle evil compatibility
(setq evil-want-integration t)
(setq evil-want-keybinding nil)

;; needed to source symlinked emacs.org
(setq vc-follow-symlinks t)
(org-babel-load-file "~/.emacs.d/emacs.org")
