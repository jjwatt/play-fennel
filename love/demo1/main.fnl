
(var time 0)
(var audio-data nil)
(var audio-source nil)
(var current-volume 0)
(var audio-latency-nudge 0.5)

(global canvas nil)

(fn hsl->rgb [h s l]
  (let [c (* (- 1 (math.abs (- (* 2 l) 1))) s)
        x (* c (- 1 (math.abs (- (% (/ h 60) 2) 1))))
        m (- l (/ c 2))
        (r g b) (if (< h 60) (values c x 0)
                    (< h 120) (values x c 0)
                    (< h 180) (values 0 c x)
                    (< h 240) (values 0 x c)
                    (< h 300) (values x 0 c)
                    (values c 0 x))]
    [(+ r m) (+ g m) (+ b m)]))

(fn get-volume-at [time sample-window-size]
  (let [sample-rate (audio-data:getSampleRate)
        center-sample (math.floor (* time sample-rate))
        half-win (math.floor (/ sample-window-size 2))]

    (var sum-squares 0)
    (var count 0)

    (for [i (- center-sample half-win) (+ center-sample half-win)]
      (when (and (<= 0 i) (< i (audio-data:getSampleCount)))
        (let [sample (audio-data:getSample i)]
          (set sum-squares (+ sum-squares (* sample sample)))
          (set count (+ count 1)))))
    (if (< 0 count)
        (math.sqrt (/ sum-squares count))
        0)))

(fn love.load []
  (love.window.setTitle "Diglet Demo1 - Model:Cycles, Fennel & LOVE2D")
  (love.graphics.setLineJoin :bevel)
  (let [(w h) (love.graphics.getDimensions)]
    (set canvas (love.graphics.newCanvas w h)))
  (love.graphics.setCanvas canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setCanvas)
  (set audio-data (love.sound.newSoundData "diglet.wav"))
  (set audio-source (love.audio.newSource audio-data))
  (love.audio.play audio-source))

(fn love.update [dt]
  (if (and audio-source (audio-source:isPlaying))
      (set time (audio-source:tell :seconds))
      (set time (+ time dt)))
  (let [sample-time (+ time audio-latency-nudge)]
    (set current-volume (get-volume-at sample-time 1024))))

(fn love.draw []
  (let [(width height) (love.graphics.getDimensions)
        cx (/ width 2)
        cy (/ height 2)]

    (love.graphics.setCanvas canvas)
    (love.graphics.setBlendMode :alpha)

    ;; Dynamic trail
    (let [clear-alpha (+ 0.01 (* current-volume 0.1))]
      (love.graphics.setColor 0 0 0 clear-alpha)
      (love.graphics.rectangle :fill 0 0 width height))

    (let [radius (+ 10 (* current-volume 600))]
      (love.graphics.setLineWidth 3)
      (love.graphics.setColor current-volume 0.5 1.0 0.8)
      (love.graphics.circle :line cx cy radius))
    (love.graphics.setCanvas)
    (love.graphics.setBlendMode :alpha :premultiplied)
    (love.graphics.setColor 1 1 1 1)
    (love.graphics.draw canvas 0 0)))

(fn love.keypressed [key]
  (when (= key "q")
    (love.event.quit)))
