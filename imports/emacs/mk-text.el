;;; mk-text.el --- -*- lexical-binding: t; -*-

;;; Commentary:

;; Self-sufficient supplementary text editing commands.

;;; Code:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers

(defun mk-column-at (point)
  "Return column number at POINT."
  (save-excursion
    (goto-char point)
    (current-column)))

(defun mk-saturated-occurence (&optional after-space)
  "Return position of first non-white space character after point.

If AFTER-SPACE is not NIL, require at least one space character
before target non-white space character."
  (save-excursion
    (let ((this-end (line-end-position)))
      (if (re-search-forward
           (concat (when after-space "[[:blank:]]")
                   "[^[:blank:]]")
           this-end ; don't go after this position
           t)       ; don't error
          (1- (point))
        this-end))))

(defun mk-with-smart-region (action)
  "Automatically detect the relevant block of lines and invoke ACTION on it.

If there is an active region, use that; otherwise select a region
with the same indentation level around the point.  This function
takes care of preserving the position of the point.  It also
deactivates the mark when necessary.

ACTION will be called with two arguments: the beginning of the
region to edit and its end.  It should return a number which will
be used as a delta to the column of the point."
  (cl-destructuring-bind (start* . end*)
      (if (region-active-p)
          (cons (min (point) (mark))
                (max (point) (mark)))
        (save-excursion
          (let* ((origin
                  (progn
                    (back-to-indentation)
                    (point)))
                 (indent (current-column))
                 (start
                  (progn
                    (while (and (= (current-column) indent)
                                (not (looking-at "^[[:space:]]*$"))
                                (/= (point) (point-min)))
                      (backward-to-indentation 1))
                    (unless (= (point) (point-min))
                      (forward-line 1))
                    (pos-bol)))
                 (end
                  (progn
                    (goto-char origin)
                    (while (and (= (current-column) indent)
                                (not (looking-at "^[[:space:]]*$"))
                                (/= (point) (point-max)))
                      (forward-to-indentation 1))
                    (pos-bol))))
            (cons start end))))
    (atomic-change-group
      (let ((original-col (current-column))
            (original-line (line-number-at-pos)))
        (deactivate-mark)
        (undo-boundary)
        (let ((column-delta (or (funcall action start* end*) 0)))
          (goto-char (point-min))
          (forward-line (- original-line 1))
          (move-to-column (max 0 (+ original-col column-delta))))))))

