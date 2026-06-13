(local f (require :fractal))

(local state {:tree nil :time 0})

(fn love.load []
  (love.window.setTitle "Recursive Fractal Tree")
  (let [w 640
        h 480]
    (love.window.setMode w h {:resizable false :vsync true})
    (set state.tree (f.create-tree (/ w 2) h -90 150 1 10))))

(fn love.update [dt]
  (set state.time (+ state.time dt))
  (let [(w h) (love.graphics.getDimensions)
        sway-angle (+ -90 (* (math.sin (* state.time 1.5)) 4))]
    (set state.tree (f.create-tree (/ w 2) h sway-angle 150 1 8))))

(fn love.draw []
  (love.graphics.clear 1 1 1 1)
  (love.graphics.setColor 0 0 0 1)
  (love.graphics.setLineWidth 1)
  (f.draw-tree state.tree))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
