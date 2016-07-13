


(defvar find-file-root-prefix (if (featurep 'xemacs) "/[sudo/root@localhost]" "/sudo:root@localhost:" )
  "*The filename prefix used to open a file with `find-file-root'.")

(defvar find-file-root-history nil
  "History list for files found using `find-file-root'.")

(defvar find-file-root-hook nil
  "Normal hook for functions to run after finding a \"root\" file.")

(defun find-file-root ()
  "*Open a file as the root user.
   Prepends `find-file-root-prefix' to the selected file name so that it
   maybe accessed via the corresponding tramp method."

  (interactive)
  (require 'tramp)
  (let* ( ;; We bind the variable `file-name-history' locally so we can
	 ;; use a separate history list for "root" files.
	 (file-name-history find-file-root-history)
	 (name (or buffer-file-name default-directory))
	 (tramp (and (tramp-tramp-file-p name)
		     (tramp-dissect-file-name name)))
	 path dir file)

    ;; If called from a "root" file, we need to fix up the path.
    (when tramp
      (setq path (tramp-file-name-localname tramp)
	    dir (file-name-directory path)))

    (when (setq file (read-file-name "Find file (UID = 0): " dir path))
      (find-file (concat find-file-root-prefix file))
      ;; If this all succeeded save our new history list.
      (setq find-file-root-history file-name-history)
      ;; allow some user customization
      (run-hooks 'find-file-root-hook))))

(global-set-key [(control x) (control r)] 'find-file-root)



(defun find-file-hook-root-header-warning ()
  (when (and buffer-file-name (string-match "root@localhost" buffer-file-name))
    (find-file-root-header-warning)))
(add-hook 'find-file-hook 'find-file-hook-root-header-warning)

(defvar find-file-root-log "~/system/root-log"
  "*ChangeLog in which to log changes to system files.")

(defun find-file-root-log-do-it()
  "Add an entry for the current buffer to `find-file-root-log'."
  (let ((add-log-mailing-address "root@localhost")
	(add-log-full-name "")
	(add-log-file-name-function 'identity)
	(add-log-buffer-file-name-function
	 (lambda () ;; strip tramp prefix
	   (tramp-file-name-localname
	    (tramp-dissect-file-name
	     (or buffer-file-name default-directory)))
	   )))
    (add-change-log-entry nil find-file-root-log 'other-window)))

(defun find-file-root-log-on-save ()
  "*Prompt for a log entry in `find-file-root-log' after saving a root file.
   This function is suitable to add to `find-file-root-hook'."
  (add-hook 'after-save-hook 'find-file-root-log-do-it 'append 'local))

(add-hook 'find-file-root-hook 'find-file-root-log-on-save)

(defun my-find-file-root-hook ()
  "Some personal preferences."
  ;; Turn auto save off and simplify backups (my version of tramp
  ;; barfs unless I do this:-)
  (setq buffer-auto-save-file-name nil)
  (set (make-local-variable 'backup-by-copying) nil)
  (set (make-local-variable 'backup-directory-alist) '(("."))))

(add-hook 'find-file-root-hook 'my-find-file-root-hook)

(defun really-toggle-read-only (&optional force)
  "Change whether this buffer is visiting its file read-only by really
trying to acquire the rights with sudo (and tramp)"
  (interactive "P")
  (let* ((currentfilename buffer-file-name)
	 (newfilename
	  ;; We first check that the buffer is linked to a file
	  (if (not currentfilename)
	      ;; If not, we just toggle the read-only mark
	      nil
	    ;; What is the current state
	    (if buffer-read-only
		;; The buffer is read-only, we should acquire rights to edit it
		(if (and (not force) (file-writable-p currentfilename))
		    ;; The file is writable, we don't need to acquire rights
		    nil
		  (if (buffer-modified-p)
		      (error "Buffer is read-only and has been modified. Don't know what to do.")
		    ;; To acquire rights, we need to use sudo
		    ;; Do we have a tramp file name ?
		    (if (eq (string-match tramp-file-name-regexp currentfilename) 0)
			;; Yes, we add sudo to it
			(let* ((v (tramp-dissect-file-name currentfilename))
			       (l (tramp-file-name-localname v)))
			  (if (or (string= "sudo"
					   (let ((m (tramp-file-name-method v)))
					     (if (not (stringp m))
						 (car (last (append m nil)))
					       m)))
				  (eq (string-match "^sudo::" l) 0))
			      (error "This file is already opened with sudo")
			    ;; We add sudo
			    (let ((toarray (lambda (a) (if (and (not (stringp a)) (arrayp a))
							   a (vector a)))))
			      (tramp-make-tramp-file-name
			       "multi"
			       (vconcat (apply toarray (list (tramp-file-name-method v))) ["sudo"])
			       (vconcat (apply toarray (list (tramp-file-name-user v))) ["root"])
			       (vconcat (apply toarray (list (tramp-file-name-host v))) ["localhost"])
			       l))))
		      ;; It is not a tramp file-name
		      (tramp-make-tramp-file-name
		       nil "sudo" nil "" currentfilename))))
	      ;; The buffer is not read-only, we must drop rights
	      (if (buffer-modified-p)
		  (error "Buffer is modified, save it first first.")
		(if (eq (string-match tramp-file-name-regexp currentfilename) 0)
		    ;; We should remove sudo
		    (let* ((v (tramp-dissect-file-name currentfilename))
			   (l (tramp-file-name-localname v))
			   (m (tramp-file-name-method v)))
		      ;; Two cases, either sudo is in local file name part or in the methods
		      (if (eq (string-match "^sudo::" l) 0)
			  ;; Necessary, we have a multi (otherwise, sudo would not have been
			  ;; in the localname)
			  ;; Do we have more than one method left ?
			  (if (> (length m) 1)
			      ;; Yes, still multi
			      (tramp-make-tramp-file-name
			       "multi"
			       m
			       (tramp-file-name-user v)
			       (tramp-file-name-host v)
			       (progn (string-match "^sudo::\\(.*\\)$" l)
				      (match-string 1 l)))
			    ;; We don't need multi anymore
			    (tramp-make-tramp-file-name
			     nil
			     (car (append m nil))
			     (car (append (tramp-file-name-user v) nil))
			     (car (append (tramp-file-name-host v) nil))
			     (progn (string-match "^sudo::\\(.*\\)$" l)
				    (match-string 1 l))))
			;; sudo should be in the methods
			(if (and (stringp m) (string= m "sudo"))
			    l
			  (if (and (not (stringp m)) (string= (car (last (append m nil))) "sudo"))
			      ;; Do we still need multi ?
			      (if (> (length m) 2)
				  (tramp-make-tramp-file-name
				   "multi"
				   (apply 'vector (butlast (append
							    m nil)))
				   (apply 'vector (butlast (append
							    (tramp-file-name-user v) nil)))
				   (apply 'vector (butlast (append
							    (tramp-file-name-host v) nil)))
				   l)
				(tramp-make-tramp-file-name
				 nil
				 (car (append m nil))
				 (car (append (tramp-file-name-user v) nil))
				 (car (append (tramp-file-name-host v) nil))
				 l))
			    ;; No sudo found
			    nil))))
		  ;; This is not a tramp file
		  nil))))))
    (if newfilename
	(find-alternate-file newfilename)
      (toggle-read-only))))

(defun find-alternative-file-with-sudo ()
  (interactive)
  (let ((fname (or buffer-file-name
		   dired-directory)))
    (when fname
      (if (string-match "^/sudo:root@localhost:" fname)
	  (setq fname (replace-regexp-in-string
		       "^/sudo:root@localhost:" ""
		       fname))
	(setq fname (concat "/sudo:root@localhost:" fname)))
      (find-alternate-file fname))))


;(add-to-list 'tramp-remote-path "c:/cygwin64/bin")

(require 'tramp)

(setq tramp-default-method "ssh")

;;(nconc (cadr (assq 'tramp-login-args (assoc "ssh" tramp-methods))) '(("bash" "-i")))
;;(setcdr (assq 'tramp-remote-sh (assoc "ssh" tramp-methods)) '("bash -i"))
