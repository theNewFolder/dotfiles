# Emacs configuration

{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;  # Emacs 30 with pure GTK (better Wayland support)

    extraPackages = epkgs: with epkgs; [
      # Essential
      use-package

      # Evil (Vim emulation)
      evil
      evil-collection
      evil-surround
      evil-commentary

      # Org-mode (built-in, but ensure org-roam deps)
      org
      org-roam
      org-roam-ui

      # Completion
      vertico
      consult
      marginalia
      orderless
      corfu
      cape

      # Git
      magit
      forge
      git-gutter

      # UI
      gruvbox-theme
      doom-modeline
      all-the-icons
      rainbow-delimiters
      which-key

      # LSP
      lsp-mode
      lsp-ui
      company

      # Languages
      nix-mode
      markdown-mode
      yaml-mode
      json-mode

      # AI tools
      gptel

      # Utilities
      projectile
      treemacs
      treemacs-evil
      helpful
      undo-tree
    ];
  };

  # Emacs daemon service
  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
  };

  # Create initial Emacs config if it doesn't exist
  # You can expand this into a full literate config later
  home.file.".emacs.d/init.el".text = ''
    ;;; init.el --- Emacs configuration -*- lexical-binding: t -*-
    ;;; Commentary:
    ;;; Minimal Emacs config for NixOS with Evil and Org-mode

    ;;; Code:

    ;; ===== Performance =====
    (setq gc-cons-threshold 100000000)
    (setq read-process-output-max (* 1024 1024))

    ;; ===== Package setup =====
    (require 'package)
    (setq package-enable-at-startup nil)

    ;; ===== Evil Mode =====
    (require 'evil)
    (setq evil-want-keybinding nil)  ; Required for evil-collection
    (evil-mode 1)
    (require 'evil-collection)
    (evil-collection-init)
    (require 'evil-surround)
    (global-evil-surround-mode 1)
    (require 'evil-commentary)
    (evil-commentary-mode)

    ;; ===== UI =====
    (load-theme 'gruvbox-dark-hard t)
    (require 'doom-modeline)
    (doom-modeline-mode 1)
    (setq doom-modeline-height 25)
    (setq doom-modeline-bar-width 3)

    ;; Clean UI
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1)
    (setq inhibit-startup-screen t)
    (setq initial-scratch-message "")

    ;; Line numbers
    (global-display-line-numbers-mode 1)
    (setq display-line-numbers-type 'relative)

    ;; Font
    (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 120)

    ;; Rainbow delimiters
    (require 'rainbow-delimiters)
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

    ;; Which-key
    (require 'which-key)
    (which-key-mode)
    (setq which-key-idle-delay 0.3)

    ;; ===== Completion =====
    (require 'vertico)
    (vertico-mode)
    (require 'marginalia)
    (marginalia-mode)
    (require 'orderless)
    (setq completion-styles '(orderless basic))
    (require 'corfu)
    (global-corfu-mode)
    (setq corfu-auto t)

    ;; ===== Org Mode =====
    (require 'org)
    (setq org-directory "~/org/")
    (setq org-default-notes-file (concat org-directory "notes.org"))
    (setq org-agenda-files '("~/org/" "~/dotfiles/docs/"))

    ;; Org-roam
    (require 'org-roam)
    (setq org-roam-directory "~/org/roam/")
    (setq org-roam-database-connector 'sqlite-builtin)
    (org-roam-db-autosync-mode)

    ;; Org keybindings
    (global-set-key (kbd "C-c a") 'org-agenda)
    (global-set-key (kbd "C-c c") 'org-capture)
    (global-set-key (kbd "C-c l") 'org-store-link)

    ;; Org-roam keybindings
    (global-set-key (kbd "C-c n f") 'org-roam-node-find)
    (global-set-key (kbd "C-c n i") 'org-roam-node-insert)
    (global-set-key (kbd "C-c n c") 'org-roam-capture)
    (global-set-key (kbd "C-c n b") 'org-roam-buffer-toggle)

    ;; ===== Magit =====
    (require 'magit)
    (global-set-key (kbd "C-x g") 'magit-status)

    ;; ===== Which-key leader hints =====
    (which-key-add-key-based-replacements
      "C-c a" "org-agenda"
      "C-c c" "org-capture"
      "C-c n" "org-roam"
      "C-x g" "magit")

    ;; ===== AI (gptel) =====
    (require 'gptel)
    ;; Configure with your API key from ~/.secrets/
    (when (file-exists-p "~/.secrets/gemini_api_key")
      (setq gptel-api-key
        (with-temp-buffer
          (insert-file-contents "~/.secrets/gemini_api_key")
          (string-trim (buffer-string)))))

    ;; ===== Custom keybindings with Evil leader =====
    (evil-set-leader 'normal (kbd "SPC"))
    (evil-define-key 'normal 'global (kbd "<leader>ff") 'find-file)
    (evil-define-key 'normal 'global (kbd "<leader>fs") 'save-buffer)
    (evil-define-key 'normal 'global (kbd "<leader>bb") 'switch-to-buffer)
    (evil-define-key 'normal 'global (kbd "<leader>bd") 'kill-buffer)
    (evil-define-key 'normal 'global (kbd "<leader>oa") 'org-agenda)
    (evil-define-key 'normal 'global (kbd "<leader>oc") 'org-capture)
    (evil-define-key 'normal 'global (kbd "<leader>or") 'org-roam-node-find)
    (evil-define-key 'normal 'global (kbd "<leader>gs") 'magit-status)

    ;; ===== Misc =====
    (setq make-backup-files nil)
    (setq auto-save-default nil)
    (setq create-lockfiles nil)
    (setq custom-file (concat user-emacs-directory "custom.el"))
    (when (file-exists-p custom-file)
      (load custom-file))

    ;;; init.el ends here
  '';

  # Org directories
  home.file."org/.keep".text = "";
  home.file."org/roam/.keep".text = "";
}
