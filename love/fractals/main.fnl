;;; Sutcliffe Pentagon Fractal Animation
;;; Based on the Processing version in Generative Art Ch. 8

;;; Global Parameters
(local max-levels 4)
(local num-sides 8)
(local rotation-speed 24)
(local noise-speed 0.24)
;; Creamy colored sketchbook style
(local bg-color [0.96 0.94 0.90])
(local width 500)
(local height 500)

(var strut-factor 0.3)
(var strut-noise 0)
(var angle-accumulator 0)
(var pentagon nil)
(var paper-texture nil)

(local PointObj {})
(set PointObj.__index PointObj)
(fn PointObj.new [x y]
  (setmetatable {:x x :y y} PointObj))

(local Branch {})
(set Branch.__index Branch)
(fn Branch.new [level num points]
  (let [self (setmetatable {:level level
                            :num num
                            :outer-points points
                            :my-branches []} Branch)]
    (set self.mid-points (self:calc-mid-points))
    (set self.proj-points (self:calc-strut-points))
    (if (< (+ self.level 1) max-levels)
        (do
          ;; Central inner core branch
          (let [child-branch (Branch.new (+ self.level 1) 0 self.proj-points)]
            (table.insert self.my-branches child-branch))

          ;; Peripheral sub-branches around the perimiter
          (for [k 1 (# self.outer-points)]
            (var nextk (- k 1))
            (if (< nextk 1)
                (set nextk (# self.outer-points)))
            (let [new-points [(. self.proj-points k)
                              (. self.mid-points k)
                              (. self.outer-points k)
                              (. self.mid-points nextk)
                              (. self.proj-points nextk)]
                  peripheral-branch (Branch.new (+ self.level 1) k new-points)]
              (table.insert self.my-branches peripheral-branch)))))
    self))

(fn Branch.calc-mid-points [self]
  (local mp-array [])
  (for [i 1 (# self.outer-points)]
    (var nexti (+ i 1))
    (if (< (# self.outer-points) nexti) (set nexti 1))
    (let [this-mp (self:calc-mid-point
                   (. self.outer-points i)
                   (. self.outer-points nexti))]
      (table.insert mp-array this-mp)))
  mp-array)

(fn Branch.calc-mid-point [self end1 end2]
  (let [mx (if (> end1.x end2.x)
               (+ end2.x (/ (- end1.x end2.x) 2))
               (+ end1.x (/ (- end2.x end1.x) 2)))
        my (if (> end1.y end2.y)
               (+ end2.y (/ (- end1.y end2.y) 2))
               (+ end1.y (/ (- end2.y end1.y) 2)))]
    (PointObj.new mx my)))

(fn Branch.calc-strut-points [self]
  (local strut-array [])
  (for [i 1 (# self.mid-points)]
    (var nexti (+ i 3))
    (if (< (# self.mid-points) nexti)
        (set nexti (- nexti (# self.mid-points))))
    (let [this-sp (self:calc-proj-point
                   (. self.mid-points i)
                   (. self.outer-points nexti))]
      (table.insert strut-array this-sp)))
  strut-array)

(fn Branch.calc-proj-point [self mp op]
  (let [opp (if (> op.x mp.x) (- op.x mp.x) (- mp.x op.x))
        adj (if (> op.y mp.y) (- op.y mp.y) (- mp.y op.y))
        px (if (> op.x mp.x)
               (+ mp.x (* opp strut-factor))
               (- mp.x (* opp strut-factor)))
        py (if (> op.y mp.y)
               (+ mp.y (* adj strut-factor))
               (- mp.y (* adj strut-factor)))]
    (PointObj.new px py)))

(fn Branch.draw-me [self]
  (love.graphics.setLineWidth (math.max 1 (- 5 self.level)))
  ;; Charcoal graphite pencil color
  (love.graphics.setColor 0.15 0.15 0.15 0.7)

  ;; Draw outer frames
  (for [i 1 (# self.outer-points)]
    (var nexti (+ i 1))
    (when (< (# self.outer-points) nexti) (set nexti 1))
    (love.graphics.line (. self.outer-points i :x)
                        (. self.outer-points i :y)
                        (. self.outer-points nexti :x)
                        (. self.outer-points nexti :y)))
  ;; Draw inner midpoints, line connections and projection anchors
  (love.graphics.setLineWidth 0.5)
  (for [j 1 (# self.mid-points)]
    (love.graphics.setColor 0.2 0.2 0.2 0.4)
    (love.graphics.line (. self.mid-points j :x)
                        (. self.mid-points j :y)
                        (. self.proj-points j :x)
                        (. self.proj-points j :y))
    ;; Circle fills
    (let [[r g b] bg-color]
      (love.graphics.setColor r g b 0.9))
    (love.graphics.circle :fill (. self.mid-points j :x) (. self.mid-points j :y) 2.5)
    (love.graphics.circle :fill (. self.proj-points j :x) (. self.proj-points j :y) 2.5)

    ;; Circle outlines
    (love.graphics.setColor 0.15 0.15 0.15 0.5)
    (love.graphics.circle :line (. self.mid-points j :x) (. self.mid-points j :y) 2.5)
    (love.graphics.circle :line (. self.proj-points j :x) (. self.proj-points j :y) 2.5))

  ;; Cascade down by child nodes.
  (each [_ child (ipairs self.my-branches)]
    (child:draw-me)))

(local FractalRoot {})
(set FractalRoot.__index FractalRoot)
(fn FractalRoot.new [start-angle]
  (let [self (setmetatable {:point-array []} FractalRoot)
        (w h) (love.graphics.getDimensions)
        center-x (/ w 2)
        center-y (/ h 2)
        angle-step (/ 360.0 num-sides)]
    (for [i 0 359 angle-step]
      (let [rad (math.rad (+ start-angle i))
            x (+ center-x (* 400 (math.cos rad)))
            y (+ center-y (* 400 (math.sin rad)))]
        (table.insert self.point-array (PointObj.new x y))))
    (set self.root-branch (Branch.new 0 0 self.point-array))
    self))

(fn FractalRoot.draw-shape [self]
  (: self.root-branch :draw-me))


;;; Love Engine core loops

(fn love.load []
  (love.window.setTitle "Sutcliffe Fennel Sketchbook")
  (love.window.setMode width height)
  (love.graphics.setLineStyle :smooth)
  (set strut-noise (love.math.random 10))

  ;; Pre-bake procedural paper canvas
  (local (w h) (love.graphics.getDimensions))
  (set paper-texture (love.graphics.newCanvas w h))

  (love.graphics.setCanvas paper-texture)
  (love.graphics.clear 1 1 1 1)

  ;; Splotches
  (for [i 1 400]
    (let [rx (love.math.random 0 w)
          ry (love.math.random 0 h)
          size (love.math.random 40 200)]
      (love.graphics.setColor 0.75 0.72 0.68 0.12)
      (love.graphics.circle :fill rx ry size)))

  ;; Micro-fibers
  (for [i 1 250000]
    (let [rx (love.math.random 0 w)
          ry (love.math.random 0 h)]
      (if (< 0.4 (love.math.random))
          (let [dark (* (love.math.random) 0.18)
                one-minus-dark (- 1 dark)]
            (love.graphics.setColor one-minus-dark one-minus-dark one-minus-dark 1))
          (let [bright (* (love.math.random) 0.1)]
            (love.graphics.setColor 1 1 1 bright)))
      (if (< 0.85 (love.math.random))
          (do
            (love.graphics.setLineWidth 1)
            (love.graphics.line rx ry (+ rx (love.math.random 2 4)) (+ ry (love.math.random 1 2))))
          (love.graphics.points rx ry))))
  (love.graphics.setCanvas))

(fn love.update [dt]
  (set angle-accumulator (+ angle-accumulator (* rotation-speed dt)))
  (set strut-noise (+ strut-noise (* noise-speed dt)))
  (set strut-factor (* (love.math.noise strut-noise) 2))
  (set pentagon (FractalRoot.new angle-accumulator)))

(fn love.draw []
  (let [[r g b] bg-color]
    (love.graphics.clear r g b))
  (if pentagon (pentagon:draw-shape))

  ;; Overlay sketchbook texture mapping using multiply
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.setBlendMode :multiply :premultiplied)
  (love.graphics.draw paper-texture 0 0)
  (love.graphics.setBlendMode :alpha))

