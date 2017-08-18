;;; -*- lexical-binding: t; -*-

;;; Binding

(use-package bind-key
  :ensure t
  :pin melpa-stable)

(use-package which-key
  :ensure t
  :pin melpa-stable
  :config
  (which-key-mode 1))

;; Define leader keys
(use-package general
  :ensure t
  :pin melpa-stable
  :config
  (setq general-default-keymaps '(evil-normal-state-map))
  
  ;; Set leader which-key text
  (general-create-definer moon-leader       :prefix "SPC" :which-key "moon leader")
  (general-create-definer projectile-leader :prefix "SPC" :which-key "projectile" :infix "p")
  (general-create-definer git-leader        :prefix "SPC" :which-key "git" :infix "g")
  (general-create-definer help-leader       :prefix "SPC" :which-key "help" :infix "h")
  (general-create-definer buffer-leader     :prefix "SPC" :which-key "buffer" :infix "b")
  (general-create-definer directory-leader  :prefix "SPC" :which-key "directory" :infix "d")
  (general-create-definer tag-leader        :prefix "SPC" :which-key "tag" :infix "t")
  (general-create-definer jump-leader       :prefix "SPC" :which-key "jump" :infix "j")
  (general-create-definer find-leader       :prefix "SPC" :which-key "find" :infix "f")
  ;; (general-define-key "SPC" '(:ignore t :which-key "moon leader"))
  (general-define-key :states '(normal) :prefix "SPC"
                      "" '(nil :which-key "moon leader")
                      "p" '(:ignore t :which-key "projectile")
                      "g" '(:ignore t :which-key "git")
                      "h" '(:ignore t :which-key "help")
                      "b" '(:ignore t :which-key "buffer")
                      "d" '(:ignore t :which-key "directory")
                      "t" '(:ignore t :which-key "tag")
                      "j" '(:ignore t :which-key "jump")
                      "f" '(:ignore t :which-key "find"))
  ;; (general-define-key :keymaps '(minibuffer-local-map
  ;;                                minibuffer-local-ns-map
  ;;                                minibuffer-local-completion-map
  ;;                                minibuffer-local-must-match-map
  ;;                                minibuffer-local-isearch-map)
  ;;                     "ESC" 'abort-recursive-edit) 
  ;; Global keybindings
  (moon-leader "u" 'universal-argument)
  (help-leader "m" 'describe-mode)
  (general-define-key :states '(normal visual insert motion emacs)
                      "M-x" 'execute-extended-command
                      "A-x" 'execute-extended-command)
  (moon-leader "M-;" 'eval-expression
               "A-;" 'eval-expression
               "M-=" 'text-scale-increase
               "M--" 'text-scale-decrease) 
  (buffer-leader "l" 'list-buffers
                 "K" 'kill-buffer
                 "k" 'kill-this-buffer
                 "s" 'save-buffer))
