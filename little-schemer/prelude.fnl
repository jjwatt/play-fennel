;; Stuff we need to bootstrap The Little Schemer
;; from fennel

(fn car [[head & tail]]
  head)
(fn cdr [[head & tail]]
  tail)
(fn cons [head tail]
  [head (table.unpack tail)])
(fn null? [o]
  (= nil o))
(fn list? [t]
  (= (type t) :table))
(fn atom? [t]
  (and (not (list? t) (not (null? t)))))
(fn empty? [t]
  (null? t))

;;; Chapter 1
(fn s-expr? [x]
  (or (atom? x)
      (list? x)))
(fn eq? [a b]
  (= a b))

;;; Chapter 2
;; lat? list of atoms?
;; Like the book (not safe)
(fn lat? [l]
  (if (null? l) true
      (atom? (car l)) (lat? (cdr l))
      false))

(fn member? [a lat]
  (if
   (null? lat)
   false
   (or (eq? (car lat) a)
       (member? a (cdr lat)))))

;;; Chapter 3: Cons the Magnificient

(fn rember [a lat]
  (if
   (null? lat) []
   (eq? (car lat) a) (cdr lat)
   (cons (car lat) (rember a (cdr lat)))))

