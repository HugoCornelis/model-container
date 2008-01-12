;;; neurospaces-vars.el --- user customization variables for Neurospaces Mode

;; Copyright (C) 1985,87,92,93,94,95,96,97,98 Free Software Foundation, Inc.

;; Authors:    2006 Hugo Cornelis, based on cc-mode.
;; Maintainer: hugo.cornelis@gmail.com

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(require 'custom)
(require 'cc-vars)


(defcustom neurospaces-mode-hook nil
  "*Hook called by `neurospaces-mode'."
  :type 'hook
  :group 'c)

;; comes from func-menu.el

(require 'func-menu)

;;; Neurospaces
;;;
;;; Hugo Cornelis <hugo.cornelis@gmail.com>
(defvar fume-function-name-regexp-neurospaces
  "^\\(function\\|procedure\\)\\([ \t]+\\([_a-zA-Z][_a-zA-Z0-9]*\\)\\|[ \t]+\\)$"
  "Expression to get neurospaces function Names")

;; add function parser for neurospaces mode
(setq fume-function-name-regexp-alist
      (append '((neurospaces-mode . fume-function-name-regexp-neurospaces))
              fume-function-name-regexp-alist))

;;; Specialised routine to get the next neurospaces function in the buffer
;;;
;;; Hugo Cornelis <hugo@bbf.uia.ac.be>
(defun fume-find-next-neurospaces-function-name (buffer)
  "Searches for the next neurospaces function in BUFFER."
  (set-buffer buffer)
  ;; Search for the function
  (if (re-search-forward fume-function-name-regexp-neurospaces nil t)
      (let ((char (progn
                    (backward-up-list 1)
                    (save-excursion
                      (goto-char (scan-sexps (point) 1))
                      (skip-chars-forward "[ \t\n]")
                      (following-char)))))
        ;; Skip this function name if it is a prototype declaration.
	;; should still be recoded for neurospaces function prototypes.
	;; then I have to test on '^[ \t]*extern' ?
        (if (eq char ?\;)
            (fume-find-next-c-function-name buffer)
          (let (beg
                name)
            ;; Get the function name and position
            (forward-sexp -1)
            (setq beg (point))
            (forward-sexp)
            (setq name (buffer-substring beg (point)))
            ;; ghastly crock for DEFUN declarations
            (cond ((string-match "^DEFUN\\s-*" name)
                   (forward-word 1)
                   (forward-word -1)
                   (setq beg (point))
                   (cond ((re-search-forward "\"," nil t)
                          (re-search-backward "\"," nil t)
                          (setq name
                                (format "%s %s"
                                        name
                                        (buffer-substring beg (point))))))))
            ;; kludge to avoid `void' etc in menu
            (if (string-match
                "\\`\\(void\\|if\\|else if\\|else\\|switch\\|for\\|while\\)\\'"
		name)
                (fume-find-next-c-function-name buffer)
              (cons name beg)))))))

; (buffer)
;  "Searches for the next neurospaces function in BUFFER."
;  (set-buffer buffer)
;  (if (re-search-forward fume-function-name-regexp-neurospaces nil t)
;      (let ((beg (match-beginning fume-function-name-regexp-neurospaces))
;            (end (match-end fume-function-name-regexp-neurospaces)))
;        (cons (buffer-substring beg end) beg))))

;; add function parser for neurospaces mode
(setq fume-find-function-name-method-alist
      (append '((neurospaces-mode    . fume-find-next-neurospaces-function-name))
              fume-find-function-name-method-alist))



(provide 'neurospaces-vars)
;;; neurospaces-vars.el ends here
