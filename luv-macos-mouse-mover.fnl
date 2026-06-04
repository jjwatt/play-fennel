;;!/usr/bin/env fennel
;; Mouse mover for macOS using cliclick and uv/luv
;; brew install cliclick
;; luarocks install luv
(local uv (require :luv))
(math.randomseed (os.time))

(fn move-mouse [x y]
  "Move the mouse to x, y."
  (os.execute (string.format "cliclick m:%d,%d" x y)))

(fn get-screen-dimensions [fallback-w fallback-h]
  "Get screen dimensions with osascript or fallback to fallback values."
  (let [f (io.popen "osascript -e 'tell application \"Finder\" to get bounds of window of desktop'")
        bounds (when f (f:read :*l))]
    (when f (f:close))
    (if bounds
        (let [(_ _ width height) (bounds:match "(%d+), (%d+), (%d+), (%d+)")]
          (values (or (tonumber width) fallback-w) (or (tonumber height) fallback-h)))
        (values fallback-w fallback-h))))

(local (screen-width screen-height) (get-screen-dimensions 2560 1440))
(print (string.format "Screen: %dx%d | Ctrl-C to quit" screen-width screen-height))

(var running true)
(local timer (uv.new_timer))

(fn jitter []
  "Move the mouse to a random point on the screen and setup to do it again at a random interval."
  (when running
    (let [x (math.random 0 (- screen-width 1))
          y (math.random 0 (- screen-height 1))]
      (move-mouse x y)
      (let [next-ms (math.random (* 30 1000) (* 180 1000))]
        ;; (print (string.format "Next move in %.0f seconds" (/ next-ms 1000)))
        (uv.timer_stop timer)
        (uv.timer_start timer next-ms 0 jitter)))))

(local timer (uv.new_timer))
(uv.timer_start timer 0 0 jitter)

;; Catch Ctrl-C
(local sig (uv.new_signal))
(uv.signal_start sig "sigint"
                 (fn []
                   (print "\nExiting.")
                   (set running false)
                   (uv.timer_stop timer)
                   (uv.stop)))

(uv.run)
