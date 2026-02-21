# Emacs Learning Hub & System Optimization — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Transform ~/dotfiles into a fully integrated Emacs-centric learning hub with GTD, Zettelkasten, literate notebooks, dwm integration, and full T490 system optimization.

**Architecture:** 7 layers built in dependency order. Each layer is testable standalone. Foundation first (dirs, fonts, stow), then Emacs config (literate config.org), then integrations, then dwm, then patches, then shell, then system tuning.

**Tech Stack:** Void Linux, dwm (source), Emacs (source, native-comp), zsh, GNU Stow, org-mode, org-roam, gptel, picom-ftlabs, XLibre

**Note:** Use `gh` for all git operations. Sudo password is `o`. All suckless tools and Emacs are built from source.

---

## Layer 1: Foundation

### Task 1: Create ~/org directory structure

**Files:**
- Create: `~/org/inbox.org`
- Create: `~/org/todo.org`
- Create: `~/org/projects.org`
- Create: `~/org/someday.org`
- Create: `~/org/habits.org`
- Create: `~/org/journal.org`
- Create: `~/org/bookmarks.org`
- Create: `~/org/elfeed.org`
- Create: `~/org/learning/linux.org`
- Create: `~/org/learning/bash.org`
- Create: `~/org/learning/emacs.org`
- Create: `~/org/learning/lisp.org`
- Create: `~/org/learning/ai.org`
- Create: `~/org/learning/c.org`
- Create: `~/org/roam/.gitkeep`
- Create: `~/org/roam/journal/.gitkeep`
- Create: `~/org/archive/.gitkeep`

**Step 1: Create all directories**

```bash
mkdir -p ~/org/{learning,roam/journal,archive}
```

**Step 2: Create GTD org files with headers**

```bash
for f in inbox todo projects someday habits journal bookmarks; do
  cat > ~/org/${f}.org <<ORGEOF
#+TITLE: $(echo $f | sed 's/.*/\u&/')
#+FILETAGS: :${f}:
#+STARTUP: overview indent
ORGEOF
done
```

**Step 3: Create elfeed.org with Emacs ecosystem feeds**

Write `~/org/elfeed.org`:
```org
#+TITLE: Elfeed Feeds
* Emacs                                                          :emacs:
** https://planet.emacslife.com/atom.xml
** https://protesilaos.com/codelog.xml
** https://systemcrafters.net/rss/news.xml
** https://irreal.org/blog/?feed=rss2
** https://sachachua.com/blog/feed/
```

**Step 4: Create learning notebooks with chapter structure**

Each notebook gets the progressive chapter template. Example for `~/org/learning/bash.org`:
```org
#+TITLE: Bash Scripting
#+FILETAGS: :learning:bash:
#+STARTUP: overview indent
#+PROPERTY: header-args:shell :results output

* 1. Fundamentals
** Concepts
** Code Examples
   #+begin_src shell
   #+end_src
** Exercises
** Notes

* 2. Variables & Quoting
** Concepts
** Code Examples
** Exercises
** Notes
```

Repeat for linux.org (topics: filesystems, processes, networking, services, permissions), emacs.org (topics: buffers, windows, modes, elisp basics, packages), lisp.org (topics: s-expressions, lists, functions, macros, recursion), ai.org (topics: prompting, APIs, embeddings, agents), c.org (topics: pointers, structs, memory, Makefiles, suckless source reading).

**Step 5: Verify structure**

```bash
find ~/org -type f | sort
```

Expected: 20+ files across the directory tree.

---

### Task 2: Install Terminus Nerd Font

**Files:**
- Install to: `~/.local/share/fonts/`

**Step 1: Download TerminessNerdFont**

```bash
mkdir -p ~/.local/share/fonts
cd /tmp
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Terminus.tar.xz
tar xf Terminus.tar.xz -C ~/.local/share/fonts/
fc-cache -fv
```

**Step 2: Verify font is available**

```bash
fc-list | grep -i "Terminess"
```

Expected: Multiple entries for TerminessNerdFont variants.

---

### Task 3: Install GNU Stow

**Step 1: Install stow via xbps**

```bash
echo "o" | sudo -S xbps-install -Sy stow
```

**Step 2: Restructure dotfiles for stow**

```bash
cd ~/dotfiles
mkdir -p stow/zsh stow/emacs/.emacs.d stow/xinitrc stow/xresources
mkdir -p stow/fontconfig/.config/fontconfig
mkdir -p stow/picom/.config/picom
mkdir -p stow/dunst/.config/dunst
mkdir -p stow/lf/.config/lf
mkdir -p stow/starship/.config
mkdir -p stow/atuin/.config/atuin
```

**Step 3: Move existing config files into stow structure**

```bash
cd ~/dotfiles
# Move (keep originals as stow will manage symlinks)
cp zsh/.zshrc stow/zsh/.zshrc
cp zsh/.zprofile stow/zsh/.zprofile
cp emacs/early-init.el stow/emacs/.emacs.d/early-init.el
cp emacs/init.el stow/emacs/.emacs.d/init.el
cp xinitrc/.xinitrc stow/xinitrc/.xinitrc
cp Xresources/.Xresources stow/xresources/.Xresources
cp fontconfig/fonts.conf stow/fontconfig/.config/fontconfig/fonts.conf
cp picom.conf stow/picom/.config/picom/picom.conf
```

**Step 4: Remove old symlinks and deploy via stow**

