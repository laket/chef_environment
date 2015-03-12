(add-to-list 'load-path (locate-user-emacs-file "rust-mode"))
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

(setq racer-rust-src-path "<%= @rustc_srcdir  =>")
(setq racer-cmd "<%= @racer_cmd_path  =>")
(add-to-list 'load-path "<%= @racer_editors =>")
;(eval-after-load "rust-mode" '(require 'racer))
