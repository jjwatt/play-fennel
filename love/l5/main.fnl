(require :L5)

(macro inc! [var-name ?by]
  (let [increment-amount (or ?by 1)]
    `(set ,var-name (+ ,var-name ,increment-amount))))

(macro dec! [var-name ?by]
  (let [decrement-amount (or ?by 1)]
    `(set ,var-name (- ,var-name ,decrement-amount))))

(fn custom-random [p]
  (- 1 (pow (random 1) p)))

(fn custom-noise [v]
  (pow (sin v) 3))

(fn setup []
  (windowTitle "Perfect Seamless Noise Circle")
  (size 500 300)
  (background 255)
  (strokeWeight 5)
  (smooth)

  (let [center-x 250
        center-y 150
        radius 100
        diameter (* 2 radius)]
    (stroke 0 30)
    (noFill)
    (ellipse center-x center-y diameter diameter)

    ;; 1. Generate core points using 2D circular noise space
    (let [noise-offset-x (random 100)
          noise-offset-y (random 100)
          ;; This controls how dramatic/spiky the noise variations are
          noise-radius 1.2

          points (fcollect [angle 0 360]
                   (let [rad (radians angle)
                         ;; Calculate a circular path inside the noise map
                         nx (+ noise-offset-x (* noise-radius (cos rad)))
                         ny (+ noise-offset-y (* noise-radius (sin rad)))

                         ;; Sample 2D noise instead of 1D noise
                         n-val (love.math.noise nx ny)
                         rad-variance (* 30 (custom-noise n-val))
                         this-radius (+ radius rad-variance)]
                     {:x (+ center-x (* this-radius (cos rad)))
                      :y (+ center-y (* this-radius (sin rad)))}))]

      ;; 2. Explicitly stitch the Catmull-Rom buffer
      (let [first-pt (. points 1)
            second-pt (. points 2)
            last-pt (. points (length points))
            penultimate-pt (. points (- (length points) 1))]

        (table.insert points first-pt)
        (table.insert points second-pt)
        (table.insert points 1 last-pt)
        (table.insert points 1 penultimate-pt))

      (stroke 20 50 70)
      (strokeWeight 1)
      (fill 20 50 70)

      ;; 3. Render perfectly smooth loop
      (for [i 1 (- (length points) 3)]
        (let [p1 (. points i)
              p2 (. points (+ i 1))
              p3 (. points (+ i 2))
              p4 (. points (+ i 3))]
          (curve p1.x p1.y p2.x p2.y p3.x p3.y p4.x p4.y))))))

(fn draw [])

(set _G.setup setup)
(set _G.draw draw)