```bash
rm -f ~/.zshrc ~/.zprofile ~/.xinitrc ~/.Xresources
cd ~/dotfiles/stow
stow -t ~ zsh emacs xinitrc xresources fontconfig picom
```

**Step 5: Verify symlinks**

```bash
ls -la ~/.zshrc ~/.emacs.d/init.el ~/.xinitrc ~/.Xresources
```

Expected: All point into `~/dotfiles/stow/...`

---

### Task 4: Migrate PKM content into ~/org

**Step 1: Merge GTD files from existing repos**

```bash
# From org-pkm (has most content)
for f in ~/repos/org-pkm/*.org; do
  base=$(basename "$f")
  if [ -f ~/org/"$base" ]; then
    # Append content (skip header) to existing file
    tail -n +4 "$f" >> ~/org/"$base"
  else
    cp "$f" ~/org/
  fi
done

# From pkm/gtd/
for f in ~/repos/pkm/gtd/*.org; do
  base=$(basename "$f")
  if [ ! -f ~/org/"$base" ]; then
    cp "$f" ~/org/
  fi
done
```

**Step 2: Merge learning content from ai-knowledge**

```bash
cp ~/repos/ai-knowledge/learning/emacs/*.org ~/org/learning/ 2>/dev/null || true
cp ~/repos/ai-knowledge/reference/*.org ~/org/learning/ 2>/dev/null || true
```

**Step 3: Initialize ~/org as a git repo**

```bash
cd ~/org
git init
git add -A
git commit -m "Initial org directory: GTD + learning notebooks + roam"
```

---

## Layer 2: Emacs Core (config.org)

### Task 5: Create literate config.org with early-init and bootstrap

**Files:**
- Create: `~/dotfiles/stow/emacs/.emacs.d/config.org`
- Modify: `~/dotfiles/stow/emacs/.emacs.d/init.el` (replace with loader)

**Step 1: Create config.org with early-init section**

Write `~/dotfiles/stow/emacs/.emacs.d/config.org` — the first two sections:

```org
#+TITLE: Emacs Configuration
#+AUTHOR: Omran Al Teneiji
#+PROPERTY: header-args:emacs-lisp :tangle init.el
#+STARTUP: overview indent

* Early Init
:PROPERTIES:
:header-args:emacs-lisp: :tangle early-init.el
:END:

#+begin_src emacs-lisp
;;; early-init.el -*- lexical-binding: t -*-
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      package-enable-at-startup nil)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)
(push '(background-color . "#282828") default-frame-alist)
(push '(foreground-color . "#ebdbb2") default-frame-alist)
(push '(cursor-color . "#fe8019") default-frame-alist)

(setq native-comp-async-report-warnings-errors 'silent)
#+end_src

* Bootstrap

#+begin_src emacs-lisp
;;; init.el -*- lexical-binding: t -*-

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
#+end_src

* Performance

#+begin_src emacs-lisp
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
#+end_src

* Core Defaults

#+begin_src emacs-lisp
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
  (set-face-attribute 'default nil :family "TerminessNerdFont" :height 140))
#+end_src

* Theme

#+begin_src emacs-lisp
(use-package gruvbox-theme
  :demand t
  :config
  (load-theme 'gruvbox-dark-hard t))
#+end_src

* Evil

#+begin_src emacs-lisp
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
#+end_src

* Completion Stack

#+begin_src emacs-lisp
(use-package vertico
  :demand t
  :init (vertico-mode 1))

(use-package orderless
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :demand t
  :init (marginalia-mode 1))

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
  :init (global-corfu-mode 1))

(use-package embark
  :demand t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package wgrep
  :defer t)

(use-package which-key
  :demand t
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.3))
#+end_src
```

**Step 2: Replace init.el with config.org loader**

Replace `~/dotfiles/stow/emacs/.emacs.d/init.el` with:

```elisp
;;; init.el -*- lexical-binding: t -*-
;; Tangled from config.org — do not edit directly.
(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory))
```

Wait — this won't work because org-babel-load-file needs org loaded, but straight.el isn't loaded yet. Instead, the config.org tangles TO init.el via `:tangle init.el`. So the workflow is:

1. Edit config.org
2. Tangle (C-c C-v t or auto-tangle on save)
3. init.el is regenerated

So init.el stays as the tangled output. No loader needed.

**Step 3: Tangle config.org to verify it produces valid init.el**

```bash
cd ~/.emacs.d
emacs --batch -l org config.org -f org-babel-tangle
```

Expected: Produces `init.el` and `early-init.el` in `~/.emacs.d/`.

**Step 4: Test Emacs starts with the tangled config**

```bash
emacs --debug-init &
```

Expected: Emacs opens with gruvbox-dark-hard, evil mode, vertico completion.

---

### Task 6: Add Org-Mode core + GTD to config.org

**Files:**
- Modify: `~/dotfiles/stow/emacs/.emacs.d/config.org` (append sections)

**Step 1: Add Org-Mode core section**

Append to config.org:

