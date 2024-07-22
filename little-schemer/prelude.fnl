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
(fn atom? [t]
  (and (not= (type t) :nil) (not= (type t) :table)))
(fn pair? [t]
  (and (not= (type t) :nil) (not (atom? t))))
(fn empty? [t]
             (if (= nil (next t))
                 true
                 false))
;; doesn't handle nil
;; (fn lat? [l]
;;   (if (empty? l)
;;       true
;;       (if (not (atom? (car l)))
;;           false
;;           (lat? (cdr l)))))

;; lat that handles nil
(fn lat? [l]
  (if (empty? l)
      true
      (if (or (= nil l) (not (atom? (car l))))
          false
          (lat? (cdr l)))))
