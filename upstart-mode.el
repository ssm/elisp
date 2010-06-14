;;; upstart-mode.el - Syntax highlighting for upstart
;;;
;;; Copyright © 2010 Stig Sandbeck Mathisen <ssm@debian.org>
;;; All rights reserved.

;;; This program is free software: you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.

;;; Required: Copy this file to your load path, and add the following
;;; statement to your emacs init file (typically ~/.emacs)
;;
;; (require 'upstart-mode)

;;; Optional: Add MMM-mode for highlighting the embedded shell scripts
;;; inside the script blocks (Note: indentation does not work inside
;;; the mmm blocks.  Any assistance would be welcome.
;;
;; (require 'mmm-auto)
;; (setq mmm-global-mode 'maybe)
;; (mmm-add-classes
;;  '((upstart-sh
;;     :submode sh-mode
;;     :face mmm-submode-decoration-level "code"
;;     :front "^\\(\\(pre\\|post\\)-\\(start\\|stop\\) \\)?script"
;;     :front-offset (end-of-line 1)
;;     :back "end script"
;;     :end-not-begin t)))
;; (mmm-add-mode-ext-class 'upstart-mode nil 'upstart-sh)


;; I just love standards, there are so many to choose from
(if (string-match "XEmacs\\|Lucid" emacs-version)
    (require 'generic-mode)
  (require 'generic))

;; Add a major mode called "upstart mode", based on generic-mode
(define-generic-mode 'upstart-mode
  '("#")  ; comments
  '(;; Event definition
    "start on" "stop on" "and" "or"
    ;; Job environment
    "env" "export"
    ;; Services tasks and respawning
    "task" "respawn" "respawn limit" "normal exit"
    ;; Instances
    "instance"
    ;; Process environment
    "console output" "console owner" "umask" "nice" "oom" "chroot"
    "chdir" "limit"
    ;; Documentation
    "description" "author" "version" "emits"
    ;; Miscellaneois
    "kill timeout" "expect stop" "expect daemon" "expect fork"
    ;; Process definitions
    "exec" "script" "end script"
    "pre-start exec" "pre-start script"
    "post-start exec" "post-start script"
    "pre-stop exec" "pre-stop script"
    "post-stop exec" "post-stop script")
  nil
  '("\\.upstart$")
  nil
  "A mode for upstart files")

(provide 'upstart-mode)