```org
* Org-Mode Core

#+begin_src emacs-lisp
(use-package org
  :straight (:type built-in)
  :hook (org-mode . visual-line-mode)
  :config
  (setq org-directory "~/org"
        org-default-notes-file "~/org/inbox.org"
        org-agenda-files '("~/org/inbox.org" "~/org/todo.org"
                           "~/org/projects.org" "~/org/habits.org")
        org-log-done 'time
        org-log-into-drawer t
        org-return-follows-link t
        org-confirm-babel-evaluate nil
        org-startup-indented t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-ellipsis " ..."
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-image-actual-width '(600))

  ;; Babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     (C . t)))

  ;; Structure templates
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("cc" . "src C"))

  ;; TODO keywords
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "DOING(d)" "BLOCKED(b@/!)" "|" "DONE(!)" "DROPPED(x@/!)")))
  (setq org-todo-keyword-faces
        '(("TODO"    . (:foreground "#fb4934" :weight bold))
          ("NEXT"    . (:foreground "#b8bb26" :weight bold))
          ("DOING"   . (:foreground "#fe8019" :weight bold))
          ("BLOCKED" . (:foreground "#fabd2f" :weight bold))
          ("DONE"    . (:foreground "#928374" :weight bold))
          ("DROPPED" . (:foreground "#928374" :weight bold))))

  ;; Tags
  (setq org-tag-alist
        '((:startgroup) ("@home" . ?h) ("@work" . ?w) ("@errands" . ?e) (:endgroup)
          (:startgroup) ("deep" . ?d) ("shallow" . ?s) (:endgroup)
          ("learning" . ?l) ("project" . ?P) ("reading" . ?r)))

  ;; Refile
  (setq org-refile-targets
        '(("~/org/projects.org" :maxlevel . 3)
          ("~/org/someday.org" :level . 1)
          ("~/org/archive/archive.org" :maxlevel . 2)))
  (setq org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)

  ;; Capture
  (setq org-capture-templates
        '(("i" "Inbox" entry (file+headline "~/org/inbox.org" "Inbox")
           "* TODO %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n" :empty-lines 1)
          ("t" "Task" entry (file+headline "~/org/inbox.org" "Tasks")
           "* TODO %?\n  :PROPERTIES:\n  :CREATED: %U\n  :CONTEXT: %a\n  :END:\n" :empty-lines 1)
          ("n" "Note" entry (file+headline "~/org/inbox.org" "Notes")
           "* %? :note:\n  %U\n" :empty-lines 1)
          ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
           "* %<%H:%M> %?\n" :tree-type week)
          ("b" "Bookmark" entry (file+headline "~/org/bookmarks.org" "Unsorted")
           "* [[%^{URL}][%^{Title}]] :bookmark:\n  %U\n  %?\n" :empty-lines 1)
          ("H" "Habit" entry (file "~/org/habits.org")
           "* TODO %?\n  SCHEDULED: %^t\n  :PROPERTIES:\n  :STYLE: habit\n  :END:\n" :empty-lines 1)))

  ;; Agenda
  (setq org-agenda-start-with-log-mode t
        org-agenda-window-setup 'current-window
        org-agenda-span 'day
        org-deadline-warning-days 7
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t)

  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-agenda-span 'day)
                        (org-agenda-overriding-header "Today")))
            (todo "DOING" ((org-agenda-overriding-header "In Progress")))
            (todo "NEXT" ((org-agenda-overriding-header "Next Actions")))
            (todo "BLOCKED" ((org-agenda-overriding-header "Blocked")))
            (tags "inbox" ((org-agenda-overriding-header "Inbox (process)")))))
          ("W" "Weekly Review"
           ((agenda "" ((org-agenda-span 7)
                        (org-agenda-overriding-header "This Week")))
            (todo "BLOCKED" ((org-agenda-overriding-header "Blocked")))
            (todo "TODO" ((org-agenda-overriding-header "All TODOs")))))))

  ;; Habit
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 40)

  ;; Clock
  (setq org-clock-persist 'history
        org-clock-into-drawer t
        org-clock-out-remove-zero-time-clocks t)
  (org-clock-persistence-insinuate))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package org-super-agenda
  :after org
  :demand t
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "Overdue" :deadline past :order 0)
          (:name "Due Today" :deadline today :order 1)
          (:name "In Progress" :todo "DOING" :order 2)
          (:name "Next Actions" :todo "NEXT" :order 3)
          (:name "Habits" :habit t :order 8)
          (:name "Blocked" :todo "BLOCKED" :order 9)
          (:discard (:anything t)))))
#+end_src
```

**Step 2: Tangle and test**

```bash
cd ~/.emacs.d && emacs --batch -l org config.org -f org-babel-tangle
emacs --eval '(org-agenda nil "d")' &
```

Expected: Emacs opens with the Dashboard agenda view.

---

### Task 7: Add Org-Roam + auto-tangle to config.org

**Files:**
- Modify: `~/dotfiles/stow/emacs/.emacs.d/config.org` (append)

**Step 1: Add Org-Roam section**

Append to config.org:

