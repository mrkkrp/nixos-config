;;; mk-package.el --- -*- lexical-binding: t; -*-

;;; Commentary:

;; Custom functions for package management.

;;; Code:

(require 'package)

(defun mk-melpa-page (package)
  "Go to the MELPA page of PACKAGE."
  (interactive
   (list
    (completing-read "MELPA: "
                     (mapcar #'car package-archive-contents))))
  (browse-url
   (concat "https://melpa.org/#/"
           (url-hexify-string package))))

(defun mk-package-page (package)
  "Go to the PACKAGE home page if it exists."
  (interactive
   (list
    (intern
     (completing-read "Package's home page: "
                      (mapcar #'car package-archive-contents)))))
  (message "%s "package)
  (let ((home-page
         (cdr
          (assq :url
                (package-desc-extras
                 (cadr (assq package package-archive-contents)))))))
    (when home-page
      (browse-url home-page))))

(provide 'mk-package)

;;; mk-package.el ends here
