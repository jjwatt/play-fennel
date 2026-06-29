(local json (require :json))

(var time 0)
(var audio-source nil)
(var shake-time 0)
(var shake-intensity 0)
(var bg-wave-offset 0)

(global canvas nil)
(global song-data (json.decode (love.filesystem.read "diglet_renoise.json")))
(global track-configs
        {1 {:notes (. song-data.tracks 1 :notes)
            :next-idx 1
            :color [0.1 0.4 0.45]
            :shape :circle :behavior :shockwave}
         2 {:notes (. song-data.tracks 2 :notes)
            :next-idx 1
            :color [0.85 0.35 0.25]
            :shape :circle :behavior :shockwave}
         3 {:notes (. song-data.tracks 3 :notes)
            :next-idx 1
            :color [0.85 0.65 0.25]
            :shape :noise-ring :behavior :particle}
         4 {:notes (. song-data.tracks 4 :notes)
            :next-idx 1
            :color [0.35 0.55 0.4]
            :shape :noise-ring :behavior :orbit}
         5 {:notes (. song-data.tracks 5 :notes)
            :next-idx 1
            :color [0.75 0.5 0.6]
            :shape :circle :behavior :orbit}
         6 {:notes (. song-data.tracks 6 :notes)
            :next-idx 1
            :color [0.9 0.85 0.75]
            :shape :circle :behavior :particle}
         7 {:notes (. song-data.tracks 7 :notes)
            :next-idx 1
            :color [0.85 0.95 0.25]
            :shape :circle :behavior :shockwave}
         })
(global visual-events [])

(fn draw-noise-ring [cx cy radius noise-scale noise-strength]
  "Draws a noisy ring."
  (local points [])
  (local segments 120)
  (for [i 0 segments]
    (let [angle (* (/ i segments) (* math.pi 2))
          sample-x (+ 100 (* (math.cos angle) noise-scale))
          sample-y (+ 100 (* (math.sin angle) noise-scale))
          sample-z (* time 1.2)
          noise-val (love.math.noise sample-x sample-y sample-z)
          displaced-radius (+ radius (* (- noise-val 0.5) noise-strength))
          px (+ cx (* (math.cos angle) displaced-radius))
          py (+ cy (* (math.sin angle) displaced-radius))]
      (table.insert points px)
      (table.insert points py)))
  (love.graphics.setLineJoin :none)
  (love.graphics.line points)
  (love.graphics.setLineJoin :bevel))

(fn draw-background-waves [width height]
  "Draws layered, fluid sine/noise horizontal waves to the canvas."
  (love.graphics.setLineWidth 1)

  ;; Draw 5 wave lines stacked vertically.
  (for [w 1 5]
    (let [points []
          steps 40
          base-y (+ (* height 0.2) (* w (* height 0.125)))]
      (for [i 0 steps]
        (let [x (* (/ i steps) width)
              n-val (love.math.noise (* i 0.1) (* w 10) bg-wave-offset)
              y (+ base-y (* (- n-val 0.5) 80))]
          (table.insert points x)
          (table.insert points y)))
      (love.graphics.setColor 0.3 0.5 0.4 (* 0.08 (/ w 5)))
      (love.graphics.line points))))

(fn calc-radius [track-num base-radius]
  "Calculate max radius based on instrument track."
  (match track-num
    (where (or 1 2)) (* base-radius 12)
    (where (or 4 5)) (* base-radius 5)
    _                (* base-radius 3.5)))

(fn calc-lifespan [track-num]
  "Determine visual lifespan in seconds based on track."
  (match track-num
    (where (or 1 2)) 0.4
    3                0.3
    (where (or 4 5)) 0.8
    _                0.6))

(fn calc-xy [track-num width height]
  "Calculate spatial coords based on track role."
  (match track-num
    (where (or 1 2)) (values (/ width 2) (/ height 2))
    (where (or 4 5)) (values (/ width 2) (+ (/ height 2) 0))
    _                (values (love.math.random (* width 0.2) (* width 0.8))
                             (love.math.random (* height 0.2) (* height 0.6)))))

(fn love.load []
  (love.window.setTitle "Digletr - Renoise, Fennel & LOVE2D")
  (love.graphics.setLineJoin :bevel)
  (let [(w h) (love.graphics.getDimensions)]
    (set canvas (love.graphics.newCanvas w h)))
  (love.graphics.setCanvas canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setCanvas)
  (set audio-source (love.audio.newSource "diglet_renoise.wav" :stream))
  (love.audio.play audio-source))