```org
* Org-Roam (Zettelkasten)

#+begin_src emacs-lisp
(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org/roam/"))
  (org-roam-completion-everywhere t)
  (org-roam-database-connector 'sqlite-builtin)
  (org-roam-dailies-directory "journal/")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  (setq org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

  (setq org-roam-capture-templates
        '(("d" "Default" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: \n#+date: %U\n")
           :unnarrowed t)
          ("s" "Code Snippet" plain
           "* Source\n%^{Language|shell|emacs-lisp|python|c}\n\n* Code\n\n#+begin_src %\\1\n%?\n#+end_src\n\n* Explanation\n\n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :snippet:\n#+date: %U\n")
           :unnarrowed t)
          ("c" "Concept" plain
           "* Definition\n\n%?\n\n* Related Concepts\n\n- \n\n* Links\n\n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :concept:\n#+date: %U\n")
           :unnarrowed t)
          ("w" "Tutorial Walkthrough" plain
           "* Prerequisites\n\n- \n\n* Steps\n\n1. %?\n\n* Troubleshooting\n\n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :tutorial:\n#+date: %U\n")
           :unnarrowed t)
          ("l" "Literature Note" plain
           "* Source\n\n- Author: %^{Author}\n- Title: ${title}\n- URL: %^{URL}\n\n* Summary\n\n%?\n\n* Key Ideas\n\n- \n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :literature:\n#+date: %U\n")
           :unnarrowed t)
          ("f" "Fleeting" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :fleeting:\n#+date: %U\n")
           :unnarrowed t)))

  (setq org-roam-dailies-capture-templates
        '(("d" "Default" entry "* %<%H:%M> %?"
           :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
          ("t" "Task" entry "* TODO %?\n  SCHEDULED: %t\n"
           :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")))))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t))
#+end_src

* Org-Protocol

#+begin_src emacs-lisp
(require 'org-protocol)
(add-to-list 'org-capture-templates
             '("W" "Web Capture" entry
               (file+headline "~/org/inbox.org" "Web")
               "* TODO %:annotation\n  %U\n  %:initial\n  %?\n"
               :empty-lines 1))
#+end_src

* Auto-Tangle

#+begin_src emacs-lisp
(defun my/org-babel-tangle-config ()
  "Tangle config.org on save."
  (when (string-equal (buffer-file-name)
                      (expand-file-name "config.org" user-emacs-directory))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'my/org-babel-tangle-config nil t)))
#+end_src
```

**Step 2: Tangle and test org-roam**

```bash
cd ~/.emacs.d && emacs --batch -l org config.org -f org-babel-tangle
emacs --eval '(progn (require (quote org-roam)) (org-roam-db-autosync-mode))' &
```

Expected: Emacs starts, org-roam DB builds from ~/org/roam/.

---

## Layer 3: Emacs Integrations

### Task 8: Add magit, elfeed, gptel, eglot, vterm to config.org

**Files:**
- Modify: `~/dotfiles/stow/emacs/.emacs.d/config.org` (append)

**Step 1: Add Git section**

```org
* Git

#+begin_src emacs-lisp
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package git-timemachine
  :defer t)
#+end_src
```

**Step 2: Add RSS section**

```org
* RSS

#+begin_src emacs-lisp
(use-package elfeed
  :bind ("C-x w" . elfeed)
  :config
  (setq elfeed-search-filter "@1-week-ago +unread"))

(use-package elfeed-org
  :after elfeed
  :demand t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/org/elfeed.org")))
#+end_src
```

**Step 3: Add AI section**

```org
* AI (gptel)

#+begin_src emacs-lisp
(use-package gptel
  :bind (("C-c g" . gptel-send)
         ("C-c G" . gptel-menu))
  :config
  (setq gptel-model 'claude-sonnet-4-20250514
        gptel-default-mode 'org-mode)
  ;; Gemini backend
  (gptel-make-gemini "Gemini"
    :key (lambda () (getenv "GEMINI_API_KEY"))
    :stream t))
#+end_src
```

**Step 4: Add LSP section**

```org
* LSP (eglot)

#+begin_src emacs-lisp
(use-package eglot
  :straight (:type built-in)
  :hook ((python-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (sh-mode . eglot-ensure)))
#+end_src
```

**Step 5: Add Terminal section**

```org
* Terminal

#+begin_src emacs-lisp
(use-package vterm
  :bind ("C-c t" . vterm)
  :config
  (setq vterm-max-scrollback 10000))
#+end_src
```

**Step 6: Add Dired section**

```org
* File Management

#+begin_src emacs-lisp
(use-package dired
  :straight (:type built-in)
  :config
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-dwim-target t
        dired-auto-revert-buffer t))
#+end_src
```

**Step 7: Add Server section**

```org
* Server

#+begin_src emacs-lisp
(use-package server
  :straight (:type built-in)
  :config
  (unless (server-running-p) (server-start)))
#+end_src
```

**Step 8: Install LSP servers via xbps**

```bash
echo "o" | sudo -S xbps-install -Sy bash-language-server python3-lsp-server clang-tools-extra
```

**Step 9: Install vterm dependency**

```bash
echo "o" | sudo -S xbps-install -Sy cmake libvterm-devel
```

**Step 10: Tangle, restart Emacs, verify**

```bash
cd ~/.emacs.d && emacs --batch -l org config.org -f org-babel-tangle
# Restart emacs daemon
emacsclient -e '(kill-emacs)' 2>/dev/null; emacs --daemon
emacsclient -c &
```

Expected: All packages install and load. `C-x g` opens magit, `C-x w` opens elfeed, `C-c g` activates gptel.

---

## Layer 4: dwm Integration

### Task 9: Add Emacs keybindings to dwm config.h

**Files:**
- Modify: `~/dotfiles/suckless/dwm/config.h`

**Step 1: Add org-capture, org-agenda, org-roam-find keybindings**

Find the `keys[]` array in `~/dotfiles/suckless/dwm/config.h` and add before the closing `};`:

```c
{ MODKEY,            XK_c,      spawn,    SHCMD("emacsclient -c -e '(org-capture)'") },
{ MODKEY,            XK_a,      spawn,    SHCMD("emacsclient -c -e '(org-agenda-list)'") },
{ MODKEY,            XK_n,      spawn,    SHCMD("emacsclient -c -e '(org-roam-node-find)'") },
```

**Step 2: Rebuild dwm**

