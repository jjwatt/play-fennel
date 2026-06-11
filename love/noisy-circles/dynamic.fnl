(local d {})

(fn d.random-range [min max]
  (+ min (* (love.math.random) (- max min))))

(fn distance [x1 y1 x2 y2]
  (let [dx (- x2 x1)
        dy (- y2 y1)]
    (math.sqrt (+ (* dx dx) (* dy dy)))))

(fn d.copy-table [t]
  (let [new-t {}]
    (each [k v (pairs t)] (tset new-t k v))
    new-t))

;; State Creators
(fn d.make-bouncer [w h]
  {:x (d.random-range 0 w)
   :y (d.random-range 0 h)
   :radius (d.random-range 10 120)
   :x-move (d.random-range -2 2)
   :y-move (d.random-range -2 2)})

(fn d.make-effect [x y r]
  {:x x
   :y y
   :radius r
   :alpha 150})

;; Movement Engines
(fn d.move-bouncer-noise-steering [c w h]
  (let [raw-noise (love.math.noise (* c.x 0.005) (* c.y 0.005))
        steer-angle (* raw-noise math.pi 2)
        steer-strength 0.20
        ax (* (math.cos steer-angle) steer-strength)
        ay (* (math.sin steer-angle) steer-strength)
        max-speed 3.0
        raw-x (+ c.x-move ax)
        raw-y (+ c.y-move ay)
        speed (distance 0 0 raw-x raw-y)
        ;; Velocity Limiter
        [x-move y-move] (if (> speed max-speed)
                            [(* (/ raw-x speed) max-speed) (* (/ raw-y speed) max-speed)]
                            [raw-x raw-y])
        next-x (+ c.x x-move)
        next-y (+ c.y y-move)
        r c.radius
        ;; toroidal matrix wrapping limits
        final-x (if (> (- next-x r) w) (- r) (< (+ next-x r) 0) (+ w r) next-x)
        final-y (if (> (- next-y r) h) (- r) (< (+ next-y r) 0) (+ h r) next-y)]

    {:x final-x
     :y final-y
     :x-move x-move
     :y-move y-move
     :radius c.radius
     :alpha c.alpha}))

;; Collisions
(fn handle-collision [acc b2]
  (let [b1 acc.bouncer
        effects acc.effects
        dx (- b2.x b1.x)
        dy (- b2.y b1.y)
        dist (distance b1.x b1.y b2.x b2.y)
        min-dist (+ b1.radius b2.radius)]
    (if (and (> dist 0) (< dist min-dist))
        (let [angle (math.atan2 dy dx)
              target-x (+ b1.x (* (math.cos angle) min-dist))
              target-y (+ b1.y (* (math.sin angle) min-dist))
              ax (* (- target-x b2.x) 0.05)
              ay (* (- target-y b2.y) 0.05)
              mid-x (+ b1.x (* dx 0.5))
              mid-y (+ b1.y (* dx 0.5))
              raw-effect-rad (- min-dist dist)
              effect-rad (math.min raw-effect-rad 120)
              new-fx (d.make-effect mid-x mid-y effect-rad)]
          (table.insert effects new-fx)
          {:bouncer (doto (d.copy-table b1)
                      (tset :x-move (- b1.x-move ax))
                      (tset :y-move (- b1.y-move ay)))
           :effects effects})
        acc)))


(fn d.process-bouncer-interactions [all-bouncers b1]
  (accumulate [acc {:bouncer b1 :effects []}
               _ b2 (ipairs all-bouncers)]
    (handle-collision acc b2)))

;; Custom noise line renderer
(fn d.draw-noisy-circle [cx cy base-radius alpha]
  (love.graphics.setColor 0.25 0.25 0.25 (/ (/ alpha 4) 255))

  (let [points []
        time (* (love.timer.getTime) 12.0)
        noise-anchor-x (+ (* cx 0.05) time)
        noise-anchor-y (+ (* cy 0.05) time)]
    (for [degree 0 360 2]
      (let [rad (math.rad degree)
            cos-val (math.cos rad)
            sin-val (math.sin rad)
            freq 0.1
            noise-x (+ noise-anchor-x (* cos-val freq))
            noise-y (+ noise-anchor-y (* sin-val freq))
            base-noise (love.math.noise noise-x noise-y)
            ;; jitter-noise (love.math.noise (* noise-x 1.5) (* noise-y 1.5))
            ;; combined-noise (+ (* base-noise 0.99) (* jitter-noise 0.01))
            variance (* base-radius 0.15 (- base-noise 0.5))
            current-radius (+ base-radius variance)
            x (+ cx (* current-radius cos-val))
            y (+ cy (* current-radius sin-val))]
        (table.insert points x)
        (table.insert points y)))
    (if (>= (# points) 4)
        (love.graphics.line points))))

d
