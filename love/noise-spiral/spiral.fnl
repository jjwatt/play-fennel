(fn old-get-palette-color [t]
  "Generates a cycling RGB palette based on normalized time/phase input."
  (let [r (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 0.0))))
        g (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 2.0))))
        b (+ 0.5 (* 0.5 (math.cos (+ (* t 2) 4.0))))]
    (values r g b 1)))

(fn get-palette-color [t]
  "Generate a cycling cyberpunk palette (cyans, magentas, deep purples)"
  (let [phase (* t 2.0)
        ;; RED: High baseline keeps magentas/pinks firing constantly.
        r (+ 0.5 (* 0.5 (math.cos phase)))
        ;; GREEN: Heavily restricted to prevent yellow/orange mud.
        g (+ 0.2 (* 0.2 (math.sin phase)))
        ;; BLUE: Maxed out to keep the indigo/neon foundation strong.
        b (+ 0.5 (* 0.5 (math.cos (+ phase 3.14))))]
    (values r g b 1)))

(var smooth-noise-state 0)

(lambda my-noise-spiral12 [draw-line set-color noise-fn center-x center-y max-radius t]
  (var startradius 0)
  (var lastx (- 999))
  (var lasty (- 999))

  (let [radius-scale (+ 0.6 (* 0.4 (noise-fn (math.sin (* t 1.5)))))
        dynamic-max-radius (* max-radius radius-scale)
        total-loops 10
        max-angle (* 360 total-loops)
        step-size 5
        growth-rate (/ dynamic-max-radius max-angle)]

    (var radius-noise (+ 10 (* 15 (noise-fn (* t 0.2)))))

    (for [angle 0 max-angle step-size]
      (set radius-noise (+ radius-noise 0.09))

      (let [color-phase (+ (/ angle 45) (* t 1.5))
            (r g b a) (get-palette-color color-phase)]
        (set-color r g b a))

      (let [glitch-time (+ t (* 0.2 (math.random)))
            noise-angle (+ angle (* startradius 0.5))
            moving-wave (math.sin (+ (* noise-angle (+ 3 (* 4 (noise-fn t)))) (* glitch-time 10)))
            glitch-trigger (math.random)
            glitch-factor (if (> glitch-trigger 0.85)
                              (* 15 (math.random))
                              0)
            noise-x (+ (* angle 0.02) glitch-factor)
            noise-y (* t 0.8)
            raw-noise (noise-fn noise-x noise-y)
            _ (set smooth-noise-state (+ smooth-noise-state (* (- raw-noise smooth-noise-state) 0.05)))
            combined-noise (+ (* 0.4 moving-wave) (* 0.6 smooth-noise-state))
            dynamic-power (+ 2.0 (* 5.0 (noise-fn (* t 1.5))))
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


{: my-noise-spiral12}
