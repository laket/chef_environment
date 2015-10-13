; for gomode
(require 'eldoc)
(require 'go-mode-load)

(add-hook 'before-save-hook 'gofmt-before-save)
(require 'go-autocomplete)
(require 'auto-complete-config)
(require 'go-eldoc)

(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'go-mode-hook
          '(lambda()
            (setq c-basic-offset 4)
            (setq indent-tabs-mode t)
            (local-set-key (kbd "M-.") 'godef-jump)
            (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
            (local-set-key (kbd "C-c i") 'go-goto-imports)
            (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
            (local-set-key (kbd "C-c C-d") 'godoc)))