```bash
cd ~/dotfiles/suckless/src/dwm
cp ~/dotfiles/suckless/dwm/config.h config.h
echo "o" | sudo -S make clean install
```

**Step 3: Create org-protocol desktop file**

Write `~/.local/share/applications/org-protocol.desktop`:
```ini
[Desktop Entry]
Name=Org Protocol
Exec=emacsclient %u
Type=Application
Terminal=false
MimeType=x-scheme-handler/org-protocol;
```

```bash
xdg-mime default org-protocol.desktop x-scheme-handler/org-protocol
```

**Step 4: Create dmenu-emacs script**

Write `~/.local/bin/dmenu-emacs`:
```bash
#!/usr/bin/env bash
set -euo pipefail
buf=$(emacsclient -e '(mapconcat (lambda (b) (buffer-name b)) (buffer-list) "\n")' \
  | tr -d '"' | dmenu -i -l 20 -p "Buffer:")
[ -n "$buf" ] && emacsclient -c --eval "(switch-to-buffer \"$buf\")"
```

```bash
chmod +x ~/.local/bin/dmenu-emacs
```

Add keybinding in dwm config.h:
```c
{ MODKEY|ShiftMask,  XK_e,      spawn,    SHCMD("dmenu-emacs") },
```

---

## Layer 5: dwm Patches

### Task 10: Download and apply scratchpad, swallow, xresources patches

**Files:**
- Download: `~/dotfiles/suckless/patches/dwm-scratchpad-*.diff`
- Download: `~/dotfiles/suckless/patches/dwm-swallow-*.diff`
- Download: `~/dotfiles/suckless/patches/dwm-xresources-*.diff`
- Modify: `~/dotfiles/suckless/dwm/config.h` (add scratchpad/swallow/xresources config)

**Step 1: Download patches**

```bash
cd ~/dotfiles/suckless/patches
curl -LO https://dwm.suckless.org/patches/scratchpad/dwm-scratchpad-6.5.diff
curl -LO https://dwm.suckless.org/patches/swallow/dwm-swallow-20201211-61bb8b2.diff
curl -LO https://dwm.suckless.org/patches/xresources/dwm-xresources-20210827-138b405.diff
```

**Step 2: Apply patches one at a time (test each)**

```bash
cd ~/dotfiles/suckless/src/dwm
git checkout .  # Clean state
# Re-apply existing 8 patches first (use build script)
# Then apply new ones:
git apply --check ~/dotfiles/suckless/patches/dwm-scratchpad-6.5.diff
git apply ~/dotfiles/suckless/patches/dwm-scratchpad-6.5.diff

git apply --check ~/dotfiles/suckless/patches/dwm-swallow-20201211-61bb8b2.diff
git apply ~/dotfiles/suckless/patches/dwm-swallow-20201211-61bb8b2.diff

git apply --check ~/dotfiles/suckless/patches/dwm-xresources-20210827-138b405.diff
git apply ~/dotfiles/suckless/patches/dwm-xresources-20210827-138b405.diff
```

Note: Patches may need manual conflict resolution. Check each `--check` output.

**Step 3: Update config.h for scratchpad**

Add to config.h:
```c
/* scratchpad */
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "kitty", "--title", scratchpadname, "-o", "initial_window_width=100c", "-o", "initial_window_height=30c", NULL };
```

Add keybinding:
```c
{ MODKEY,            XK_grave,  togglescratchpad, {.v = scratchpadcmd} },
```

**Step 4: Install swallow dependency**

```bash
echo "o" | sudo -S xbps-install -Sy libxcb-devel xcb-util-devel
```

**Step 5: Rebuild and install dwm**

```bash
cp ~/dotfiles/suckless/dwm/config.h config.h
echo "o" | sudo -S make clean install
```

### Task 11: Update dwmblocks with Nerd Font icons

**Files:**
- Modify: `~/dotfiles/scripts/statusbar/sb-volume`
- Modify: `~/dotfiles/scripts/statusbar/sb-cpu`
- Modify: `~/dotfiles/scripts/statusbar/sb-memory`
- Modify: `~/dotfiles/scripts/statusbar/sb-battery`
- Modify: `~/dotfiles/scripts/statusbar/sb-network`
- Modify: `~/dotfiles/scripts/statusbar/sb-temp`
- Modify: `~/dotfiles/scripts/statusbar/sb-date`

**Step 1: Update each script's output prefix**

For each sb-* script, replace the text prefix with a Nerd Font icon:
- `sb-volume`: prefix ` ` (or ` ` for muted)
- `sb-cpu`: prefix ` `
- `sb-memory`: prefix ` `
- `sb-battery`: prefix ` ` (dynamic: ` ` <20%, ` ` 20-50%, ` ` 50-80%, ` ` >80%)
- `sb-network`: prefix ` ` (wifi) or ` ` (ethernet) or ` ` (disconnected)
- `sb-temp`: prefix ` `
- `sb-date`: prefix ` `

**Step 2: Rebuild dwmblocks**

```bash
cd ~/dotfiles/suckless/src/dwmblocks
echo "o" | sudo -S make clean install
```

### Task 12: Build picom-ftlabs from source

**Files:**
- Clone: `~/dotfiles/suckless/src/picom-ftlabs`
- Modify: `~/dotfiles/stow/picom/.config/picom/picom.conf`

**Step 1: Install picom build dependencies**

