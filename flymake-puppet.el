;;; A flymake handler for puppet manifests
;;;
;;; Author: Stig Sandbeck Mathisen <ssm@fnord.no>
;;;
;;; Homepage: http://fnord.no/
;;;
;;; Usage:
;;;   (require 'flymake-puppet)
;;;   (add-hook 'puppet-mode-hook 'flymake-puppet-load)

(require 'flymake)

(defvar flymake-puppet-allowed-file-name-masks '(("\\.pp$" flymake-puppet-init)))

(defvar flymake-puppet-executable "puppet")

(defvar flymake-puppet-err-line-patterns
  '(("err: Could not parse for environment .+: \\(.+\\) at \\(.+\\):\\([0-9]+\\)" 2 3 nil 1)))

(defun flymake-puppet-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "puppet" (list "parser" "validate" local-file))))

(defun flymake-puppet-load ()
  (interactive)
  (set (make-local-variable 'flymake-allowed-file-name-masks)
       flymake-puppet-allowed-file-name-masks)
  (set (make-local-variable 'flymake-err-line-patterns)
       flymake-puppet-err-line-patterns)
  (if (executable-find flymake-puppet-executable)
      (flymake-mode t)
    (message "not emabling flymake: executable '%s' not found"
             flymake-puppet-executable)))

(provide 'flymake-puppet)
