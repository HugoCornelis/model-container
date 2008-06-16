;;; neurospaces-mode.el --- specific language support for Neurospaces Mode

;; Copyright (C) 2005-2008 Hugo Cornelis

;; Authors:    2005-2008 Hugo Cornelis
;; Maintainer: Hugo Cornelis

;; How to use :
;;
;; 1. Put the files in the neurospaces mode package somewhere in your
;; homedirectory, e.g. in the directory
;; "~/neurospaces/emacs/neurospaces-mode/".
;;
;; 2. Put in your emacs initialization file :
;; (load-file "~/neurospaces/emacs/neurospaces-mode/neurospaces-vars.el")
;; (load-file "~/neurospaces/emacs/neurospaces-mode/neurospaces-langs.el")
;; (load-file "~/neurospaces/emacs/neurospaces-mode/neurospaces-mode.el")
;; (load-file "~/neurospaces/emacs/neurospaces-mode/neurospaces-files.el")
;;

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;(defconst c-version "5.20"
;  "CC Mode version number.")

;;; Commentary:

;; This package provides GNU Emacs major modes for editing Neurospaces
;; code.

;; NOTE: This mode does not perform font-locking (a.k.a syntactic
;; coloring, keyword highlighting, etc.) for any of the supported
;; modes.  Typically this is done by a package called font-lock.el
;; which I do *not* maintain.  You should contact the Emacs
;; maintainers for questions about coloring or highlighting in any
;; language mode.

;;; Code:

