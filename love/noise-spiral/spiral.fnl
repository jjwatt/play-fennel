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

(fn spiral-noise12 [noise-fn random-fn t angle startradius prev-smooth]
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

(fn spiral-noise13 [noise-fn random-fn t angle base-radius _prev-smooth]
  (let [glitch-trigger (random-fn)
        glitch-factor (if (> glitch-trigger 1.0)
                          (* 15 (random-fn))
                          0)
        noise-x (+ (* angle 0.03) glitch-factor)
        noise-y (* t 0.8)
        base-noise (noise-fn noise-x noise-y)
        spikes (math.pow base-noise 4.5)]
    {:smooth 0 :spikes spikes :combined base-noise}))

(fn next-radius [random-fn base-radius radius-noise spikes angle t]
  (let [path-shredder (* 6 (random-fn) (math.cos (+ angle t)))
        noise-factor (+ 0.1 (* 0.9 spikes))]
    (+ base-radius (* radius-noise noise-factor) path-shredder)))

(fn draw-spiral [{: draw-line
                  : set-color
                  : noise-fn
                  : random-fn
                  : smooth-noise-state
                  : noise-strategy
                  : color-speed
                  : color-scale
                  : radius-noise
                  : radius-scale-fn
                  : angle-jitter-scale
                  : max-radius}
                  center-x
                  center-y
                  t]
  (let [radius-scale (radius-scale-fn t noise-fn)
        dynamic-max-radius (* max-radius radius-scale)
        total-loops 10
        max-angle (* 360 total-loops)
        step-size 5
        growth-rate (/ dynamic-max-radius max-angle)]
    (var radius-noise-val radius-noise)
    (var base-radius 0)
    (var prev nil)
    (var smooth smooth-noise-state)
    (for [angle 0 max-angle step-size]
      (set radius-noise-val (+ radius-noise-val 0.09))
      (let [color-phase (+ (/ angle color-scale) (* t color-speed))
            (r g b a) (get-palette-color color-phase)]
        (set-color r g b a))
      (let [noise-result (noise-strategy noise-fn random-fn t angle base-radius smooth)]
        (set smooth noise-result.smooth)
        (let [this-radius (next-radius random-fn base-radius radius-noise-val noise-result.spikes angle t)
              angle-jitter (* angle-jitter-scale noise-result.combined)
              radians (math.rad (+ angle angle-jitter))
              x (+ center-x (* this-radius (math.cos radians)))
              y (+ center-y (* this-radius (math.sin radians)))]
          (when prev
            (draw-line x y prev.x prev.y))
          (set prev {:x x :y y})
          (set base-radius (+ base-radius (* growth-rate step-size))))))
    (values smooth)))


(fn make-spiral [{: name
                  : noise-strategy
                  : color-speed
                  : color-scale
                  : radius-noise
                  : radius-scale-fn
                  : angle-jitter-scale
                  : needs-smooth-state}]
  (lambda [config center-x center-y max-radius t]
    (draw-spiral {:draw-line config.draw-line
                  :set-color config.set-color
                  :noise-fn config.noise-fn
                  :random-fn config.random-fn
                  :smooth-noise-state (if needs-smooth-state
                                          config.smooth-noise-state
                                          0)
                  :noise-strategy noise-strategy
                  :color-speed color-speed
                  :color-scale color-scale
                  :radius-noise radius-noise
                  :radius-scale-fn radius-scale-fn
                  :angle-jitter-scale angle-jitter-scale
                  :max-radius max-radius}
                 center-x center-y t)))

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
                                         {:smooth (lerp prev-smooth raw 0.1)
                                          :spikes (math.pow raw 2)
                                          :combined raw}))
                     :color-speed 3.0
                     :color-scale 20
                     :radius-noise 5
                     :radius-scale-fn (fn [t] 1.0)
                     :angle-jitter-scale 2.0
                     :needs-smooth-state true}))


;; (lambda draw-noise-spiral12 [{: draw-line : set-color : noise-fn : random-fn : smooth-noise-state}
;;                                center-x center-y max-radius t]
;;   (draw-spiral {:draw-line draw-line
;;                 :set-color set-color
;;                 :noise-fn noise-fn
;;                 :random-fn random-fn
;;                 :smooth-noise-state smooth-noise-state
;;                 :noise-strategy spiral-noise12
;;                 :color-speed 1.5
;;                 :color-scale 45
;;                 :radius-noise 10
;;                 :radius-scale-fn (fn [t] (+ 0.6 (* 0.4 (noise-fn (math.sin (* t 1.5))))))
;;                 :angle-jitter-scale 1
;;                 :max-radius max-radius}
;;                center-x center-y t))

;; (lambda draw-noise-spiral13 [{: draw-line : set-color : noise-fn : random-fn}
;;                                center-x center-y max-radius t]
;;   (draw-spiral {:draw-line draw-line
;;                 :set-color set-color
;;                 :noise-fn noise-fn
;;                 :random-fn random-fn
;;                 :smooth-noise-state 0
;;                 :noise-strategy spiral-noise13
;;                 :color-speed 0.4
;;                 :color-scale 180
;;                 :radius-noise 35
;;                 :radius-scale-fn (fn [t] (+ 0.6 (* 0.4 (math.sin (* t 1.5)))))
;;                 :angle-jitter-scale 1.0
;;                 :max-radius max-radius}
;;                center-x center-y t))


{
 : draw-noise-spiral12
 : draw-noise-spiral13
 : draw-noise-spiral14
}
