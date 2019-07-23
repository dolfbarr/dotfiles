(defun cfg:reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (defaulmy-start-timet current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

(cfg:reverse-input-method 'russian-computer)

;; Remove Odd gui elements
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))
(setq inhibit-splash-screen   t)
(setq ingibit-startup-message t)



;; Electric Modes
(electric-pair-mode 1)

;; Delete selection
(delete-selection-mode t)

;; Display file size/time in mode-line
(setq display-time-24hr-format t)
(display-time-mode             t)
(size-indication-mode          t)
(setq-default standart-indent  2)


;; Syntax highlighting
(require 'font-lock)
(global-font-lock-mode             t)
(setq font-lock-maximum-decoration t)

;; Highlight search resaults
(setq search-highlight        t)
(setq query-replace-highlight t)

;; Show Paren Modes
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)

;; System Type Detection
(defun is-linux-system()
  (string-equal system-type "gnu/linux"))
(defun is-windows-system()
  (string-equal system-type "windows-nt"))
(defun is-mac-system()
  (string-equal system-type "darwin"))

;; User Details
(setq user-name  "%user-name%")
(setq user-email "%user-mail%")

;; Server Mode for *nix family
(when (or (is-linux-system) (is-mac-system))
  (require 'server)
  (unless (server-running-p)
    (server-start)))

;; MELPA Init
(setq package-list '(material-theme rainbow-delimiters column-marker git-gutter neotree all-the-icons multi-term xscheme dashboard lorem-ipsum projectile highlight-indentation company org-journal))

(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(unless package-archive-contents ;; Fetch the list of packages available
  (package-refresh-contents))

(dolist (package package-list) ;; Install the missing packages
  (unless (package-installed-p package)
    (package-install package)))

;; Theme
(load-theme 'material t)

;; Frame Title Format
(setq frame-title-format
          '(buffer-file-name "%f"
            (dired-directory dired-directory "%b")))

;; Rainbow Delemiters in prog mode
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Column Marker
(require 'column-marker)
(add-hook 'prog-mode-hook (lambda () (interactive) (column-marker-1 120)))

;; Whitespace
(require 'whitespace)

(add-hook 'prog-mode-hook
  (function (lambda ()
              (whitespace-mode t))))
(setq whitespace-style '(face trailing spaces space-mark))

;; Highlight line
(global-hl-line-mode +1)

;; Linum
(require 'linum)
(line-number-mode        t)
(global-linum-mode       t)
(column-number-mode      t)
(setq linum-format  "%d")
(add-hook 'prog-mode-hook 'linum-mode)
;; Custom face/function to pad the line number in a way that does not conflict with whitespace-mode
(defface linum-padding
  `((t :inherit 'linum
       :foreground ,(face-attribute 'linum :background nil t)))
  "Face for displaying leading zeroes for line numbers in display margin."
  :group 'linum)

(defun linum-format-func (line)
  (let ((w (length
            (number-to-string (count-lines (point-min) (point-max))))))
    (concat
     (propertize " " 'face 'linum-padding)
     (propertize (make-string (- w (length (number-to-string line))) ?0)
                 'face 'linum-padding)
     (propertize (number-to-string line) 'face 'linum)
     (propertize " " 'face 'linum-padding)
     )))

(setq linum-format 'linum-format-func)

;; Git Gutter
(global-git-gutter-mode +1)

;; Code Highlight
(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)

;; Shorter lines
(fset 'yes-or-no-p 'y-or-n-p)

;; Neotree
(require 'neotree)
(defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (if (neo-global--window-exists-p)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name)))
        (message "Could not find git project root."))))
(global-set-key [f8] 'neotree-project-dir)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq projectile-switch-project-action 'neotree-projectile-action)
(setq-default neo-show-hidden-files t)

;; All The Icons
(require 'all-the-icons)

;; Multi-Term
(global-set-key (kbd "<f7>") 'multi-term-dedicated-toggle)
(add-hook 'term-mode-hook 'my-inhibit-global-linum-mode)

(defun my-inhibit-global-linum-mode ()
  "Counter-act `global-linum-mode'."
  (add-hook 'after-change-major-mode-hook
            (lambda () (linum-mode 0))
            :append :local))
(require 'cl-lib)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (cl-letf (((symbol-function #'process-list) (lambda ())))
    ad-do-it))

;; Shift the selected region right if distance is postive, left if
;; negative

(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:

(global-set-key [C-S-right] 'shift-right)
(global-set-key [C-S-left] 'shift-left)

;; Org Mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)

(setq org-agenda-files '("~/Dropbox/org/"))

;; Dashboard
(dashboard-setup-startup-hook)
(setq dashboard-items '((recents  . 2)
                        (bookmarks . 10)
                        (projects . 10)
                        (agenda . 20)))
(setq dashboard-startup-banner 'logo)
(setq dashboard-banner-logo-title (concat "Happy hacking on Emacs v." emacs-version " @ " (emacs-init-time) ", " (user-login-name)))

;; MIT\GNU Scheme
(require 'xscheme)

;; Javascript

;; HTML/CSS/LESS/SASS

;; Projectile
(projectile-mode)

;; Highlight-indentation
(require 'highlight-indentation)
(add-hook 'prog-mode-hook 'highlight-indentation-mode)

;; IDO
(require 'ido)
(ido-mode                      t)
(icomplete-mode                t)
(ido-everywhere                t)
(setq ido-vitrual-buffers      t)
(setq ido-enable-flex-matching t)

;; Company
(add-hook 'prog-mode-hook 'company-mode)


;; Journal
(require 'org-journal)
(setq org-journal-dir '"~/Dropbox/org/journal")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org-journal company highlight-indentation projectile lorem-ipsum dashboard multi-term all-the-icons neotree git-gutter column-marker rainbow-delimiters material-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )