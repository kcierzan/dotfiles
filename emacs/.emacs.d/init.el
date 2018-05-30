;;;; -*- lexical-binding: t; -*-
(setq custom-file "~/.emacs.d/custom.el")

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

;; (setq monospace-font "SF Mono")
;; (setq nerd-font "SFMono Nerd Font")
(setq monospace-font "Iosevka Nerd Font")
(setq string-font "Iosevka Slab")
(setq nerd-font "Iosevka Nerd Font")
(setq variable-pitch-font "Iosevka Slab")

(setq package-enable-at-startup nil)
(package-initialize)

;; install use-package if we haven't already
(eval-and-compile
  (unless (package-installed-p 'use-package)
    (progn
      (package-refresh-contents)
      (package-install 'use-package)
      (defvar use-package-verbose nil)
      (require 'use-package)
      (package-initialize))))

;; download everything and shut up
(setq use-package-always-ensure t)
(setq use-package-verbose nil)

;; we configure org mode early - the rest of the config is loaded via org-babel
(use-package org
  :init
  (setq org-agenda-files (quote ("~/git/org")))
  (setq org-use-fast-todo-selection t)
  (setq org-directory "~/git/org")
  (setq org-src-fontify-natively t
        org-src-tabs-act-natively t
        org-src-preserve-indentation nil
        org-catch-invisible-edits t)
  (setq org-todo-keywords
        '((sequence "TODO" "NEXT" "|" "DONE" "CANCELLED")))
  (setq org-capture-templates
        '(("t" "todo" entry (file "~/git/org/refile.org")
           "* TODO %?\n%U\n%a\n"
           :clock-resume t)
          ("r" "respond" entry (file "~/git/org/refile.org")
           "* NEXT Respond to $:from on $:subject\nSCHEDULED: %t\n%U\n%a\n"
           :clock-in t
           :clock-resume t
           :immediate-finish t)
          ("n" "note" entry (file+datetree "~/git/org/notes.org")
           "* %? :NOTE:\n%U\n%a\n"
           :clock-resume t)
          ("l" "log" entry
           (file+olp+datetree "~/git/org/worklog.org")
           "* TODO %^{Description} %^g\n\%?\n\nAdded: %U"
           :clock-in t
           :clock-keep t)))
  (setq org-todo-keyword-faces
        '(("TODO" . org-warning)
          ("DOING" . "orange")))
  ;; org refile targets
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9))))
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
                     '((company-abbrev company-files))))))
  (add-hook 'after-init-hook '(lambda ()
                                (require 'org-indent)
                                (set-face-attribute 'org-indent nil :inherit 'fixed-pitch)))
  (add-hook 'org-mode-hook '(lambda ()
                              (variable-pitch-mode 1)
                              (setq line-spacing 2)
                              (company-mode 0)
                              (setq truncate-lines nil)
                              ;; (set-face-attribute 'default nil :family "Bitter")
                              (set-face-attribute 'org-link nil :underline t)
                              (mapc (lambda (face)
                                      (set-face-attribute face nil :family monospace-font))
                                    (list 'org-code
                                          'org-link
                                          'org-block
                                          'org-table
                                          'org-level-1
                                          'org-level-2
                                          'org-level-3
                                          'org-level-4
                                          'org-level-5
                                          'org-block-begin-line
                                          'org-block-end-line
                                          'org-meta-line
                                          'org-document-info-keyword))))
(defun kyle/position-to-kill-ring ()
  "Copy to the kill ring a string in the format \"file-name:line-number\"
for the current buffer's file name, and the line number at point."
  (interactive)
  (kill-new
   (format "%s::%d" (buffer-file-name) (save-restriction
                                         (widen) (line-number-at-pos)))))
(org-babel-do-load-languages 'org-babel-load-languages
                             '((shell . t)
                               (python . t)
                               (js . t)
                               (sql . t)
                               (emacs-lisp . t)
                               (org . t)
                               (ruby . t)))
(setq org-confirm-babel-evaluate nil))

;; We are going to use evil-collection instead
(setq evil-want-integration nil)

;; needed to source symlinked emacs.org
(setq vc-follow-symlinks t)
(org-babel-load-file "~/.emacs.d/emacs.org")
