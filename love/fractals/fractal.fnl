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

(fn lerp-points [p1 p2 factor]
  {:x (lerp p1.x p2.x factor)
   :y (lerp p1.y p2.y factor)})

(fn generate-sutcliffe [outer-points depth max-depth config]
  (let [node {:points outer-points :children []}
        sides (# outer-points)]
    (if (< depth max-depth)
        (let [next-depth (+ depth 1)
              inner-points []]
          (let [midpoints []
                inner-ring []]
            (for [i 1 sides]
              (let [p1 (. outer-points i)
                    p2 (. outer-points (+ (% i sides) 1))]
                (table.insert midpoints (lerp-points p1 p2 0.5))))

            ;; Generate inner ring vertices pushed toward the core
            (for [i 1 sides]
              (let [p (. outer-points i)
                    opp-idx (+ (% (+ i 1) sides) 1)
                    target (. midpoints opp-idx)
                    inner-p (lerp-points p target config.strut-factor)]
                (table.insert inner-ring inner-p)))

            ;; Multi-branch ceiling
            ;; Create 1 center child.
            (let [child-trees [(generate-sutcliffe inner-ring next-depth max-depth config)]]
              ;; Create 5 parameter children packed into the side clearances.
              (for [i 1 sides]
                (let [p1 (. outer-points i)
                      p2 (. outer-points (+ (% i sides) 1))
                      mid (. midpoints i)
                      ip1 (. inner-ring i)
                      ip2 (. inner-ring (+ (% i sides) 1))
                      side-hull [p1 mid p2 ip2 ip1]]
                  (table.insert child-trees (generate-sutcliffe side-hull next-depth max-depth config))))
              (tset node :children child-trees)))))
    node))

(fn create-root-polygon [w h max-depth config]
  (let [cx (/ w 2)
        cy (/ h 2)
        outer-points []
        sides config.num-sides
        angle-step (/ 360 sides)]
    (for [i 0 (- sides 1)]
      (let [rad (math.rad (- (* i angle-step) 90))
            px (+ cx (* 420 (math.cos rad)))
            py (+ cy (* 420 (math.sin rad)))]
        (table.insert outer-points {:x px :y py})))
    (generate-sutcliffe outer-points 1 max-depth config)))

(fn draw-tree [node]
  (let [points node.points
        num-points (# points)]
    (for [i 1 num-points]
      (let [p1 (. points i)
            p2 (. points (+ (% i num-points) 1))]
        (love.graphics.line p1.x p1.y p2.x p2.y)))
    (each [_ child (ipairs node.children)]
      (draw-tree child))))

{: create-root-polygon
 : draw-tree }
