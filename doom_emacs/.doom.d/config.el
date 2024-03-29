;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
;;
(setq doom-font (font-spec :family "Iosevka Comfy" :size 18 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Iosevka Comfy Duo" :size 18 :weight 'regular))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

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

;; tell lsp-mode that it should use html-lsp for .erb files
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(".*\\.html\\.erb$" . "html")))

(let ((disabled-formatting-modes '(c-mode web-mode)))
  (dolist (elem disabled-formatting-modes)
    ;; the `+format-on-save-enabled-modes' list starts with a `not' so this disables
    ;; format-on-save for web-mode as it wreaks havoc on .erb files. Fun times with elisp...
    (add-to-list '+format-on-save-enabled-modes elem t)))

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

(use-package! prisma-mode)
(add-hook! 'prisma-mode-hook 'lsp-mode)

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
