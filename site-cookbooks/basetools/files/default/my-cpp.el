(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-style "k&r")  
            (setq c-basic-offset 4)
            (setq indent-tabs-mode nil)
            (c-set-offset 'statement-cont 'c-lineup-math)
            )) 

