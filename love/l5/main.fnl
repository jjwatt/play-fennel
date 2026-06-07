(require :L5)

(macro inc! [var-name ?by]
  (let [increment-amount (or ?by 1)]
    `(set ,var-name (+ ,var-name ,increment-amount))))

(macro dec! [var-name ?by]
  (let [decrement-amount (or ?by 1)]
    `(set ,var-name (- ,var-name ,decrement-amount))))

(fn setup []
  (windowTitle "2D Noise Grid")
  (size 300 300)
  (background 255)
  (smooth)
  (let [x-start (random 10)]
    (var x-noise x-start)
    (var y-noise (random 10))
    (for [y 0 height]
      (inc! y-noise 0.01)
      (set x-noise x-start)
      (for [x 0 width]
        (inc! x-noise 0.01)
        (let [alph (* (love.math.noise x-noise y-noise) 255)]
          (stroke 0 alph)
          (line x y (+ x 1) (+ y 1)))))))

(fn draw []
  )

(set _G.setup setup)
(set _G.draw draw)