(fn love.update [dt]
  (if (and audio-source (audio-source:isPlaying))
      (set time (audio-source:tell :seconds))
      (set time (+ time dt)))
  (each [track-num config (pairs track-configs)]
    (while (let [current-note (. config.notes config.next-idx)]
             (and current-note (<= current-note.time time)))
      (let [current-note (. config.notes config.next-idx)
            (width height) (love.graphics.getDimensions)
            base-radius (- current-note.midi 20)
            max-radius (calc-radius track-num base-radius)
            lifespan (calc-lifespan track-num)
            (x y) (calc-xy track-num width height)]
        (table.insert visual-events
                      {:x x
                       :y y
                       :max-radius max-radius
                       :alpha current-note.velocity
                       :color config.color
                       :shape config.shape
                       :behavior config.behavior
                       :age 0
                       :lifespan lifespan})
        (when (or (= track-num 1) (= track-num 7))
          (set shake-time 0.2)
          (set shake-intensity 30))
        (tset config :next-idx (+ config.next-idx 1)))))
  ;; Update existing visual events and clear dead ones.
  (for [i (# visual-events) 1 -1]
    (let [event (. visual-events i)]
      (set event.age (+ event.age dt))
      (match [event.behavior]
        :orbit
        (let [angle (* event.age 10)]
            (set event.x (+ event.x (* (math.cos angle) 2)))
            (set event.y (+ event.y (* (math.sin angle) 2))))
        :particle
        (set event.y (- event.y (* dt 150))))
      (if (<= event.lifespan event.age)
          (table.remove visual-events i))))
  (if (< 0 shake-time)
      (do
        (set shake-time (- shake-time dt))
        (set shake-intensity (* shake-intensity 0.9)))
      (set shake-intensity 0))
  (set bg-wave-offset (+ bg-wave-offset (* dt 0.5))))

(fn love.draw []
  (let [(width height) (love.graphics.getDimensions)]

    (love.graphics.setCanvas canvas)
    (love.graphics.setBlendMode :alpha)

    ;; Standard trail clear
    (love.graphics.setColor 0 0 0 0.06)
    (love.graphics.rectangle :fill 0 0 width height)

    (draw-background-waves width height)

    ;; Render every active note event.
    (each [_ event (ipairs visual-events)]
      (let [pct (/ event.age event.lifespan)
            current-radius (* event.max-radius pct)
            ;; Fade out linerarly.
            current-alpha (* event.alpha (- 1 pct))
            line-width (* 4 (- 1 pct))
            (r g b) (values (. event.color 1) (. event.color 2) (. event.color 3))]

        ;; Default line properties.
        (love.graphics.setLineWidth line-width)
        (love.graphics.setColor r g b current-alpha)
        (match [event.behavior event.shape]
          [:shockwave _]
          ;; shockwave always implies circle for now
          (let [dynamic-pct (math.sqrt pct)
                shock-radius (* event.max-radius dynamic-pct)
                shock-alpha (* event.alpha (- 1 pct))]
            (love.graphics.setLineWidth (* 8 (- 1 dynamic-pct)))
            (love.graphics.setColor r g b shock-alpha)
            (love.graphics.circle :line event.x event.y shock-radius)
            (love.graphics.circle :line event.x event.y (* shock-radius 0.85)))
          [_ :circle]
          (love.graphics.circle :line event.x event.y current-radius)
          [_ :square]
          (let [size (* current-radius 1.5)]
            (love.graphics.rectangle :line (- event.x (/ size 2)) (- event.y (/ size 2)) size size))
          [_ :cross]
          (let [len current-radius]
            (love.graphics.line (- event.x len) event.y (+ event.x len) event.y)
            (love.graphics.line event.x (- event.y len) event.x (+ event.y len)))
          [_ :noise-ring]
          (let [frequency 1.5
                strength (* event.alpha 120)]
            (draw-noise-ring event.x event.y current-radius frequency strength))
          _
          (love.graphics.circle :line event.x event.y current-radius))))

    (love.graphics.setCanvas)

    (love.graphics.push)
    (when (< 0 shake-time)
      (let [dx (love.math.random (- shake-intensity) shake-intensity)
            dy (love.math.random (- shake-intensity) shake-intensity)]
        (love.graphics.translate dx dy)))
    
    (love.graphics.setBlendMode :alpha :premultiplied)
    (love.graphics.setColor 1 1 1 1)
    (love.graphics.draw canvas 0 0)
    (love.graphics.pop)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
