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

;; Add emacs folder to the path
(add-to-list 'load-path "~/emacs/")


(setq grep-find-command "find . -name '.svn' -prune -o -name 'data' -prune -o -name '*' ! -name '*~' -print0 | xargs -0 grep -H -n -i -s ")

;;grep search for multibly matches in a file 
;;(setq grep-find-command "find . -name '.svn' -prune -o -name 'data' -prune -o -name '*' ! -name '*~' -print0 | xargs -0 grep -l  first_word * | xargs grep -H -n -i second_word")

;; find-dired+
(load "find-dired+.el")

(global-set-key [f2] 'find-dired)


