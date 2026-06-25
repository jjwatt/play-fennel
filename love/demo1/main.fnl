(local json (require :json))

(var time 0)
(var audio-source nil)

(global canvas nil)
(global song-data (json.decode (love.filesystem.read "impeachy.json")))
(global track-configs
        {1 {:notes (. song-data.tracks 1 :notes)
            :next-idx 1
            :color [0.1 0.4 0.45]}
         2 {:notes (. song-data.tracks 2 :notes)
            :next-idx 1
            :color [0.85 0.35 0.25]}
         3 {:notes (. song-data.tracks 3 :notes)
            :next-idx 1
            :color [0.85 0.65 0.25]}
         4 {:notes (. song-data.tracks 4 :notes)
            :next-idx 1
            :color [0.35 0.55 0.4]}
         5 {:notes (. song-data.tracks 5 :notes)
            :next-idx 1
            :color [0.75 0.5 0.6]}
         6 {:notes (. song-data.tracks 6 :notes)
            :next-idx 1
            :color [0.9 0.85 0.75]}
         })
(global visual-events [])

(fn love.load []
  (love.window.setTitle "Impeachy - Fennel & LOVE2D")
  (love.graphics.setLineJoin :bevel)
  (let [(w h) (love.graphics.getDimensions)]
    (set canvas (love.graphics.newCanvas w h)))
  (love.graphics.setCanvas canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setCanvas)
  (set audio-source (love.audio.newSource "impeachy.wav" :stream))
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
            max-radius (if (< current-note.midi 45)
                           (* base-radius 6)
                           (* base-radius 2.5))
            lifespan (if (< current-note.midi 45) 1.2 0.5)
            (x y) (if (= track-num 1)
                      (values (/ width 2) (/ height 2))
                      (values (love.math.random (* width 0.2) (* width 0.8))
                              (love.math.random (* height 0.3) (* height 0.7))))]
        (table.insert visual-events
                      {:x x
                       :y y
                       :max-radius max-radius
                       :alpha current-note.velocity
                       :color config.color
                       :age 0
                       :lifespan lifespan})
        (tset config :next-idx (+ config.next-idx 1)))))
  ;; Update existing visual events and clear dead ones.
  (for [i (# visual-events) 1 -1]
    (let [event (. visual-events i)]
      (set event.age (+ event.age dt))
      (if (<= event.lifespan event.age)
          (table.remove visual-events i)))))

(fn love.draw []
  (let [(width height) (love.graphics.getDimensions)]

    (love.graphics.setCanvas canvas)
    (love.graphics.setBlendMode :alpha)
    (love.graphics.setColor 0 0 0 0.03)
    (love.graphics.rectangle :fill 0 0 width height)

    ;; Render every active note event.
    (each [_ event (ipairs visual-events)]
      (let [pct (/ event.age event.lifespan)
            current-radius (* event.max-radius pct)
            ;; Fade out linerarly.
            current-alpha (* event.alpha (- 1 pct))
            line-width (* 4 (- 1 pct))
            (r g b) (values (. event.color 1) (. event.color 2) (. event.color 3))]
        (love.graphics.setLineWidth line-width)
        ;; Color shifts based on event age.
        (love.graphics.setColor r g b current-alpha)

        ;; Draw primary ring.
        (love.graphics.circle :line event.x event.y (* event.max-radius pct))
        ;; Draw a secondary trailing echo ring at half the speed
        (love.graphics.circle :line event.x event.y (* event.max-radius pct 0.5))))
    
    (love.graphics.setCanvas)
    
    (love.graphics.setBlendMode :alpha :premultiplied)
    (love.graphics.setColor 1 1 1 1)
    (love.graphics.draw canvas 0 0)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
