;;; -*- lexical-binding: t; -*-

;;; Package
(package-initialize)                       ; Set up packaging system
(require 'package)

                                           ; set up our package repos
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

(setq package-enable-at-startup nil)       ; don't use package.el for loading packages
(package-initialize)
(unless (package-installed-p 'use-package) ; if use-package isn't installed, install it
  (package-refresh-contents)
  (package-install 'use-package))

;; Set location of annoying variables created by custom.el
(setq custom-file "~/.emacs.d/custom.el")

(use-package paradox
  :ensure t
  :pin melpa-stable
  :config (paradox-enable))
