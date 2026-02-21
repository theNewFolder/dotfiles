;;; init.el -*- lexical-binding: t -*-

;; ── straight.el bootstrap ──────────────────────────────────────────────────
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

;; ── Performance ─────────────────────────────────────────────────────────────
(setq read-process-output-max (* 4 1024 1024)
      native-comp-async-report-warnings-errors 'silent
      byte-compile-warnings '(not obsolete)
      warning-suppress-log-types '((comp) (bytecomp)))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1)
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(use-package gcmh
  :demand t
  :config
  (gcmh-mode 1)
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 64 1024 1024)))

;; ── Core UI ─────────────────────────────────────────────────────────────────
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
        scroll-preserve-screen-position t
        bidi-paragraph-direction 'left-to-right)
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (global-display-line-numbers-mode 1)
  (setq display-line-numbers-type 'relative)
  (column-number-mode 1)
  (global-auto-revert-mode 1)
  (set-face-attribute 'default nil :family "DankMono Nerd Font" :height 140))

(use-package gruvbox-theme
  :demand t
  :config
  (load-theme 'gruvbox-dark-hard t)
  (custom-set-faces
   '(org-level-1 ((t (:foreground "#fb4934" :weight bold :height 1.3))))
   '(org-level-2 ((t (:foreground "#fabd2f" :weight bold :height 1.15))))
   '(org-level-3 ((t (:foreground "#b8bb26" :weight bold :height 1.05))))
   '(org-level-4 ((t (:foreground "#83a598" :weight semi-bold))))
   '(org-level-5 ((t (:foreground "#8ec07c"))))
   '(org-level-6 ((t (:foreground "#d3869b"))))
   '(org-level-7 ((t (:foreground "#fe8019"))))
   '(org-level-8 ((t (:foreground "#ebdbb2"))))
   '(org-document-title ((t (:foreground "#fabd2f" :weight bold :height 1.5))))
   '(org-done ((t (:foreground "#928374" :weight normal :strike-through t))))
   '(org-todo ((t (:foreground "#fb4934" :weight bold))))
   '(org-headline-done ((t (:foreground "#928374" :strike-through t))))
   '(org-date ((t (:foreground "#83a598" :underline t))))
   '(org-scheduled-today ((t (:foreground "#b8bb26"))))
   '(org-table ((t (:foreground "#83a598"))))
   '(org-tag ((t (:foreground "#928374" :weight bold :height 0.8))))))

;; ── Dashboard ───────────────────────────────────────────────────────────────
(use-package nerd-icons
  :demand t)

(use-package dashboard
  :demand t
  :after nerd-icons
  :config
  (setq dashboard-startup-banner (expand-file-name "banner.txt" user-emacs-directory)
        dashboard-banner-logo-title nil
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-show-shortcuts t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-icon-type 'nerd-icons
        dashboard-display-icons-p t
        dashboard-items '((agenda . 10)
                          (recents . 7)
                          (bookmarks . 5))
        dashboard-heading-icons '((recents   . "nf-oct-history")
                                  (agenda    . "nf-oct-calendar")
                                  (bookmarks . "nf-oct-bookmark"))
        dashboard-week-agenda nil
        dashboard-agenda-sort-strategy '(priority-down time-up)
        dashboard-agenda-release-buffers t)

  (setq dashboard-navigator-buttons
    `(((,(nerd-icons-octicon "nf-oct-book" :height 1.1) "Roam" "org-roam-node-find"
        (lambda (&rest _) (org-roam-node-find)))
       (,(nerd-icons-octicon "nf-oct-tasklist" :height 1.1) "Agenda" "org-agenda"
        (lambda (&rest _) (org-agenda nil "g")))
       (,(nerd-icons-octicon "nf-oct-pencil" :height 1.1) "Capture" "org-capture"
        (lambda (&rest _) (org-capture)))
       (,(nerd-icons-octicon "nf-oct-history" :height 1.1) "Today" "daily note"
        (lambda (&rest _) (org-roam-dailies-goto-today))))))

  (setq dashboard-footer-messages
        '("dwm: M-j/k focus | M-S-RET term | M-d dmenu | M-b bar | M-S-q quit"
          "SPC SPC M-x | SPC . find-file | SPC b b switch-buf | SPC f r recent"
          "SPC n f roam-find | SPC n i insert-link | SPC n d t daily | SPC n j journal"
          "SPC o a agenda | SPC o c capture | SPC o i inbox | SPC g s magit"
          "SPC s s line-search | SPC s r ripgrep | SPC a a gptel | SPC t t vterm"
          ", t todo | , s schedule | , d deadline | , r refile | , p priority"
          "Evil: gc comment | ys surround | cs change-surr | ds del-surr"
          "Org: TAB fold | S-TAB fold-all | C-RET new-head | M-RET sub-head"
          "GTD: C-c c capture | i inbox | t task | n note | w weekly-review"))

  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice 'dashboard-open))

;; ── Evil Mode ───────────────────────────────────────────────────────────────
(use-package evil
  :demand t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-d-scroll t
        evil-want-C-i-jump nil
        evil-search-module 'evil-search
        evil-split-window-below t
        evil-vsplit-window-right t
        evil-undo-system 'undo-redo
        evil-respect-visual-line-mode t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (evil-set-initial-state 'eshell-mode 'insert))

(use-package evil-collection
  :after evil
  :demand t
  :config
  (evil-collection-init))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (evil-org-set-key-theme '(navigation insert textobjects additional calendar))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-surround
  :after evil
  :demand t
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :demand t
  :config
  (evil-commentary-mode 1))

;; ── General.el (SPC leader) ─────────────────────────────────────────────────
(use-package general
  :demand t
  :config
  (general-evil-setup)
  (general-create-definer my/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")
  (general-create-definer my/local-leader
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix ","
    :global-prefix "M-,")

  (my/leader-keys
    "SPC" '(execute-extended-command :wk "M-x")
    "."   '(find-file :wk "find file")
    ";"   '(eval-expression :wk "eval")

    "b"   '(:ignore t :wk "buffer")
    "bb"  '(consult-buffer :wk "switch")
    "bd"  '(kill-this-buffer :wk "kill")
    "bi"  '(ibuffer :wk "ibuffer")
    "bs"  '(save-buffer :wk "save")

    "f"   '(:ignore t :wk "file")
    "ff"  '(find-file :wk "find")
    "fs"  '(save-buffer :wk "save")
    "fr"  '(consult-recent-file :wk "recent")

    "w"   '(:keymap evil-window-map :wk "window")

    "n"   '(:ignore t :wk "notes")
    "nf"  '(org-roam-node-find :wk "find node")
    "ni"  '(org-roam-node-insert :wk "insert node")
    "nc"  '(org-roam-capture :wk "capture")
    "nb"  '(org-roam-buffer-toggle :wk "backlinks")
    "nd"  '(:ignore t :wk "dailies")
    "ndt" '(org-roam-dailies-goto-today :wk "today")
    "ndT" '(org-roam-dailies-goto-tomorrow :wk "tomorrow")
    "ndy" '(org-roam-dailies-goto-yesterday :wk "yesterday")
    "nj"  '(org-roam-dailies-capture-today :wk "journal")

    "o"   '(:ignore t :wk "org")
    "oa"  '(org-agenda :wk "agenda")
    "oc"  '(org-capture :wk "capture")
    "oi"  '(my/org-capture-inbox :wk "inbox")
    "ol"  '(org-store-link :wk "store link")

    "g"   '(:ignore t :wk "git")
    "gs"  '(magit-status :wk "status")
    "gl"  '(magit-log-current :wk "log")
    "gd"  '(magit-diff :wk "diff")
    "gt"  '(git-timemachine :wk "timemachine")

    "s"   '(:ignore t :wk "search")
    "ss"  '(consult-line :wk "line")
    "sg"  '(consult-grep :wk "grep")
    "sr"  '(consult-ripgrep :wk "ripgrep")
    "so"  '(consult-org-heading :wk "org heading")

    "a"   '(:ignore t :wk "ai")
    "aa"  '(gptel-send :wk "send")
    "am"  '(gptel-menu :wk "menu")

    "q"   '(:ignore t :wk "query")
    "qq"  '(org-ql-search :wk "search")
    "qv"  '(org-ql-view :wk "views")

    "t"   '(:ignore t :wk "toggle")
    "tt"  '(vterm :wk "terminal")
    "tw"  '(elfeed :wk "elfeed")
    "tz"  '(visual-fill-column-mode :wk "zen"))

  (with-eval-after-load 'org
    (my/local-leader
      :keymaps 'org-mode-map
      "t"  '(org-todo :wk "todo state")
      "T"  '(org-set-tags-command :wk "set tags")
      "s"  '(org-schedule :wk "schedule")
      "d"  '(org-deadline :wk "deadline")
      "p"  '(org-priority :wk "priority")
      "r"  '(org-refile :wk "refile")
      "e"  '(org-set-effort :wk "effort")
      "n"  '(org-add-note :wk "add note")
      "i"  '(:ignore t :wk "insert")
      "il" '(org-insert-link :wk "link")
      "ih" '(org-insert-heading :wk "heading")
      "x"  '(org-export-dispatch :wk "export")
      "c"  '(org-toggle-checkbox :wk "checkbox")
      "b"  '(:ignore t :wk "babel")
      "be" '(org-babel-execute-src-block :wk "execute")
      "bt" '(org-babel-tangle :wk "tangle"))))

;; ── Completion Stack ────────────────────────────────────────────────────────
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

;; ── YASnippet ───────────────────────────────────────────────────────────────
(use-package yasnippet
  :demand t
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (yas-global-mode 1))

;; ── Org Mode ────────────────────────────────────────────────────────────────
(use-package org
  :straight (:type built-in)
  :hook (org-mode . visual-line-mode)
  :config
  (setq org-directory "~/org"
        org-default-notes-file "~/org/inbox.org"
        org-agenda-files '("~/org/inbox.org"
                           "~/org/projects/projects.org"
                           "~/org/projects/tasks.org"
                           "~/org/projects/todo.org"
                           "~/org/areas/habits.org"
                           "~/org/areas/agenda.org"
                           "~/org/areas/meetings.org"
                           "~/org/reviews.org")
        org-log-done 'time
        org-log-into-drawer t
        org-return-follows-link t
        org-confirm-babel-evaluate nil
        org-startup-indented t
        org-startup-folded 'overview
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-ellipsis " ▾"
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-edit-src-content-indentation 0
        org-src-window-setup 'current-window
        org-image-actual-width '(600))

  ;; Babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     (C . t)))

  ;; Structure templates (C-c C-,)
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("cc" . "src C"))

  ;; ── TODO keywords ──────────────────────────────────────────────────────
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n!)" "STARTED(s!)" "WAITING(w@/!)" "|"
                    "DONE(d!)" "DROPPED(x@/!)")
          (sequence "PROJECT(p)" "|" "DONE_PROJECT(D!)")
          (sequence "SOMEDAY(S)" "|" "ACTIVATED(A!)")))
  (setq org-todo-keyword-faces
        '(("TODO"     . (:foreground "#fb4934" :weight bold))
          ("NEXT"     . (:foreground "#fabd2f" :weight bold))
          ("STARTED"  . (:foreground "#83a598" :weight bold))
          ("WAITING"  . (:foreground "#d3869b" :weight bold))
          ("SOMEDAY"  . (:foreground "#928374" :weight bold))
          ("PROJECT"  . (:foreground "#8ec07c" :weight bold))
          ("DONE"     . (:foreground "#b8bb26" :weight normal))
          ("DROPPED"  . (:foreground "#928374" :weight normal :strike-through t))))

  (defun my/log-todo-next-activation (&rest _)
    (when (and (string= (org-get-todo-state) "NEXT")
               (not (org-entry-get nil "ACTIVATED")))
      (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d %a]"))))
  (add-hook 'org-after-todo-state-change-hook #'my/log-todo-next-activation)

  ;; ── Tags ───────────────────────────────────────────────────────────────
  (setq org-tag-alist
        '((:startgroup) ("@home" . ?h) ("@work" . ?w) ("@laptop" . ?l)
          ("@phone" . ?p) ("@errand" . ?e) (:endgroup)
          ("inbox"    . ?i) ("someday"  . ?s) ("review"   . ?r)
          ("project"  . ?P) ("meeting"  . ?m) ("habit"    . ?H)
          ("learning" . ?L) ("reading"  . ?R) ("deep"     . ?d)))

  ;; ── Refile ─────────────────────────────────────────────────────────────
  (setq org-refile-targets
        '(("~/org/projects/projects.org" :maxlevel . 3)
          ("~/org/someday.org" :level . 1)
          ("~/org/areas/agenda.org" :maxlevel . 2)
          ("~/org/archive/archive.org" :maxlevel . 2)
          (nil :maxlevel . 3)))
  (setq org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)

  (defun my/gtd-save-org-buffers ()
    (save-some-buffers t (lambda ()
      (when (member (buffer-file-name) org-agenda-files) t))))
  (advice-add 'org-refile :after (lambda (&rest _) (my/gtd-save-org-buffers)))

  ;; ── Capture Templates ──────────────────────────────────────────────────
  (setq org-capture-templates
        `(("i" "Inbox" entry (file "~/org/inbox.org")
           ,(concat "* TODO %?\n"
                    "  :PROPERTIES:\n  :CREATED: %U\n  :END:\n"
                    "  %a\n")
           :empty-lines 1)
          ("t" "Task" entry (file+headline "~/org/projects/tasks.org" "Active")
           "* TODO %? :@inbox:\n  SCHEDULED: %T\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n"
           :empty-lines 1)
          ("n" "Note" entry (file+headline "~/org/inbox.org" "Notes")
           "* %? :note:\n  %U\n" :empty-lines 1)
          ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
           "* %<%H:%M> %?\n" :tree-type week)
          ("m" "Meeting" entry (file+headline "~/org/areas/meetings.org" "Upcoming")
           ,(concat "* %? :meeting:\n"
                    "  <%<%Y-%m-%d %a %H:00>>\n\n"
                    "** Attendees\n\n** Notes\n\n** Action Items\n")
           :empty-lines 1)
          ("s" "Someday" entry (file+headline "~/org/someday.org" "Someday")
           "* SOMEDAY %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n"
           :empty-lines 1)
          ("b" "Bookmark" entry (file+headline "~/org/resources/bookmarks.org" "Unsorted")
           "* [[%^{URL}][%^{Title}]] :bookmark:\n  %U\n  %?\n" :empty-lines 1)
          ("H" "Habit" entry (file "~/org/areas/habits.org")
           "* TODO %?\n  SCHEDULED: %^t\n  :PROPERTIES:\n  :STYLE: habit\n  :END:\n"
           :empty-lines 1)
          ("f" "Fleeting Note" entry (file "~/org/inbox.org")
           "* %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  %a"
           :empty-lines 1)
          ("r" "Reference" entry (file "~/org/inbox.org")
           ,(concat "* %^{Title}\n"
                    "  :PROPERTIES:\n"
                    "  :SOURCE: %^{Source URL or book}\n"
                    "  :AUTHOR: %^{Author}\n"
                    "  :CREATED: %U\n"
                    "  :END:\n\n  %?")
           :empty-lines 1)
          ("w" "Weekly Review" entry
           (file+olp+datetree "~/org/reviews.org")
           (file "~/org/templates/weekly-review.org")
           :clock-in t :clock-resume t)
          ("W" "Web Capture" entry
           (file+headline "~/org/inbox.org" "Web")
           "* TODO %:annotation\n  %U\n  %:initial\n  %?\n"
           :empty-lines 1)))

  (add-hook 'org-capture-mode-hook 'delete-other-windows)

  ;; ── Agenda ─────────────────────────────────────────────────────────────
  (setq org-agenda-start-with-log-mode t
        org-agenda-window-setup 'current-window
        org-agenda-span 'day
        org-agenda-start-day nil
        org-deadline-warning-days 7
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-stuck-projects '("+TODO=\"PROJECT\"" ("NEXT" "STARTED") nil ""))

  (defun my/org-skip-subtree-if-habit ()
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (if (string= (org-entry-get nil "STYLE") "habit") subtree-end nil)))

  (defun my/org-skip-subtree-if-priority (priority)
    (let ((subtree-end (save-excursion (org-end-of-subtree t)))
          (pri-value (* 1000 (- org-lowest-priority priority)))
          (pri-current (org-get-priority (thing-at-point 'line t))))
      (if (= pri-value pri-current) subtree-end nil)))

  (setq org-agenda-custom-commands
        '(("g" "GTD Dashboard"
           ((agenda ""
                    ((org-agenda-span 1)
                     (org-agenda-skip-function
                      '(org-agenda-skip-entry-if 'deadline))
                     (org-deadline-warning-days 0)
                     (org-agenda-overriding-header "TODAY\n")))
            (todo "STARTED"
                  ((org-agenda-overriding-header "\nIN PROGRESS\n")))
            (todo "NEXT"
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-agenda-prefix-format "  %i %-12:c [%e] ")
                   (org-agenda-overriding-header "\nNEXT ACTIONS\n")))
            (todo "WAITING"
                  ((org-agenda-overriding-header "\nWAITING\n")))
            (agenda nil
                    ((org-agenda-entry-types '(:deadline))
                     (org-agenda-format-date "")
                     (org-deadline-warning-days 7)
                     (org-agenda-overriding-header "\nDEADLINES (7d)\n")))
            (tags-todo "+inbox"
                       ((org-agenda-prefix-format "  %?-12t% s")
                        (org-agenda-overriding-header "\nINBOX (process)\n")))
            (tags "CLOSED>=\"<today>\""
                  ((org-agenda-overriding-header "\nDONE TODAY\n")))))
          ("c" . "By Context")
          ("cw" "@work"   tags-todo "@work")
          ("ch" "@home"   tags-todo "@home")
          ("cl" "@laptop" tags-todo "@laptop")
          ("ce" "@errand" tags-todo "@errand")
          ("W" "Weekly Review"
           ((agenda "" ((org-agenda-span 7)
                        (org-agenda-overriding-header "This Week")))
            (todo "WAITING"
                  ((org-agenda-overriding-header "Waiting For")))
            (todo "SOMEDAY"
                  ((org-agenda-overriding-header "Someday/Maybe")))
            (todo "PROJECT"
                  ((org-agenda-overriding-header "Active Projects")))
            (tags "CLOSED>=\"<-1w>\""
                  ((org-agenda-overriding-header "Done This Week")))))
          ("!" "High Priority"
           ((tags "PRIORITY=\"A\""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'todo 'done))
                   (org-agenda-overriding-header "HIGH PRIORITY")))))))

  (setq org-agenda-hide-tags-regexp
        (regexp-opt '("project" "inbox" "@work" "@home" "@laptop")))

  ;; ── Habit ──────────────────────────────────────────────────────────────
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 40)

  ;; ── Clock ──────────────────────────────────────────────────────────────
  (setq org-clock-persist 'history
        org-clock-into-drawer t
        org-clock-out-remove-zero-time-clocks t)
  (org-clock-persistence-insinuate)

  ;; ── Checkbox reset for repeating tasks ─────────────────────────────────
  (defun my/org-reset-checkbox-state-maybe ()
    (when (org-entry-get (point) "RESET_CHECK_BOXES")
      (org-reset-checkbox-state-subtree)))
  (defun my/org-checklist-hook ()
    (when (member org-state org-done-keywords)
      (my/org-reset-checkbox-state-maybe)))
  (add-hook 'org-after-todo-state-change-hook 'my/org-checklist-hook))

