;;; rails.el --- A minor mode for rails development  -*- lexical-binding: t; -*-
;;; Commentary:
;;;
;;; This package is very new and should not be used by anyone
;;;
;;; Code:
(defconst rails-app-marker-file "Gemfile"
  "The file used to determine whether the directory is a Rails project.")

(defun rails/spec-path-for-file (rails-file)
  "Get the path to the spec associated with the RAILS-FILE."
  (let* ((path (expand-file-name rails-file))
         (in-spec-dir (replace-regexp-in-string "/app/"
                                                "/spec/"
                                                path))
         (spec-file (replace-regexp-in-string "\\(.rb\\)$"
                                              "_spec\\1"
                                              in-spec-dir)))
    spec-file))

(defun rails--parent-directory (file)
  "Return the parent directory for a given FILE."
  (file-name-directory (directory-file-name (file-name-directory file))))

(defun rails--app-directories (parent-dir)
  "Return a list of regular directories that are direct children of PARENT-DIR."
  (let ((child-dirs (directory-files parent-dir t directory-files-no-dot-files-regexp)))
    (seq-filter #'rails--directory-in-app-p child-dirs)))

(defun rails--directory-in-app-p (dir)
  (let ((rails-file (concat dir "/config/application.rb")))
    (file-exists-p rails-file)))

(defun rails--app-name-from-dir (dir)
  (file-name-nondirectory (directory-file-name dir)))

(defun rails--directory-in-engine-p (dir)
  "Return t if DIR is a directory in a Rails engine."
  (let ((engine-name (rails--app-name-from-dir dir)))
    (and (file-directory-p dir)
         (file-exists-p (concat dir "lib/" engine-name ".rb")))))

(defun rails--app-root-directory ()
  "Get the rails app root for the current buffer file."
  (locate-dominating-file (buffer-file-name) rails-app-marker-file))

(defun rails--start-console (app-name)
  "Start a rails console for the APP-NAME."
  (require 'inf-ruby)
  (inf-ruby-console-run
   "bundle exec rails console"
   (concat "[" app-name "]" "rails-console" )))

(defun rails--select-monorepo-app-path (root-path)
  "Interactively select a Rails app from the current monorepo at ROOT-PATH."
  (let* ((parent-dir (rails--parent-directory root-path))
         (app-dirs (rails--app-directories parent-dir)))
    (completing-read "Launch app console: " app-dirs nil t)))

;;;###autoload
(defun rails/start-monorepo-console ()
  "Get the path to a valid rails application root for the project."
  (interactive)
  (if-let ((root-path (rails--app-root-directory)))
      (cond ((rails--directory-in-app-p root-path)
             (let ((default-directory root-path))
               (rails--start-console (rails--app-name-from-dir default-directory))))
            ((rails--directory-in-engine-p root-path)
             (let ((default-directory (rails--select-monorepo-app-path root-path)))
               (rails--start-console (rails-app-name-from-dir default-directory))))
            (t (message "No rails apps found")))))

(defun rails/factory-path-for-model (rails-model)
  "Get the path to the factory associated with the RAILS-MODEL."
  (let* ((path (expand-file-name rails-model))
         (factory-dir (replace-regexp-in-string "/app/models/"
                                                "/spec/factories/"
                                                path))
         (pluralized (replace-regexp-in-string "\\(.rb\\)$"
                                               "s\\1"
                                               factory-dir)))
    pluralized))

(defun rails--current-file-name ()
  (or (buffer-file-name)
      (buffer-name (current-buffer))))

(defun rails--remove-underscores (str)
  "Remove all underscores in STR."
  (replace-regexp-in-string "_" "" str t t))

(defun rails--filename-to-rails-class (filename)
  (let ((klass (capitalize
                (file-name-nondirectory
                 (file-name-sans-extension filename)))))
    (rails--remove-underscores klass)))

(defun rails/qualified-rails-class-from-model-file ()
  (let* ((dirs (split-string (rails--current-file-name) "/"))
         (models-directory-child-dirs (cdr (member "models" dirs)))
         (file (car (last models-directory-child-dirs)))
         (caps-namespaces (mapcar
                           (lambda (dir)
                             (rails--remove-underscores (capitalize dir)))
                           (butlast models-directory-child-dirs))))
    (mapconcat 'identity
               (flatten-tree
                (list caps-namespaces
                      (rails--filename-to-rails-class file)))
               "::")))

(provide 'rails)
;;; rails.el ends here
