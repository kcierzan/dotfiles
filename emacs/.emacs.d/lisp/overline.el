;;; package --- Overline.el -*- lexical-binding: t; -*-
;;; Commentary:
;;;
;;; A custom modeline configuration with a cool overline.
;;;
;;; Code:

;; TODO: do we need this?
(defvar overline--vc-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line down-mouse-1] 'vc-diff)
    (define-key map [modeline down-mouse-3] 'vc-root-diff)
    map))

(defvar overline--vc-faces
  '((added . vc-locally-added-state)
    (edited . vc-edited-state)
    (removed . vc-removed-state)
    (missing . vc-missing-state)
    (conflict . vc-conflict-state)
    (locked . vc-locked-state)
    (up-to-date . vc-up-to-date-state)))

(defvar after-load-theme-hook nil)

(defadvice load-theme (after run-after-load-theme-hook activate)
  (run-hooks 'after-load-theme-hook))

(defun overline/set-mode-line-theme ()
  (set-face-attribute 'mode-line-active nil
                      :background (face-background 'default)
                      :overline (face-foreground 'default)
                      :box `(:line-width (1 . 8) :color ,(face-background 'default)))
  (set-face-attribute 'mode-line-inactive nil
                      :background (face-background 'default)
                      :overline nil
                      :box `(:line-width (1 . 8) :color ,(face-background 'default))))

(add-hook 'after-load-theme-hook #'overline/set-mode-line-theme)

(setq-default mode-line-format '("%e"
                                 " "
                                 overline--buffer-identification-segment
                                 " "
                                 overline--major-mode-segment
                                 overline--right-alignment-space-segment ;; all later sections will be right-aligned
                                 overline--vc-branch-segment
                                 " "
                                 overline--flymake-status-segment))

;; Segments -----------------------------------------------------------------

(defvar-local overline--buffer-identification-segment
    '(:eval (overline--buffer-identification)))

(defvar-local overline--major-mode-segment
    '(:eval (overline--major-mode)))

(defvar-local overline--right-alignment-space-segment
    `(:eval
      (propertize " "
                  'display
                  `((space :align-to (-
                                      (+ right right-fringe right-margin)
                                      ,(overline--length-rhs)))))))

(defvar-local overline--vc-branch-segment
    '(:eval (overline--current-branch)))

(defvar-local overline--flymake-status-segment
    `(:eval (overline--flymake-status)))

;; All modeline segment variables must be risky local variables
(dolist (construct '(overline--buffer-identification-segment
                     overline--major-mode-segment
                     overline--vc-branch-segment
                     overline--flymake-status-segment
                     overline--right-alignment-space-segment))
  (put construct 'risky-local-variable t))

;; Segment functions -----------------------------------------------------------------
;; Exposing all segments as functions allows us to call them in other places to do things
;; like calculate their width.

(defun overline--buffer-identification ()
  (propertize (overline--buffer-name)
              'face (overline--buffer-identification-face)))

(defun overline--major-mode ()
  (when (mode-line-window-selected-p)
    (concat
     (overline--major-mode-indicator)
     " "
     (propertize
      (overline--major-mode-name)
      'face 'shadow
      'mouse-face 'mode-line-highlight))))

(defun overline--flymake-status ()
  (when (and (bound-and-true-p flymake-mode)
             (mode-line-window-selected-p))
    (list
     '(:eval (overline--flymake-errors))
     " "
     '(:eval (overline--flymake-warnings))
     " "
     '(:eval (overline--flymake-notes)))))

(defun overline--current-branch ()
  (when-let* (((mode-line-window-selected-p))
              (file (buffer-file-name))
              (backend (vc-backend file))
              (branch (overline--vc-branch-name file backend))
              (face (overline--vc-face file backend)))
    (overline--ellipsize (overline--branch-icon-and-name branch face))))

;; Helper Functions -------------------------------------------------------------

(defun overline--length-rhs ()
  "All right hand side segments must be called here.
This is requires to determine an accurate length for the right hand
side segments."
  (+ (length (overline--current-branch))
     (length (overline--flymake-status))
     1))

(defun overline--abbreviate-path (path)
  (let ((short-path (overline--unexpand-home-path path)))
    (if (overline--long-segment-p short-path 50)
        (let* ((full-path (split-string short-path "/"))
               (file (car (last full-path)))
               (parent (car (last full-path 2)))
               (path-pieces (butlast full-path 2))
               (letter-dirs (s-join "/" (mapcar #'overline--abbreviate-directory path-pieces))))
          (s-join "/" (list letter-dirs parent file)))
      short-path)))

(defun overline--buffer-name ()
  (let ((name (overline--abbreviate-path (buffer-file-name))))
    (if buffer-read-only
        (format "%s %s"
                (char-to-string #xe672)
                (or name ""))
      name)))

(defun overline--major-mode-indicator ()
  (let ((indicator (cond
                    ((derived-mode-p 'text-mode) (char-to-string #xf03ec))
                    ((derived-mode-p 'prog-mode) (char-to-string #xf10d6))
                    ((derived-mode-p 'comint-mode) (char-to-string #xe795))
                    (t (char-to-string #xf444)))))
    (propertize indicator 'face 'shadow)))

(defun overline--branch-icon-and-name (branch &optional face)
  (concat
   (propertize (char-to-string #xf126) 'face 'shadow)
   " "
   (propertize branch
               'face face
               'local-map overline--vc-map)))

(defun overline--flymake-errors ()
  (when-let ((count (overline--flymake-counter :error)))
    (concat
     (propertize (char-to-string #xea87) 'face 'error)
     " "
     (propertize count 'face 'error))))

(defun overline--flymake-warnings ()
  (when-let ((count (overline--flymake-counter :warning)))
    (concat
     (propertize (char-to-string #xea6c) 'face 'warning)
     " "
     (propertize count 'face 'warning))))

(defun overline--flymake-notes ()
  (when-let ((count (overline--flymake-counter :note)))
    (concat
     (propertize (char-to-string #xea6c) 'face 'nerd-icons-blue)
     " "
     (propertize count 'face 'nerd-icons-blue))))

(defun overline--home-directory-path-p (path)
  "Return t if the PATH is in $HOME, else nil."
  (string-prefix-p (getenv "HOME") path))

(defun overline--unexpand-home-path (path)
  "If PATH is a path in $HOME, add the ~/ abbreviation, else return PATH."
  (if (overline--home-directory-path-p path)
      (replace-regexp-in-string (getenv "HOME") "~" path)
    path))

(defun overline--abbreviate-directory (dir)
  "Abbreviate DIR, replacing directory names with single letters."
  (cond ((string= "~" dir) dir)
        ((string= "." (substring dir 0 1)) (substring dir 0 2))
        (t (substring dir 0 1))))

(defun overline--buffer-identification-face ()
  "Return a face for the buffer name given the modified state of the buffer."
  (let ((file (buffer-file-name)))
    (cond
     ((and (mode-line-window-selected-p)
           file
           (buffer-modified-p))
      '(italic mode-line-buffer-id))
     ((and file (buffer-modified-p))
      'italic)
     ((mode-line-window-selected-p)
      'mode-line-buffer-id))))

(defun overline--major-mode-name ()
  "Return the name of the major mode, stripping out -mode and -ts."
  (let* ((without-mode (string-replace "-mode" "" (symbol-name major-mode)))
         (without-ts (string-replace "-ts" "" without-mode)))
    (capitalize without-ts)))

(defun overline--vc-branch-name (file backend)
  (when-let ((rev (vc-working-revision file backend))
             (branch (or (vc-git--symbolic-ref file)
                         (substring rev 0 7))))
    branch))

(defun overline--vc-face (file backend)
  "Get the appropriate face for the given BACKEND `vc-state' of the FILE."
  (alist-get (vc-state file backend) overline--vc-faces 'up-to-date))

(defun overline--long-segment-p (segment max-length)
  "Return t if SEGMENT exceeds MAX-LENGTH or if the frame is small."
  (or (< (frame-width) 75)
      (> (length segment) max-length)))

(defun overline--ellipsize (segment)
  "Ellipsize the SEGMENT if the window is too small or it is too long."
  (if (overline--long-segment-p segment 30)
      (concat (substring segment 0 30) "...")
    segment))

(defun overline--flymake-counter (type)
  "Return the count of flymake issues for the given TYPE."
  (let ((count 0))
    (dolist (d (flymake-diagnostics))
      (when (= (flymake--severity type)
               (flymake--severity (flymake-diagnostic-type d)))
        (cl-incf count)))
    (when (cl-plusp count)
      (number-to-string count))))


(provide 'overline)
