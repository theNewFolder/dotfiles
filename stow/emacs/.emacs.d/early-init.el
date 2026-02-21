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
