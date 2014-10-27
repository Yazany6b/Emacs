
;;this file done by yazan baniyounes to configure the email sending process
 (setq smtpmail-default-smtp-server "smtp.mail.yahoo.com") ; needs to be specified before the (require)
 (require 'smtpmail)
 (setq send-mail-function 'smtpmail-send-it)
 (setq message-send-mail-function 'smtpmail-send-it)
 (setq smtpmail-stream-type 'ssl)
 (setq user-full-name "Yazan")
 (setq smtpmail-local-domain "yahoo.com")
 (setq smtpmail-starttls-credentials '(("smtp.mail.yahoo.com" 465 nil nil)))
 (setq user-mail-address (concat "yazanse@" smtpmail-local-domain))
 (setq smtpmail-smtp-server "smtp.mail.yahoo.com")
 (setq smtpmail-smtp-service 465)
 (setq smtpmail-debug-info t) ; only to debug problems
 (setq smtpmail-auth-credentials  ; or use ~/.authinfo
          '(("smtp.mail.yahoo.com" 465 "yazanse@yahoo.com" nil)))

(setenv "MAILHOST" "pop.mail.yahoo.com")
 (setq rmail-primary-inbox-list '("pop://yazanse@yahoo.com")
       rmail-pop-password-required t)
