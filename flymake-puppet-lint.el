;;; A flymake handler for puppet manifests
;;;
;;; Author: Stig Sandbeck Mathisen <ssm@fnord.no>
;;;
;;; Homepage: http://fnord.no/
;;;
;;; Usage:
;;;   (require 'flymake-puppet-lint)
;;;   (add-hook 'puppet-mode-hook 'flymake-puppet-lint-load)

(require 'flymake)

(defvar flymake-puppet-lint-allowed-file-name-masks '(("\\.pp$" flymake-puppet-lint-init)))

(defvar flymake-puppet-lint-executable "puppet-lint")

(defvar flymake-puppet-lint-err-line-patterns
  '((".+: \\(.+\\):\\([0-9]+\\) \\(.+\\)" 1 2 nil 3)))

(defun flymake-puppet-lint-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "puppet-lint"
          (list "--fail-on-warnings"
                "--no-inherits_across_namespaces-check"
                "--no-2sp_soft_tabs-check"
                "--no-80chars-check"
                "--no-autoloader_layout-check"
                "--log-format"
                "%{kind}: %{filename}:%{linenumber} %{message}"
                local-file))))

(defun flymake-puppet-lint-load ()
  (interactive)
  (set (make-local-variable 'flymake-allowed-file-name-masks)
       flymake-puppet-lint-allowed-file-name-masks)
  (set (make-local-variable 'flymake-err-line-patterns)
       flymake-puppet-lint-err-line-patterns)
  (if (executable-find flymake-puppet-lint-executable)
      (flymake-mode t)
    (message "not emabling flymake: executable '%s' not found"
             flymake-puppet-lint-executable)))
(provide 'flymake-puppet-lint)
