
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

(fn custom-random []
  (- 1 (^ (math.random) 5)))

(lambda my-sin-wave [?offset
                     ?scale-val
                     ?angle-inc
                     ?angle]
  ;; start at 0,0
  (var lastx 0)
  (var lasty 0)
  (var angle (or ?angle 0))
  (let [offset (or ?offset 50)
        scale-val (or ?scale-val 20)
        angle-inc (or ?angle-inc (/ math.pi 18))
        width (lyte.get_window_width)]
    (for [x 0 width 5]
      (let [y (+ offset (* (math.sin angle) scale-val))]
        (when (> lastx 0)
          (lyte.draw_line x y lastx lasty))
        (set angle (+ angle angle-inc))
        (set lastx x)
        (set lasty y)))))

(fn my-eight-eleven [width height ?pow]
  (for [x 5 width 5]
    (let [n (mapvalue x 5 width -1 1)
          p (^ n (or ?pow 4))
          ypos (lerp 20 height p)]
      (lyte.draw_line x 0 x ypos))))

(fn my-curve []
  (for [x 0 200 1]
    (let [n (norm x 0.0 200.0)]
      (var y (^ n 4))
      (set y (* 200 y))
      (lyte.draw_point x y))))

(fn _G.lyte.tick [dt width height]
  (lyte.cls 0 0 0 1)
  (lyte.set_color 1 0 0 0.3)
  (for [i 1 4]
    (let [x (* i (/ width 7))
          y (* i (/ height 7))]
      (lyte.draw_rect x y (/ width 3) (/ height 3)))))

(fn _G.lyte.tick [dt width height]
  (lyte.draw_text "Hello World" 0 0)
  (lyte.draw_rect 40 40 40 40)
  (for [i 1 4]
    (let [x (* i (/ width 7))
          y (* i (/ height 7))]
      (lyte.draw_rect x y (/ width 3) (/ height 3))))
  (lyte.draw_rect (/ width 7) (/ height 7) (/ width 3) (/ height 3))
)