```bash
echo "o" | sudo -S xbps-install -Sy meson ninja libev-devel xcb-util-renderutil-devel \
  xcb-util-image-devel pixman-devel libconfig-devel libGL-devel pcre2-devel \
  dbus-devel uthash
```

**Step 2: Clone and build picom-ftlabs**

```bash
cd ~/dotfiles/suckless/src
git clone https://github.com/HcGys/FT-Labs-picom.git picom-ftlabs
cd picom-ftlabs
git submodule update --init --recursive
meson setup build
ninja -C build
echo "o" | sudo -S ninja -C build install
```

**Step 3: Update picom.conf for fade-only animations**

Add to `~/dotfiles/stow/picom/.config/picom/picom.conf`:
```
# Animations (picom-ftlabs)
animations = true;
animation-stiffness = 200;
animation-window-mass = 0.5;
animation-dampening = 20;
animation-for-open-window = "fade";
animation-for-unmap-window = "fade";
```

**Step 4: Restow picom config**

```bash
cd ~/dotfiles/stow && stow -R -t ~ picom
```

---

## Layer 6: Shell & Tools

### Task 13: Install new shell tools

**Step 1: Install via xbps**

```bash
echo "o" | sudo -S xbps-install -Sy starship lf atuin direnv chafa poppler-utils atool pass
```

**Step 2: Install fzf-tab, fast-syntax-highlighting, zsh-completions**

```bash
mkdir -p ~/.local/share/zsh/plugins
git clone https://github.com/Aloxaf/fzf-tab ~/.local/share/zsh/plugins/fzf-tab
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.local/share/zsh/plugins/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.local/share/zsh/plugins/zsh-completions
```

### Task 14: Update .zshrc with new plugins, starship, atuin, direnv, bookmarks

**Files:**
- Modify: `~/dotfiles/stow/zsh/.zshrc`

**Step 1: Replace the plugins section**

In `.zshrc`, replace lines 61-74 (plugin loader + zsh-syntax-highlighting/autosuggestions) with:

```zsh
# Plugin loader
source_if_exists() { [[ -f "$1" ]] && source "$1"; }

# Completions (must be before compinit)
fpath=(~/.local/share/zsh/plugins/zsh-completions/src $fpath)

# fzf-tab (must be after compinit, before other widgets)
source_if_exists ~/.local/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# Autosuggestions
source_if_exists /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists /usr/share/zsh/site-functions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#504945'

# History substring search
source_if_exists /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source_if_exists /usr/share/zsh/site-functions/zsh-history-substring-search.zsh

# Syntax highlighting (fast fork, must be last)
source_if_exists ~/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# fzf-tab preview config
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=auto $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || eza -1 --color=always $realpath 2>/dev/null'
```

**Step 2: Replace prompt section with starship**

Replace lines 54-59 (the PROMPT section) with:

```zsh
# Prompt (starship)
eval "$(starship init zsh)"
```

**Step 3: Add atuin, direnv, bookmarks at end of .zshrc**

Before the `unfunction source_if_exists` line, add:

```zsh
# Atuin (replaces ctrl-r)
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh --disable-up-arrow)"

# Direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Bookmarks
[ -f ~/.config/shell/bm-dirs ] && while IFS=$'\t' read -r key dir; do
  alias "g${key}=cd ${dir}"
done < ~/.config/shell/bm-dirs

[ -f ~/.config/shell/bm-files ] && while IFS=$'\t' read -r key file; do
  alias "e${key}=\$EDITOR ${file}"
done < ~/.config/shell/bm-files
```

**Step 4: Restow zsh**

```bash
cd ~/dotfiles/stow && stow -R -t ~ zsh
```

### Task 15: Create config files for starship, atuin, lf, bookmarks

**Files:**
- Create: `~/dotfiles/stow/starship/.config/starship.toml`
- Create: `~/dotfiles/stow/atuin/.config/atuin/config.toml`
- Create: `~/dotfiles/stow/lf/.config/lf/lfrc`
- Create: `~/dotfiles/stow/lf/.config/lf/preview`
- Create: `~/.config/shell/bm-dirs`
- Create: `~/.config/shell/bm-files`

**Step 1: Write starship.toml**

```toml
format = "$directory$git_branch$git_status$character"

[character]
success_symbol = "[](green)"
error_symbol = "[](red)"

[directory]
style = "bold yellow"
truncation_length = 3

[git_branch]
style = "bold purple"
format = " [$branch]($style) "

[git_status]
style = "bold red"
```

**Step 2: Write atuin config.toml**

```toml
[style]
compact = true

[colors]
selected_highlight = { foreground = "#282828", background = "#fabd2f" }
```

**Step 3: Write lf config (lfrc)**

```
set previewer ~/.config/lf/preview
set cleaner ~/.config/lf/cleaner
set icons true
set hidden true
set ignorecase true
set drawbox true

map <enter> open
map D delete
map x cut
map y copy
map p paste
map R reload
map . set hidden!
```

**Step 4: Write lf preview script**

```bash
#!/bin/sh
case "$(file -Lb --mime-type -- "$1")" in
  text/*) bat --color=always --style=numbers --line-range=:200 "$1" ;;
  image/*) chafa -f symbols -s 80x24 "$1" ;;
  application/pdf) pdftotext "$1" - | head -200 ;;
  application/zip|application/*tar*|application/*compress*) atool -l "$1" ;;
  *) file -Lb -- "$1" ;;
esac
```

```bash
chmod +x ~/dotfiles/stow/lf/.config/lf/preview
```

