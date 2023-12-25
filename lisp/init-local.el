;;; init-local.el -- ngn999's custom settings
;;; Commentary:
;;; Code:

;;; desktop
(desktop-save-mode -1)

;;; theme
(require-package 'modus-themes)
;;; For packaged versions which must use `require'.
(use-package modus-themes
  :ensure t
  :config
  (require 'modus-themes)
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil)

  ;; Maybe define some palette overrides, such as by using our presets
  (setq modus-themes-common-palette-overridesa
        modus-themes-preset-overrides-intense)

  ;; Load the theme of your choice.
  ;; (load-theme 'modus-operandi)
  ;; for purcell, modus-operandi is the project’s main light theme, while modus-vivendi is its dark counterpart.
  (setq custom-enabled-themes '(modus-vivendi))
  (define-key global-map (kbd "<f5>") #'modus-themes-toggle))

;; (use-package project
;;   :custom
;;   (project-vc-ignores '(".DS_Store" "*.elc" "node_modules" "venv" ".venv")))

;;; Org
(use-package org
  :config
  (setq org-directory "~/Library/CloudStorage/Dropbox/org/roam/")
  (setq org-agenda-files '("~/Library/CloudStorage/Dropbox/org/todo/" "~/Library/CloudStorage/Dropbox/org/roam/"))
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  ;; (setq org-preview-latex-process-alist
  ;;       '((dvipng :programs
  ;;                 ("latex" "dvipng")
  ;;                 :description "dvi > png"
  ;;                 :message "you need to install the programs: latex and dvipng."
  ;;                 :image-input-type "dvi"
  ;;                 :image-output-type "png"
  ;;                 :image-size-adjust (1.0 . 1.0)
  ;;                 :latex-compiler ("latex -interaction nonstopmode -output-directory %o $(readlink -f %f)")
  ;;                 :image-converter ("dvipng -D %D -T tight -o %O $(readlink -f %f)")
  ;;                 :transparent-image-converter ("dvipng -D %D -T tight -bg Transparent -o %O $(readlink -f %f)"))))
  )

(use-package calendar
  :config
  (setq calendar-week-start-day 1))

;;;; Font
(set-face-attribute 'default nil :font "Monaco 14")
;; (set-frame-font "Monaco 14" nil t)
;;; set Chinese font
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font) charset
                    (font-spec :family "LXGW WenKai Mono" :size 15)))

;;; Some functionality uses this to identify you, e.g. GPG configuration, email
;;; clients, file templates and snippets.
(setq user-full-name "ngn999"
      user-mail-address "ngn998@gmail.com")

;;; fill-column
(setq-default fill-column 120)

;; `M-x combobulate' (default: `C-c o o') to start using Combobulate
(use-package treesit
  :preface
  (defun mp-setup-install-grammars ()
    "Install Tree-sitter grammars if they are absent."
    (interactive)
    (dolist (grammar
             ;;; txs/src is path for parser.c
             '((css "https://github.com/tree-sitter/tree-sitter-css")
               (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
               (json "https://github.com/tree-sitter/tree-sitter-json")
               (python "https://github.com/tree-sitter/tree-sitter-python")
               (haskell "https://github.com/tree-sitter/tree-sitter-haskell")
               (rust "https://github.com/tree-sitter/tree-sitter-rust")
               (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
               (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
      (add-to-list 'treesit-language-source-alist grammar)
      ;; Only install `grammar' if we don't already have it
      ;; installed. However, if you want to *update* a grammar then
      ;; this obviously prevents that from happening.
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar)))))

  ;; Optional, but recommended. Tree-sitter enabled major modes are
  ;; distinct from their ordinary counterparts.
  ;;
  ;; You can remap major modes with `major-mode-remap-alist'. Note
  ;; that this does *not* extend to hooks! Make sure you migrate them
  ;; also
  (dolist (mapping '((python-mode . python-ts-mode)
                     (css-mode . css-ts-mode)
                     (typescript-mode . tsx-ts-mode)
                     (js-mode . js-ts-mode)
                     (css-mode . css-ts-mode)
                     (rust-mode . rust-ts-mode)
                     (json-mode . json-ts-mode)
                     (yaml-mode . yaml-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping))

  :config
  (mp-setup-install-grammars)
  ;; Do not forget to customize Combobulate to your liking:
  ;;
  ;;  M-x customize-group RET combobulate RET
  ;;
  ;; (use-package combobulate
  ;;   :preface
  ;;   ;; You can customize Combobulate's key prefix here.
  ;;   ;; Note that you may have to restart Emacs for this to take effect!
  ;;   (setq combobulate-key-prefix "C-c o")

  ;;   ;; Optional, but recommended.
  ;;   ;;
  ;;   ;; You can manually enable Combobulate with `M-x
  ;;   ;; combobulate-mode'.
  ;;   :hook ((python-ts-mode . combobulate-mode)
  ;;          (js-ts-mode . combobulate-mode)
  ;;          (css-ts-mode . combobulate-mode)
  ;;          (yaml-ts-mode . combobulate-mode)
  ;;          (typescript-ts-mode . combobulate-mode)
  ;;          (tsx-ts-mode . combobulate-mode))
  ;;   ;; Amend this to the directory where you keep Combobulate's source
  ;;   ;; code.
  ;;   :load-path ("~/.emacs.d/site-lisp/combobulate/"))
  )

;; Configure directory extension.
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; orderless
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;; python
(defun my-python-mode-setup ()
  "Here you should set the value of `flymake-diagnostic-functions'
to a list that contains only the Pyright diagnostic function.
  The exact name of this function will depend on your setup and
  how you've installed Pyright. This is just a placeholder."
  (setq-local flymake-diagnostic-functions '(pyright-diagnostic-function)))
(add-hook 'python-mode-hook 'my-python-mode-setup)
(add-hook 'python-ts-mode-hook 'my-python-mode-setup)

;;; json-mode
(use-package json-mode)

;; ;;; anki editor
;; (use-package anki-editor
;;   :load-path ("~/.emacs.d/site-lisp/anki-editor/"))

;; (require-package 'anki-editor-view)
;; (use-package anki-editor-view
;;   :config
;;   (setq anki-editor-view-files (list org-directory)))

;; (require-package 'breadcrumb)
;; (use-package breadcrumb
;;   :ensure t
;;   :init
;;   (setq-default mode-line-format
;;                 (append mode-line-format
;;                         '((:eval (breadcrumb-imenu-crumbs))))))

;;; hledger
(require-package 'hledger-mode)
(use-package hledger-mode
  :mode ("\\.journal\\'" "\\.hledger\\'")
  :bind (("C-c j" . hledger-run-command)
         :map hledger-mode-map
         ("C-c e" . hledger-jentry)
         ("M-p" . hledger/prev-entry)
         ("M-n" . hledger/next-entry))
  :init
  (setq hledger-jfile
        (expand-file-name "~/.2023.hledger")))

(require-package 'flymake-hledger)
(use-package flymake-hledger
  :after (ledger-mode flymake hledger-mode)
  :hook (
         (ledger-mode . flymake-hledger-enable)
         ;; Make C-x ` work ?
         ;; XXX Both of these work only in the first file opened; debugging needed.
         ;; (ledger-mode . (lambda () (setq next-error-function 'flymake-goto-next-error)))
         ;; (ledger-mode . (lambda () (setq next-error-function (lambda (num reset) (when reset (goto-char (point-min))) (flymake-goto-next-error num)))))
         )

  :custom
  ;; (flymake-show-diagnostics-at-end-of-line t) ; might require Emacs 30
  (flymake-suppress-zero-counters t)
  (flymake-hledger-checks '("accounts" "commodities" "balancednoautoconversion" "ordereddates")) ; "recentassertions" "payees" "tags" "uniqueleafnames" https://hledger.org/hledger.html#check
  )

;;; solidity
(require-package 'solidity-flycheck)
(require-package 'company-solidity)
(require-package 'solidity-mode)
(use-package solidity
  :custom
  (solidity-comment-style 'slash "we all love slash style")
  :bind
  (("C-c C-g" . solidity-estimate-gas-at-point)))

(use-package company
  :ensure t
  :hook (solidity-mode . my-solidity-mode-setup))
(defun my-solidity-mode-setup ()
  (company-mode t)
  (setq-local company-backends '((company-solidity company-capf company-dabbrev-code))))
(use-package solidity-flycheck
  :after (solidity-mode flymake)
  :config
  (setq solidity-flycheck-solc-checker-active t))


(provide 'init-local)
;;; init-local.el ends here
