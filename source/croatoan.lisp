(in-package :de.anvi.croatoan)

;;; Define all macros here centrally.

(defmacro with-screen ((screen &key 
                               (input-reading  :unbuffered) 
                               (input-blocking t)
                               (input-echoing  t)
                               (enable-fkeys   t) 
                               (enable-colors  t)
                               (use-default-colors nil)
                               (cursor-visibility t))
                       &body body)
  "Add documentation here."
  `(unwind-protect
        (let ((,screen (make-instance 'screen
                                      :input-reading  ,input-reading
                                      :input-blocking ,input-blocking
                                      :input-echoing  ,input-echoing
                                      :enable-fkeys   ,enable-fkeys
                                      :enable-colors  ,enable-colors
                                      :use-default-colors ,use-default-colors
                                      :cursor-visibility ,cursor-visibility))

              ;; when an error is signaled and not handled, cleanly end ncurses, print the condition text
              ;; into the repl and get out of the debugger into the repl.
              ;; the debugger is annoying with ncurses apps.
              ;; add (abort) to automatically get out of the debugger.
              (*debugger-hook* #'(lambda (c h) (declare (ignore h)) (end-screen) (print c) )))

          ;; clear the display when starting up.
          (clear ,screen)

          ,@body)

     ;; cleanly exit ncurses whatever happens.
     (end-screen)))

;; window event loop, behaves like case. at the moment, it is limited to a single window.
;; for this to work, input-reading has to be unbuffered.
;; if input-blocking is nil, we can handle the (nil) event, i.e. stuff that happens between key presses.
;; if input-blocking is t, the (nil) event is never returned.
;; the main window event loop name is hard coded to "event-case-loop" to be used with return-from.
;; instead of ((nil) nil), which eats 100% CPU, use input-blocking t.
(defmacro event-case ((window event &optional mouse-y mouse-x) &body body)
  (if (and mouse-y mouse-x)
      `(loop named event-case do
            (multiple-value-bind (,event ,mouse-y ,mouse-x) (get-event ,window)
              ;;(print (list ,event mouse-y mouse-x) ,window)
              (case ,event
                ,@body)))
      `(loop named event-case do
            (let ((,event (get-event ,window)))
              (case ,event
                ,@body)))))
