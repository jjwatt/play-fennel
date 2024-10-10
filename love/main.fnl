
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

(fn love.load []
  ;; start a thread listening on stdin
  (: (love.thread.newThread "require('love.event')
while 1 do love.event.push('stdin', io.read('*line')) end") :start))
(fn love.handlers.stdin [line]
  ;; evaluate lines read from stdin as fennel code
  (let [(ok val) (pcall fennel.eval line)]
    (print (if ok (fennel.view val) val))))
(fn love.draw []
  ;; (love.graphics.arc :line :open 16 16 16
  ;;                    (* 0 (/ math.pi 180))
  ;;                    (* 90 (/ math.pi 180))
  ;;                    10)
  (love.graphics.setColor 1 1 0)
  (let [spiral {:x 100
                :y 100
                :radius 100
                :startradius 2
                :radiusinc 0.25
                :step 10}]
    (my-spiral2 spiral.x
                spiral.y
                spiral.radius
                spiral.startradius
                spiral.step
                spiral.radiusinc))
  (love.graphics.setColor 1 0 0)
  (let [spiral {:x 200
                :y 200
                :radius 100
                :startradius 2
                :radiusinc 0.50
                :step 10}]
    (my-spiral2 spiral.x
                spiral.y
                spiral.radius
                spiral.startradius
                spiral.step
                spiral.radiusinc))
  (my-sin-wave)
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
