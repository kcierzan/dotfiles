;;; projection.el --- An opinionated project management package -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024 John Doe
;;
;; Author: John Doe <john@doe.com>
;; Maintainer: John Doe <john@doe.com>
;; Created: May 24, 2024
;; Modified: May 24, 2024
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/kcierzan/projection
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  An opinionated project management package
;;
;;; Code:
(require 'cl-lib)

(defvar projection-known-projects nil
  "A list of known projects.")

(defvar projection-project-marker-file ".git"
  "A file that when found in a directory marks it as a project.")

(defvar projection-project-directories '("~/git")
  "A list of paths to search for projects.")

(defvar-local projection-current-project nil
  "The current project.")

(defun projection--unexpand-home-path (path)
  "Transforms a PATH from '/Users/me/...' to '~/'."
  (let ((home (expand-file-name "~")))
    (if (string-prefix-p home path)
        (concat "~" (substring path (length home)))
      path)))

(defun projection--discover-in-dir (directory)
  "Discover projects in DIRECTORY.
Returns a list of directories containing the project marker file."
  (cl-remove-if-not
   (lambda (dir)
     (and (file-directory-p dir)
          (file-exists-p (expand-file-name projection-project-marker-file dir))))
   (mapcar 'projection--unexpand-home-path (directory-files directory t directory-files-no-dot-files-regexp))))

(defun projection-discover-projects ()
  "Search the directories in `projection-project-directories'.
for the presence of of `projection-project-marker-file' and add it to the
`projection-known-projects'list"
  (interactive)
  (dolist (dir projection-project-directories)
    (let* ((discovered (projection--discover-in-dir dir))
           (new-project-list (cl-union projection-known-projects discovered :test 'string=))
           (count-new (- (length new-project-list) (length projection-known-projects))))
      (message "Added %s projects to known projects" count-new)
      (setq projection-known-projects new-project-list))))

(defun projection-add-project ()
  "Add a project to the list of known projects."
  (interactive)
  (let* ((dir (read-directory-name "Enter project directory: "))
         (marker (expand-file-name projection-project-marker-file dir)))
    (cond
     ((not (file-directory-p dir))
      (message "%s is not a valid directory" dir)
      nil)
     ((not (file-directory-p marker))
      (message "%s is not a valid project" dir)
      nil)
     ((cl-member dir projection-known-projects :test 'string=)
      (message "%s is already a known project" dir)
      nil)
     (t
      (add-to-list 'projection-known-projects dir)
      (message "Added %s to known directories" dir)
      dir))))

(defun projection-remove-project ()
  "Remove a project from the list of known projects."
  (interactive)
  (let ((deletion-target (completing-read "Select project: " projection-known-projects nil t nil)))
    (message "Removed %s from projection-known-projects" deletion-target)
    (setq projection-known-projects (cl-remove deletion-target projection-known-projects :test 'string=))))

(defun projection-set-current-project ()
  "Set the current project for the buffer."
  (interactive)
  (let ((selected (completing-read "Set project: " projection-known-projects nil t nil)))
    (message "Set current project to %s" selected)
    (setq-local projection-current-project selected)))

(defun projection-open-project-file ()
  "Open a file from the current Git repo."
  (interactive)
  (let* ((default-directory (expand-file-name projection-current-project))
         (original-project projection-current-project)
         (git-files (split-string (shell-command-to-string "git ls-files") "\n" t))
         (file (completing-read "Open file: " git-files nil t)))
    (when file
      (let ((buffer (find-file (expand-file-name file default-directory))))
        (with-current-buffer buffer
          (setq-local projection-current-project original-project))))))

(provide 'projection)
;;; projection.el ends here