**Step 5: Write bookmark files**

`~/.config/shell/bm-dirs`:
```
d	~/Documents
D	~/Downloads
o	~/org
or	~/org/roam
ol	~/org/learning
r	~/repos
df	~/dotfiles
s	~/dotfiles/suckless
```

`~/.config/shell/bm-files`:
```
cf	~/dotfiles/stow/emacs/.emacs.d/config.org
zr	~/dotfiles/stow/zsh/.zshrc
dw	~/dotfiles/suckless/dwm/config.h
xi	~/dotfiles/stow/xinitrc/.xinitrc
```

**Step 6: Stow all new configs**

```bash
cd ~/dotfiles/stow && stow -t ~ starship atuin lf
```

### Task 16: Create dmenu scripts

**Files:**
- Create: `~/.local/bin/dmenu-power`
- Create: `~/.local/bin/dmenu-websearch`
- Create: `~/.local/bin/dmenu-emoji`
- Create: `~/.local/bin/dmenu-mount`
- Create: `~/.local/bin/dmenu-pass`
- Create: `~/.local/bin/dmenu-bookmarks`
- Create: `~/.local/bin/dmenu-calc`

**Step 1: Write dmenu-power**

```bash
#!/usr/bin/env bash
set -euo pipefail
choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | dmenu -i -p "Power:")
case "$choice" in
  Lock)     slock ;;
  Logout)   pkill dwm ;;
  Suspend)  systemctl suspend || loginctl suspend ;;
  Reboot)   sudo reboot ;;
  Shutdown) sudo shutdown -h now ;;
esac
```

**Step 2: Write dmenu-websearch**

```bash
#!/usr/bin/env bash
set -euo pipefail
query=$(dmenu -p "Search:" < /dev/null)
[ -n "$query" ] && firefox "https://duckduckgo.com/?q=$(printf '%s' "$query" | jq -sRr @uri)"
```

**Step 3: Write dmenu-emoji**

```bash
#!/usr/bin/env bash
set -euo pipefail
emoji=$(curl -sSL "https://unicode.org/Public/emoji/latest/emoji-test.txt" \
  | grep "fully-qualified" | sed 's/.*# //' | dmenu -i -l 20 -p "Emoji:")
[ -n "$emoji" ] && printf '%s' "${emoji%% *}" | xclip -selection clipboard
```

Note: For better performance, cache the emoji list to `~/.local/share/emoji-list`.

**Step 4: Write dmenu-calc**

```bash
#!/usr/bin/env bash
set -euo pipefail
result=$(dmenu -p "Calc:" < /dev/null | bc -l 2>/dev/null)
[ -n "$result" ] && printf '%s' "$result" | xclip -selection clipboard && notify-send "Result" "$result"
```

**Step 5: Write remaining scripts (dmenu-mount, dmenu-pass, dmenu-bookmarks)**

These are longer scripts — reference Luke Smith's voidrice for dmenu-mount and dmenu-pass patterns.

**Step 6: Make all executable and add dwm keybindings**

```bash
chmod +x ~/.local/bin/dmenu-*
```

Add to dwm config.h `keys[]`:
```c
{ MODKEY,            XK_x,      spawn,    SHCMD("dmenu-power") },
{ MODKEY,            XK_s,      spawn,    SHCMD("dmenu-websearch") },
{ MODKEY,            XK_period, spawn,    SHCMD("dmenu-emoji") },
{ MODKEY|ShiftMask,  XK_c,      spawn,    SHCMD("dmenu-calc") },
```

---

## Layer 7: System Tuning

### Task 17: Kernel boot parameters + fstab

**Step 1: Update GRUB cmdline**

```bash
echo "o" | sudo -S sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 loglevel=3 console=tty2 nowatchdog mitigations=off"/' /etc/default/grub
echo "o" | sudo -S grub-mkconfig -o /boot/grub/grub.cfg
```

**Step 2: Add noatime to fstab**

```bash
echo "o" | sudo -S sed -i 's/defaults/defaults,noatime/' /etc/fstab
```

### Task 18: Intel i915 tuning

**Step 1: Create i915 modprobe config**

```bash
echo "o" | sudo -S tee /etc/modprobe.d/i915.conf > /dev/null <<'EOF'
options i915 enable_guc=2 enable_dc=4 enable_fbc=1
EOF
```

### Task 19: Install and enable system services

**Step 1: Install packages**

```bash
echo "o" | sudo -S xbps-install -Sy earlyoom irqbalance profile-sync-daemon intel-undervolt stress-ng
```

**Step 2: Enable runit services**

```bash
echo "o" | sudo -S ln -sf /etc/sv/earlyoom /var/service/
echo "o" | sudo -S ln -sf /etc/sv/irqbalance /var/service/
```

**Step 3: Configure and enable PSD**

```bash
# PSD runs as user service
psd  # First run generates config
# Edit ~/.config/psd/psd.conf if needed
```

### Task 20: Advanced TLP + Intel undervolt

**Step 1: Update TLP config**

```bash
echo "o" | sudo -S tee -a /etc/tlp.d/10-t490-battery-first.conf > /dev/null <<'EOF'
DISK_APM_LEVEL_ON_BAT="128"
SOUND_POWER_SAVE_ON_BAT=1
USB_AUTOSUSPEND=1
TPACPI_ENABLE=1
TPSMAPI_ENABLE=1
EOF
echo "o" | sudo -S sv restart tlp
```

**Step 2: Configure intel-undervolt**

