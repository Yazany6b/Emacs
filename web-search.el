
;; search google

(defun net-search-google ()
  "Google the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Google: "))))))

(global-set-key (kbd "C-c g") 'net-search-google)

;;search wikipidea

(defun net-search-wikipedia ()
  "Wiki the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://en.wikipedia.org/wiki/Special:Search?search="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Wikipedia: "))))))

(global-set-key (kbd "C-c w") 'net-search-wikipedia)


;;search stack over flow

(defun net-search-stackoverflow ()
  "Stackoverflow the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://stackoverflow.com/search?q="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Stackoverflow: "))))))

(global-set-key (kbd "C-c s") 'net-search-stackoverflow)

;;search android dev site

(defun net-search-androiddev ()
  "Android Dev the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://developer.android.com/index.html#q="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Android-Dev: "))))))

(global-set-key (kbd "C-c v") 'net-search-androiddev)

;;search php dev site
;; site:www.w3schools.com
(defun net-search-phpdev ()
  "Php the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://php.net/results.php?q="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "PHP-Dev: "))))))

(global-set-key (kbd "C-c p") 'net-search-phpdev)

;;search w3 schools site

(defun net-search-w3 ()
  "w3 the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "https://www.google.jo/#q=site:www.w3schools.com+"
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "W3-Schools: "))))))

(global-set-key (kbd "C-c h") 'net-search-w3)

;;Search youtube

(defun net-search-youtube ()
  "Youtube the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://www.youtube.com/results?search_query="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Youtube: "))))))

(global-set-key (kbd "C-c y") 'net-search-youtube)


(add-hook 'w3-parse-hooks 'w3-tidy-page)

(defvar w3-fast-parse-tidy-program "~/emacs/exec/tidy.exe")

(defun w3-tidy-page (&optional buff)
    "Use html tidy to clean up the HTML in the current buffer."
    (save-excursion
        (if buff
	    (set-buffer buff)
          (setq buff (current-buffer)))
        (widen)
        (call-process-region (point-min) (point-max)
	   	             w3-fast-parse-tidy-program
			     t (list buff nil) nil ;nil nil nil;
			     "--show-warnings" "no" "--show-errors" "0" "--force-output" "yes"
			     "-quiet" "-clean" "-bare" "-omit"
			     "--drop-proprietary-attributes" "yes" "--hide-comments" "yes"
			   )))


(global-set-key (kbd "C-c t") 'w3-tidy-page)



;; Google translate fuction 

(defun net-translate-english ()
  "Google the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "https://translate.google.com/#en/ar/"
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "To Arabic: "))))))

(global-set-key (kbd "C-c o") 'net-translate-english)


(defun net-translate-arabic ()
  "Google the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "https://translate.google.com/#ar/en/"
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "To English: "))))))

(global-set-key (kbd "C-c i") 'net-translate-arabic)
