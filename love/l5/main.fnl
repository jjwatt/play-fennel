(require :L5)

(fn custom-random [p]
  (- 1 (pow (random 1) p)))

(macro inc! [var-name ?by]
  (let [increment-amount (or ?by 1)]
    `(set ,var-name (+ ,var-name ,increment-amount))))

(macro dec! [var-name ?by]
  (let [decrement-amount (or ?by 1)]
    `(set ,var-name (- ,var-name ,decrement-amount))))

(fn setup []
  (windowTitle "Functional Noise Spirals 4.4")
  (size 500 300)
  (background 255)
  (strokeWeight 0.5)
  (smooth)

  (let [center-x 250
        center-y 150]
    ;; Draw 100 spiral strands.
    (for [_ 1 100]
      ;; Random params for this strand.
      (let [start-angle (random 360)
            end-angle (random 1440)
            angle-step (+ 5 (random 3))
            _ (stroke (random 20) (random 50) (random 70) 80)
            points (let [noise-seed (random 10)]
                     (var r-noise noise-seed)
                     (var current-radius 10)
                     (fcollect [angle start-angle end-angle angle-step]
                       (let [_ (inc! r-noise 0.05)
                             _ (inc! current-radius)
                             this-radius (+ current-radius (- (* (love.math.noise r-noise) 200) 100))
                             rad (radians angle)
                             x (+ center-x (* this-radius (math.cos rad)))
                             y (+ center-y (* this-radius (math.sin rad)))]
                         {: x : y})))]
        ;; Rendering step.
        (var prev nil)
        (each [_ pt (ipairs points)]
          (when prev
              (line prev.x prev.y pt.x pt.y))
          (set prev pt)))))
  )

(fn draw [])

(set _G.setup setup)
(set _G.draw draw)
