(local json (require :json))

(var time 0)
(var audio-source nil)

(global canvas nil)
(global song-data (json.decode (love.filesystem.read "impeachy.json")))
(global track-configs
        {1 {:notes (. song-data.tracks 1 :notes)
            :next-idx 1
            :color [0.15 0.15 0.6]}
         2 {:notes (. song-data.tracks 2 :notes)
            :next-idx 1
            :color [0.4 0.2 0.7]}
         3 {:notes (. song-data.tracks 3 :notes)
            :next-idx 1
            :color [0.8 0.2 0.6]}
         4 {:notes (. song-data.tracks 4 :notes)
            :next-idx 1
            :color [1.0 0.4 0.5]}
         5 {:notes (. song-data.tracks 5 :notes)
            :next-idx 1
            :color [1.0 0.6 0.4]}
         6 {:notes (. song-data.tracks 6 :notes)
            :next-idx 1
            :color [1.0 0.8 0.5]}
         })
(global visual-events [])

(fn love.load []
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
            (width height) (love.graphics.getDimensions)]
        (table.insert visual-events
                      {:x (love.math.random 100 (- width 100))
                       :y (love.math.random 100 (- height 100))
                       :max-radius (* current-note.midi 2)
                       :alpha current-note.velocity
                       :color config.color
                       :age 0
                       :lifespan 0.5})
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
            (r g b) (values (. event.color 1) (. event.color 2) (. event.color 3))]
        (love.graphics.setLineWidth 2)
        ;; Color shifts based on event age.
        (love.graphics.setColor r g b current-alpha)
        (love.graphics.circle :line event.x event.y current-radius)))
    
    (love.graphics.setCanvas)
    
    (love.graphics.setBlendMode :alpha :premultiplied)
    (love.graphics.setColor 1 1 1 1)
    (love.graphics.draw canvas 0 0)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
