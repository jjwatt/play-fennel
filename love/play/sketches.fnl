
(fn norm [value low high]
  "Normalize value to between 0.0 and 1.0"
  (/ (- value low) (- high low)))
(fn lerp [low high amt]
  "Linear interpolation of amt (normalized) to low-high"
  (+ low (* amt (- high low))))
(fn mapvalue [value low1 high1 low2 high2]
  "Map from one set of values to the other"
  (let [n (norm value low1 high1)
        c (lerp low2 high2 n)]
    c))

(lambda my-spiral [centerx
                   centery
                   radius
                   ?startradius
                   ?step
                   ?radiusinc]
  (let [spiral {:radius (or ?startradius (/ radius 10))
                :radiusinc (or ?radiusinc 0.25)
                :lastx 0 :lasty 0}]
    ;; startradius is where the spiral starts and then it
    ;; grows out. base the startradius on the radius
    ;; if it's not passed as an argument.
    (for [angle 0 (* 360 4) (or ?step 8)]
      (set spiral.radius (+ spiral.radius spiral.radiusinc))
      (let [radians (math.rad angle)
            x (+ centerx (* spiral.radius (math.cos radians)))
            y (+ centery (* spiral.radius (math.sin radians)))]
        (when (> spiral.lastx 0)
          ;; the first time through we setup lastx and lasty
          (love.graphics.line x y spiral.lastx spiral.lasty))
        (set spiral.lastx x)
        (set spiral.lasty y)))))

;; Use the center as the lastx, lasty values to start
(lambda my-spiral2 [centerx
                    centery
                    radius
                    ?startradius
                    ?step
                    ?radiusinc]
  (let [spiral {:radius (or ?startradius (/ radius 10))
                :radiusinc (or ?radiusinc 0.25)
                :lastx centerx
                :lasty centery}]
    ;; startradius is where the spiral starts and then it
    ;; grows out. base the startradius on the radius
    ;; if it's not passed as an argument.
    (for [angle 0 (* 360 4) (or ?step 8)]
      (set spiral.radius (+ spiral.radius spiral.radiusinc))
      (let [radians (math.rad angle)
            x (+ centerx (* spiral.radius (math.cos radians)))
            y (+ centery (* spiral.radius (math.sin radians)))]
        (love.graphics.line x y spiral.lastx spiral.lasty)
        (set spiral.lastx x)
        (set spiral.lasty y)))))

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
        (width _) (love.graphics.getDimensions)]
    (for [x 0 width 5]
      (let [y (+ offset (* (math.sin angle) scale-val))]
        (when (> lastx 0)
          (love.graphics.line x y lastx lasty))
        (set angle (+ angle angle-inc))
        (set lastx x)
        (set lasty y)))))

(fn my-eight-eleven [width height ?pow]
  (for [x 5 width 5]
    (let [n (mapvalue x 5 width -1 1)
          p (^ n (or ?pow 4))
          ypos (lerp 20 height p)]
      (love.graphics.line x 0 x ypos))))

(fn my-curve []
  (for [x 0 200 1]
    (let [n (norm x 0.0 200.0)]
      (var y (^ n 4))
      (set y (* 200 y))
      (love.graphics.points x y))))
