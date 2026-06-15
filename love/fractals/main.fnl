(local f (require :fractal))

(local state {:time 0
              :rotation 0
              :config {:max-depth 5
                       :num-children 5
                       :decay 0.55
                       :speed-multiplier 1.8}})

(fn love.load []
  (love.window.setTitle "Functional Cog Fractals")
  (let [w 1280
        h 720]
    (love.window.setMode w h {:resizable false :vsync true})))

(fn love.update [dt]
  (set state.time (+ state.time dt))
  (set state.rotation (+ state.rotation (* dt 15.0))))

(fn love.draw []
  (love.graphics.clear 0.96 0.96 0.94 1)
  (let [(w h) (love.graphics.getDimensions)
        cx (/ w 2)
        cy (/ h 2)
        base-len 130]
    (for [i 1 6]
      (let [base-angle (* i (/ 360 6))
            root-node (f.create-cog cx cy base-angle base-len 1 state.config state.rotation)]
        (f.draw-cog root-node)))))

(fn love.keypressed [key]
  (when (or (= key :q) (= key :escape))
    (love.event.quit)))
