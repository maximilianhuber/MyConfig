;; mu4e
(after! mu4e
  (defun mu4e-message-maildir-matches (msg rx)
    (when rx
      (if (listp rx)
          ;; If rx is a list, try each one for a match
          (or (mu4e-message-maildir-matches msg (car rx))
              (mu4e-message-maildir-matches msg (cdr rx)))
        ;; Not a list, check rx
        (string-match rx (mu4e-message-field msg :maildir)))))
  (setq
   mu4e-use-maildirs-extension t
   mu4e-enable-notifications t
   mu4e-enable-mode-line t)

  (add-hook 'mu4e-compose-mode-hook 'flyspell-mode)
  ;; PGP-Sign all e-mails
  ;; (add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)
  (setq mu4e-maildir "~/Maildir/"
        mu4e-get-mail-command "runMbsync"
        mu4e-attachment-dir  "~/Downloads"
        ;; This enabled the thread like viewing of email similar to gmail's UI.
        mu4e-headers-include-related t
        mu4e-view-show-images t

        mu4e-view-show-addresses t
        message-kill-buffer-on-exit t

        mu4e-update-interval 300

        mu4e-compose-format-flowed nil

        mml2015-use 'epg
        mml2015-encrypt-to-self t

        mml2015-sign-with-sender t ;; also encrypt for self (https://emacs.stackexchange.com/questions/2227/how-can-i-make-encrypted-messages-readable-in-my-sent-folder)
        mu4e-context-policy 'pick-first

        message-send-mail-function 'message-send-mail-with-sendmail
        sendmail-program "msmtp"
        message-sendmail-envelope-from 'header)

  (add-to-list 'mu4e-view-actions
               '("View in browser" . mu4e-action-view-in-browser) t)
  (add-to-list 'mu4e-view-actions
               '("retag message" . mu4e-action-retag-message) t)

      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Marks
  ;; See: https://www.djcbsoftware.nl/code/mu/mu4e/Adding-a-new-kind-of-mark.html
  (add-to-list 'mu4e-marks
               '(tag
                 :char       "g"
                 :prompt     "gtag"
                 :ask-target (lambda () (read-string "What tag do you want to add?"))
                 :action     (lambda (docid msg target)
                               (mu4e-action-retag-message msg (concat "+" target)))))
  (add-to-list 'mu4e-marks
               '(archive
                 :char       "A"
                 :prompt     "Archive"
                 :show-target (lambda (target) "archive")
                 :action      (lambda (docid msg target)
                                ;; must come before proc-move since retag runs
                                ;; 'sed' on the file
                                (mu4e-action-retag-message msg "-\\Inbox")
                                (mu4e~proc-move docid nil "+S-u-N"))))
  (mu4e~headers-defun-mark-for tag)
  (mu4e~headers-defun-mark-for archive)
  (define-key mu4e-headers-mode-map (kbd "g") 'mu4e-headers-mark-for-tag)
  (define-key mu4e-headers-mode-map (kbd "A") 'mu4e-headers-mark-for-archive)
  )
