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

(fn custom-random []
  (- 1 (^ (math.random) 5)))

(lambda my-spiral [centerx
                   centery
                   radius
                   ?startradius
                   ?step
                   ?radiusinc]
  (let [spiral {:radius (or ?startradius (/ radius 10))
                :radiusinc (or ?radiusinc 0.25)
                :lastx 0 :lasty 0}]
    ;; startradius is where the spiral starts and then it
    ;; grows out. base the startradius on the radius
    ;; if it's not passed as an argument.
    (for [angle 0 (* 360 4) (or ?step 8)]
      (set spiral.radius (+ spiral.radius spiral.radiusinc))
      (let [radians (math.rad angle)
            x (+ centerx (* spiral.radius (math.cos radians)))
            y (+ centery (* spiral.radius (math.sin radians)))]
        (when (> spiral.lastx 0)
          ;; the first time through we setup lastx and lasty
          (love.graphics.line x y spiral.lastx spiral.lasty))
        (set spiral.lastx x)
        (set spiral.lasty y)))))

;; Use the center as the lastx, lasty values to start
(lambda my-spiral2 [centerx
                    centery
                    radius
                    ?startradius
                    ?step
                    ?radiusinc]
  (let [spiral {:radius (or ?startradius (/ radius 10))
                :radiusinc (or ?radiusinc 0.25)
                :lastx centerx
                :lasty centery}]
    ;; startradius is where the spiral starts and then it
    ;; grows out. base the startradius on the radius
    ;; if it's not passed as an argument.
    (for [angle 0 (* 360 4) (or ?step 8)]
      (set spiral.radius (+ spiral.radius spiral.radiusinc))
      (let [radians (math.rad angle)
            x (+ centerx (* spiral.radius (math.cos radians)))
            y (+ centery (* spiral.radius (math.sin radians)))]
        (love.graphics.line x y spiral.lastx spiral.lasty)
        (set spiral.lastx x)
        (set spiral.lasty y)))))

(lambda my-noise-spiral [draw-line centerx centery radius t]
  (var startradius 0)
  (var lastx (- 999))
  (var lasty (- 999))
  ;; (var radius-noise (math.random startradius))
  (var radius-noise (+ 5 (* 10 (math.sin t))))
  (for [angle 0 (* 360 4) 5]
    (set radius-noise (+ radius-noise 0.09))
    (let [thisradius (+ startradius
                        (* radius-noise
                           (- 1 (custom-random))))]
      (set startradius (+ startradius 0.2
                          (- 1 (custom-random))))
      (let [radians (math.rad angle)
            x (+ centerx (* thisradius (math.cos radians)))
            y (+ centery (* thisradius (math.sin radians)))]
        (when (> lastx (- 999))
          (draw-line x y lastx lasty))
        (set (lastx lasty)
             (values x y))))))

(lambda my-noise-spiral2 [draw-line center-x center-y max-radius t]
  (var startradius 0)
  (var lastx (- 999))
  (var lasty (- 999))

  (let [total-loops 10
        max-angle (* 360 total-loops)
        step-size 5
        growth-rate (/ max-radius max-angle)]
    (var radius-noise (+ 5 (* 10 (math.sin t) 0.25)))
    (for [angle 0 max-angle step-size]
      (set radius-noise (+ radius-noise 0.09))
      (let [noise-factor (+ 0.5 (* 0.5 (math.sin (+ angle (* t 5)))))]
        (let [thisradius (+ startradius (* radius-noise noise-factor))]
          (set startradius (+ startradius (* growth-rate step-size) (* 0.5 (math.cos (+ angle t)))))
          (let [radians (math.rad angle)
                x (+ center-x (* thisradius (math.cos radians)))
                y (+ center-y (* thisradius (math.sin radians)))]
            (when (> lastx (- 999))
              (draw-line x y lastx lasty))
            (set (lastx lasty)
                 (values x y))))))))

(fn get-palette-color [t]
  "Generates a cycling RGB palette based on normalized time/phase input."
  (let [r (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 0.0))))
        g (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 2.0))))
        b (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 4.0))))]
    (values r g b 1)))

(fn get-palette-color [t]
  "Generates a cycling RGB palette based on normalized time/phase input."
  (let [r (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 0.0))))
        g (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 2.0))))
        b (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 4.0))))]
    (values r g b 1)))

(var smooth-noise-state 0)

