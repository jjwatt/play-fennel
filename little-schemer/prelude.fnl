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
;; "safe" because it checks assumes a list
(fn lat? [l]
  (if (atom? l) false
      (if (empty? l)
          true
          (if (or
               (= nil l)
               (not (atom? (car l))))
              false
              (lat? (cdr l))))))
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

(fn member? [a lat]
  (if
   (null? lat)
   false
   (or (eq? (car lat) a)
       (member? a (cdr lat)))))
