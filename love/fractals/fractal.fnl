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

(fn lerp-points [p1 p2 factor]
  {:x (lerp p1.x p2.x factor)
   :y (lerp p1.y p2.y factor)})

;; Generates a perfectly proportioned, regular polygon hull at a specific angle
(fn generate-regular-hull [cx cy radius sides base-angle]
  (let [pts []
        angle-step (/ 360 sides)]
    (for [i 0 (- sides 1)]
      (let [rad (math.rad (- (+ (* i angle-step) base-angle) 90))
            px (+ cx (* radius (math.cos rad)))
            py (+ cy (* radius (math.sin rad)))]
        (table.insert pts {:x px :y py})))
    pts))

;; Recursively creates an interlocking, twisted Sutcliffe structural tree
(fn generate-sutcliffe [cx cy radius angle depth max-depth config]
  (let [sides config.num-sides
        ;; 1. Generate the outer regular polygon frame for this layer
        outer-pts (generate-regular-hull cx cy radius sides angle)
        node {:points outer-pts :children []}]

    (if (< depth max-depth)
        (let [next-depth (+ depth 1)
              ;; Decay the radius for the inner layer
              next-radius (* radius config.decay)
              ;; THE MAGIC LINK: Twist the next layer's orientation slightly!
              next-angle (+ angle config.twist-step)

              ;; 2. Generate the inner regular frame with the structural twist
              inner-ring (generate-regular-hull cx cy next-radius sides next-angle)

              ;; Calculate outer midpoints for packing the side clearance panels
              midpoints []]
          (for [i 1 sides]
            (let [p1 (. outer-pts i)
                  p2 (. outer-pts (+ (% i sides) 1))]
              (table.insert midpoints (lerp-points p1 p2 0.5))))

          ;; 3. Build multi-branching tree array
          ;; Spawn 1 perfectly twisted center iris child
          (let [child-trees [
            (generate-sutcliffe cx cy next-radius next-angle next-depth max-depth config)
          ]]

            ;; Spawn the perimeter panel children packing the side clearways
            (for [i 1 sides]
              (let [p1 (. outer-pts i)
                    p2 (. outer-pts (+ (% i sides) 1))
                    mid (. midpoints i)
                    ;; Grab the corresponding twisted inner vertices
                    ip1 (. inner-ring i)
                    ip2 (. inner-ring (+ (% i sides) 1))

                    ;; Interlocking trapezoidal panel hull boundary
                    side-hull [p1 mid p2 ip2 ip1]]

                ;; We wrap the side hull raw coordinates in a terminal node block
                (table.insert child-trees {:points side-hull :children []})))

            (tset node :children child-trees))))
    node))

(fn create-root-polygon [w h max-depth config]
  (let [cx (/ w 2)
        cy (/ h 2)
        initial-radius 420
        initial-angle 0]
    (generate-sutcliffe cx cy initial-radius initial-angle 1 max-depth config)))

(fn draw-tree [node]
  (let [pts node.points
        num-pts (# pts)]
    (for [i 1 num-pts]
      (let [p1 (. pts i)
            p2 (. pts (+ (% i num-pts) 1))]
        (love.graphics.line p1.x p1.y p2.x p2.y)))

    (each [_ child (ipairs node.children)]
      (draw-tree child))))

{: create-root-polygon
 : draw-tree }
