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
