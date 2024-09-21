;!/usr/bin/env fennel
(local lgi (require :lgi))
(local GLib lgi.GLib)

(fn get-idle-time []
  (let [f (io.popen :xprintidle)
        idle-time (f:read :*n)] (f:close)
        idle-time))

(fn move-mouse [x y]
  (os.execute
   (string.format "xdotool mousemove %d %d" x y)))

(fn get-screen-dimensions []
  (let [f (io.popen "xrandr | grep '*' | awk '{print $1}'")
        dims (f:read :*l)]
    (f:close)
    (local (width height) (dims:match "(%d+)x(%d+)"))
    (values (or (tonumber width) 1920) (or (tonumber height) 1080))))

(fn stay-awake []
  (let [(screen-width screen-height) (get-screen-dimensions)]
    (while true
      (when (> ((tonumber get-idle-time)) 1000)
        (local x (math.random 0 (- screen-width 1)))
        (local y (math.random 0 (- screen-height 1)))
        (move-mouse x y))
      (GLib.usleep (* 30 1000)))))

(local main-loop (GLib.MainLoop nil false))

(GLib.idle_add GLib.PRIORITY_DEFAULT_IDLE
               (fn []
                 (stay-awake)
                 GLib.SOURCE_REMOVE))

(main-loop:run)
