
(define fib
  (lambda (n)
    (if (< n 3)
      1
      (+ (fib (- n 1)) (fib (- n 2))))))

(print (fib 5))
(print (fib 10))
(print (fib 15))
(print (fib 20))
(print (fib 25))

