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

(fn get-inner-points [p1 p2]
  (let [nx (lerp p1.x p2.x 0.5)
        ny (lerp p1.y p2.y 0.5)]
    {:x nx :y ny}))

(fn generate-branches [points depth max-depth]
  (let [node {:points points :children []}]
    (if (< depth max-depth)
        (let [next-points []]
          (for [i 1 5]
            (let [p1 (. points i)
                  next-idx (+ (% i 5) 1)
                  p2 (. points next-idx)
                  inner-p (get-inner-points p1 p2)]
              (table.insert next-points inner-p)))
          (tset node :children [(generate-branches next-points (+ depth 1) max-depth)])))
    node))

(fn create-root-pentagon [w h max-depth]
  (let [cent-x (/ w 2)
        cent-y (/ h 2)
        outer-points []]
    (for [deg 0 359 72]
      (let [rad (math.rad deg)
            px (+ cent-x (* 400 (math.cos rad)))
            py (+ cent-y (* 400 (math.sin rad)))]
        (table.insert outer-points {:x px :y py})))
    (generate-branches outer-points 1 max-depth)))

(fn draw-tree [node]
  (let [pts node.points]
    (for [i 1 5]
      (let [p1 (. pts i)
            next-idx (+ (% i 5) 1)
            p2 (. pts next-idx)]
        (love.graphics.line p1.x p1.y p2.x p2.y))))
  (each [_ child (ipairs node.children)]
    (draw-tree child)))

{: create-root-pentagon
 : draw-tree }
