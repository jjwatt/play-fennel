(require :L5)

(fn setup []
  (windowTitle "The Wrong Way To Draw A Line (Imperative)")
  (size 500 100)
  (background 255)
  (strokeWeight 5)
  (smooth)

  (var lastx -999)
  (var lasty -999)
  (var y 50)
  (let [border-x 20
        border-y 10
        step 10
        max-x (- width border-x)]
    (for [x border-x max-x step]
      (set y (+ border-y (random (- height (* 2 border-y)))))
      (when (> lastx -999)
        (line x y lastx lasty))
      (set lastx x)
      (set lasty y))))

(fn draw [])

(set _G.setup setup)
(set _G.draw draw)