(lambda my-noise-spiral12 [draw-line set-color center-x center-y max-radius t]
  (var startradius 0)
  (var lastx (- 999))
  (var lasty (- 999))

  (let [radius-scale (+ 0.6 (* 0.4 (math.sin (* t 1.5))))
        dynamic-max-radius (* max-radius radius-scale)
        total-loops 10
        max-angle (* 360 total-loops)
        step-size 5
        growth-rate (/ dynamic-max-radius max-angle)]

    (var radius-noise (+ 10 (* 15 (math.sin (* t 0.2)))))

    (for [angle 0 max-angle step-size]
      (set radius-noise (+ radius-noise 0.09))

      (let [color-phase (+ (/ angle 180) (* t 0.4))
            (r g b a) (get-palette-color color-phase)]
        (set-color r g b a))

      (let [glitch-time (+ t (* 0.2 (math.random)))
            ;; --- THE GHOST PATH OBLITERATOR ---
            ;; As the spiral expands outward, the noise profile twists and deforms.
            ;; This stops the spikes from aligning across rings, erasing the uniform paths!
            noise-angle (+ angle (* startradius 0.5))
            moving-wave (math.sin (+ (* noise-angle (+ 3 (* 4 (math.sin t)))) (* glitch-time 10)))

            raw-noise (math.random)
            _ (set smooth-noise-state (+ smooth-noise-state (* (- raw-noise smooth-noise-state) 0.05)))
            combined-noise (+ (* 0.4 moving-wave) (* 0.6 smooth-noise-state))
            dynamic-power (+ 4.5 (* 2.5 (math.sin (* t 3))))
            sharp-spikes (^ (math.abs combined-noise) dynamic-power)

            path-shredder (* 6 (math.random) (math.cos (+ angle t)))
            noise-factor (+ 0.1 (* 0.9 sharp-spikes))]

        (let [thisradius (+ startradius (* radius-noise noise-factor) path-shredder)]
          (set startradius (+ startradius (* growth-rate step-size)))

          (let [angle-jitter (* 1 combined-noise)
                radians (math.rad (+ angle angle-jitter))
                x (+ center-x (* thisradius (math.cos radians)))
                y (+ center-y (* thisradius (math.sin radians)))]

            (when (> lastx (- 999))
              (draw-line x y lastx lasty))

            (set (lastx lasty)
                 (values x y))))))))

(lambda my-noise-spiral13 [draw-line set-color center-x center-y max-radius t]
  (var startradius 0)
  (var lastx (- 999))
  (var lasty (- 999))

  (let [radius-scale (+ 0.6 (* 0.4 (math.sin (* t 1.5))))
        dynamic-max-radius (* max-radius radius-scale)
        total-loops 10
        max-angle (* 360 total-loops)
        step-size 5
        radius-noise 35
        growth-rate (/ dynamic-max-radius max-angle)]

    (for [angle 0 max-angle step-size]

      (let [color-phase (+ (/ angle 180) (* t 0.4))
            (r g b a) (get-palette-color color-phase)]
        (set-color r g b a))

      (let [glitch-trigger (math.random)
            glitch-factor (if (> glitch-trigger 0.85)
                            (* 15 (math.random))
                            0)

            ;; By adding glitch-factor directly inside the noise-x lookup,
            ;; we force the smooth wave to instantly rip open into a sharp spike!
            noise-x (+ (* angle 0.02) glitch-factor)
            noise-y (* t 0.8)

            base-noise (love.math.noise noise-x noise-y)

            ;; Keep your high sharpening power to pin the thorns into needles
            sharp-spikes (^ base-noise 4.5)

            ;; Bring back your micro-random white noise layer to chew up the flat paths!
            path-shredder (* 6 (math.random) (math.cos (+ angle t)))
            noise-factor sharp-spikes]

        (let [thisradius (+ startradius (* radius-noise noise-factor) path-shredder)]
          (set startradius (+ startradius (* growth-rate step-size)))

          ;; Re-inject a subtle angle jitter to completely stop the circles from lining up
          (let [angle-jitter (* 1.5 base-noise)
                radians (math.rad (+ angle angle-jitter))
                x (+ center-x (* thisradius (math.cos radians)))
                y (+ center-y (* thisradius (math.sin radians)))]

            (when (> lastx (- 999))
              (draw-line x y lastx lasty))

            (set (lastx lasty)
                 (values x y))))))))

(lambda my-sin-wave [?offset
                     ?scale-val
                     ?angle-inc
                     ?angle]
  ;; start at 0,0
  (var lastx 0)
  (var lasty 0)
  (var angle (or ?angle 0))
  (let [offset (or ?offset 50)
        scale-val (or ?scale-val 20)
        angle-inc (or ?angle-inc (/ math.pi 18))
        (width _) (love.graphics.getDimensions)]
    (for [x 0 width 5]
      (let [y (+ offset (* (math.sin angle) scale-val))]
        (when (> lastx 0)
          (love.graphics.line x y lastx lasty))
        (set angle (+ angle angle-inc))
        (set lastx x)
        (set lasty y)))))

(fn my-eight-eleven [width height ?pow]
  (for [x 5 width 5]
    (let [n (mapvalue x 5 width -1 1)
          p (^ n (or ?pow 4))
          ypos (lerp 20 height p)]
      (love.graphics.line x 0 x ypos))))

(fn my-curve []
  (for [x 0 200 1]
    (let [n (norm x 0.0 200.0)]
      (var y (^ n 4))
      (set y (* 200 y))
      (love.graphics.points x y))))

{ : my-sin-wave
  : my-spiral
  : my-spiral2
  : my-noise-spiral
  : my-noise-spiral2
  : my-noise-spiral12
  : my-noise-spiral13
  : my-eight-eleven
  : my-curve}
