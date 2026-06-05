(require :L5)

(fn setup []
  (windowTitle "Noisy Line")
  (size 500 100)
  (background 255)
  (strokeWeight 5)
  (smooth)

  (stroke 0 30)
  (line 20 50 480 50)
  (stroke 20 50 70)

  (let [border-x 20
        x-step 10
        max-x (- width border-x)]
    (var y 50)
    (var y-noise (random 10))
    (let [points []]
      (for [x border-x max-x x-step]
        (let [y (+ 10 (* (love.math.noise y-noise) 80))]
          (set y-noise (+ y-noise 0.1))
          (table.insert points {: x : y})))
      (for [i 1 (- (length points) 1)]
        (let [{:x x1 :y y1} (. points i)
              {:x x2 :y y2} (. points (+ i 1))]
          (line x1 y1 x2 y2))))))

(fn draw [])

(set _G.setup setup)
(set _G.draw draw)
