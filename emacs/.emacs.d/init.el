;;;; -*- lexical-binding: t; -*-

;;; Init

;; Here we go...

(package-initialize)

;; Set emacs directory
(defconst moon-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        (t "~/.emacs.d/")))

; load modules
(defun moon/load-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file moon-init-dir)))

(defconst moon-modules '("package.el"
                         "binding.el"
                         "evil.el"
                         "core.el"
                         "editor.el"
                         "python-mode.el"
                         "git.el"
                         "markdown.el"
                         "ui.el"))

(mapc 'moon/load-file moon-modules)
