;Key Bind
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key [?\C-.] 'goto-line)

(global-set-key "\C-x\C-q" '(lambda ()
			      (interactive)
			    (other-window -1)
			    (delete-window)))

(global-set-key "\C-x\C-h"
  (lambda ()
    (interactive)
    (enlarge-window 1 )
    )
  )
(global-set-key "\C-x\C-l"
  (lambda ()
    (interactive)
    (enlarge-window -1 )
    )
  )

;(global-set-key "\C-j" 'anything)
(global-set-key "\C-o" 'auto-complete-mode)

(define-key ac-complete-mode-map "\t" 'ac-expand)
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)

;; M-p/M-n で警告/エラー行の移動
(global-set-key "\M-p" 'flymake-goto-prev-error)
(global-set-key "\M-n" 'flymake-goto-next-error)
(global-set-key [?\C-;] 'flymake-show-and-sit)

(add-hook 'python-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c h") 'hohe2-lookup-pydoc)))
