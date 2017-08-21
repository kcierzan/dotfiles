;;; -*- lexical-binding: t; -*-

;;; Core

;; Features essential to a functional Emacs experience

;; TODO: Install hydra
;;       Make hydra maps for window manipulation
;;       Make hydra for multiple cursors
;;       Make hydra for smartparens/paredit functionality

(menu-bar-mode -1)
(tooltip-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(setq
 ring-bell-function 'ignore
 mouse-wheel-scroll-amount '(5 ((shift) . 2))
 mouse-wheel-progressive-speed nil
 mouse-wheel-follow-mouse t
 scroll-step 1
 auto-window-vscroll nil
 ns-use-native-fullscreen nil
 ns-pop-up-frames nil
 create-lockfiles nil
 ;; keep the prompt out of the minibuffer
 minibuffer-prompt-properties '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)
 auto-save-default nil
 make-backup-files nil)

(defalias 'yes-or-no-p 'y-or-n-p) ; only ask y/n

;; quiet startup
(advice-add #'display-startup-echo-area-message :override #'ignore)
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil
      mode-line-format nil)

(use-package exec-path-from-shell
  :ensure t
  :pin melpa
  :config
  (setq exec-path-from-shell-check-startup-files nil)
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package projectile
  ;; :after gtags
  :ensure t
  :pin melpa
  :config
  (projectile-mode)
  (projectile-discover-projects-in-directory "~/git/"))

(use-package ivy
  :ensure t
  :pin melpa
  :general
  (buffer-leader "b" 'ivy-switch-buffer)
  :config
  (ivy-mode 1)
  (setq enable-recursive-minibuffers t)
  (set-face-background 'ivy-minibuffer-match-face-1 nil)) 

(use-package counsel
  :ensure t
  :pin melpa
  :commands
  (counsel-find-file
   counsel-imenu
   counsel-rg
   counsel-recentf
   counsel-M-x
   counsel-describe-function
   counsel-describe-variable
   describe-key)
  :general
  (find-leader "f" 'counsel-find-file
               "o" 'counsel-imenu
               "g" 'counsel-projectile-rg)
  (help-leader "k" 'describe-key
               "f" 'counsel-describe-function
               "v" 'counsel-describe-variable)
  (buffer-leader "r" 'counsel-recentf)
  (tag-leader "R" 'projectile-regenerate-tags)
  (general-define-key "M-x" 'counsel-M-x)
  :config
  (setq counsel-rg-base-command "rg -i --hidden --no-heading --line-number %s ."))

(use-package ggtags
  :ensure t
  :pin melpa
  :general
  (tag-leader "t" 'ggtags-find-tag-dwim
              "r" 'ggtags-find-reference))

(use-package counsel-projectile
  :ensure t
  :pin melpa
  :after counsel
  :commands
  (counsel-projectile
   counsel-projectile-switch-project
   counsel-projectile-find-file)
  :general
  (projectile-leader "s" 'counsel-projectile-switch-project
                     "f" 'counsel-projectile-find-file
                     "p" 'counsel-projectile)
  (moon-leader "SPC" 'counsel-projectile-find-file)
  :config
  (counsel-projectile-on))

(use-package sr-speedbar
  :ensure t
  :pin melpa
  :config
  (setq speedbar-show-unknown-files nil)
  (setq speedbar-use-images nil)) 

(use-package projectile-speedbar
  :ensure t
  :pin melpa
  :after sr-speedbar
  :general
  (tag-leader "b" 'projectile-speedbar-toggle)
  :config
  (setq projectile-speedbar-enable nil))

(use-package neotree
  :ensure t
  :pin melpa
  :general
  (directory-leader "b" 'neotree-toggle)
  (:keymap 'neotree-mode-map
           "TAB" 'neotree-enter
           "M-SPC" 'neotree-quick-look
           "q" 'neotree-hide
           "H" 'neotree-hidden-file-toggle
           "RET" 'neotree-enter)
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-smart-open t))

(use-package hydra
  :ensure t
  :pin melpa)

(use-package smex
  :ensure t
  :pin melpa
  :general
  (general-define-key "M-X" 'smex-major-mode-commands))

(use-package ripgrep
  :ensure t
  :pin melpa)
