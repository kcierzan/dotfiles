;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

(setq shell-file-name (executable-find "zsh"))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "IosevkaNeapolitan Nerd Font" :size 16 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Iosevka Aile" :size 16 :weight 'medium)
      doom-serif-font (font-spec :family "Iosevka Etoile" :size 16 :weight 'medium))

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq doom-modeline-height 40)
(setq projectile-project-search-path '(("~/git" . 2) ("~/src" . 2) ("~/.dotfiles")))

;; Re-binding external keyboard modifiers via macOS system preferences results in
;; re-bound modifiers becoming "right" modifiers. By default, DOOM binds right
;; option to `none'.
;; N.B: emacs-mac uses the mac-* prefix for mac-specific variables, not ns-*
(setq mac-right-option-modifier 'meta)

;; The pager is generally just annoying in emacs
(setenv "PAGER" "cat")

(setq lsp-disabled-clients '(semgrep-ls rubocop-ls))

;; Nobody uses prettier-ruby
(setq-hook! 'ruby-mode-hook +format-with 'rubocop)

(after! lsp-mode
  ;; use web mode for erb files
  (add-to-list 'lsp-language-id-configuration '(".*\\.html\\.erb$" . "html"))
  ;; use ruby-lsp instead of solargraph
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection (list "rubocop" "--lsp"))
                    :major-modes '(ruby-mode)
                    :priority 0
                    :add-on? t
                    :server-id 'addon-rubocop-ls))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "ruby-lsp")
                    :major-modes '(ruby-mode)
                    :multi-root t
                    :priority 100
                    :server-id 'ruby-lsp-ls)))

;; snipe all the things we can see
(after! evil-snipe
  (setq evil-snipe-scope 'whole-visible
        evil-snipe-repeat-scope 'whole-visible))

;; why not write with proportional font?
(add-hook! 'org-mode-hook 'variable-pitch-mode)
;; and add some more forgiving line spacing
(setq-hook! 'org-mode-hook line-spacing 0.3)

(setq-hook! 'typescript-mode-hook typescript-indent-level 2)
(setq-hook! 'typescript-tsx-mode-hook typescript-indent-level 2)

(use-package! lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(use-package! prisma-mode
  :config
  (add-hook! 'prisma-mode-hook 'lsp-mode))

(use-package! ultra-scroll-mac
  :init
  (setq scroll-conservatively 101
        scroll-margin 0)
  :config
  (ultra-scroll-mac-mode 1))

(use-package! meow
  :demand t
  :config (progn
            (defun meow-setup ()
              (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
              (meow-motion-overwrite-define-key
               '("j" . meow-next)
               '("k" . meow-prev)
               '("<escape>" . ignore))
              (meow-leader-define-key
               ;; SPC j/k will run the original command in MOTION state.
               '("j" . "H-j")
               '("k" . "H-k")
               ;; Use SPC (0-9) for digit arguments.
               '("1" . meow-digit-argument)
               '("2" . meow-digit-argument)
               '("3" . meow-digit-argument)
               '("4" . meow-digit-argument)
               '("5" . meow-digit-argument)
               '("6" . meow-digit-argument)
               '("7" . meow-digit-argument)
               '("8" . meow-digit-argument)
               '("9" . meow-digit-argument)
               '("0" . meow-digit-argument)
               '("/" . meow-keypad-describe-key)
               '("?" . meow-cheatsheet))
              (meow-normal-define-key
               '("0" . meow-expand-0)
               '("9" . meow-expand-9)
               '("8" . meow-expand-8)
               '("7" . meow-expand-7)
               '("6" . meow-expand-6)
               '("5" . meow-expand-5)
               '("4" . meow-expand-4)
               '("3" . meow-expand-3)
               '("2" . meow-expand-2)
               '("1" . meow-expand-1)
               '("-" . negative-argument)
               '(";" . meow-reverse)
               '("," . meow-inner-of-thing)
               '("." . meow-bounds-of-thing)
               '("[" . meow-beginning-of-thing)
               '("]" . meow-end-of-thing)
               '("a" . meow-append)
               '("A" . meow-open-below)
               '("b" . meow-back-word)
               '("B" . meow-back-symbol)
               '("c" . meow-change)
               '("d" . meow-delete)
               '("D" . meow-backward-delete)
               '("e" . meow-next-word)
               '("E" . meow-next-symbol)
               '("f" . meow-find)
               '("g" . meow-cancel-selection)
               '("G" . meow-grab)
               '("h" . meow-left)
               '("H" . meow-left-expand)
               '("i" . meow-insert)
               '("I" . meow-open-above)
               '("j" . meow-next)
               '("J" . meow-next-expand)
               '("k" . meow-prev)
               '("K" . meow-prev-expand)
               '("l" . meow-right)
               '("L" . meow-right-expand)
               '("m" . meow-join)
               '("n" . meow-search)
               '("o" . meow-block)
               '("O" . meow-to-block)
               '("p" . meow-yank)
               '("q" . meow-quit)
               '("Q" . meow-goto-line)
               '("r" . meow-replace)
               '("R" . meow-swap-grab)
               '("s" . meow-kill)
               '("t" . meow-till)
               '("u" . meow-undo)
               '("U" . meow-undo-in-selection)
               '("v" . meow-visit)
               '("w" . meow-mark-word)
               '("W" . meow-mark-symbol)
               '("x" . meow-line)
               '("X" . meow-goto-line)
               '("y" . meow-save)
               '("Y" . meow-sync-grab)
               '("z" . meow-pop-selection)
               '("'" . repeat)
               '("<escape>" . ignore)))
            (meow-setup)
            (meow-global-mode 1)))

;; lsp booster: https://github.com/blahgeek/emacs-lsp-booster
;; this requires a rust binary to be in the path
;; TODO: Build the rust binary if it doesn't already exist
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

;; org-mode ricing ahead
(custom-theme-set-faces
 'user
 '(tree-sitter-hl-face:punctuation ((t (:inherit fixed-pitch))))
 '(org-document-title ((t (:height 2.0 :weight bold))))
 '(org-level-1 ((t (:height 1.75 :inherit outline-1))))
 '(org-level-2 ((t (:height 1.5 :inherit outline-2))))
 '(org-level-3 ((t (:height 1.25 :inherit outline-3))))
 '(org-level-4 ((t (:height 1.1 :inherit outline-4))))
 '(org-level-5 ((t (:inherit outline-5))))
 '(org-level-6 ((t (:inherit outline-6))))
 '(org-level-7 ((t (:inherit outline-7))))
 '(org-level-8 ((t (:inherit outline-8))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(line-number ((t (:inherit fixed-pitch))))
 '(line-number-current-line ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (shadow fixed-pitch)))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-table ((t (:inherit fixed-pitch))))
 '(org-todo ((t (:inherit fixed-pitch))))
 '(org-done ((t (:inherit fixed-pitch))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))
