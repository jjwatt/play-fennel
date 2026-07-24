(local {: cos : sin : abs : pow : rad : pi} math)

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

(fn get-palette-color [t]
  "Generate a cycling cyberpunk palette (cyans, magentas, deep purples)"
  (let [phase (* t 2.0)
        ;; RED: High baseline keeps magentas/pinks firing constantly.
        r (+ 0.5 (* 0.5 (cos phase)))
        ;; GREEN: Heavily restricted to prevent yellow/orange mud.
        g (+ 0.2 (* 0.2 (sin phase)))
        ;; BLUE: Maxed out to keep the indigo/neon foundation strong.
        b (+ 0.5 (* 0.5 (cos (+ phase 3.14))))]
    (values r g b 1)))

(fn spiral-noise12 [noise-fn random-fn t angle startradius prev-smooth]
  "Noise strategy 12: Generates an aggressive, heavily modulated noise profile."
  (let [glitch-time (+ t (* 0.2 (random-fn)))
        noise-angle (+ angle (* startradius 0.5))
        wave-speed (+ 3 (* 4 (noise-fn t)))
        moving-wave (sin (+ (* noise-angle wave-speed) (* glitch-time 10)))
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
        spikes (pow (abs combined) dynamic-power)]
    (values smooth spikes combined)))

(fn spiral-noise13 [noise-fn random-fn t angle base-radius _prev-smooth]
  "Noise strategy 13: Generates a high-contrast, spike-heavy raw noise profile."
  (let [glitch-trigger (random-fn)
        glitch-factor (if (> glitch-trigger 0.85)
                          (* 15 (random-fn))
                          0)
        noise-x (+ (* angle 0.03) glitch-factor)
        noise-y (* t 0.8)
        base-noise (noise-fn noise-x noise-y)
        spikes (math.pow base-noise 4.5)]
    (values 0 spikes base-noise)))

(fn next-radius [random-fn base-radius radius-noise spikes angle t]
  "Calculates the explicit radial distance for a single coordinate step.
  Combines the baseline spiral growth with noise spikes and a volatile
  high-frequency 'path-shredder' offset driven by cosmic/trigonometric
  jitter."
  (let [path-shredder (* 6 (random-fn) (math.cos (+ angle t)))
        noise-factor (+ 0.1 (* 0.9 spikes))]
    (+ base-radius (* radius-noise noise-factor) path-shredder)))

(fn draw-spiral [opts cfg center-x center-y max-radius t]
  "Iterates from 0 to max-angle, drawing line segments to form a generative spiral."
  (let [{: noise-fn : random-fn : set-color : draw-line : smooth-noise-state} cfg
        {: radius-scale-fn : radius-noise : color-scale : angle-jitter-scale
         : color-speed : needs-smooth-state : noise-strategy} opts
        radius-scale-fn (or radius-scale-fn #1.0)
        radius-scale (radius-scale-fn t noise-fn)
        dynamic-max-radius (* max-radius radius-scale)
        total-loops 10
        max-angle (* 360 total-loops)
        step-size 5
        growth-rate (/ dynamic-max-radius max-angle)]
    (var smooth (if needs-smooth-state (or smooth-noise-state 0) 0))
    (var base-radius 0)
    (var radius-noise-val radius-noise)
    (var prev-x false)
    (var prev-y false)
    (for [angle 0 max-angle step-size]
      (let [color-phase (+ (/ angle color-scale) (* t color-speed))
            (r g b a) (get-palette-color color-phase)
            (next-smooth spikes combined) (noise-strategy noise-fn random-fn t angle base-radius smooth)
            this-radius (next-radius random-fn base-radius radius-noise-val spikes angle t)
            angle-jitter (* angle-jitter-scale combined)
            radians (rad (+ angle angle-jitter))
            x (+ center-x (* this-radius (cos radians)))
            y (+ center-y (* this-radius (sin radians)))]
        (set-color r g b a)
        (when prev-x
          (draw-line x y prev-x prev-y))
        (set radius-noise-val (+ radius-noise-val 0.09))
        (set smooth next-smooth)
        (set base-radius (+ base-radius (* growth-rate step-size)))
        (set prev-x x)
        (set prev-y y)))
    ;; Return the final smooth value out of the drawing function.
    smooth))

(fn make-spiral [options]
  "Factory to inject permanent configurations into a spiral drawing runner."
  (fn [cfg center-x center-y max-radius t]
    (draw-spiral options cfg center-x center-y max-radius t)))

(local draw-noise-spiral12
       (make-spiral {:name "noise-spiral12"
                     :noise-strategy spiral-noise12
                     :color-speed 1.5
                     :color-scale 45
                     :radius-noise 10
                     :radius-scale-fn (fn [t noise-fn] (+ 0.6 (* 0.4 (noise-fn (math.sin (* t 1.5))))))
                     :angle-jitter-scale 1
                     :needs-smooth-state true}))

(local draw-noise-spiral13
       (make-spiral {:name "noise-spiral13"
                     :noise-strategy spiral-noise13
                     :color-speed 0.4
                     :color-scale 180
                     :radius-noise 35
                     :radius-scale-fn (fn [t _] (+ 0.6 (* 0.4 (math.sin (* t 1.5)))))
                     :angle-jitter-scale 1.5
                     :needs-smooth-state false}))

(local draw-noise-spiral14
       (make-spiral {:name "noise-spiral14"
                     :noise-strategy (fn [noise-fn random-fn t angle base-radius prev-smooth]
                                       (let [raw (noise-fn (* t 2) angle)]
                                         (values (lerp prev-smooth raw 0.1)
                                                 (math.pow raw 2)
                                                 raw)))
                     :color-speed 3.0
                     :color-scale 20
                     :radius-noise 5
                     :radius-scale-fn (fn [t _] (+ 0.4 (* 0.2 (math.cos (* t 1.5)))))
                     :angle-jitter-scale 2.0
                     :needs-smooth-state true}))

{
 : draw-noise-spiral12
 : draw-noise-spiral13
 : draw-noise-spiral14
}
