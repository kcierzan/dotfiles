;;; sudo.el --- Edit files with sudo -*- lexical binding: t; -*-

;;;###autoload
(defun my/sudo-find-file (file)
  "Open file as root"
  (interactive "FOpen file as root: ")
  (when (file-writable-p file)
    (user-error "File is user writable, aborting sudo"))
  (find-file (if (file-remote-p)
                 (concat "/" (file-remote-p file 'method) ":" (file-remote-p file 'user) "@" (file-remote-p file 'host) "|sudo:root@" (file-remote-p file 'host) ":" (file-remote-p file 'localname))
               (concat "/sudo:root@localhost:" file))))

;;;###autoload
(defun my/sudo-this-file ()
  "Open the current file as root."
  (interactive)
  (my/sudo-find-file (file-truename buffer-file-name)))
