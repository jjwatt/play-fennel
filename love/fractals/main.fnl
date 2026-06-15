(local f (require :fractal))

(local state {:tree nil :time 0})

(fn love.load []
  (love.window.setTitle "Ch. 8: Fractal Pentagons - Step 2")
  (let [w 1000
        h 1000]
    (love.window.setMode w h {:resizable false :vsync true})
    (set state.config {:decay 0.82
                       :twist-step 3.0
                       :noise-amplitude 120.0
                       :noise-freq 0.005
                       :noise-speed 1.2})))

(fn love.update [dt]
  (set state.time (+ state.time dt))
  (let [(w h) (love.graphics.getDimensions)
        max-levels 10]
    (set state.tree (f.create-root-pentagon w h max-levels state.config state.time))))

(fn love.draw []
  (love.graphics.clear 0.95 0.95 0.95 1)
  (love.graphics.setColor 0.15 0.15 0.15 1)
  (love.graphics.setLineWidth 1.5)
  (when state.tree
    (f.draw-tree state.tree)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
