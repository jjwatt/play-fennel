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
  (windowTitle "Catmull-Rom Noise Circle")
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
    ;; "guide" circle
    (ellipse center-x center-y diameter diameter)

    ;; Generate a continuous loop of points (0-360)
    (let [noise-start (random 10)
          points (let [noise-val noise-start]
                   (fcollect [angle 0 360]
                     (let [n-val (+ noise-start (* angle 0.1))
                           rad-variance (* 30 (custom-noise n-val))
                           this-radius (+ radius rad-variance)
                           rad (radians angle)
                           x (+ center-x (* this-radius (cos rad)))
                           y (+ center-y (* this-radius (sin rad)))]
                       {: x : y})))]
      (stroke 20 50 70)
      (strokeWeight 1)
      (fill 20 50 70)
      ;; The catmull-rom sliding window loop
      ;; Need 4 points per curve segment
      (for [i 1 (- (length points) 3)]
        (let [p1 (. points i)
              p2 (. points (+ i 1))
              p3 (. points (+ i 2))
              p4 (. points (+ i 3))]
          (curve p1.x p1.y p2.x p2.y p3.x p3.y p4.x p4.y))))))

(fn draw [])

(set _G.setup setup)
(set _G.draw draw)
