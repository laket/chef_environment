(setq inhibit-splash-screen t) 
(setq inhibit-startup-message t)
(setq-default tab-width 4 indent-tabs-mode nil)
(put 'scroll-left 'disabled nil)

;;; emacs-basic
(setq default-load-path load-path)
(setq my-load-path (list (expand-file-name "~/.emacs.d/")))
(setq load-path (append my-load-path default-load-path))

;Disable limit
(put 'set-goal-column 'disabled nil)

;; ibus
;(setq ibus-cursor-color '("red" "blue" "limegreen"))


;;; view
(show-paren-mode)
(linum-mode)

(set-default-font "Inconsolata-11")
(set-face-font 'variable-pitch "Inconsolata-11")
(set-fontset-font (frame-parameter nil 'font)
		  'japanese-jisx0208
		  '("Takaoゴシック" . "unicode-bmp"))

(if window-system (progn
(set-face-foreground 'font-lock-comment-face "MediumSeaGreen")
(set-face-foreground 'font-lock-string-face  "purple")
(set-face-foreground 'font-lock-keyword-face "blue")
(set-face-foreground 'font-lock-function-name-face "blue")
(set-face-bold-p 'font-lock-function-name-face t)
(set-face-foreground 'font-lock-variable-name-face "black")
(set-face-foreground 'font-lock-type-face "LightSeaGreen")
(set-face-foreground 'font-lock-builtin-face "purple")
(set-face-foreground 'font-lock-constant-face "black")
(set-face-foreground 'font-lock-warning-face "blue")
(set-face-bold-p 'font-lock-warning-face nil)
))


(setq initial-frame-alist (append (list '(cursor-coloro . "purple")
                                        '(width .  80)
                                        '(height . 40)
					;'(left . -10)
					;'(top 10))
                                        )
                                  initial-frame-alist))


;auto complete
(require 'auto-complete)
(global-auto-complete-mode t)
(setq ac-sources '(ac-source-words-in-buffer ac-source-abbrev))

;各言語用の設定
;(load-file "~/.emacs.d/local.el")
(load-file "~/.emacs.d/my-key-bind.el")
(load-file "~/.emacs.d/my-cpp.el")

