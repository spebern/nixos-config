;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Bernhard Specht"
      user-mail-address "bernhard@specht.net"

      display-line-numbers-type nil)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Source Code Pro" :size 13))
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Nextcloud/org/")

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; rust
(after! rustic
  (setq lsp-rust-analyzer-cargo-watch-command "clippy")
  (setq lsp-rust-analyzer-cargo-load-out-dirs-from-check t)
  (setq lsp-rust-analyzer-proc-macro-enable t)
                                        ;  (setq lsp-rust-analyzer-display-chaining-hints t)
                                        ;  (setq lsp-rust-analyzer-display-parameter-hints t)
                                        ;  (setq lsp-rust-analyzer-server-display-inlay-hints t)
  (setq lsp-rust-all-features t)
  (setq lsp-rust-full-docs t))

(setq org-journal-encrypt-journal t)
(setq org-journal-dir "~/Nextcloud/org")

(setq +latex-viewers '(zathura))
(setq latex-preview-pane-use-frame t)

(add-hook 'vue-mode-local-vars-hook #'lsp!)

(use-package! vue-mode
  :ensure t)

(use-package! vue-html-mode
  :mode ("/\\.vue$"))

(use-package! cperl-mode
  :mode ("/\\.pm$" "/\\.pl$" "/\\.t$"))

(eval-after-load "org"
  '(require 'ox-confluence nil t))

(use-package! protobuf-mode)

(setq-default org-download-image-dir "~/Nextcloud/org/images")
(setq-default org-roam-directory "~/Nextcloud/org")

(setq-hook! 'vue-mode-hook +format-with-lsp nil)

;; org babel http
(use-package! ob-http)

(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))

(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
    (shell-command-to-string "wl-paste -n")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred

(after! rustic
  (set-popup-rule! "^\\*cargo" :size 0.5))
(setq rustic-cargo-test-disable-warnings t)

(setq! citar-bibliography '("~/Nextcloud/references.bib"))


(setq org-image-actual-width (list 550))
(setq leetcode-prefer-language "python3")
(setq leetcode-prefer-sql "mysql")
(setq leetcode-save-solutions t)
(setq leetcode-directory "~/leetcode")
(add-hook 'leetcode-solution-mode-hook
          (lambda() (flycheck-mode -1)))

(after! go-mode
  (setq gofmt-command "goimports")
  (add-hook 'go-mode-hook
            (lambda ()
              (add-hook 'after-save-hook 'gofmt nil 'make-it-local))))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))

(use-package! org-modern
  :hook (org-mode . global-org-modern-mode)
  :config
  (setq org-modern-label-border 0.3))

(setq bookmark-default-file "~/Nextcloud/bookmarks")

(load! "+bindings.el")
