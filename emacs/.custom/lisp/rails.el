;;; rails.el --- A minor mode for rails development  -*- lexical-binding: t; -*-
;;; Commentary:
;;;
;;; This package is very new and should not be used by anyone
;;;
;;; Code:

(defun rails-get-spec-path (rails-file)
  "Get the path to the spec associated with the RAILS-FILE."
  (let* ((path (expand-file-name rails-file))
         (in-spec-dir (replace-regexp-in-string "/app/"
                                                "/spec/"
                                                path))
         (spec-file (replace-regexp-in-string "\\(.rb\\)$"
                                              "_spec\\1"
                                              in-spec-dir)))
    spec-file))

(defun rails-parent-directory (file)
  "Return the parent directory for a given file path"
  (file-name-directory (directory-file-name (file-name-directory file))))

(defun rails-app-directories  (dir)
  "Return a list of regular directories that are direct children of DIR."
  (let ((child-dirs (directory-files dir t directory-files-no-dot-files-regexp)))
    (seq-filter #'rails-dir-rails-app-p child-dirs)))

(defun rails-dir-rails-app-p (dir)
  (let ((rails-file (concat dir "/config/application.rb")))
    (file-exists-p rails-file)))

(defun rails-app-name-from-dir (dir)
  (file-name-nondirectory (directory-file-name dir)))

(defun rails-dir-engine-p (dir)
  (let ((engine-name (rails-app-name-from-dir dir)))
    (and (file-directory-p dir)
         (file-exists-p (concat dir "lib/" engine-name ".rb")))))

(defun rails-app-root-directory ()
  "Get the rails app root for the current buffer file"
  (locate-dominating-file (buffer-file-name) "Gemfile"))

(defun rails-file-in-engine-p ()
  "Return t if the buffer file is in a rails engine"
  (when-let ((root-path (rails-app-root-directory)))
    (rails-dir-rails-engine-p root-path)))

(defun rails-file-in-app-p ()
  (when-let ((root-path (rails-app-root-directory)))
    (file-exists-p (concat root-path "config/application.rb"))))

(defun rails-start-rails-console (app-name)
  (inf-ruby-console-run
   "bundle exec rails console"
   (concat "[" app-name "]" "rails-console" )))

(defun rails-sibling-rails-app (dir)
  (let* ((parent-dir (rails-parent-directory dir))
         (app-dirs (rails-app-directories parent-dir)))
    (completing-read "Launch app console: " app-dirs nil t)))

(defun rails-smart-console ()
  "Get the path to a valid rails application root for the project."
  (interactive)
  (if-let ((root-path (rails-app-root-directory)))
      (cond ((file-exists-p (concat root-path "config/application.rb"))
             (let ((default-directory root-path))
               (rails-start-rails-console (rails-app-name-from-dir default-directory))))
            ((rails-dir-engine-p root-path)
             (let ((default-directory (rails-sibling-rails-app root-path)))
               (rails-start-rails-console (rails-app-name-from-dir default-directory))))
            (t (message "No rails apps found")))))

(defun rails-get-factory-path (rails-model)
  "Get the path to the factory associated with the RAILS-MODEL."
  (let* ((path (expand-file-name rails-model))
         (factory-dir (replace-regexp-in-string "/app/models/"
                                                "/spec/factories/"
                                                path))
         (pluralized (replace-regexp-in-string "\\(.rb\\)$"
                                               "s\\1"
                                               factory-dir)))
    pluralized))

(provide 'rails)
;;; rails.el ends here
