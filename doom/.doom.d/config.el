;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; set fonts
(if (memq window-system '(mac ns))
    (setq doom-font (font-spec :family "JetBrains Mono" :size 14.0 :weight 'semi-bold)
      doom-variable-pitch-font (font-spec :family "Bitter" :size 20.0)
      doom-serif-font (font-spec :family "Bitter" :size 14.0))
  (setq doom-font (font-spec :family "JetBrains Mono" :size 10.0 :weight 'semi-bold)
      doom-variable-pitch-font (font-spec :family "Bitter" :size 12.0)
      doom-serif-font (font-spec :family "Bitter" :size 12.0)))

;; set the org directory
(setq org-directory "~/Sync/org/")

;; automatically update buffers if the files have changed on disk
(global-auto-revert-mode)

;; set some nice eshell aliases
(set-eshell-alias!
 "la" "ls_extended_macos -lah")

;; add a worklog org capture template
(after! org (add-to-list 'org-capture-templates
                         '("l" "Worklog entry" entry
                           (file+olp+datetree "~/Sync/org/worklog.org")
                           "* TODO %^{Description} %^g\n\%?\n\nAdded: %U"
                           :clock-in t
                           :clock-keep t)))

;; enable ligatures if using emacs-mac
(if (fboundp 'mac-auto-operator-composition-mode)
    (mac-auto-operator-composition-mode))

;; convenience function to yank file and line number to kill ring
  (defun my/position-to-kill-ring ()
    "Copy to the kill ring a string in the format \"file-name:line-number\"
  for the current buffer's file name, and the line number at point."
    (kill-new
     (format "%s::%d" (buffer-file-name) (save-restriction
                                           (widen) (line-number-at-pos)))))

(use-package sqlup-mode
  :hook ((sql-mode sql-interactive-mode) . sqlup-mode))

(use-package counsel-etags
  :commands (counsel-etags-find-tag
             counsel-etags-list-tag
             counsel-etags-recent-tag
             counsel-etags-find-tag-at-point))

(use-package prettier-js
  :hook(js2-mode . prettier-js-mode))

(add-hook 'doom-load-theme-hook (lambda ()
                               (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
                               (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)))

;; force 's' to trigger the evil-avy timer
(map! :n "s" #'evil-avy-goto-char-2)

;; `evil-snipe' attempts to clobber this wonderful binding
(after! evil-snipe
  (evil-snipe-mode -1)
  (map! :n "s" #'evil-avy-goto-char-2))

;; this is a hack around screen resolutions specific to me
(if (memq window-system '(mac ns))
    (setq doom-modeline-height 40)
  (setq doom-modeline-height 65))

(load-theme 'doom-horizon t)

(after! browse-at-remote (add-to-list 'browse-at-remote-remote-type-domains  '("gitlab.aweber.io" . "gitlab")))

;; search all files, except for the annoying ones
;; (after! (:any ivy swiper counsel counsel-projectile projectile)
;;   (setq counsel-rg-base-command "rg  --with-filename --no-heading --line-number --color never --hidden --follow --glob \"!.git/*\" -g \"!*.pyc\" --iglob \"!tags\" 2> /dev/null %s"))

;; move the cursor to the new window after it is created
(defun my/evil-window-follow (&rest _) (evil-window-down 1))
(defun my/evil-window-vfollow (&rest _) (evil-window-right 1))
(advice-add #'evil-window-split :after #'my/evil-window-follow)
(advice-add #'evil-window-vsplit :after #'my/evil-window-vfollow)

(setq fancy-splash-image "~/Sync/fish-header.png")

(add-hook 'org-mode-hook
          '(lambda () (variable-pitch-mode 1)
             (setq line-spacing 1)
             (setq truncate-lines nil)
             (set-face-attribute 'org-link nil :underline t)
             (org-indent-mode -1)
             (mapc (lambda (face)
                     (set-face-attribute face nil :family "JetBrains Mono"))
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
