(local clj (require :cljlib))
(import-macros cljm (doto :cljlib require))
(import-macros {: fn*} :cljlib)
(import-macros {: defn} :cljlib)
(import-macros {: loop} :cljlib)

;; multi-arity like clojure
(fn* bar
     "examples:
          (bar 1)
          (bar 1 2 3 4)"
     ([a] a)
     ([a b] (+ a b))
     ([a b & c]
      (bar (+ a b) (clj.unpack* c))))
;; Can use defn, too
(defn bar
  "docstring."
  ([a] a)
  ([a b] (+ a b))
  ([a b & c]
   (bar (+ a b) (clj.unpack* c))))

(let [t1 [1 2 3]
      (t2 v) (clj.remove t1)]
  (assert (clj.eq t1 [1 2 3])))

(assert (clj.eq [0 1] (clj.cons 0 [1])))

;; loop like clojure!
(loop [[first & rest] [1 2 3 4 5]
       i 0]
      (if (= nil first)
          i
          (recur rest (+ 1 i))))

(clj.seq [1 2 3 4])
