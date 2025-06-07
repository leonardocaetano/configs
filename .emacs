;; ================================ USAGE

;; F5: cicle trough .c/.h
;; F6: ripgrep
;; F8: compile
;; F12: filetree
;; remember to use chmod u+x to be able to compile
;; M-x dired to create folders (+) and files (C-x C-f)

;; ================================ PLUGINS STUFF

;; initial prep for package stuff, adds the melpa mirror
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
			 
;; list the packages you want
(setq package-list
    '(evil smex deadgrep dired-sidebar)) ;; put your packages here!

;; activate all the packages
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
	
;; smex specific settings
(global-set-key (kbd "M-x") 'smex)

;; company specify settings ;; we disable autocomplete for now, too annoying!
;; (global-company-mode 1)
;; (with-eval-after-load 'company
;;   ;; Make TAB and S-TAB cycle through candidates
;;   (define-key company-active-map (kbd "TAB") 'company-select-next)
;;   (define-key company-active-map (kbd "<tab>") 'company-select-next)
;;   (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
;;   (define-key company-active-map (kbd "<backtab>") 'company-select-previous)
;;   (setq company-selection-wrap-around t))

;; deadgrep (you need to have ripgrep installed on your system and in your $PATH
(defun my-open-deadgrep-and-edit ()
  (interactive)
  (call-interactively #'deadgrep)
  (run-at-time "0.1 sec" nil
               (lambda ()
                 (when (derived-mode-p 'deadgrep-mode)
                   (deadgrep-edit-mode)))))
(global-set-key (kbd "<f6>") #'my-open-deadgrep-and-edit)

;; dired-sidebar
(use-package dired-sidebar
  :bind (("<f12>" . dired-sidebar-toggle-sidebar))
  :ensure nil
  :commands (dired-sidebar-toggle-sidebar))
(add-hook 'dired-mode-hook 'auto-revert-mode)
(setq global-auto-revert-non-file-buffers t)

;; evil 
(require 'evil)
(evil-mode 1)

;; ================================ INDENTATION STUFF

;; @NOTE: we should try to find a way to encapsulate this under a personal profile and provide other ones for when dealing with other's people code

;; --- C/C++

;; proper switch/case indent in C
(add-hook 'c-mode-common-hook
          (lambda ()
             (c-set-offset 'case-label '+)))

;; other C stuff
(setq c-default-style "bsd")
(setq-default indent-tabs-mode nil)
(setq c-basic-offset 4)
(setq default-tab-width 4)

;; puts closing brakets
(electric-pair-mode t) 

;; ================================ LANGUAGE-SPECIFIC STUFF

;; --- C/C++

;; cycle through .c/.cpp and .h using C-c
(add-hook 'c-mode-common-hook
  (lambda()
  (local-set-key  (kbd "<f5>") 'ff-find-other-file)))

;; ================================ CUSTOM THEME

(deftheme leo-theme)

(let ((fg "#ffffff")
      ;; (bg "#1e1e1e")
      (bg "#000000")
      (comment "#00ff00")
      (error-bg "#ff0000")
      (todo-bg "#0000ff")
      (cursor-line "#2e2e2e")
      (match-paren "#8fb3a0")
      (number "#03f4fc")
      (string "#f2ce6b")
      (status-line "#3a3a3a")
      (status-line-nc "#252525")
      (quickfix-bg "#3e4d8c")
      (inactive "#888888"))

  (custom-theme-set-faces
   'leo-theme

   ;; basic
   `(default ((t (:foreground ,fg :background ,bg))))
   `(cursor ((t (:background ,fg))))
   `(region ((t (:background ,cursor-line))))
   `(highlight ((t (:background ,cursor-line))))
   `(fringe ((t (:background ,bg))))
   `(vertical-border ((t (:foreground ,bg :background ,fg))))
   `(window-divider ((t (:foreground ,bg :background ,fg))))
   `(minibuffer-prompt ((t (:foreground ,fg))))
   `(mode-line ((t (:foreground ,fg :background ,status-line :box nil))))
   `(mode-line-inactive ((t (:foreground ,inactive :background ,status-line-nc :box nil))))
   `(hl-line ((t (:background ,cursor-line))))
   `(match ((t (:foreground ,fg :background ,match-paren))))
   `(error ((t (:foreground ,fg :background ,error-bg))))
   `(warning ((t (:foreground ,fg))))
   `(success ((t (:foreground ,fg))))

   ;; syntax
   `(font-lock-comment-face ((t (:foreground ,comment))))
   `(font-lock-constant-face ((t (:foreground ,fg))))
   `(font-lock-variable-name-face ((t (:foreground ,fg))))
   `(font-lock-function-name-face ((t (:foreground ,fg))))
   `(font-lock-keyword-face ((t (:foreground ,fg))))
   `(font-lock-preprocessor-face ((t (:foreground ,fg))))
   `(font-lock-type-face ((t (:foreground ,fg))))
   `(font-lock-builtin-face ((t (:foreground ,fg))))
   `(font-lock-string-face ((t (:foreground ,string))))
   `(font-lock-number-face ((t (:foreground ,number))))
   `(font-lock-warning-face ((t (:foreground ,fg :background ,todo-bg))))

   ;; dired/netrw equivalents
   `(dired-directory ((t (:foreground ,fg))))
   `(dired-flagged ((t (:foreground ,fg))))
   `(dired-header ((t (:foreground ,fg))))
   `(dired-mark ((t (:foreground ,fg))))
   `(dired-symlink ((t (:foreground ,fg))))

   ;; end of buffer
   `(default ((t (:foreground ,fg :background ,bg))))
   `(trailing-whitespace ((t (:background ,error-bg))))

   ;; quickfix
   `(compilation-info ((t (:foreground ,fg :background ,quickfix-bg))))
   ))

(enable-theme 'leo-theme)

(set-face-foreground 'vertical-border "#ffffff")

(defface my-number-face
  '((t :foreground "#03f4fc"))
  "Face for numeric literals (ints, floats, hex, bin).")

(defun my-colorize-numbers ()
  (font-lock-add-keywords
   nil
   '(;; Decimal integer and float (e.g. 42, 3.14, .5, 5.)
     ("\\b\\([0-9]+\\.?[0-9]*\\|\\.[0-9]+\\)\\([eE][-+]?[0-9]+\\)?\\b" . 'my-number-face)
     ;; Hexadecimal (e.g. 0x1F, 0XAB)
     ("\\b0[xX][0-9a-fA-F]+\\b" . 'my-number-face)
     ;; Binary (e.g. 0b1010)
     ("\\b0[bB][01]+\\b" . 'my-number-face))))

(add-hook 'prog-mode-hook #'my-colorize-numbers)

;; errors colors
(with-eval-after-load 'compile
  (set-face-attribute 'compilation-error nil :background "#440000" :foreground "#f1a492")
  (set-face-attribute 'compilation-warning nil :background "#444400" :foreground "yellow")
  (set-face-attribute 'compilation-info nil :background "#003300" :foreground "light green"))
  
;; highlight current line
;; (global-hl-line-mode 1) 

;; ================================ GLOBAL CONFIGS

;; disables menu-bar
(menu-bar-mode -1)

;; disables tool-bar
(tool-bar-mode -1)

;; disables scroll-bar
(toggle-scroll-bar -1)

;; enables auto-reload
(global-auto-revert-mode t)

;; removes splash-screen
(setq inhibit-splash-screen t)

;; removes the bind of f10 and f11
(global-unset-key (kbd "<f10>"))
(global-unset-key (kbd "<f11>"))

;; removes the fringe (aka these spaces on the horizontal sides of the buffers)
(set-fringe-mode '(0 . 1))

;; makes emacs to save all files as LF
(setq require-final-newline t)

;; disables the quit short-cut, for my own safety
(global-unset-key (kbd "C-x C-c")) 

;; sets the font config
(if (eq system-type 'gnu/linux)
  (set-frame-font "Liberation Mono-12" t t)
)
(if (eq system-type 'windows-nt)
  (set-frame-font "Liberation Mono 12")
)

;; fixes ctrl-u up
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)

;; asks for confirmation inside the minibuffer instead of opening a annoying window
;; @TODO

;; highlights @TODOs and other stuff
(setq fixme-modes '(c++-mode c-mode python-mode latex-mode emacs-lisp-mode))
(make-face 'font-lock-todo-face)
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-note-face)
(make-face 'font-lock-speed-face)
(mapc (lambda (mode)
	(font-lock-add-keywords
	 mode
	 '(("\\<\\(TODO\\)" 1 'font-lock-todo-face t)
	   ("\\<\\(FIXME\\)" 1 'font-lock-fixme-face t)
	   ("\\<\\(NOTE\\)" 1 'font-lock-note-face t)
           ("\\<\\(SPEED\\)" 1 'font-lock-speed-face t))))
      fixme-modes)
(modify-face 'font-lock-todo-face "Yellow" nil nil t nil t nil nil)
(modify-face 'font-lock-fixme-face "Yellow" nil nil t nil t nil nil)
(modify-face 'font-lock-note-face "Yellow" nil nil t nil t nil nil)
(modify-face 'font-lock-speed-face "Yellow" nil nil t nil t nil nil)

;; changes the cursor style
(setq-default cursor-type 'bar)

;; puts backup files away, without disabling it
(setq
   backup-by-copying t      ; doesn't clobber symlinks
   backup-directory-alist
   '(("." . "~/.emacs_saves/"))     ; doesn't litter my fs tree
   delete-old-versions t
   kept-new-versions 100
   kept-old-versions 20
   version-control t)       ; use versioned backups
(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs_saves/" t)))

;; disables the default minibuffer message
(defun display-startup-echo-area-message nil)

;; just a nice msg for you, the one who programs
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "


             stuff is going to get made")

;; sets a default directory for startup
(if (eq system-type 'gnu/linux)
    (setq default-directory "~/dev/")
)
(if (eq system-type 'windows-nt)
    (setq default-directory "c:/dev/")
)

;; the name of file open appears on window title
(setq frame-title-format "%b")

;; minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; show the number of matches on search
(defun my-isearch-update-post-hook()
  (let (suffix num-before num-after num-total)
    (setq num-before (count-matches isearch-string (point-min) (point)))
    (setq num-after (count-matches isearch-string (point) (point-max)))
    (setq num-total (+ num-before num-after))
    (setq suffix (if (= num-total 0)
                     ""
                   (format " [%d of %d]" num-before num-total)))
    (setq isearch-message-suffix-add suffix)
    (isearch-message)))
(add-hook 'isearch-update-post-hook 'my-isearch-update-post-hook)

;; ignore case when searching
(setq ac-ignore-case nil)

;; puts this custom-file stuff away
(defconst custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t 'noerror 'nomessage)

;; disable lockfiles
(setq create-lockfiles nil)

;; hide warmless errors
(setq native-comp-async-report-warnings-errors nil)

;; ================================ ZOOM FUNCTIONALITY

(when (display-graphic-p)
  ;; Save the original font height
  (defvar my/default-font-height (face-attribute 'default :height)
    "Default font height to reset to.")

  (defvar my/frame-scale-factor 1.0
    "Current scale factor for the frame.")

  (defun my/set-frame-scale (scale)
    "Set SCALE for the current frame."
    (interactive "nScale factor: ")
    (setq my/frame-scale-factor scale)
    (set-face-attribute 'default nil
                        :height (truncate (* my/default-font-height scale))))

  (defun my/increase-scale ()
    "Increase frame scale."
    (interactive)
    (my/set-frame-scale (+ my/frame-scale-factor 0.1)))

  (defun my/decrease-scale ()
    "Decrease frame scale."
    (interactive)
    (my/set-frame-scale (- my/frame-scale-factor 0.1)))

  (defun my/reset-scale ()
    "Reset frame scale to the original font height."
    (interactive)
    (my/set-frame-scale 1.0))

  ;; Keybindings
  (global-set-key (kbd "C-=") #'my/increase-scale)
  (global-set-key (kbd "C--") #'my/decrease-scale)
  (global-set-key (kbd "C-0") #'my/reset-scale))

;; ================================ COMPILATION

(defun find-build-script ()
  "Search upwards for build.sh or build.bat and return its path."
  (let ((filename (if (eq system-type 'windows-nt) "build.bat" "build.sh"))
        (dir (file-name-directory (or (buffer-file-name) default-directory)))
        (found nil)
        (root nil))
    (while (and (not found) (not (equal dir root)))
      (let ((candidate (expand-file-name filename dir)))
        (if (file-exists-p candidate)
            (setq found candidate)
          (setq root dir)
          (setq dir (file-name-directory (directory-file-name dir))))))
    found))

(defun build ()
  "Search for build.sh or build.bat and run it using `compile`."
  (interactive)
  (let ((script (find-build-script)))
    (if script
        (let ((default-directory (file-name-directory script))
              (compile-command (if (eq system-type 'windows-nt)
                                   "build.bat"
                                 "./build.sh")))
          (save-some-buffers t) ;; like `:wa`
          (compile compile-command))
      (message "No build.bat or build.sh found in directory hierarchy."))))

(global-set-key (kbd "<f8>") 'build)

;; hide full path of files

(defun my/find-project-root (dir)
  "Find project root starting from DIR by looking for build.bat, build.sh, or .git."
  (let ((parent (file-name-directory (directory-file-name dir))))
    (cond
     ((or (file-exists-p (expand-file-name "build.bat" dir))
          (file-exists-p (expand-file-name "build.sh" dir))
          (file-exists-p (expand-file-name ".git" dir)))
      dir)
     ((or (not parent) (equal parent dir))
      nil)
     (t
      (my/find-project-root parent)))))

(defun my/set-compilation-directory ()
  "Set `default-directory` inside compilation buffer to project root."
  (when (derived-mode-p 'compilation-mode)
    (let ((root (my/find-project-root default-directory)))
      (when root
        (setq-local default-directory root)))))

(defun my/compilation-filter-strip-full-paths ()
  "Strip full project path from compilation output, anywhere inside the text."
  (when (and (derived-mode-p 'compilation-mode)
             (boundp 'default-directory))
    (let* ((inhibit-read-only t)
           (root (expand-file-name default-directory))
           (is-windows (memq system-type '(windows-nt ms-dos)))
           (root-pattern (if is-windows
                             ;; Replace / with \\ for Windows
                             (replace-regexp-in-string "/" "\\\\" (regexp-quote root) t t)
                           ;; Linux/macOS
                           (regexp-quote root))))
      (save-excursion
        (goto-char compilation-filter-start)
        (while (re-search-forward root-pattern nil t)
          (replace-match ""))))))

(add-hook 'compilation-mode-hook #'my/set-compilation-directory)
(add-hook 'compilation-filter-hook #'my/compilation-filter-strip-full-paths)
 
;; ================================ EOF
