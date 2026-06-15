(local f (require :fractal))

(local state {:tree nil})

(fn love.load []
  (love.window.setTitle "Ch. 8: Fractal Pentagons - Step 2")
  (let [w 1000
        h 1000
        max-levels 12
        config {:decay 0.85
                :twist-step 4.5}]
    (love.window.setMode w h {:resizable false :vsync true})
    (set state.tree (f.create-root-pentagon w h max-levels config))))

(fn love.update [dt])

(fn love.draw []
  (love.graphics.clear 0.95 0.95 0.95 1)
  (love.graphics.setColor 0.15 0.15 0.15 1)
  (love.graphics.setLineWidth 1.5)
  (when state.tree
    (f.draw-tree state.tree)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
