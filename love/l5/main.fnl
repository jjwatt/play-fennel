(require :L5)

(fn custom-random [p]
  (- 1 (pow (random 1) p)))

(macro inc! [var-name ?by]
  (let [increment-amount (or ?by 1)]
    `(set ,var-name (+ ,var-name ,increment-amount))))

(macro dec! [var-name ?by]
  (let [decrement-amount (or ?by 1)]
    `(set ,var-name (+ ,var-name ,decrement-amount))))

(fn setup []
  (windowTitle "Noise Spiral 2")
  (size 500 300)
  (background 255)
  (strokeWeight 0.5)
  (smooth)

  (let [radius 100
        center-x 250
        center-y 150]
    (var x 0)
    (var y 0)
    (for [i 0 100]
      (var last-x -999)
      (var last-y -999)
      (var radius-noise (random 10))
      (var radius 10)
      (stroke (random 20) (random 50) (random 70) 80)
      (var start-angle (random 360))
      (var end-angle (random 1440))
      (var angle-step (+ 5 (random 3)))
      (for [angle start-angle end-angle angle-step]
        (inc! radius-noise 0.05)
        (inc! radius 0.5)
        (let [this-radius (+ radius (- (* (love.math.noise radius-noise) 200) 100))
              rad (radians angle)]
          (set x (+ center-x (* this-radius (cos rad))))
          (set y (+ center-y (* this-radius (sin rad))))
          (when (> last-x -999)
            (line x y last-x last-y))
          (set last-x x)
          (set last-y y)))))
  )

(fn draw [])

(set _G.setup setup)
(set _G.draw draw)
