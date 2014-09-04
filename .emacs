(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(iswitchb-mode 1)

;; Add emacs folder to the path
(add-to-list 'load-path "~/emacs/")


(setq grep-find-command "find . -name '.svn' -prune -o -name 'data' -prune -o -name '*' ! -name '*~' -print0 | xargs -0 grep -H -n -i -s ")

;;grep search for multibly matches in a file 
;;(setq grep-find-command "find . -name '.svn' -prune -o -name 'data' -prune -o -name '*' ! -name '*~' -print0 | xargs -0 grep -l  first_word * | xargs grep -H -n -i second_word")

;; find-dired+
(load "find-dired+.el")

(global-set-key [f2] 'find-dired)

(defun open-with-android-studio()
  (interactive)
  (when buffer-file-name
  (w32-shell-execute "open" "studio64.exe" buffer-file-name)))

(global-set-key [f3] 'open-with-android-studio)

(defun w32explore (file)
    "Open Windows Explorer to FILE (a file or a folder)."
    (interactive "fFile: ")
    (let ((w32file (subst-char-in-string ?/ ?\\ (expand-file-name file))))
      (if (file-directory-p w32file)
          (w32-shell-execute "explore" w32file "/e,/select,")
        (w32-shell-execute "open" "explorer" (concat "/e,/select," w32file)))))

(global-set-key [f4] 'w32explore)


(global-unset-key "\C-z")

;; create an invisible backup directory and make the backups also invisable
(defun make-backup-file-name (filename)
(defvar backups-dir "~/.backups/")
(make-directory backups-dir t)
(expand-file-name
(concat backups-dir "." (file-name-nondirectory filename) "~")
(file-name-directory filename)))

