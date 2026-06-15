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

(fn get-inner-points [p center factor]
  (let [nx (lerp p.x center.x factor)
        ny (lerp p.y center.y factor)]
    {:x nx :y ny}))

(fn generate-branches [points depth max-depth center]
  (let [node {:points points :children []}]
    (if (< depth max-depth)
        (let [next-points []]
          (for [i 1 5]
            (let [p (. points i)
                  inner-p (get-inner-points p center 0.42)]
              (table.insert next-points inner-p)))
          (tset node :children [(generate-branches next-points (+ depth 1) max-depth center)])))
    node))

(fn create-root-pentagon [w h max-depth]
  (let [cx (/ w 2)
        cy (/ h 2)
        center {:x cx :y cy}
        outer-points []]
    (for [deg 0 359 72]
      (let [rad (math.rad (- deg 90))
            px (+ cx (* 400 (math.cos rad)))
            py (+ cy (* 400 (math.sin rad)))]
        (table.insert outer-points {:x px :y py})))
    (generate-branches outer-points 1 max-depth center)))

(fn draw-tree [node]
  (let [pts node.points]
    (for [i 1 5]
      (let [p1 (. pts i)
            next-idx (+ (% i 5) 1)
            p2 (. pts next-idx)]
        (love.graphics.line p1.x p1.y p2.x p2.y)))
    (each [_ child (ipairs node.children)]
      (for [i 1 5]
        (let [parent-p (. pts i)
              child-p (. child.points i)]
          (love.graphics.push :all)
          (love.graphics.setColor 0.15 0.15 0.15 0.25)
          (love.graphics.line parent-p.x parent-p.y child-p.x child-p.y)
          (love.graphics.pop)))
      (draw-tree child))))

{: create-root-pentagon
 : draw-tree }
