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

(fn generate-branches [cx cy radius angle depth max-depth config]
  (let [points []]
    (for [i 0 4]
      (let [vertex-deg (+ (* i 72) angle)
            rad (math.rad (- vertex-deg 90))
            px (+ cx (* radius (math.cos rad)))
            py (+ cy (* radius (math.sin rad)))]
        (table.insert points {:x px :y py})))
    (let [node {:points points :children []}]
      (if (< depth max-depth)
          (let [next-depth (+ depth 1)
                next-radius (* radius config.decay)
                next-angle (+ angle config.twist-step)]
            (tset node :children [(generate-branches cx cy next-radius next-angle next-depth max-depth config)])))
      node)))

(fn create-root-pentagon [w h max-depth config]
  (let [cx (/ w 2)
        cy (/ h 2)
        initial-radius 400
        initial-angle 0]
    (generate-branches cx cy initial-radius initial-angle 1 max-depth config)))

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