(eval-when-compile
  (require 'cc-defs))

;; sigh.  give in to the pressure, but make really sure all the
;; definitions we need are here
(if (or (not (fboundp 'functionp))
	(not (fboundp 'char-before))
	(not (c-safe (char-after) t))
	(not (fboundp 'when))
	(not (fboundp 'unless)))
    (require 'cc-mode-19))

(eval-when-compile
  (require 'cc-menus))

;(defvar c-buffer-is-cc-mode t
;  "Non-nil for all buffers with a `major-mode' derived from CC Mode.
;Otherwise, this variable is nil.  I.e. this variable is non-nil for
;`c-mode', `c++-mode', `objc-mode', `java-mode', `idl-mode', and any;other non-CC Mode mode that calls `c-initialize-cc-mode'
;\(e.g. `awk-mode').")
;(make-variable-buffer-local 'c-buffer-is-cc-mode)
;(put 'c-buffer-is-cc-mode 'permanent-local t)

;(defvar c-initialize-on-load t
;  "When non-nil, CC Mode initializes when the cc-mode.el file is loaded.")
  


;; Other modes and packages which depend on CC Mode should do the
;; following to make sure everything is loaded and available for their
;; use:

(require 'cc-mode)
(c-initialize-cc-mode)


;;;###autoload
(defun neurospaces-mode ()
  "Major mode for editing neurospaces scripts.

The hook variable `neurospaces-mode-hook' is run with no args, if that
variable is bound and has a non-nil value.  Also the hook
`c-mode-common-hook' is run first.

Key bindings:
\\{neurospaces-mode-map}"
  (interactive)
  (c-initialize-cc-mode)
  (kill-all-local-variables)
  (set-syntax-table neurospaces-mode-syntax-table)
  (setq major-mode 'neurospaces-mode
	mode-name "neurospaces"
	local-abbrev-table neurospaces-mode-abbrev-table)
  (use-local-map neurospaces-mode-map)
  (c-common-init)
  (setq comment-start "// "
	comment-end ""
	c-conditional-key c-C++-conditional-key
	c-comment-start-regexp c-C++-comment-start-regexp
	c-class-key c-C++-class-key
	c-access-key c-C++-access-key
	c-recognize-knr-p nil
;;	imenu-generic-expression cc-imenu-c++-generic-expression
;;	imenu-case-fold-search nil
	)
  (run-hooks 'c-mode-common-hook)
  (run-hooks 'neurospaces-mode-hook)
  (c-update-modeline))

(defvar neurospaces-font-lock-keywords (purecopy
  (list
   (concat "\\<\\("
	   "neurospaces\\|ndf\\|version\\|units\\|import\\|private_models\\|public_models"
	   "\\|NEUROSPACES\\|NDF\\|VERSION\\|UNITS\\|IMPORT\\|PRIVATE_MODELS\\|PUBLIC_MODELS"
	   "\\)\\>")
;   ("#endif" "#else" "#ifdef" "#ifndef" "#if" "#include" "#define" "#undef")
   (cons (concat "\\<\\("
		 "int\\|str\\|float"
		 "\\)\\>")
	 'font-lock-type-face)
   (cons (concat "\\<\\("

		 ;; use listactions, listclasses, listobjects

		 "projection"
		 "\\|connection"
		 "\\|connection"
		 "\\|contour_group"
		 "\\|contour_point"
		 "\\|em_contour"
		 "\\|network"
		 "\\|population"
		 "\\|cell"
		 "\\|fiber"
		 "\\|neuron"
		 "\\|randomvalue"
		 "\\|segment"
		 "\\|segment"
		 "\\|channel"
		 "\\|pool"
		 "\\|alpha"
		 "\\|exponential_equation"
		 "\\|hh_gate"
		 "\\|gate_kinetic_b"
		 "\\|gate_kinetic_a"
		 "\\|gate_kinetic_part"
		 "\\|concentration_gate_kinetic"

		 "\\|PROJECTION"
		 "\\|CONNECTION"
		 "\\|CONNECTION"
		 "\\|CONTOUR_GROUP"
		 "\\|CONTOUR_POINT"
		 "\\|EM_CONTOUR"
		 "\\|NETWORK"
		 "\\|POPULATION"
		 "\\|CELL"
		 "\\|FIBER"
		 "\\|NEURON"
		 "\\|RANDOMVALUE"
		 "\\|SEGMENT"
		 "\\|SEGMENT"
		 "\\|CHANNEL"
		 "\\|POOL"
		 "\\|ALPHA"
		 "\\|EXPONENTIAL_EQUATION"
		 "\\|HH_GATE"
		 "\\|GATE_KINETIC_B"
		 "\\|GATE_KINETIC_A"
		 "\\|GATE_KINETIC_PART"
		 "\\|CONCENTRATION_GATE_KINETIC"

		 "\\|SERIAL"
		 "\\|LOWER"
		 "\\|HIGHER"
		 "\\|MINIMUM"
		 "\\|MAXIMUM"
		 "\\|NEGATE"
		 "\\|MINUS"
		 "\\|DIVIDE"
		 "\\|TIME"
		 "\\|STEP"
		 "\\|FIXED"
		 "\\|randomize"
		 "\\|MGBLOCK"
		 "\\|NERNST"
		 "\\)\\>")
	 'font-lock-type-face)
   (cons (concat "\\<\\("

		 ;; use listcommands output instead

		 "units"
		 "\\|seconds"
		 "\\|meters"
		 "\\|voltage"
		 "\\|siemens"
		 "\\|file"
		 "\\|chantablefile"
		 "\\|end"

		 "\\|algorithm"
		 "\\|algorithm_instance"
		 "\\|group"
		 "\\|has"
		 "\\|child"
		 "\\|attachment_point"
		 "\\|generates"
		 "\\|receives"
		 "\\|events"
		 "\\|bindables"
		 "\\|bindings"
		 "\\|input"
		 "\\|output"
		 "\\|alias"
		 "\\|attributes"
		 "\\|parameter"
		 "\\|parameters"
		 "\\|options"
		 "\\|spherical"
		 "\\|cylindrical"
		 "\\|absolute"
		 "\\|relative"

		 "\\|UNITS"
		 "\\|SECONDS"
		 "\\|METERS"
		 "\\|VOLTAGE"
		 "\\|SIEMENS"
		 "\\|FILE"
		 "\\|CHANTABLEFILE"
		 "\\|END"

		 "\\|ALGORITHM"
		 "\\|ALGORITHM_INSTANCE"
		 "\\|GROUP"
		 "\\|HAS"
		 "\\|CHILD"
		 "\\|ATTACHMENT_POINT"
		 "\\|GENERATES"
		 "\\|RECEIVES"
		 "\\|EVENTS"
		 "\\|BINDABLES"
		 "\\|BINDINGS"
		 "\\|INPUT"
		 "\\|OUTPUT"
		 "\\|ALIAS"
		 "\\|ATTRIBUTES"
		 "\\|PARAMETER"
		 "\\|PARAMETERS"
		 "\\|OPTIONS"
		 "\\|SPHERICAL"
		 "\\|CYLINDRICAL"
		 "\\|ABSOLUTE"
		 "\\|RELATIVE"

		 "\\)\\>")
	 'font-lock-builtin-face)
   (cons (concat "#\\(|e\\(lse\\|ndif\\)\\|"
		 "i\\(f\\(\\|def\\|ndef\\)\\|nclude\\)\\|undef\\)\\>")
	 'font-lock-keyword-face)
   '("^[ \n\t]*\\(function\\|extern\\)[ \t]+\\([^ \t]+\\)" 1 font-lock-function-name-face)
   '("\\(--- .* ---\\|=== .* ===\\)" . font-lock-string-face)
   ))
  "Additional expressions to highlight in Neurospaces mode.")

(put 'neurospaces-mode 'font-lock-defaults '(neurospaces-font-lock-keywords))

(provide 'neurospaces-mode)
