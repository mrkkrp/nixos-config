;;; mk-utils.el --- -*- lexical-binding: t; -*-

;;; Commentary:

;; I've collected various auxiliary functions here to avoid cluttering other
;; files.

;;; Code:

(eval-when-compile
  (require 'dired))

(require 'cl-lib)
(require 'f)
(require 'subr-x)

(defmacro mk-translate-kbd (from to)
  "Translate combinations of keys FROM to TO combination."
  `(define-key key-translation-map (kbd ,from) (kbd ,to)))

(defun mk-set-key (key fnc)
  "Set global key binding that binds KEY to FNC."
  (global-set-key (kbd key) fnc))

(defmacro mk-iwrap (fnc &rest args)
  "Interactively invoke function FNC with arguments ARGS."
  `(lambda (&rest rest)
     (interactive)
     (apply ,fnc ,@args rest)))

(defun mk-switch-to-messages ()
  "Switch to the *Messages* buffer."
  (interactive)
  (switch-to-buffer "*Messages*"))

(defun mk-switch-to-scratch ()
  "Switch to the *scratch* buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun mk-double-buffer ()
  "Show current buffer in other window and switch to that window."
  (interactive)
  (if (> (length (window-list)) 1)
      (let ((original-buffer (buffer-name)))
        (other-window 1)
        (switch-to-buffer original-buffer))
    (split-window-sensibly)
    (other-window 1)))

(defun mk-grab-input (prompt &optional initial-input add-space)
  "Grab input from user.

If there is an active region, use its contents, otherwise read
text from the minibuffer.  PROMPT is a prompt to show,
INITIAL-INPUT is the initial input.  If INITIAL-INPUT and
ADD-SPACE are not NIL, add one space after the initial input."
  (if mark-active
      (buffer-substring (region-beginning)
                        (region-end))
    (read-string prompt
                 (concat initial-input
                         (when (and initial-input add-space) " ")))))

(defun mk-get-existing-projects (dir)
  "Return a list of existing projects under DIR.

All projects are combinations of two directory segments (org or
user, then project name, slash separated) immediately under the
specified directory."
  (cl-sort
   (mapcar (lambda (path)
             (f-relative path "~/projects"))
           (f-glob "*/*" dir))
   #'string-lessp))

(defun mk-project-jump (project-name)
  "Jump to PROJECT-NAME opening it in Dired."
  (interactive
   (list
    (completing-read "Projects: "
                     (mk-get-existing-projects "~/projects"))))
  (find-file
   (f-expand project-name "~/projects")))

(defun mk-grep (regexp)
  "Grep for REGEXP in current directory recursively."
  (interactive
   (list
    (read-string "Grep: ")))
  (ripgrep-regexp regexp default-directory))

(defun mk-find-file (file)
  "Find a FILE under current ‘default-directory’."
  (interactive
   (list
    (completing-read
     "Files: "
     (cl-sort
      (with-temp-buffer
        (call-process
         "fd" nil (current-buffer) nil
         "--type" "file" "--ignore-case" ".")
        (split-string (buffer-string) "\n" t " "))
      #'string-lessp))))
  (find-file (f-expand file default-directory)))

(defun mk-show-date (&optional stamp)
  "Show current date in the minibuffer.

If STAMP is not NIL, insert date at point."
  (interactive)
  (funcall (if stamp #'insert #'message)
           (format-time-string "%A, %e %B, %Y")))

(defun mk-file-name-to-kill-ring (arg)
  "Put name of file into kill ring.

If user's visiting a buffer that's associated with a file, use
name of the file.  If major mode is ‘dired-mode’, use name of
file at point, but if point is not placed at any file, put name
of actual directory into kill ring.  Argument ARG, if given,
makes result string be quoted as for yanking into shell."
  (interactive "P")
  (let ((φ (if (cl-find major-mode
                        '(dired-mode wdired-mode))
               (or (dired-get-filename nil t)
                   default-directory)
             (buffer-file-name))))
    (when φ
      (message "%s → kill ring"
               (kill-new
                (expand-file-name
                 (if arg
                     (shell-quote-argument φ)
                   φ)))))))

(provide 'mk-utils)

;;; mk-utils.el ends here