```bash
echo "o" | sudo -S tee /etc/intel-undervolt.conf > /dev/null <<'EOF'
undervolt 0 'CPU' -80
undervolt 1 'GPU' -50
undervolt 2 'CPU Cache' -80
undervolt 3 'System Agent' 0
undervolt 4 'Analog I/O' 0
EOF
echo "o" | sudo -S intel-undervolt apply
```

**Step 3: Create intel-undervolt runit service**

```bash
echo "o" | sudo -S mkdir -p /etc/sv/intel-undervolt
echo "o" | sudo -S tee /etc/sv/intel-undervolt/run > /dev/null <<'SEOF'
#!/bin/sh
exec intel-undervolt apply && sleep infinity
SEOF
echo "o" | sudo -S chmod +x /etc/sv/intel-undervolt/run
echo "o" | sudo -S ln -sf /etc/sv/intel-undervolt /var/service/
```

**Step 4: Stress test undervolt stability**

```bash
stress-ng --cpu 4 --timeout 300
```

Expected: No crashes or throttling beyond normal for 5 minutes.

### Task 21: Powertop auto-tune runit service

**Step 1: Create service**

```bash
echo "o" | sudo -S mkdir -p /etc/sv/powertop-autotune
echo "o" | sudo -S tee /etc/sv/powertop-autotune/run > /dev/null <<'SEOF'
#!/bin/sh
exec 2>&1
powertop --auto-tune
exec pause
SEOF
echo "o" | sudo -S chmod +x /etc/sv/powertop-autotune/run
echo "o" | sudo -S ln -sf /etc/sv/powertop-autotune /var/service/
```

### Task 22: XLibre migration

**Step 1: Add XLibre repo**

```bash
printf "repository=https://github.com/xlibre-void/xlibre/releases/latest/download/\n" | \
  echo "o" | sudo -S tee /etc/xbps.d/99-repository-xlibre.conf
echo "o" | sudo -S xbps-install -S
```

**Step 2: Install xlibre-minimal**

```bash
echo "o" | sudo -S xbps-install -Sy xlibre-minimal
```

**Step 3: Test X session**

```bash
startx
```

Expected: dwm starts normally. If it fails, rollback:
```bash
echo "o" | sudo -S xbps-remove xlibre-minimal
echo "o" | sudo -S xbps-install -Sy xorg-minimal
```

---

## Gruvbox Consistency Pass

### Task 23: Verify and fix Gruvbox colors across all tools

**Files to check and update:**
- `~/dotfiles/suckless/dwm/config.h` (already gruvbox)
- `~/dotfiles/suckless/dmenu/config.h`
- `~/dotfiles/suckless/st/config.h`
- `~/dotfiles/stow/xresources/.Xresources`
- `~/dotfiles/stow/picom/.config/picom/picom.conf`
- `~/dotfiles/stow/dunst/.config/dunst/dunstrc`
- `~/dotfiles/stow/lf/.config/lf/lfrc`
- `~/dotfiles/stow/starship/.config/starship.toml`

**Canonical Gruvbox Dark Hard palette:**
```
bg:      #282828    fg:      #ebdbb2
bg1:     #3c3836    fg4:     #a89984
bg2:     #504945    gray:    #928374
red:     #cc241d    red1:    #fb4934
green:   #98971a    green1:  #b8bb26
yellow:  #d79921    yellow1: #fabd2f
blue:    #458588    blue1:   #83a598
purple:  #b16286    purple1: #d3869b
aqua:    #689d6a    aqua1:   #8ec07c
orange:  #d65d0e    orange1: #fe8019
```

Verify each file uses these exact hex values. Fix any deviations.

**Step 1: Update Terminus Nerd Font in all suckless config.h files**

Replace `"Terminus:pixelsize=22..."` with:
```c
"TerminessNerdFont:pixelsize=22:antialias=false:autohint=false"
```

In dwm, st, dmenu config.h.

**Step 2: Rebuild all suckless tools**

```bash
cd ~/dotfiles/suckless/src
for tool in dwm st dmenu dwmblocks; do
  cd "$tool"
  cp ~/dotfiles/suckless/${tool}/config.h config.h 2>/dev/null
  echo "o" | sudo -S make clean install
  cd ..
done
```

---

## Final Verification

### Task 24: End-to-end smoke test

**Step 1: Reboot**

```bash
echo "o" | sudo -S reboot
```

**Step 2: After reboot, verify checklist**

```
[ ] Silent boot (no kernel log spam)
[ ] startx launches dwm with gruvbox theme
[ ] dwmblocks shows Nerd Font icons
[ ] picom-ftlabs fade animations work
[ ] Super+c opens org-capture
[ ] Super+a opens org-agenda
[ ] Super+n opens org-roam-node-find
[ ] Super+grave toggles kitty scratchpad
[ ] Terminal swallows mpv/feh/zathura
[ ] Xresources colors load without recompile
[ ] emacsclient -c opens with full config
[ ] C-c g activates gptel
[ ] C-x g opens magit
[ ] C-x w opens elfeed
[ ] fzf-tab works in zsh
[ ] Starship prompt shows git info
[ ] atuin replaces Ctrl-R
[ ] dmenu-power shows power menu
[ ] dmenu-websearch opens DuckDuckGo
[ ] lf opens with previews
[ ] Battery thresholds: tlp-stat -b shows 75/85
[ ] Undervolt applied: intel-undervolt read
[ ] Services running: sv status earlyoom irqbalance
```
