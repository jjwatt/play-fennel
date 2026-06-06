(require :L5)

(macro inc! [var-name ?by]
  (let [increment-amount (or ?by 1)]
    `(set ,var-name (+ ,var-name ,increment-amount))))

(macro dec! [var-name ?by]
  (let [decrement-amount (or ?by 1)]
    `(set ,var-name (- ,var-name ,decrement-amount))))

;; Global State
(var _ang 0)
(var _noise-val (random 100))

(fn setup []
  (windowTitle "Wave Clock (functional)")
  (size 600 600)
  (background 255)
  (smooth))

(fn draw []
  (inc! _noise-val 0.005)
  (inc! _ang 0.5)

  (when (> _ang 360)
    (dec! _ang 360))

  (let [center-x (/ width 2)
        center-y (/ height 2)
        rad (radians _ang)
        nx (+ 10 (* (cos rad) _noise-val))
        ny (+ 10 (* (sin rad) _noise-val))
        radius (+ 100 (* (love.math.noise nx ny) 250))
        opp-rad (+ rad math.pi)
        x1 (+ center-x (* radius (math.cos rad)))
        y1 (+ center-y (* radius (math.sin rad)))
        x2 (+ center-x (* radius (math.cos opp-rad)))
        y2 (+ center-y (* radius (math.sin opp-rad)))]

    (let [stroke-noise (love.math.noise (* _noise-val 0.5))
          r (+ 10 (* stroke-noise 40))
          g (+ 20 (* stroke-noise 30))
          b (+ 50 (* stroke-noise 30))
          a 40]
      (stroke r g b a)
      (strokeWeight 0.5))
    (line x1 y1 x2 y2)))

(set _G.setup setup)
(set _G.draw draw)
