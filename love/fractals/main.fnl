(local f (require :fractal))

(local state {:tree nil
              :max-levels 4
              :config {:num-sides 5
                       :strut-factor 0.33}})

(fn love.load []
  (love.window.setTitle "Ch. 8ish: Sutcliffe Polygon Sandbox")
  (let [w 1000
        h 1000]
    (love.window.setMode w h {:resizable false :vsync true})
    (set state.tree (f.create-root-polygon 1000 1000 state.max-levels state.config))))

(fn love.draw []
  (love.graphics.clear 0.85 0.85 0.80 1)
  (love.graphics.setColor 0.05 0.05 0.05 1)
  (love.graphics.setLineWidth 1.2)
  (when state.tree
    (f.draw-tree state.tree)))

(fn love.keypressed [key]
  (let [cfg state.config]
    (if (= key :escape) (love.event.quit)
        (= key :left) (set cfg.num-sides (math.max 3 (- cfg.num-sides 1)))
        (= key :right) (set cfg.num-sides (math.min 10 (+ cfg.num-sides 1)))
        (= key :up) (set cfg.strut-factor (math.min 0.48 (+ cfg.strut-factor 0.02)))
        (= key :down) (set cfg.strut-factor (math.max 0.15 (- cfg.strut-factor 0.02))))
    (set state.tree (f.create-root-polygon 1000 1000 state.max-levels state.config))))
