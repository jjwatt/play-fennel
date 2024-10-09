
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
    (for [angle 0 (* 360 8) (or ?step 8)]
      (set spiral.radius (+ spiral.radius spiral.radiusinc))
      (let [radians (math.rad angle)
            x (+ centerx (* spiral.radius (math.cos radians)))
            y (+ centery (* spiral.radius (math.sin radians)))]
        (when (> spiral.lastx 0)
          ;; the first time through we setup lastx and lasty
          (love.graphics.line x y spiral.lastx spiral.lasty))
        (set spiral.lastx x)
        (set spiral.lasty y)))))

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
  (let [spiral {:x 100
                :y 100
                :radius 100
                :startradius 2
                :radiusinc 0.25
                :step 10}]
      (my-spiral spiral.x
                 spiral.y
                 spiral.radius
                 spiral.startradius
                 spiral.step
                 spiral.radiusinc)
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
)



;; (fn love.keypressed [key]
;;   (love.event.quit))
