(defun home-directory-path-p (path)
  (string-prefix-p (getenv "HOME") path))

(defun unexpand-home-path (path)
  (if (home-directory-path-p path)
      (replace-regexp-in-string (getenv "HOME") "~" path)
    path))

(defun abbreviate-directory (dir)
  (cond ((string= "~" dir) dir)
        ((string= "." (substring dir 0 1)) (substring dir 0 2))
        (t (substring dir 0 1))))

(defun abbreviate-path (path)
  (let ((short-path (unexpand-home-path path)))
    (if (abbreviate-p short-path 50)
        (let* ((full-path (s-split "/" short-path))
               (file (car (last full-path)))
               (parent (car (last full-path 2)))
               (path-pieces (butlast full-path 2))
               (letter-dirs (s-join "/" (mapcar #'abbreviate-directory path-pieces))))
          (s-join "/" (list letter-dirs parent file)))
      short-path)))

(defun my/modeline-buffer-identification-face ()
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

(defun my/modeline-buffer-name ()
  (let ((name (abbreviate-path (buffer-file-name))))
    (if buffer-read-only
        (format "%s %s" (char-to-string #xe672) name)
      name)))

(defvar-local my/modeline-buffer-identification
    '(:eval
      (propertize (my/modeline-buffer-name)
                  'face (my/modeline-buffer-identification-face))))

(defun my/modeline-major-mode-indicator ()
  (let ((indicator (cond
                    ((derived-mode-p 'text-mode) (char-to-string #xf03ec))
                    ((derived-mode-p 'prog-mode) (char-to-string #xf10d6))
                    ((derived-mode-p 'comint-mode) (char-to-string #xe795))
                    (t (char-to-string #xf444)))))
    (propertize indicator 'face 'shadow)))


(defun my/modeline-major-mode-name ()
  (capitalize (string-replace "-mode" "" (symbol-name major-mode))))

(defvar-local my/modeline-major-mode
    '(:eval
      (concat
       (my/modeline-major-mode-indicator)
       " "
       (propertize
        (my/modeline-major-mode-name)
        'face 'shadow
        'mouse-face 'mode-line-highlight))))

(defun my--vc-branch-name (file backend)
  (when-let ((rev (vc-working-revision file backend))
             (branch (or (vc-git--symbolic-ref file)
                         (substring rev 0 7))))
    (capitalize branch)))

(defvar my/modeline--vc-faces
  '((added . vc-locally-added-state)
    (edited . vc-edited-state)
    (removed . vc-removed-state)
    (missing . vc-missing-state)
    (conflict . vc-conflict-state)
    (locked . vc-locked-state)
    (up-to-date . vc-up-to-date-state)))

(defun my-modeline--vc-face (file backend)
  (alist-get (vc-state file backend) my/modeline--vc-faces 'up-to-date))

(defun abbreviate-p (segment max-length)
  (or (< (frame-width) 75)
      (> (length segment) max-length)))

(defun my/modeline-string-cut-end (str)
  (if (abbreviate-p str 30)
      (concat (substring str 0 30) "...")
    str))

(defvar my/modeline-vc-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line down-mouse-1] 'vc-diff)
    (define-key map [modeline down-mouse-3] 'vc-root-diff)
    map))

(defun my/modeline--vc-text (file branch &optional face)
  (concat
   (propertize (char-to-string #xf126) 'face 'shadow)
   " "
   (propertize branch
               'face face
               'local-map my/modeline-vc-map)))

(defun my/modeline--vc-details (file branch &optional face)
  (my/modeline-string-cut-end
   (my/modeline--vc-text file branch face)))

(defvar-local my/modeline-vc-branch
    '(:eval
      (when-let* (((mode-line-window-selected-p))
                  (file (buffer-file-name))
                  (backend (vc-backend file))
                  (branch (my--vc-branch-name file backend))
                  (face (my-modeline--vc-face file backend)))
        (my/modeline--vc-details file branch face))))

(dolist (construct '(my/modeline-buffer-identification
                     my/modeline-major-mode
                     my/modeline-vc-branch))
  (put construct 'risky-local-variable t))

(setq-default mode-line-format '("%e"
                                 " "
                                 my/modeline-buffer-identification
                                 " "
                                 my/modeline-major-mode
                                 " "
                                 my/modeline-vc-branch))
(provide 'modeline)
