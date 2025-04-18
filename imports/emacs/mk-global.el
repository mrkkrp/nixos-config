;;; mk-global.el --- -*- lexical-binding: t; -*-

;;; Commentary:

;; Top-level settings that are not related to particular packages.

;;; Code:

(require 'mk-utils)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set variables

(setq-default
 auto-save-no-message t
 cursor-in-non-selected-windows nil
 cursor-type '(bar . 1)
 custom-file (f-expand ".emacs-custom.el" user-emacs-directory)
 echo-keystrokes 0.1
 enable-recursive-minibuffers t
 explicit-shell-file-name "bash"
 fill-column 76
 frame-title-format "660c03ad-0f61-438c-9342-957f73cd9b05"
 gc-cons-threshold 2000000
 indent-tabs-mode nil
 indicate-empty-lines t
 inhibit-startup-screen t
 initial-scratch-message (concat ";; Emacs " emacs-version " -*- lexical-binding: t; -*-\n\n")
 major-mode 'text-mode
 resize-mini-windows t
 ring-bell-function 'ignore
 scroll-margin 3
 scroll-step 1
 sentence-end-double-space nil
 shell-file-name "bash"
 tab-width 4
 use-short-answers t
 user-full-name "Mark Karpov"
 user-mail-address "markkarpov92@gmail.com"
 x-underline-at-descent-line t
 )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key translation

(mk-translate-kbd "<C-menu>"      "<next>")
(mk-translate-kbd "<C-return>"    "<return>")
(mk-translate-kbd "<next> <next>" "M-x")
(mk-translate-kbd "C-C s"         "C-c C-s")
(mk-translate-kbd "C-c b"         "C-c C-b")
(mk-translate-kbd "C-c c"         "C-c C-c")
(mk-translate-kbd "C-c d"         "C-c C-d")
(mk-translate-kbd "C-c k"         "C-c C-k")
(mk-translate-kbd "C-c l"         "C-c C-l")
(mk-translate-kbd "C-c n"         "C-c C-n")
(mk-translate-kbd "C-c o"         "C-c C-o")
(mk-translate-kbd "C-c u"         "C-c C-u")
(mk-translate-kbd "C-c v"         "C-c C-v")
(mk-translate-kbd "C-x ;"         "C-x C-;")
(mk-translate-kbd "C-x o"         "C-x C-o")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global key map

(mk-set-key "<next>" nil)

(mk-set-key "<f6>" 'mk-toggle-done)
(mk-set-key "<f7>" 'mk-insert-day-template)
(mk-set-key "<f8>" 'mk-find-notes)
(mk-set-key "<next> d a" (mk-iwrap 'mk-show-date))
(mk-set-key "<next> d b" 'mk-double-buffer)
(mk-set-key "<next> f n" 'mk-file-name-to-kill-ring)
(mk-set-key "<next> m m" 'mk-switch-to-messages)
(mk-set-key "<next> s s" 'mk-switch-to-scratch)
(mk-set-key "<next> s t" (mk-iwrap 'mk-show-date t))
(mk-set-key "<next> u u" 'mk-project-jump)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other

(defalias 'display-startup-echo-area-message (mk-iwrap 'mk-show-date))

(advice-add 'process-kill-buffer-query-function
            :override
            (lambda (&rest _rest) (list t)))

(tool-bar-mode 0)
(menu-bar-mode 0)

(put 'erase-buffer 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(provide 'mk-global)

;;; mk-global.el ends here
