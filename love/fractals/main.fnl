(local f (require :fractal))

(local state {:tree nil :time 0})

(fn love.load []
  (set state.tree (f.create-tree 250 300 -90 80 1 8)))

(fn love.update [dt]
  (set state.time (+ state.time dt)))

(fn love.draw []
  (love.graphics.clear 1 1 1 1)
  (love.graphics.setColor 0 0 0 1)
  (love.graphics.setLineWidth 1)
  (f.draw-tree state.tree))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
