;; now we're in business

;; call/cc
(+ 1 (call/cc
      (lambda (k)
	(+ 2 (k 3)))))

(define r #f)
( + 1 (call/cc
       (lambda (k)
	 (set! r k)
	 (+ 2 (k 3)))))

;; escaping continuations
(define list-product
  (lambda (s)
    (let recur ((s s))
      (if (null? s) 1
	  (* (car s) (recur (cdr s)))))))

(define list-product
  (lambda (s)
    (call/cc
     (lambda (exit)
       (let recur ((s s))
	 (if (null? s) 1
	     (if (= (car s) 0) (exit 0)
		 (* (car s) (recur (cdr s))))))))))

;; flatten
(define flatten
  (lambda (tree)
    (cond ((null? tree) '())
	  ((pair? (car tree))
	   (append (flatten (car tree))
		   (flatten (cdr tree))))
	  (else
	   (cons (car tree)
		 (flatten (cdr tree)))))))

	  ;; do two trees have the same fringe?
	  ;; (same-fringe? '(1 (2 3)) '((1 2) 3))
	  (define same-fringe?
	    (lambda (tree1 tree2)
	      (let loop ((ftree1 (flatten tree1))
			 (ftree2 (flatten tree2)))
		(cond ((and (null? ftree1) (null? ftree2)) #t)
		      ((or (null? ftree1) (null? ftree2)) #f)
		      ((eqv? (car ftree1) (car ftree2))
		       (loop (cdr ftree1) (cdr ftree2)))
		      (else #f)))))


