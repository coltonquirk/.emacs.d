;; -*- lexical-binding: t; -*-

(setq frame-inhibit-implied-resize t) ;; prevent resize window on startup
;; (setq default-frame-alist '((width . 80) (height . 44)))

(setq custom-file "~/.emacs.d/custom.el")

(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; disable visible scrollbar
;; (tool-bar-mode -1)   ; disable the toolbar
;; (tooltip-mode -1)    ; disable tooltips
(set-fringe-mode 10) ; Give some breathing room

;; (menu-bar-mode -1)   ; Disable the menu bar

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Set up the visible bell
;; (setq visible-bell t)

(set-face-attribute 'default nil :font "JuliaMono Nerd Font" :height 140)

(setq catppuccin-flavor 'mocha) ;; 'latte, 'frappe, 'machiato, 'mocha
(load-theme 'catppuccin :no-confirm)

;; TODO relative line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
;; (setq global-display-line-numbers 'relative)

;; (pdf-tools-install) 
(pdf-loader-install) ;; On demand loading, leads to faster loading

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook
		vterm-mode-hook
		nov-mode-hook
		pdf-tools-mode-hook
		pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config

  (setq which-key-idle-delay 0.3))

;; Helpful
(use-package helpful
  :ensure t   ;; Not necessary with (always-ensure package thing below so maybe I do need it here)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; (use-package command-log-mode) ;; showing the keys pressed

;; Keymaps
;; (global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

;; How to define a key for a particular mode
;; (define-key emacs-lisp-mode-map (kbd "C-x M-t") 'counsel-load-theme)

(use-package company)

;; Useful completions for minibuffer?
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package all-the-icons)

;; DOOM
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package doom-themes)

;; General.el
;; Isolated place to define your own key bindings.
;; works with/needs evil mode active (I think because C-SPC is already bound
;; but is unbound in evil mode?)
(use-package general
  :config
  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (my/leader-keys
   "t" '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")))

;; EVIL >:-P
(defun my/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circe-server-mode
		  circe-chat-mode
		  circe-query-mode
		  sauron-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

;; TODO <ENTER> doesn't work to open a file in dired mode
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :hook (evil-mode . my/evil-hook)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; Do I need this one?
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions outsie of visual line mode buffers
  ;; OMG this is actually great, wish this was a thing in (neo)vim by default.
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
(require 'evil)

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Hydra - really fast keybindings
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :ext t))

(my/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code") ;; Where to check for projects? Need to change this.
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))  ;; load dired when switiching projects.

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Magit
(use-package magit
  :custom
  ;; Might get rid of this custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; evil-magit is now part of evil-collection
;; which I have above.
;; (use-package evil-magit
;;   :after magit)

;; TODO forge?

;; TYPST
(use-package typst-ts-mode
  :vc (:url "https://codeberg.org/meow_king/typst-ts-mode.git"))

(with-eval-after-load 'eglot
  (with-eval-after-load 'typst-ts-mode
    (add-to-list 'eglot-server-programs
		 `((typst-ts-mode) .
		   ,(eglot-alternatives `(,typst-ts-lsp-download-path
					  "tinymist"
					  "typst-lsp"))))))
(use-package websocket)
(use-package typst-preview
  :init
  (setq typst-preview-autostart t)
  (setq typst-preview-open-browser-automatically t)

  :custom
  (typst-preview-browser "default")
  (typst-preview-invert-colors "false")
  (typst-preview-executbale "tinymist")
  (typst-preview-partial-rendering t)

  :config
  (define-key typst-preview-mode-map (kbd "C-c C-j") 'typst-preview-send-position))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; JULIA
(use-package julia-ts-mode
  :ensure t
  :mode "\\.jl$")

(add-hook 'julia-mode-hook #'julia-vterm-mode)
(add-hook 'julia-mode-hook #'company-mode)
;; Start julia repl with all threads
(setq julia-vterm-repl-program "julia -t auto")
;; (use-package julia-repl)
;; (use-package julia-vterm)

;; Maybe get better unicode stuff.
(set-language-environment "UTF-8")


;; ORG
(require 'org)
(add-to-list 'org-babel-load-languages '(julia . t))
(add-to-list 'org-babel-load-languages '(julia-vterm . t))
(org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)

(defalias 'org-babel-execute:julia 'org-babel-execute:julia-vterm)
(defalias 'org-babel-variable-assignments:julia 'org-babel-variable-assignments:julia-vterm)

;; LaTeX Files
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(use-package reftex ; with AUCTeX LaTeX mode
  :hook (LaTeX-mode . turn-on-reftex))
(use-package reftex ; with Emacs latex mode
  :hook (latex-mode . turn-on-reftex))

(load-file custom-file)

