(in-package :de.anvi.ncurses)

;;; getstr
;;; accept character strings from curses terminal keyboard
;;; http://invisible-island.net/ncurses/man/curs_getstr.3x.html

;;; C prototypes

;; int getstr(char *str);
;; int getnstr(char *str, int n);
;; int wgetstr(WINDOW *win, char *str);
;; int wgetnstr(WINDOW *win, char *str, int n);
;; int mvgetstr(int y, int x, char *str);
;; int mvgetnstr(int y, int x, char *str, int n);
;; int mvwgetstr(WINDOW *win, int y, int x, char *str);
;; int mvwgetnstr(WINDOW *, int y, int x, char *str, int n);

;;; Low-level CFFI wrappers

(defcfun ("getstr"     %getstr)     :int                                (str :string))
(defcfun ("getnstr"    %getnstr)    :int                                (str :string) (n :int))
(defcfun ("wgetstr"    %wgetstr)    :int (win window)                   (str :string))
(defcfun ("wgetnstr"   %wgetnstr)   :int (win window)                   (str :string) (n :int))
(defcfun ("mvgetstr"   %mvgetstr)   :int              (y :int) (x :int) (str :string))
(defcfun ("mvgetnstr"  %mvgetnstr)  :int              (y :int) (x :int) (str :string) (n :int))
(defcfun ("mvwgetstr"  %mvwgetstr)  :int (win window) (y :int) (x :int) (str :string))
(defcfun ("mvwgetnstr" %mvwgetnstr) :int (win window) (y :int) (x :int) (str :string) (n :int))
