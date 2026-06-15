
(fn create-root-pentagon [w h]
  (let [cent-x (/ w 2)
        cent-y (/ h 2)
        points []]
    (for [deg 0 359 72]
      (let [rad (math.rad deg)
            px (+ cent-x (* 400 (math.cos rad)))
            py (+ cent-y (* 400 (math.sin rad)))]
        (table.insert points {:x px :y py})))
    {:points points}))

(fn draw-root [root]
  (let [pts root.points]
    (for [i 1 5]
      (let [p1 (. pts i)
            next-idx (+ (% i 5) 1)
            p2 (. pts next-idx)]
        (love.graphics.line p1.x p1.y p2.x p2.y)))))

{: create-root-pentagon
 : draw-root }
