;; Stuff we need to bootstrap The Little Schemer
;; from fennel

(fn table-insert [tab val]
  (var t tab)
  (table.insert t val)
  t)
(fn table-remove [tab indx]
  (var t tab)
  (table.remove t indx)
  t)
(fn car [lst]
  (. lst 1))
(fn cdr [lst]
  (icollect [i v (ipairs lst)] (if (not= 1 i) v)))
(fn cons [head tail]
  [head (table.unpack tail)])
(fn map [func lst]
  (icollect [_ val (ipairs lst)]
    (func val)))
;; (fn atom? [t]
;;   (and (not= (type t) :nil) (not= (type t) :table)))
(fn atom? [t]
  (not= (type t) :table))
;; "safe" list
(fn list? [t]
  (and (not (atom? t))
       (not= (type t) :nil)
       (= (type t) :table)))
(fn pair? [t]
  (list? t))
;; unsafe empty. will throw on atom
(fn unsafe-empty? [t]
  (if (= nil (next t))
      true
      false))
;; "safe" null
(fn null? [o]
  (if (atom? o)
      (= nil o)
      (= nil (next o))))
;; safe empty based on null?
(fn empty? [t]
  (null? t))
;; Chapter 1
;; Primitive
(fn s-expr? [x]
  (or (atom? x)
      (list? x)))
;; Probably wrong
(fn eq? [a b]
  (= a b))
;; Chapter 2
;; lat? list of atoms?
;; "safe" because it checks assumes a list
;; TODO: rewrite in fennel style (use match or case etc)
(fn lat? [l]
  (if (atom? l) false
      (if (empty? l)
          true
          (if (or
               (= nil l)
               (not (atom? (car l))))
              false
              (lat? (cdr l))))))

;; probably broken af
;; just wrote it
;; (fn fennel-lat? [list]
;;   (if (atom? list)
;;       false
;;       (if empty? list)
;;       true
;;       (match list
;;         nil false
;;         [head & tail] (if (not (atom? head))
;;                           false
;;                           (fennel-lat? tail)))))
;; terrible failure
;; (fn fennel-lat? [list]
;;   (match list
;;     x (if (empty? x)
;;           true
;;           (if (atom? x)
;;               false))
;;     nil false
;;     [head & tail] (if (not (atom? head))
;;                       false
;;                       (fennel-lat? tail))
;;     [] true))

;; This is kinda clearer, definitional.
(fn lat2? [l]
  (if (atom? l)
      false
      (empty? l)
      true
      (= nil l)
      false
      (not (atom? (car l)))
      false
      (lat2? (cdr l))))

;; lat3 is lat2 simplified
(fn lat3? [list]
  (if (or
       (atom? list)
       (= nil list)
       (not (atom? (car list))))
      false
      (empty? list)
      true
      (lat3? (cdr list))))
(fn member? [a lat]
  (if
   (null? lat)
   false
   (or (eq? (car lat) a)
       (member? a (cdr lat)))))
(fn rember [a lat]
  (if
   (null? lat) []
   (eq? a (car lat)) (cdr lat)
   (cons (car lat) (rember a (cdr lat)))))

