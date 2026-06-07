(require :L5)

(macro inc! [var-name ?by]
  (let [increment-amount (or ?by 1)]
    `(set ,var-name (+ ,var-name ,increment-amount))))

(macro dec! [var-name ?by]
  (let [decrement-amount (or ?by 1)]
    `(set ,var-name (- ,var-name ,decrement-amount))))

(fn draw-point [x y noise-factor]
  (let [len (* 10 noise-factor)]
    (rect x y len len)))

(fn setup []
  (windowTitle "2D Noise Grid")
  (size 300 300)
  (background 255)
  (smooth)
  (let [x-start (random 10)]
    (var x-noise x-start)
    (var y-noise (random 10))
    (for [y 0 height 5]
      (inc! y-noise 0.01)
      (set x-noise x-start)
      (for [x 0 width 5]
        (inc! x-noise 0.01)
        (draw-point x y (love.math.noise x-noise y-noise))))))

(fn draw []
  )

(set _G.setup setup)
(set _G.draw draw)
