;;!/usr/bin/env fennel
(math.randomseed (os.time))

(fn move-mouse [x y]
  (os.execute (string.format "cliclick m:%d,%d" x y)))

(fn get-screen-dimensions []
  (let [cmd "osascript -e 'tell application \"Finder\" to get bounds of window of desktop'"
        f (io.popen cmd)
        bounds (f:read :*l)]
    (f:close)
    (let [(_ _ width height) (bounds:match "(%d+), (%d+), (%d+), (%d+)")]
      (values (or (tonumber width) 2560) (or (tonumber height) 1440)))))

(fn stay-awake []
  (let [(screen-width screen-height) (get-screen-dimensions)]
    (while true
      (let [x (math.random 0 (- screen-width 1))
            y (math.random 0 (- screen-height 1))]
        (move-mouse x y))
      (os.execute "sleep 20"))))

(stay-awake)
