(local f (require :fractal))

(local state {:root nil})

(fn love.load []
  (love.window.setTitle "Ch. 8: Fractal Pentagons - Step 1")
  (let [w 1000
        h 1000]
    (love.window.setMode w h)
    (set state.root (f.create-root-pentagon w h))))

(fn love.update [dt])

(fn love.draw []
  (love.graphics.clear 0.95 0.95 0.95 1)
  (love.graphics.setColor 0.15 0.15 0.15 1)
  (love.graphics.setLineWidth 2)
  (when state.root
    (f.draw-root state.root)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
