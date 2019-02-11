;;; switch-buffer-hook.el --- Switch buffer hook

;; Copyright (C) 2019 yonggang.yyg <yygcode@gmail.com>

;; Author: yonggang.yyg <yygcode@gmail.com>
;; URL: https://github.com/yygcode/switch-buffer-hook
;; Package-Version: 1.0.0
;; Version: 1.0.0

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This package implements switch-buffer-hook depends on
;; `buffer-list-update-hook'.

;;; Installation

;; To use this hook, put the following in your init.el:
;; (require 'switch-buffer-hook.el)
;; (switch-buffer-hook-enable)

;; You can remove the hook by
;; (switch-buffer-hook-enable -1)

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING, if not see
;; <http://www.gnu.org/licenses/>.

;;; Code:

(defvar switch-buffer-hook nil
  "Normal hook run after buffer switched.
The hook prototype is HOOK-FUNC(CURRENT-BUFFER PREVIOUS-BUFFER).")

(defvar switch-buffer-hook--last-buffer nil
  "Last visible buffer in current window of current frame.")

(defun switch-buffer-hook--function()
  "Run `switch-buffer-hook' if needed."
  ;; (message "%s: cur=%s win=%s last=%s savelast=%s" (time-to-seconds)
  ;;          (current-buffer) (window-buffer)
  ;;          (last-buffer) switch-buffer-hook--last-buffer)
  (let ((cur (window-buffer))
        (prev (frame-parameter nil 'switch-buffer-hook--last-buffer)))
    (unless (eq cur prev)
      (set-frame-parameter nil 'switch-buffer-hook--last-buffer cur)
      (run-hook-with-args 'switch-buffer-hook cur prev))))

(define-minor-mode switch-buffer-hook-mode
  "Toggle switch buffer hook.
With a prefix argument ARG, enable switch-buffer-hook if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil."
  :init-value t
  :lighter " Switch-buffer-hook"
  :group 'switch-buffer-hook
  :global t
  (remove-hook 'buffer-list-update-hook #'switch-buffer-hook--function)
  (when switch-buffer-hook-mode
    (add-hook 'buffer-list-update-hook #'switch-buffer-hook--function)))

(provide 'switch-buffer-hook)

;;; switch-buffer-hook.el ends here
