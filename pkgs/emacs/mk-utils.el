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

(defconst mk-notes-file (f-expand "~/notes.md")
  "The file where day-to-day notes and tasks are recorded.")

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

(defconst mk-list-item-regexp
  "^[[:blank:]]*\\(?:[-*+]\\|[[:digit:]]+[.)]\\)[[:blank:]]+"
  "Regexp matching the bullet of a Markdown list item.

The match ends where the content of the item begins.")

(defun mk-goto-list-item-content ()
  "Move point to the beginning of the content of the list item at point.

Return NIL if there is no list item at point, in which case the
point is left at the beginning of the current line."
  (beginning-of-line)
  ;; A continuation line of a multi-line item is indented and not blank, so
  ;; when we see one the item itself starts on one of the preceding lines.
  (while (and (not (looking-at mk-list-item-regexp))
              (looking-at "[[:blank:]]+[^[:space:]]")
              (not (bobp)))
    (forward-line -1))
  (when (looking-at mk-list-item-regexp)
    (goto-char (match-end 0))))

(defun mk-toggle-done ()
  "Toggle the DONE marker of the list item at point.

The marker is placed right after the bullet, so the command works
for items at any nesting level and can be invoked from any line of
a multi-line item."
  (interactive)
  (save-excursion
    (unless (mk-goto-list-item-content)
      (user-error "Not inside a list item"))
    (if (looking-at "DONE[[:blank:]]+")
        (delete-region (point) (match-end 0))
      (insert "DONE "))))

(defun mk-insert-day-template (&optional arg)
  "Insert the standard day template or a diary header.

If the user is editing `mk-notes-file' then a day template is
inserted, otherwise a diary header.

By default the date is today.  Argument ARG, if supplied,
indicates how many days should be added to today."
  (interactive "P")
  (if (string-equal (buffer-file-name) mk-notes-file)
      (let ((template-file (f-expand "~/day-template.md")))
        (beginning-of-line)
        (insert "## ")
        (mk-show-date t arg)
        (newline 2)
        (when (f-file-p template-file)
          (insert (f-read-text template-file))
          (newline)))
    (newline)
    (insert "## ")
    (mk-show-date t arg "%d.%m.%Y, %A")
    (newline 2)))

(defun mk-find-notes ()
  "Open notes.md in the home directory (create if necessary)."
  (interactive)
  (find-file mk-notes-file))

(defun mk-show-date (&optional stamp arg format)
  "Show the current date in the minibuffer.

If STAMP is not NIL, insert date at point.

If ARG is given, insert the date this many days in the future.

If FORMAT is given, it is the custom format string to use."
  (interactive)
  (let* ((days-to-add (or arg current-prefix-arg 0))
         (time (time-add (current-time) (days-to-time days-to-add))))
    (funcall (if stamp #'insert #'message)
             (format-time-string (or format "%A, %e %B %Y") time))))

(defun mk-file-name-to-kill-ring (arg)
  "Put name of file into kill ring.

If user's visiting a buffer that's associated with a file, use
name of the file.  If major mode is ‘dired-mode’, use name of
file at point, but if point is not placed at any file, put name
of actual directory into kill ring.  Argument ARG, if given,
makes result string be quoted as for yanking into shell."
  (interactive "P")
  (let ((x (if (cl-find major-mode
                        '(dired-mode wdired-mode))
               (or (dired-get-filename nil t)
                   default-directory)
             (buffer-file-name))))
    (when x
      (kill-new
       (expand-file-name
        (if arg
            (shell-quote-argument x)
          x)))
      (message "%s → kill ring" x))))

(provide 'mk-utils)

;;; mk-utils.el ends here
