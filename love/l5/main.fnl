(require :L5)

(fn custom-random [p]
  (- 1 (pow (random 1) p)))

(fn setup []
  (windowTitle "Circle")
  (size 500 300)
  (background 255)
  (strokeWeight 5)
  (smooth)

  (stroke 0 30)
  (noFill)
  (let [radius 100
        cent-x 250
        cent-y 150]
    (ellipse cent-x cent-y (* 2 radius) (* 2 radius))
    ;; shadow the ellipse radius
    (var radius 10)
    (stroke 20 50 70)
    (var x 0)
    (var y 0)
    (var lastx -999)
    (var lasty -999)
    (for [ang 0 1440 5]
      (set radius (+ radius 0.5))
      (var rad (radians ang))
      (var x (+ cent-x (* radius (cos rad))))
      (var y (+ cent-y (* radius (sin rad))))
      (when (> lastx -999)
        (line x y lastx lasty))
      (set lastx x)
      (set lasty y)))
  )

(fn draw [])

(set _G.setup setup)
(set _G.draw draw)
