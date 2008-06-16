;;; neurospaces-files.el --- Bind specific file types to the Neurospaces mode.

;; Copyright (C) 2005-2008 Hugo Cornelis

;; Authors:    2005-2008 Hugo Cornelis
;; Maintainer: Hugo Cornelis

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; recognise .ndf files as neurospaces files
(setq auto-mode-alist
      (append '(
                ("\\.ndf$" . neurospaces-mode))
              auto-mode-alist))

;; recognise .p files as c++ files
(setq auto-mode-alist
      (append '(
                ("\\.p$" . c++-mode))
              auto-mode-alist))

;; configure function menu for neurospaces mode
(defvar fume-function-name-regexp-neurospaces
  "^\\(function\\|extern\\)[ \t]+\\([_a-zA-Z][_a-zA-Z0-9]*\\)"
  "Expression to get function/extern names in Neurospaces scripts.")

(setq fume-function-name-regexp-alist
      (append '((neurospaces-mode . fume-function-name-regexp-neurospaces))
              fume-function-name-regexp-alist))

;; Find next neurospaces function in the buffer, derived from pascal version.
;; Hugo Cornelis <hugo.cornelis@gmail.com>
;;
(defun fume-find-next-neurospaces-function-name (buffer)
  "Search for the next Neurospaces function in BUFFER."
  (set-buffer buffer)
  (if (re-search-forward fume-function-name-regexp-neurospaces nil t)
      (let ((beg (match-beginning 2))
            (end (match-end 2)))
        (cons (buffer-substring beg end) beg))))

(setq fume-find-function-name-method-alist
      (append '((neurospaces-mode . fume-find-next-neurospaces-function-name))
              fume-find-function-name-method-alist))


