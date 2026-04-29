(local sketches (require :sketches))

(global canvas nil)
;; NOTE: drawing stuff directly to the screen in love.load doesn't work
(fn love.load []
  ;; setup and draw to off-screen canvas
  (set canvas (love.graphics.newCanvas 800 600))
  (love.graphics.setCanvas canvas)
  (love.graphics.clear 0 0 0 0)
  (love.graphics.setBlendMode "alpha")
  (love.graphics.setColor 0 1 0)
  ;;  (sketches.my-spiral 100 100 100)
  ;; (sketches.my-eight-eleven (love.graphics.getDimensions))
  (sketches.my-curve)
  (love.graphics.setCanvas))

(fn love.draw []
  (var (WIDTH HEIGHT) (love.graphics.getDimensions))
  (love.graphics.setBlendMode "alpha" "premultiplied")
  (love.graphics.setColor 1 1 1 1)
  ;; draw the off-screen canvas on the screen
  (love.graphics.draw canvas 0 0))

(fn love.keypressed [key]
  (love.event.quit))
