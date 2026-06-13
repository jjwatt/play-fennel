
(fn create-tree [x y angle len depth max-depth]
  (let [rad (math.rad angle)
        x2 (+ x (* (math.cos rad) len))
        y2 (+ y (* (math.sin rad) len))
        node {:x1 x :y1 y :x2 x2 :y2 y2 :children []}]
    (if (< depth max-depth)
        (let [next-depth (+ depth 1)
              ;; Decay the length of child branches.
              next-len (* len 0.68)
              left-angle (- angle 25)
              right-angle (+ angle 25)]
          (tset node :children [
                                (create-tree x2 y2 left-angle next-len next-depth max-depth)
                                (create-tree x2 y2 right-angle next-len next-depth max-depth)])))
    node))

(fn draw-tree [node]
  (love.graphics.line node.x1 node.y1 node.x2 node.y2)
  (each [_ child (ipairs node.children)]
    (draw-tree child)))

{ : create-tree
  : draw-tree }
