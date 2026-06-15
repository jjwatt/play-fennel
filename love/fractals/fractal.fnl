

(fn create-cog [x y angle len depth config global-rotation]
  (let [rad (math.rad angle)
        x2 (+ x (* (math.cos rad) len))
        y2 (+ y (* (math.sin rad) len))
        node {:x1 x :y1 y :x2 x2 :y2 y2 :depth depth :children []}]
    (if (< depth config.max-depth)
        (let [next-depth (+ depth 1)
              next-len (* len config.decay)
              direction (if (= (% depth 2) 0) 1 -1)
              local-spin (* global-rotation direction depth config.speed-multiplier)]
          (let [child-nodes []]
            (for [i 1 config.num-children]
              (let [base-split (/ 360 config.num-children)
                    child-angle (+ angle (* i base-split) local-spin)
                    child (create-cog x2 y2 child-angle next-len next-depth config global-rotation)]
                (table.insert child-nodes child)))
            (tset node :children child-nodes))))
    node))

(fn draw-cog [node]
  (love.graphics.setLineWidth (/ 4.0 node.depth))
  (love.graphics.setColor 0.15 0.15 0.15 (/ 200 node.depth 255))
  (love.graphics.line node.x1 node.y1 node.x2 node.y2)
  (love.graphics.circle :line node.x2 node.y2 (* (- 11 node.depth) 1.5))
  (each [_ child (ipairs node.children)]
    (draw-cog child)))

{: create-cog
 : draw-cog }
