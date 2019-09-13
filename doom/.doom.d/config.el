;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; set fonts
(setq doom-font (font-spec :family "Iosevka" :size 14)
      doom-variable-pitch-font (font-spec :family "DINPro" :size 14)
      doom-serif-font (font-spec :family "Bitter" :size 14))

;; set the org directory
(setq org-directory "~/Sync/org/")

;; add a worklog org capture template
(after! 'org (add-to-list 'org-capture-templates
             '("l" "Worklog" entry
               (file+olp+datetree "~/Sync/org/worklog.org")
               "* TODO %^{Description} %^g\n\%?\n\nAdded: %U"
               :clock-in t
               :clock-keep t)))

;; disable evil snipe mode
(after! 'evil-snipe-mode (evil-snipe-mode -1))

;; map s to the king of motion commands
(map! :nv "s" 'evil-avy-goto-char-timer)

;; maybe enable ligatures on emacs-mac
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
