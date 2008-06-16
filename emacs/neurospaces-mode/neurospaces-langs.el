;;; neurospaces-langs.el --- specific language support for Neurospaces Mode

;; Copyright (C) 2005-2008 Hugo Cornelis

;; Authors:    2005-2008 Hugo Cornelis
;; Maintainer: Hugo Cornelis

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(require 'cc-mode)


;; Support for neurospaces description files

(defvar neurospaces-mode-abbrev-table nil
  "Abbreviation table used in neurospaces-mode buffers.")
(define-abbrev-table 'neurospaces-mode-abbrev-table ())

(defvar neurospaces-mode-map ()
  "Keymap used in neurospaces-mode buffers.")
;;(if neurospaces-mode-map
;;    nil
;;  (setq neurospaces-mode-map (c-make-inherited-keymap))
;; ;; add bindings which are only useful for neurospaces mode
;;  )
(if neurospaces-mode-map ()
  (setq neurospaces-mode-map (make-sparse-keymap))
  (set-keymap-name neurospaces-mode-map 'neurospaces-mode-map)
;;  (define-key neurospaces-mode-map "\e\t" 'ispell-complete-word)
  (define-key neurospaces-mode-map "\t" 'tab-to-tab-stop)
;;  (define-key neurospaces-mode-map "\es" 'center-line)
;;  (define-key neurospaces-mode-map "\eS" 'center-paragraph)
  )




;;;###autoload
(defvar neurospaces-mode-syntax-table nil
  "Syntax table used in neurospaces-mode buffers.")
(if neurospaces-mode-syntax-table
    nil
  (setq neurospaces-mode-syntax-table (make-syntax-table))
  (c-populate-syntax-table neurospaces-mode-syntax-table)
  )

(easy-menu-define c-neurospaces-menu neurospaces-mode-map "Neurospaces Mode Commands"
		  (c-mode-menu "Neurospaces"))



(provide 'neurospaces-langs)
;;; neurospaces-langs.el ends here
