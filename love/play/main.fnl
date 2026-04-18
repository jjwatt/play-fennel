(local clj (require :cljlib))
(import-macros cljm (doto :cljlib require))
(import-macros {: defn} :cljlib)
(import-macros {: loop} :cljlib)

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

(fn cutom-random []
  (- 1 (^ (math.random 0 1) 5)))

(defn draw-sine-wave
  "Draw a sine wave."
  ([]
   (let [(width height) (love.graphics.getDimensions)
         scale-val 40
         angle-inc 1
         startangle 0]
     (draw-sine-wave (/ height 2) scale-val angle-inc startangle)))
  ([offset]
   (draw-sine-wave offset 40 1 0))
  ([offset scale-val angle-inc startangle]
   (let [(width height) (love.graphics.getDimensions)
         xstep 5
         borderx 20]
     (loop [x borderx
            lastx 0
            lasty 0
            angle startangle]
           (let [rad (math.rad angle)
                 ;; sin returns between -1 and 1 so scale the value
                 ;; using scale-val
                 y (+ offset (* (math.sin rad) scale-val))
                 ]
             (when (and
                    (> lastx 0)
                    (<= lastx (- width borderx)))
               (love.graphics.line x y lastx lasty))
             (if (<= x width)
                 (recur (+ x xstep)
                        x
                        y
                        (+ angle-inc angle))))))))

(defn draw-sine-wave-noise
  "Draw a noisy sine wave."
  ([]
   (let [(width height) (love.graphics.getDimensions)
         scale-val 60
         angle-inc 1
         startangle 0]
     (draw-sine-wave-noise (/ height 2) scale-val angle-inc startangle)))
  ([offset]
   (draw-sine-wave-noise offset 40 1 0))
  ([offset scale-val angle-inc startangle]
   (let [(width height) (love.graphics.getDimensions)
         xstep 5
         borderx 20]
     (loop [x borderx
            lastx 0
            lasty 0
            angle startangle]
           (let [rad (math.rad angle)
                 ;; sin returns between -1 and 1 so scale the value
                 y (+ offset (* (custom-random) scale-val))]
             (when (and
                    (> lastx 0)
                    (<= lastx (- width borderx)))
               (love.graphics.line x y lastx lasty))
             (if (<= x width)
                 (recur (+ x xstep)
                        x
                        y
                        (+ angle angle-inc))))))))

;; (fn love.handlers.stdin [line]
;;   ;; evaluate lines read from stdin as fennel code
;;   (let [(ok val) (pcall fennel.eval line)]
;;     (print (if ok (fennel.view val) val))))

(fn love.keypressed [key]
  (love.event.quit))

(global canvas nil)
;; NOTE: drawing stuff directly to the screen in love.load doesn't work
(fn love.load []
  ;; start a thread listening on stdin
;;   (: (love.thread.newThread "require('love.event')
;; while 1 do love.event.push('stdin', io.read('*line')) end") :start)
  ;; setup and draw to off-screen canvas
  (set canvas (love.graphics.newCanvas 800 600))
  (love.graphics.setCanvas canvas)
  (love.graphics.clear 0 0 0 0)
  (love.graphics.setBlendMode "alpha")
  (love.graphics.setColor 0 1 0)
  ;; (my-sin-wave)
  (love.graphics.setCanvas))

(fn love.draw []
  (var (WIDTH HEIGHT) (love.graphics.getDimensions))
  (love.graphics.setBlendMode "alpha" "premultiplied")
  (love.graphics.setColor 1 1 1 1)
  ;; draw the off-screen canvas on the screen
  (love.graphics.draw canvas 0 0)
  ;; (my-eight-eleven WIDTH HEIGHT 4))
  ;; (draw-sine-wave 300 50 1 0)
  ;;   (print drewonce)
  ;;   (love.graphics.setColor 0 1 0)
  ;;   (my-eight-eleven WIDTH HEIGHT)
  ;;   (set drewonce true)
  ;;   (print drewonce))
  ;; (draw-sine-wave 200 30 1 0)
  ;; (draw-sine-wave 300 100 1 0)

  ;; (love.graphics.arc :line :open 16 16 16
  ;;                    (* 0 (/ math.pi 180))
  ;;                    (* 90 (/ math.pi 180))
  ;;                    10)
  ;; (love.graphics.setColor 1 1 0)
  ;; (let [spiral {:x 100
  ;;               :y 100
  ;;               :radius 100
  ;;               :startradius 2
  ;;               :radiusinc 0.25
  ;;               :step 10}]
  ;;   (my-spiral2 spiral.x
  ;;               spiral.y
  ;;               spiral.radius
  ;;               spiral.startradius
  ;;               spiral.step
  ;;               spiral.radiusinc))
  ;; (love.graphics.setColor 1 0 0)
  ;; (let [spiral {:x 200
  ;;               :y 200
  ;;               :radius 100
  ;;               :startradius 2
  ;;               :radiusinc 0.50
  ;;               :step 10}]
  ;;   (my-spiral2 spiral.x
  ;;               spiral.y
  ;;               spiral.radius
  ;;               spiral.startradius
  ;;               spiral.step
  ;;               spiral.radiusinc))
  ;; (let [wave {:offset 50
  ;;             :scale 50
  ;;             :inc (/ math.pi 18)
  ;;             :angle 0}]
  ;;   (my-sin-wave wave.offset
  ;;                wave.scale
  ;;                wave.inc
  ;;                wave.angle))
  ;; (let [spiral {:x 400
  ;;               :y 400
  ;;               :radius 100
  ;;               :startradius (math.random 1 10)
  ;;               :radiusinc 0.75
  ;;               :step (math.random 5 10)}]
  ;;   (my-spiral spiral.x
  ;;              spiral.y
  ;;              spiral.radius
  ;;              spiral.startradius
  ;;              spiral.step
  ;;              spiral.radiusinc))

  ;; (my-spiral (+ spiral.x (* 4 spiral.radius))
  ;;            spiral.y
  ;;            spiral.radius
  ;;            spiral.startradius
  ;;            spiral.step
  ;;            spiral.radiusinc)
  ;; (my-spiral (table.unpack
  ;;             (icollect [_ v (ipairs spiralargs)]
  ;;               (+ v 10))))
  )



;; (fn love.keypressed [key]
;;   (love.event.quit))
