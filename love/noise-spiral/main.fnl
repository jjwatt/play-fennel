(local spiral (require :spiral))
(local audio (require :audio))

(var time 0)
(global canvas nil)
(var bass-drone nil)
(local bassline [55 65.41 49.00 43.65])

(fn love.load []
  (love.graphics.setLineJoin :bevel)

  ;; Create a canvas matching the window size
  (let [(w h) (love.graphics.getDimensions)]
    (set canvas (love.graphics.newCanvas w h)))

  ;; Clean clear on boot
  (love.graphics.setCanvas canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setCanvas)

  ;; Start generative audio.
  ;; Generate a 55Hz (Low A note) drone!
  (set bass-drone (audio.generate-tone 55 1.0))
  ;; (bass-drone:play)
)

(fn love.update [dt]
  (let [speed-modifier 0.5]
    (set time (+ time (* dt speed-modifier))))
  (when bass-drone
    (let [current-step (+ (% (math.floor (* time 4)) (length bassline)) 1)
          target-frequency (. bassline current-step)
          pitch-ratio (/ target-frequency 55)
          vibrato (+ 1.0 (* 0.02 (math.sin (* time 8))))]
      (bass-drone:setPitch (* pitch-ratio vibrato)))))

(fn love.draw []
  (let [(width height) (love.graphics.getDimensions)
        center-x (/ width 2)
        center-y (/ height 2)
        startradius (/ width 2.5)
        fns {:draw-line love.graphics.line
             :set-color love.graphics.setColor
             :noise-fn love.math.noise
             :random-fn love.math.random}]

    (love.graphics.setCanvas canvas)

    (love.graphics.setBlendMode :alpha)

    (love.graphics.setColor 0 0 0 0.05)
    (love.graphics.rectangle :fill 0 0 width height)

    (love.graphics.setLineWidth 1)
    (var outer-spiral 0)
    (set outer-spiral (spiral.draw-noise-spiral12 {:draw-line love.graphics.line
                                                   :set-color love.graphics.setColor
                                                   :noise-fn love.math.noise
                                                   :random-fn love.math.random
                                                   :smooth-noise-state outer-spiral}
                                                  center-x center-y startradius time))
    (var inner-spiral 0)
    (set inner-spiral (spiral.draw-noise-spiral13 {:draw-line love.graphics.line
                                                   :set-color love.graphics.setColor
                                                   :noise-fn love.math.noise
                                                   :random-fn love.math.random
                                                   :smooth-noise-state 0}
                                                  center-x center-y startradius time))
    ;; (spiral.my-noise-spiral12 fns
    ;;                           center-x
    ;;                           center-y
    ;;                           startradius
    ;;                           time)

    ;; (spiral.my-noise-spiral13 fns
    ;;                           center-x
    ;;                           center-y
    ;;                           startradius
    ;;                           time)

    (love.graphics.setCanvas)

    (love.graphics.setBlendMode :alpha :premultiplied)
    (love.graphics.setColor 1 1 1 1)
    (love.graphics.draw canvas 0 0)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
