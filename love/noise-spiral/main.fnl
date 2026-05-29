(local spiral (require :spiral))
(local audio (require :audio))

(var time 0)
(global canvas nil)
(var bass-drone nil)

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
  (bass-drone:play))

(fn love.update [dt]
  (let [speed-modifier 0.5]
    (set time (+ time (* dt speed-modifier))))
  (when bass-drone
    (let [pitch-modulator (+ 1.0 (* 0.08 (math.sin (* time 1.5))))]
      (bass-drone:setPitch pitch-modulator))))

(fn love.draw []
  (let [(width height) (love.graphics.getDimensions)
        center-x (/ width 2)
        center-y (/ height 2)]

    (love.graphics.setCanvas canvas)

    (love.graphics.setBlendMode :alpha)

    (love.graphics.setColor 0 0 0 0.05)
    (love.graphics.rectangle :fill 0 0 width height)

    (love.graphics.setLineWidth 1)
    (spiral.my-noise-spiral12 love.graphics.line
                              love.graphics.setColor
                              love.math.noise
                              center-x
                              center-y
                              (/ width 2.5)
                              time)

    (spiral.my-noise-spiral13 love.graphics.line
                              love.graphics.setColor
                              love.math.noise
                              center-x
                              center-y
                              (/ width 2.5)
                              time)

    (love.graphics.setCanvas)

    (love.graphics.setBlendMode :alpha :premultiplied)
    (love.graphics.setColor 1 1 1 1)
    (love.graphics.draw canvas 0 0)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
