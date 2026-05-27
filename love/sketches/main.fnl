(local sketches (require :sketches))

(var time 0)

(fn love.load []
  (love.graphics.setLineJoin :bevel)
  (love.graphics.setBlendMode :alpha))

(fn love.update [dt]
  (let [speed-modifier 0.5]
    (set time (+ time (* dt speed-modifier)))))

(fn love.draw []
  (let [(width height) (love.graphics.getDimensions)
        center-x (/ width 2)
        center-y (/ height 2)]
    ;; (love.graphics.setColor 0 1 0 1)
    (love.graphics.setColor 0 0 0 0.08)
    (love.graphics.rectangle :fill 0 0 (love.graphics.getDimensions))
    (love.graphics.setLineWidth 2)
    (sketches.my-noise-spiral12 love.graphics.line love.graphics.setColor love.math.noise center-x center-y (/ width 2.5) time)
    ;; (sketches.my-noise-spiral13 love.graphics.line love.graphics.setColor center-x center-y (/ width 2.5) time)
    ))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