;; ── Org visual ──────────────────────────────────────────────────────────────
(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✦")))

(use-package visual-fill-column
  :hook (org-mode . visual-fill-column-mode)
  :config
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t))

;; ── Org Super Agenda ────────────────────────────────────────────────────────
(use-package org-super-agenda
  :after org
  :demand t
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "Now" :todo ("STARTED") :order 0)
          (:name "Overdue" :deadline past :order 1)
          (:name "Due Today" :deadline today :scheduled today :order 2)
          (:name "Next Actions" :todo "NEXT" :order 3)
          (:name "High Priority" :priority "A" :order 4)
          (:name "Habits" :habit t :order 8)
          (:name "Waiting" :todo "WAITING" :order 9)
          (:name "Someday" :todo "SOMEDAY" :order 10)
          (:discard (:anything t)))))

;; ── Org Roam ────────────────────────────────────────────────────────────────
(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org/roam/"))
  (org-roam-completion-everywhere t)
  (org-roam-database-connector 'sqlite-builtin)
  (org-roam-dailies-directory "daily/")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)

  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:20}" 'face 'org-tag)))

  (cl-defmethod org-roam-node-type ((node org-roam-node))
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))

  (defun my/org-roam-tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'my/org-roam-tag-new-node-as-draft)

  (setq org-roam-capture-templates
        '(("z" "Zettel" plain
           "#+filetags: :draft:\n\n%?"
           :if-new (file+head "zettel/${slug}.org"
                              "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t)
          ("r" "Reference" plain
           "* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nURL: %^{URL}\n\n* Summary\n\n%?\n\n* Key Ideas\n\n"
           :if-new (file+head "reference/${slug}.org"
                              "#+title: ${title}\n#+filetags: :reference:\n#+date: %U\n")
           :unnarrowed t)
          ("p" "Project" plain
           "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Log\n\n* Resources\n\n"
           :if-new (file+head "projects/${slug}.org"
                              "#+title: ${title}\n#+category: ${title}\n#+filetags: :project:\n")
           :unnarrowed t)
          ("c" "Contact" plain
           "* Details\n  :PROPERTIES:\n  :EMAIL: %^{Email}\n  :PHONE: %^{Phone}\n  :END:\n\n* Notes\n\n%?\n\n"
           :if-new (file+head "people/${slug}.org"
                              "#+title: ${title}\n#+filetags: :person:\n")
           :unnarrowed t)
          ("a" "Area" plain "%?"
           :if-new (file+head "areas/${slug}.org"
                              "#+title: ${title}\n#+filetags: :area:\n#+date: %U\n")
           :unnarrowed t)
          ("s" "Code Snippet" plain
           "* Source\n%^{Language|shell|emacs-lisp|python|c}\n\n* Code\n\n#+begin_src %\\1\n%?\n#+end_src\n\n* Explanation\n\n"
           :if-new (file+head "zettel/${slug}.org"
                              "#+title: ${title}\n#+filetags: :snippet:\n#+date: %U\n")
           :unnarrowed t)
          ("l" "Literature Note" plain
           "* Source\n\n- Author: %^{Author}\n- Title: ${title}\n- URL: %^{URL}\n\n* Summary\n\n%?\n\n* Key Ideas\n\n- \n"
           :if-new (file+head "reference/${slug}.org"
                              "#+title: ${title}\n#+filetags: :literature:\n#+date: %U\n")
           :unnarrowed t)))

  (setq org-roam-dailies-capture-templates
        (let ((head (concat "#+title: %<%Y-%m-%d %A>\n"
                            "#+filetags: :daily:\n"
                            "#+startup: showall\n\n"
                            "* Intentions\nThe ONE thing today: _\n\n"
                            "* Log\n\n"
                            "* Tasks\n\n"
                            "* Notes\n\n")))
          `(("d" "default" entry "* %<%H:%M> %?"
             :target (file+head "daily/%<%Y-%m-%d>.org" ,head)
             :unnarrowed t)
            ("t" "Task" item "[ ] %a"
             :target (file+head "daily/%<%Y-%m-%d>.org" ,head)
             :olp ("Tasks") :immediate-finish t)
            ("n" "Note" entry "* %<%H:%M> %?"
             :target (file+head "daily/%<%Y-%m-%d>.org" ,head)
             :olp ("Notes") :unnarrowed t))))

  ;; Keep agenda synced with :project: tagged roam nodes
  (defun my/org-roam-filter-by-tag (tag-name)
    (lambda (node) (member tag-name (org-roam-node-tags node))))
  (defun my/org-roam-list-notes-by-tag (tag-name)
    (mapcar #'org-roam-node-file
      (seq-filter (my/org-roam-filter-by-tag tag-name)
                  (org-roam-node-list))))
  (defun my/org-roam-refresh-agenda-list ()
    (interactive)
    (setq org-agenda-files
      (append '("~/org/inbox.org"
                "~/org/projects/projects.org"
                "~/org/projects/tasks.org"
                "~/org/projects/todo.org"
                "~/org/areas/habits.org"
                "~/org/areas/agenda.org"
                "~/org/areas/meetings.org"
                "~/org/reviews.org")
              (my/org-roam-list-notes-by-tag "project"))))
  (my/org-roam-refresh-agenda-list)

  (defun my/org-capture-inbox ()
    (interactive)
    (org-capture nil "i"))

  ;; Copy DONE tasks to today's daily
  (defun my/org-roam-copy-todo-to-today ()
    (when (equal org-state "DONE")
      (let ((org-refile-keep t)
            (org-roam-dailies-capture-templates
              '(("t" "tasks" entry "%?"
                 :if-new (file+head+olp "%<%Y-%m-%d>.org"
                                        "#+title: %<%Y-%m-%d>\n"
                                        ("Tasks")))))
            (org-after-refile-insert-hook #'save-buffer)
            today-file pos)
        (save-window-excursion
          (org-roam-dailies--capture (current-time) t)
          (setq today-file (buffer-file-name))
          (setq pos (point)))
        (unless (equal (file-truename today-file)
                       (file-truename (buffer-file-name)))
          (org-refile nil nil (list "Tasks" today-file nil pos))))))
  (add-to-list 'org-after-todo-state-change-hook
               #'my/org-roam-copy-todo-to-today))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t))

(require 'org-protocol)

;; ── GitHub PKM ──────────────────────────────────────────────────────────────
(defun my/gh-issues-to-org (repo)
  "Fetch open GitHub issues for REPO and insert as org TODO items."
  (interactive "sRepo (owner/name): ")
  (let ((output (shell-command-to-string
                 (format "gh issue list --repo %s --state open --limit 20 --json number,title,labels,url -t '{{range .}}* TODO [[{{.url}}][#{{.number}} {{.title}}]]{{range .labels}} :{{.name}}:{{end}}\n  SCHEDULED: <%(format-time-string \"%%Y-%%m-%%d\")>\n{{end}}'" repo))))
    (insert output)))

(defun my/gh-notifications-to-org ()
  "Fetch GitHub notifications and insert as org items."
  (interactive)
  (let ((output (shell-command-to-string
                 "gh api notifications --jq '.[] | \"* TODO \" + .subject.title + \" :\" + .repository.name + \":\" + \"\n  \" + .subject.url + \"\n\"' 2>/dev/null")))
    (if (string-empty-p output)
        (message "No GitHub notifications.")
      (insert output))))

;; ── Literate Config ─────────────────────────────────────────────────────────
(defun my/org-babel-tangle-config ()
  "Tangle config.org on save."
  (when (string-equal (buffer-file-name)
                      (expand-file-name "config.org" user-emacs-directory))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'my/org-babel-tangle-config nil t)))

;; ── Git ─────────────────────────────────────────────────────────────────────
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package git-timemachine
  :defer t)

(use-package diff-hl
  :demand t
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;; ── RSS ─────────────────────────────────────────────────────────────────────
(use-package elfeed
  :bind ("C-x w" . elfeed)
  :config
  (setq elfeed-search-filter "@1-week-ago +unread"))

(use-package elfeed-org
  :after elfeed
  :demand t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/org/areas/elfeed.org")))

;; ── AI ──────────────────────────────────────────────────────────────────────
(use-package gptel
  :bind (("C-c g" . gptel-send)
         ("C-c G" . gptel-menu))
  :config
  (setq gptel-model 'claude-sonnet-4-20250514
        gptel-default-mode 'org-mode
        gptel-org-branching-context t)
  (gptel-make-gemini "Gemini"
    :key (lambda () (getenv "GEMINI_API_KEY"))
    :stream t))

;; ── Org-ql (query language for org-mode) ────────────────────────────────────
(use-package org-ql
  :after org
  :commands (org-ql-search org-ql-view))

;; ── Dev Tools ───────────────────────────────────────────────────────────────
(use-package eglot
  :straight (:type built-in)
  :hook ((python-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (sh-mode . eglot-ensure)))

(use-package vterm
  :bind ("C-c t" . vterm)
  :config
  (setq vterm-max-scrollback 10000))

(use-package dired
  :straight (:type built-in)
  :config
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-dwim-target t
        dired-auto-revert-buffer t))

;; ── Server ──────────────────────────────────────────────────────────────────
(use-package server
  :straight (:type built-in)
  :config
  (unless (server-running-p) (server-start)))
