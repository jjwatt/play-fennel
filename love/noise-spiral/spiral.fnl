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

(fn spiral-noise [noise-fn random-fn t angle startradius prev-smooth]
  (let [glitch-time (+ t (* 0.2 (random-fn)))
        noise-angle (+ angle (* startradius 0.5))
        wave-speed (+ 3 (* 4 (noise-fn t)))
        moving-wave (math.sin (+ (* noise-angle wave-speed) (* glitch-time 10)))
        glitch-trigger (random-fn)
        glitch-factor (if (> glitch-trigger 0.85)
                          (* 15 (random-fn))
                          0)
        noise-x (+ (* angle 0.02) glitch-factor)
        noise-y (* t 0.8)
        raw-noise (noise-fn noise-x noise-y)
        smooth (lerp prev-smooth raw-noise 0.05)
        combined (+ (* 0.4 moving-wave) (* 0.6 smooth))
        dynamic-power (+ 2.0 (* 5.0 (noise-fn (* t 1.5))))
        spikes (math.pow (math.abs combined) dynamic-power)]
    {:smooth smooth :spikes spikes :combined combined}))

(fn next-radius [random-fn base-radius radius-noise spikes angle t]
  (let [path-shredder (* 6 (random-fn) (math.cos (+ angle t)))
        noise-factor (+ 0.1 (* 0.9 spikes))]
    (+ base-radius (* radius-noise noise-factor) path-shredder)))

(lambda draw-noise-spiral12 [{: draw-line
                              : set-color
                              : noise-fn
                              : random-fn
                              : smooth-noise-state}
                             center-x
                             center-y
                             max-radius
                             t]
  (let [radius-scale (+ 0.6 (* 0.4 (noise-fn (math.sin (* t 1.5)))))
        dynamic-max-radius (* max-radius radius-scale)
        total-loops 10
        max-angle (* 360 total-loops)
        step-size 5
        growth-rate (/ dynamic-max-radius max-angle)]
    (var radius-noise (+ 10 (* 15 (noise-fn (* t 0.2)))))
    (var base-radius 0)
    (var prev nil)
    (var smooth smooth-noise-state)
    (for [angle 0 max-angle step-size]
      (set radius-noise (+ radius-noise 0.09))
      (let [color-phase (+ (/ angle 45) (* t 1.5))
            (r g b a) (get-palette-color color-phase)]
        (set-color r g b a))
      (let [noise-result (spiral-noise noise-fn random-fn t angle base-radius smooth)]
        (set smooth noise-result.smooth)
        (let [this-radius (next-radius random-fn base-radius radius-noise noise-result.spikes angle t)
              angle-jitter (* 1 noise-result.combined)
              radians (math.rad (+ angle angle-jitter))
              x (+ center-x (* this-radius (math.cos radians)))
              y (+ center-y (* this-radius (math.sin radians)))]
          (when prev
            (draw-line x y prev.x prev.y))
          (set prev {:x x :y y})
          (set base-radius (+ base-radius (* growth-rate step-size))))))
    (values smooth)))

(lambda my-noise-spiral12 [{: draw-line : set-color : noise-fn : random-fn }
                           center-x center-y max-radius t]
  (var startradius 0)
  (var lastx -999)
  (var lasty -999)

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

      (let [glitch-time (+ t (* 0.2 (random-fn)))
            noise-angle (+ angle (* startradius 0.5))
            moving-wave (math.sin (+ (* noise-angle (+ 3 (* 4 (noise-fn t)))) (* glitch-time 10)))
            glitch-trigger (random-fn)
            glitch-factor (if (> glitch-trigger 0.85)
                              (* 15 (random-fn))
                              0)
            noise-x (+ (* angle 0.02) glitch-factor)
            noise-y (* t 0.8)
            raw-noise (noise-fn noise-x noise-y)
            _ (set smooth-noise-state (+ smooth-noise-state (* (- raw-noise smooth-noise-state) 0.05)))
            combined-noise (+ (* 0.4 moving-wave) (* 0.6 smooth-noise-state))
            dynamic-power (+ 2.0 (* 5.0 (noise-fn (* t 1.5))))
            sharp-spikes (math.pow (math.abs combined-noise) dynamic-power)

            path-shredder (* 6 (random-fn) (math.cos (+ angle t)))
            noise-factor (+ 0.1 (* 0.9 sharp-spikes))]

        (let [thisradius (+ startradius (* radius-noise noise-factor) path-shredder)]
          (set startradius (+ startradius (* growth-rate step-size)))

          (let [angle-jitter (* 1 combined-noise)
                radians (math.rad (+ angle angle-jitter))
                x (+ center-x (* thisradius (math.cos radians)))
                y (+ center-y (* thisradius (math.sin radians)))]

            (when (> lastx -999)
              (draw-line x y lastx lasty))

            (set (lastx lasty)
                 (values x y))))))))

(lambda my-noise-spiral13 [{: draw-line : set-color : noise-fn : random-fn}
                           center-x center-y max-radius t]
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

      (let [glitch-trigger (random-fn)
            glitch-factor (if (> glitch-trigger 0.85)
                            (* 15 (random-fn))
                            0)

            ;; By adding glitch-factor directly inside the noise-x lookup,
            ;; we force the smooth wave to instantly rip open into a sharp spike!
            noise-x (+ (* angle 0.02) glitch-factor)
            noise-y (* t 0.8)

            base-noise (noise-fn noise-x noise-y)

            ;; Keep your high sharpening power to pin the thorns into needles
            sharp-spikes (^ base-noise 4.5)

            ;; Bring back your micro-random white noise layer to chew up the flat paths!
            path-shredder (* 6 (random-fn) (math.cos (+ angle t)))
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


{: my-noise-spiral12
 : my-noise-spiral13
 : draw-noise-spiral12}