(defun mk-for-line (start end action)
  "Traverse lines in the region between START and END while invoking ACTION."
  (goto-char start)
  (cl-do ((i 0)
          (total (count-lines start end)))
      ((= i total))
    (funcall action)
    (forward-line 1)
    (setq i (1+ i))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Text editing commands

;;;###autoload
(defun mk-transpose-line-down (&optional arg)
  "Move current line and cursor down.

Argument ARG, if supplied, specifies how many times the operation
should be performed."
  (interactive "p")
  (dotimes (_ (or arg 1))
    (let ((col (current-column)))
      (forward-line    1)
      (transpose-lines 1)
      (forward-line   -1)
      (move-to-column col))))

;;;###autoload
(defun mk-transpose-line-up (&optional arg)
  "Move current line and cursor up.

Argument ARG, if supplied, specifies how many times the operation
should be performed."
  (interactive "p")
  (dotimes (_ (or arg 1))
    (let ((col (current-column)))
      (transpose-lines 1)
      (forward-line   -2)
      (move-to-column col))))

;;;###autoload
(defun mk-duplicate-line (&optional arg)
  "Copy current line and yank its copy under the current line.

Position of point shifts one line down.  Argument ARG, if
supplied, specifies how many times the operation should be
performed."
  (interactive "p")
  (dotimes (_ (or arg 1))
    (let* ((col (current-column))
           (start (line-beginning-position))
           (end (line-end-position))
           (fragment-to-duplicate (buffer-substring-no-properties start end)))
      (move-beginning-of-line 1)
      (insert fragment-to-duplicate)
      (newline)
      (move-to-column col))))

;;;###autoload
(defun mk-mark-command (&optional arg)
  "Set normal mark when ARG is NIL and rectangular otherwise."
  (interactive "P")
  (if arg
      (rectangle-mark-mode 1)
    (set-mark-command nil)))

;;;###autoload
(defun mk-smart-indent (&optional arg)
  "Align first non-white space char after point with content of previous line.

With prefix argument ARG, align to the next line instead."
  (interactive "P")
  (let* ((this-edge (mk-column-at (mk-saturated-occurence)))
         (that-edge
          (save-excursion
            (forward-line (if arg 1 -1))
            (move-to-column this-edge)
            (mk-column-at (mk-saturated-occurence t)))))
    (when (> that-edge this-edge)
      (insert-char 32 (- that-edge this-edge))
      (move-to-column that-edge))))

;;;###autoload
(defun mk-eat-indent (&optional arg)
  "Delete indentation of current line.

ARG, if given, specifies how many symbols to eat."
  (interactive "p")
  (save-excursion
    (beginning-of-line)
    (dotimes (_ (or arg 1))
      (when (looking-at "[[:blank:]]")
        (delete-char 1)))))

;;;###autoload
(defun mk-join-lines ()
  "Join the current line with the next line."
  (interactive)
  (delete-indentation t))

;;;###autoload
(defun mk-copy-rest-of-line ()
  "Copy current line from point to end of line."
  (interactive)
  (kill-new (buffer-substring (point) (line-end-position))))

;;;###autoload
(defun mk-copy-buffer ()
  "Put entire buffer into the kill ring."
  (interactive)
  (kill-new (buffer-string)))

;;;###autoload
(defun mk-yank-primary ()
  "Insert contents of the primary selection at the point."
  (interactive)
  (insert (gui-get-selection)))

;;;###autoload
(defun mk-narrow-to-region ()
  "Narrow a block and deactivate the selection.

See `mk-with-smart-region' for semantics of what constitutes a
block."
  (interactive)
  (mk-with-smart-region #'narrow-to-region))

;;;###autoload
(defun mk-add-to-beginning-of-lines (text)
  "Append TEXT to end of lines in a block.

See `mk-with-smart-region' for semantics of what constitutes a
block."
  (interactive "MAdd to the beginning of lines: ")
  (mk-with-smart-region
   (lambda (start end)
     (mk-for-line
      start
      end
      (lambda ()
        (move-beginning-of-line 1)
        (insert text)))
     (length text))))

;;;###autoload
(defun mk-add-to-end-of-lines (text)
  "Append TEXT to end of lines in a block.

See `mk-with-smart-region' for semantics of what constitutes a
block."
  (interactive "MAdd to the end of lines: ")
  (mk-with-smart-region
   (lambda (start end)
     (mk-for-line
      start
      end
      (lambda ()
        (move-end-of-line 1)
        (insert text))))))

;;;###autoload
(defun mk-remove-from-beginnig-of-lines (&optional arg)
  "Remove characters from beginning of lines in a block.

ARG, if given, specifies how many characters to delete.

See `mk-with-smart-region' for semantics of what constitutes a
block."
  (interactive "p")
  (mk-with-smart-region
   (lambda (start end)
     (mk-for-line
      start
      end
      (lambda ()
        (move-beginning-of-line 1)
        (delete-char arg)))
     (- arg))))

;;;###autoload
(defun mk-remove-from-end-of-lines (&optional arg)
  "Remove characters from end of lines in a block.

ARG, if given, specifies how many characters to delete.

See `mk-with-smart-region' for semantics of what constitutes a
block."
  (interactive "p")
  (mk-with-smart-region
   (lambda (start end)
     (mk-for-line
      start
      end
      (lambda ()
        (move-end-of-line 1)
        (delete-char (- arg)))))))

;;;###autoload
(defun mk-sort-lines (&optional reverse)
  "Automatically detect and sort block of lines with point in it.

When argument REVERSE is not NIL, use descending sort.

See `mk-with-smart-region' for semantics of what constitutes a
block."
  (interactive "P")
  (mk-with-smart-region
   (lambda (start end)
     (sort-lines reverse start end))))

;;;###autoload
(defun mk-increase-indentation (&optional arg)
  "Increase indentation in the block by `tab-width'.

ARG, if given, specifies how many spaces to insert.

See `mk-with-smart-region' for semantics of what constitutes a
block."
  (interactive "P")
  (mk-with-smart-region
   (lambda (start end)
     (let ((delta (or arg tab-width)))
       (mk-for-line
        start
        end
        (lambda ()
          (move-beginning-of-line 1)
          (insert-char 32 delta)))
       delta))))

;;;###autoload
(defun mk-decrease-indentation (&optional arg)
  "Decrease indentation in the block by `tab-width'.

ARG, if given, specifies how many spaces to remove.

See `mk-with-smart-region' for semantics of what constitutes a
block."
  (interactive "P")
  (mk-with-smart-region
   (lambda (start end)
     (let ((delta (or arg tab-width)))
       (mk-for-line
        start
        end
        (lambda ()
          (move-beginning-of-line 1)
          (dotimes (_ delta)
            (when (looking-at "[[:blank:]]")
              (delete-char 1)))))
       (- delta)))))

(provide 'mk-text)

;;; mk-text.el ends here
