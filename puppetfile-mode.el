;;; puppetfile-mode.el --- Syntax highlighting for Puppetfiles
;;;
;;; Copyright (c) 2013 Stig Sandbeck Mathisen <ssm@fnord.no>
;;; All rights reserved.
;;;
;;; Author: Stig Sandbeck Mathisen <ssm@fnord.no>
;;; Version: 0.2
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above
;;;    copyright notice, this list of conditions and the following
;;;    disclaimer in the documentation and/or other materials provided
;;;    with the distribution.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
;;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
;;; TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;;; PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR
;;; CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
;;; LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
;;; USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
;;; AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;;; ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;; POSSIBILITY OF SUCH DAMAGE.
;;;

(defgroup puppetfile nil
  "Customizations for puppetfile-mode"
  :group 'data)

(defcustom puppetfile-indent-level 2
  "*The level of indentation (number of space characters) in puppetfile-mode."
  :type 'integer  :group 'puppetfile)

(defcustom puppetfile-indent-tabs-mode nil
  "*Allow tabs when indentation in puppetfile-mode if non-nil"
  :type 'boolean :group 'puppetfile)

;; I just love standards, there are so many to choose from
(if (string-match "XEmacs\\|Lucid" emacs-version)
    (require 'generic-mode)
  (require 'generic))

;; Add a Puppetfile major mode called "puppetfile-mode", based on generic-mode

;;;###autoload
(define-generic-mode 'puppetfile-mode
  '("#")
  '("mod" "forge")
  (list
   '("'[^']*'" . font-lock-string-face)
   '(":[a-z]+" . font-lock-variable-name-face)
   )
  '("^Puppetfile$")
  (list 'puppetfile-mode-setup-function)
  "Major mode for editing Puppetfile")

;;;###autoload(add-to-list 'auto-mode-alist '("Puppetfile\\'" . puppetfile-mode))

(defun puppetfile-mode-setup-function ()
  (run-hooks 'puppetfile-mode-hook)
  (set (make-local-variable 'indent-line-function) 'puppetfile-indent-line)
  (setq indent-tabs-mode puppetfile-indent-tabs-mode))

(defvar puppetfile-mode-hook nil)

(defun puppetfile-indent-line ()
  "Indent the current Puppetfile line according to syntax."
  (interactive)
  (indent-line-to
   (max (puppetfile-calculate-indentation) 0)))


;; The function to calculate indentation level. This is a rather
;; simple and naive function, and does not perform anything like a
;; syntax check.
(defun puppetfile-calculate-indentation ()
  "Return the column to which the current line should be indented."
  (interactive)
  (save-excursion
                                        ; Do not indent the first line.
    (if (puppetfile-first-line-p) 0
                                        ; Increase indent level if a
                                        ; block opened on the previous
                                        ; line
      (if (puppetfile-empty-line-p) 0
        (if (puppetfile-inside-statement-p)
            puppetfile-indent-level
                                        ; By default, indent to the
                                        ; level of the previous
                                        ; non-empty line
          0)))))

(defun puppetfile-inside-statement-p ()
  "Check if this is a continuing statement. Returns t if the last
interesting character is a comma, while ignoring comments and
whitespace."
  (interactive)
  (save-excursion
    (previous-line)
    (beginning-of-line)
    (if (looking-at "[[:space:]]*\\(#\\|$\\)")
        (puppetfile-inside-statement-p)
      (looking-at ".*,[[:space:]]*\\(#.*\\)?$"))))

(defun puppetfile-empty-line-p ()
  "Check if this is an empty line"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (looking-at "[[:space:]]*$")))

(defun puppetfile-first-line-p ()
  "Check if we are on the first line."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (eq (point) 1)))

(provide 'puppetfile-mode)
;;; puppetfile-mode.el ends here
