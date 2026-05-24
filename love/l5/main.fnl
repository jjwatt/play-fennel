(require :L5)
(var center-x 0)
(var center-y 0)
(var diam 10)

(fn setup []
  (size 500 300)
  (windowTitle "Basic Sketch")
  (frameRate 24)
  (smooth)
  (background 180)
  (set center-x (/ width 2))
  (set center-y (/ height 2))
  (stroke 0)
  (strokeWeight 5)
  (fill 255 50))

(fn draw []
  (when (<= diam 400)
      (background 180)
      (ellipse center-x center-y diam diam)
      (set diam (+ diam 10))))

(set _G.setup setup)
(set _G.draw draw)
