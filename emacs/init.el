;;; init.el -*- lexical-binding: t -*-
;; Repo-guided Emacs profile: latest-git build, Evil + Org + PKM.

;;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t
      use-package-always-defer t)

;;; Performance baseline
(setq read-process-output-max (* 4 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1)))

(use-package gcmh
  :demand t
  :config
  (gcmh-mode 1)
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 64 1024 1024)))

;;; Core defaults
(use-package emacs
  :straight (:type built-in)
  :demand t
  :init
  (setq inhibit-startup-message t
        initial-scratch-message nil
        ring-bell-function 'ignore
        use-short-answers t
        make-backup-files nil
        auto-save-default nil
        create-lockfiles nil
        use-dialog-box nil
        scroll-margin 8
        scroll-conservatively 101
        scroll-preserve-screen-position t)
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (global-display-line-numbers-mode 1)
  (setq display-line-numbers-type 'relative)
  (column-number-mode 1)
  (global-auto-revert-mode 1)
  (set-face-attribute 'default nil :family "Terminus" :height 140))

;;; Theme
(use-package gruvbox-theme
  :demand t
  :config
  (load-theme 'gruvbox-dark-hard t))

;;; Evil
(use-package evil
  :demand t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-split-window-below t
        evil-vsplit-window-right t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :demand t
  :config
  (evil-collection-init))

;;; Completion stack
(use-package vertico
  :demand t
  :init
  (vertico-mode 1))

(use-package orderless
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :demand t
  :init
  (marginalia-mode 1))

(use-package consult
  :demand t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-s r" . consult-ripgrep)
         ("M-g g" . consult-goto-line)))

(use-package corfu
  :demand t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  :init
  (global-corfu-mode 1))

(use-package which-key
  :demand t
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.3))

;;; Org + PKM
(use-package org
  :straight (:type built-in)
  :hook (org-mode . visual-line-mode)
  :config
  (setq org-directory "~/org"
        org-default-notes-file "~/org/inbox.org"
        org-agenda-files '("~/org/inbox.org" "~/org/todo.org" "~/org/projects.org")
        org-log-done 'time
        org-return-follows-link t
        org-confirm-babel-evaluate nil))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package org-roam
  :custom
  (org-roam-directory "~/org/roam")
  (org-roam-database-connector 'sqlite-builtin)
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture))
  :config
  (org-roam-db-autosync-mode 1))

;;; Daemon-first workflow
(use-package server
  :straight (:type built-in)
  :config
  (unless (server-running-p)
    (server-start)))
