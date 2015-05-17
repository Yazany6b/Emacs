(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes (quote ("0e7397d2f61fc2144d262eba45f1b3c7893463831b9cbeaaf480ea613225a25f" default)))
 '(org-agenda-files nil)
 '(send-mail-function nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(iswitchb-mode 1)

;;(server-start)

;; Add emacs folder to the path
(add-to-list 'load-path "~/emacs/")
(add-to-list 'load-path "~/emacs/org-lisp/")

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
(global-unset-key "\C-x z")

;; create an invisible backup directory and make the backups also invisable
(defun make-backup-file-name (filename)
(defvar backups-dir "~/.backups/")
(make-directory backups-dir t)
(expand-file-name
(concat backups-dir "." (file-name-nondirectory filename) "~")
(file-name-directory filename)))

(load "email-conf.el")
(load "undo-tree.el")
(load "web-mode.el")
(load "web-search.el")
(load "auto-complete-nxml.el")

;;send email shortcut

(define-key global-map "\C-ce" 'message-send)

(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(autoload 'vbnet-mode "vbnet-mode" "Mode for editing VB.NET code." t)
   (setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\|vb\\)$" .
                                 vbnet-mode)) auto-mode-alist))

(setq inhibit-startup-message t)

;;initiate the org mode and assign keys to it
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-agenda-files '("~/orgs/"))

(require 'ido)
(ido-mode t)
