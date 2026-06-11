(local d (require :dynamic))

(local state {:bouncers []
              :effects []
              :canvas nil
              :accumulator 0
              :target-dt (/ 1 60)})

(fn love.load []
  (love.window.setTitle "Noisy Flower City - Fennel & LOVE2D")
  (let [w 1280
        h 720]
    (love.window.setMode w h)
    (for [i 1 60]
      (table.insert state.bouncers (d.make-bouncer w h)))

    (set state.canvas (love.graphics.newCanvas w h))
    (love.graphics.setCanvas state.canvas)
    (love.graphics.clear 1 1 1 1)
    (love.graphics.setCanvas)))

(fn love.update [dt]
  (set state.accumulator (+ state.accumulator dt))
  (while (>= state.accumulator state.target-dt)
    (let [(w h) (love.graphics.getDimensions)
          current-bouncers state.bouncers
          collision-results []]
      ;; Process collisions
      (each [_ b (ipairs current-bouncers)]
        (table.insert collision-results (d.process-bouncer-interactions current-bouncers b)))

      ;; Update bouncer configurations
      (let [next-bouncers []]
        (each [_ res (ipairs collision-results)]
          (table.insert next-bouncers (d.move-bouncer-noise-steering res.bouncer w h)))
        (set state.bouncers next-bouncers))

      ;; Collate and fade existing visual effects tracking lists
      (let [combined-effects []]
        ;; Age old effects
        (each [_ e (ipairs state.effects)]
          (let [next-e (d.copy-table e)]
            (set next-e.alpha (- e.alpha 5))
            (if (> next-e.alpha 0)
                (table.insert combined-effects next-e))))
        ;; Inject new collision flares.
        (each [_ res (ipairs collision-results)]
          (each [_ fx (ipairs res.effects)]
            (table.insert combined-effects fx)))
        (set state.effects combined-effects))
      (set state.accumulator (- state.accumulator state.target-dt)))))

(fn love.draw []
  (love.graphics.setCanvas state.canvas)

  (love.graphics.setColor 1 1 1 (/ 20 255))
  (love.graphics.rectangle :fill 0 0 (love.graphics.getWidth) (love.graphics.getHeight))

  (each [_ e (ipairs state.effects)]
    (love.graphics.setLineWidth (d.random-range 0 0.25))
    (d.draw-noisy-circle e.x e.y e.radius e.alpha))

  (love.graphics.setCanvas)
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.draw state.canvas 0 0))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
