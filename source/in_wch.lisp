(in-package :de.anvi.croatoan)

(defun extract-wide-char (window &key y x)
  "Extract and return a wide character (code > 255) from the window.

If the destination coordinates y and x are given, first move the cursor."
  (when (and y x) (move window y x))
  ;; we absolutely need cchar_t here, cchar crashes sbcl.
  (with-foreign-object (ptr '(:struct cchar_t))
    ;; read a struct cchar_t into the space allocated with ptr
    (%win-wch (.winptr window) ptr)
    ;; when we use cchar, the int is dereferenced, cchar_t returns a pointer to the wchar_t array.
    ;; convert-from-foreign returns a plist, then we read the char from the plist using getf
    (let* ((plist (convert-from-foreign ptr '(:struct cchar)))
           (char (getf plist 'cchar-chars))
           (attr (getf plist 'cchar-attr)))
      (make-instance 'complex-char
                     :simple-char (code-char char)
                     :attributes (loop for i in *valid-attributes* if (logtest attr (get-bitmask i)) collect i)
                     ;; first get the color attribute bits by log-AND-ing them with ch.
                     ;; then right shift them by 8 to extract the color int from them.
                     ;; then get the color pair (:white :black) associated with that number.
                     :color-pair (number->pair (ash (logand attr (get-bitmask :color)) -8))))))

;; http://stackoverflow.com/questions/30198550/extracting-wide-chars-w-attributes-in-ncurses