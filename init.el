;; From http://bzg.fr/emacs-strip-tease.html
;; disable startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
;; Prevent the cursor from blinking
; (blink-cursor-mode 0)
;; Don't let Emacs hurt your ears
(setq visible-bell nil)


;; You cat set `inhibit-startup-echo-area-message' from the
;; customization interface:
;; M-x customize-variable RET inhibit-startup-echo-area-message RET
;; then enter your username
(setq inhibit-startup-echo-area-message "evert")


;; Remove the scroll bar, tool bar and menu bar
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)

;; See http://www.gnu.org/software/emacs/manual/html_node/emacs/Tags.html
(setq tags-table-list
           '("directory1" 
			 "directory2"))

; emacs package manager el-get; see https://github.com/dimitri/el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'no-error)
  (with-current-buffer
	  (url-retrieve-synchronously
	   "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
	(let (el-get-master-branch)
	  (goto-char (point-max))
	  (eval-print-last-sexp))))
(el-get 'sync)

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(load-file "~/.emacs.d/websocket.el")

(defun toggle-selective-display ()
  (interactive)
  (set-selective-display (if selective-display nil 1)))


(setq ispell-dictionary 'british)
(setq ansi-color-for-comint-mode t)
(setq fill-column 72)
(setq show-trailing-whitespace 0)
(load-theme 'zenburn t)

(load-file "~/.emacs.d/abbrev_defs.el")
(setq dabbrev-case-replace nil)
(setq abbrev-mode t)


(setq load-path (cons "~/.emacs.d/" load-path))
; (autoload 'python-mode "python-mode" "Python editing mode." t)
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(autoload 'javascript-mode "javascript-mode" "JavaScript editing mode." t)

; (require 'ipython)

(put 'downcase-region 'disabled nil)
(put 'eval-expression 'disabled nil)
(setq-default standard-indent 4)
(global-font-lock-mode t)
(add-hook 'tex-mode-hook 'turn-on-font-lock)
(add-hook 'c-mode-hook 'turn-on-font-lock)
; (add-hook 'python-mode-hook 'turn-on-font-lock)


;(add-hook 'LaTeX-mode-hook 'flyspell-mode)
;(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)

(setq auto-mode-alist (cons '("\\.txt\\'" . text-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pl\\'" . perl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cpp\\'" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.js\\'" . javascript-mode) auto-mode-alist))

; get rid of that irritating (default) newline question when saving
(setq require-final-newline nil)


(when window-system
  ;; enable wheelmouse support by default
  (mwheel-install)
  ;; make switching frames works properly under the default click-to-focus
  (setq focus-follows-mouse nil))

; potentially, do not read default .emacs file at 
; /usr/share/emacs/site-lisp/default.el
(setq inhibit-default-init t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("f5e56ac232ff858afb08294fc3a519652ce8a165272e3c65165c42d6fe0262a0" default)))
 '(load-home-init-file t t)
 '(vc-handled-backends (quote (RCS CVS SVN SCCS Bzr Hg Mtn Arch))))
;(load-home-init-file t t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Keep track of lunch hours
(display-time-mode 1)
;(display-time)  ;; the command itself
(setq display-time-24hr-format t)
;; more info at http://www.emacswiki.org/emacs/DisplayTime


;; do not open certain buffers in special windows/frames
(setq special-display-regexps nil)

;; Following hacks from emacsblog.org
;restore normal selection mode
(cua-mode 0)
(transient-mark-mode 1)


;; For M-e and M-a sentence move commands
(setq sentence-end-double-space nil)


;; Evaluate *and* replace
;; Hack from http://emacs.wordpress.com/2007/01/17/eval-and-replace-anywhere/
(defun fc-eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

;(require 'magit)
(require 'egg)


(autoload 'smart-tabs-mode "smart-tabs-mode"
  "Intelligently indent with tabs, align with spaces!")
(autoload 'smart-tabs-mode-enable "smart-tabs-mode")
(autoload 'smart-tabs-advice "smart-tabs-mode")
(smart-tabs-advice c-indent-line c-basic-offset)
(smart-tabs-advice c-indent-region c-basic-offset)


;tab completion with TAB, while keeping indenting
(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)
  )
)
(defun my-tab-fix ()
  (local-set-key [tab] 'indent-or-expand)
)
 
(add-hook 'c-mode-hook          'my-tab-fix)
(add-hook 'c++-mode-hook          'my-tab-fix)
; (add-hook 'python-mode-hook     'my-tab-fix)
(add-hook 'sh-mode-hook         'my-tab-fix)
(add-hook 'emacs-lisp-mode-hook 'my-tab-fix)
(add-hook 'text-mode-hook       'my-tab-fix)
(add-hook 'c-mode-hook 'smart-tabs-mode-enable)

; end hacks from emacsblog.org



;; Lilypond
;(setq load-path (append (list (expand-file-name "/Applications/LilyPond.app/Contents/Resources/share/emacs/site-lisp")) load-path))  ;; typically OS X only, this path
;(autoload 'LilyPond-mode "lilypond-mode" "LilyPond Editing Mode" t)
;(add-to-list 'auto-mode-alist '("\\.ly$" . LilyPond-mode))
;(add-to-list 'auto-mode-alist '("\\.ily$" . LilyPond-mode))
;(add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock)))


;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
;;; Takes a multi-line paragraph and makes it into a single line of text.
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
  (fill-paragraph nil)))


;; Restructured Text
(require 'rst)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))

;;from  http://neuroimaging.scipy.org/site/doc/manual/html/devel/tools/tricked_out_emacs.html
(setq auto-mode-alist
      (append '(("\\.txt$" . rst-mode)
                ("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))
(require 'linum)
;;(global-linum-mode)

;;incremental numbers in a rectangle
(require 'gse-number-rect)


;; Pop-up shell:

(defvar th-shell-popup-buffer nil)

(defun th-shell-popup ()
  "Toggle a shell popup buffer with the current file's directory as cwd."
  (interactive)
  (unless (buffer-live-p th-shell-popup-buffer)
    (save-window-excursion (shell "*Popup Shell*"))
    (setq th-shell-popup-buffer (get-buffer "*Popup Shell*")))
  (let ((win (get-buffer-window th-shell-popup-buffer))
	(dir (file-name-directory (or (buffer-file-name)
				      ;; dired
				      dired-directory
				      ;; use HOME
				      "~/"))))
    (if win
	(quit-window nil win)
      (pop-to-buffer th-shell-popup-buffer nil t)
      (comint-send-string nil (concat "cd " dir "\n")))))
(global-set-key (kbd "<f9>") 'th-shell-popup)


;; "in-place" scrolling
(defun gcm-scroll-down ()
  (interactive)
  (scroll-up 1))
(defun gcm-scroll-up ()
  (interactive)
  (scroll-down 1))
(global-set-key "\M-n" 'gcm-scroll-down)
(global-set-key "\M-p" 'gcm-scroll-up)


;;(require 'auto-complete)
;;(global-auto-complete-mode t)
;;(setq ac-auto-start 3)
;;(global-auto-complete-mode nil)

;; mercurial.el builds on top of built-in VCS commands
;; might be outdated with Emacs version 22.3
(require 'mercurial)

(require 'ido)
(ido-mode t)

(require 'ein)
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)


(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

(require 'compactblock)
(require 'coffee-mode)

(setq-default tab-width 4)

;; http://introrse.com/jasonc/docs/emacs-ch.html
(define-key global-map "\C-h" 'backward-delete-char)
(define-key global-map "\C-H" 'help)
;(define-key global-map "\C-\." 'repeat)

(global-set-key         [S-f6]           'global-linum-mode)
(global-set-key         [BackSpace]    'backward-delete-char)
(global-set-key         [Del]          'delete-char)
(global-set-key         [f1]           'shell-command)
(global-set-key         [f2]           'query-replace)
(global-set-key         [S-f2]         'query-replace-regexp)
(global-set-key         [f3]           'goto-line)
(global-set-key         [f4]           'column-number-mode)
(global-set-key         [f5]           'text-mode)
(global-set-key         [f6]           'line-number-mode)
(global-set-key         [f7]           'overwrite-mode)
(global-set-key         [f8]           'toggle-selective-display)
;(global-set-key         [S-f9]         'dabbrev-completion)
;(global-set-key         [f9]           'dabbrev-expand)
(global-set-key         [f10]          'yank-rectangle)
(global-set-key         [f11]          'kill-rectangle)
(global-set-key		[f12]	       'string-rectangle)
(global-set-key         [C-f10]        'copy-to-register)
(global-set-key		[C-f12]	       'insert-register)
(global-set-key         [select]       'set-mark-command)
(global-set-key         [Prior]        'scroll-down)
(global-set-key         [Next]         'scroll-up)
(global-set-key         [C-up]         'previous-line)
(global-set-key         [C-down]       'next-line)
(global-set-key         [C-right]      'forward-word)
(global-set-key         [C-left]       'backward-word)
(global-set-key         [S-up]         'previous-line)
(global-set-key         [S-down]       'next-line)
(global-set-key         [S-right]      'forward-word)
(global-set-key         [S-left]       'backward-word)
(global-set-key		[M-f1]	       'terminal-emulator)
(global-set-key		[M-f2]	       'shell-command)
(global-set-key         [delete]       'delete-char)
(global-set-key         (kbd "C-c C-q")  'compact-uncompact-block)
(global-set-key         (kbd "C-c C-e")  'fc-eval-and-replace)
(global-set-key         (kbd "C-;")  'comment-region)
(global-set-key         "\C-xru"         'gse-number-rectangle)



;(setq c-default-style "bsd" c-basic-offset 8 tab-width 8 indent-tabs-mode t)
;; Yes, I prefer my 'own' C coding formatting.
(c-add-style "evert"
	     '("bsd"
	       (c-basic-offset . 8)
	       (c-offsets-alist
		(case-label . +))
		   (c-set-offset 'inextern-lang 0)))
(add-hook 'c-mode-common-hook 
	  (lambda () 
	    (c-set-style "evert")))
