(var [x y w h] [0 0 0 0])
(fn love.load []
  (var [x y w h] [20 20 60 20]))
;; Increase the size of the rectangle every frame.
(fn love.update [dt]
  (set w (+ w 1))
  (set h (+ h 1)))
;; Draw a colored rectangle.
(fn love.draw []
  (love.graphics.setColor 0 0.4 0.4)
  (love.graphics.rectangle "fill" x y w h))

