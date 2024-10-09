
(lambda my-spiral [centerx
                   centery
                   radius
                   ?startradius
                   ?step]
  (let [spiral {:radius (or ?startradius (/ radius 10))
                :lastx (- 1)
                :lasty (- 1)}]
    (for [angle 0 (* 360 4) (or ?step 10)]
      (set spiral.radius (+ spiral.radius 0.25))
      (let [radians (math.rad angle)
            x (+ centerx (* spiral.radius (math.cos radians)))
            y (+ centery (* spiral.radius (math.sin radians)))]
        (when (> spiral.lastx (- 1))
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
  (let [spiral {:x 50
                :y 50
                :radius 20
                :startradius 2
                :step 8}]
      (my-spiral spiral.x spiral.y spiral.radius spiral.startradius spiral.step)
      (my-spiral (+ spiral.x (* 4 spiral.radius))
                 spiral.y spiral.radius 1 20)
      ;; (my-spiral (table.unpack
      ;;             (icollect [_ v (ipairs spiralargs)]
      ;;               (+ v 10))))
      
    )
)



;; (fn love.keypressed [key]
;;   (love.event.quit))
