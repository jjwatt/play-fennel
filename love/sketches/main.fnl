(local sketches (require :sketches))

(var time 0)

(fn love.load []
  (love.graphics.setBackgroundColor 0 0 0))

(fn love.update [dt]
  (set time (+ time dt)))

(fn love.draw []
  (let [(width height) (love.graphics.getDimensions)
        center-x (/ width 2)
        center-y (/ height 2)]
    (love.graphics.setColor 0 1 0 1)
    (sketches.my-noise-spiral love.graphics.line center-x center-y width time)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
