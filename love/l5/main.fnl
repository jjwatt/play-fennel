(require :L5)

(fn norm [value low high]
  "Normalize value to between 0.0 and 1.0"
  (/ (- value low) (- high low)))
(fn lerp [low high amt]
  "Linear interpolation of amt (normalized) to low-high"
  (+ low (* amt (- high low))))
(fn mapvalue [value low1 high1 low2 high2]
  "Map from one set of values to the other"
  (let [n (norm value low1 high1)]
    (lerp low2 high2 n)))

(macro inc! [var-name ?by]
  (let [increment-amount (or ?by 1)]
    `(set ,var-name (+ ,var-name ,increment-amount))))

(macro dec! [var-name ?by]
  (let [decrement-amount (or ?by 1)]
    `(set ,var-name (- ,var-name ,decrement-amount))))

(fn setup []
  (windowTitle "Processing: 9-15")
  (size 300 300)
  (colorMode HSB)
  (for [i 0 100]
    (stroke (* i 2.5) 255 255)
    (line i 0 i 100)))

(fn draw [])

(set _G.setup setup)
(set _G.draw draw)
