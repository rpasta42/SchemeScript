
(define (to-string exp)
   (cond ((symbol? exp) (symbol->string exp))
         ((number? exp) (number->string exp))
         ((string? exp) (string-append "\"" exp "\""))
         ((pair? exp)
          (string-append
            "("
            (fold (lambda (new old)
                     (string-append old (to-string new)))
                  ""
                  exp)
            ")"))
         (else "to-string: unknown type to convert to string")))

(define (ir-gen-err msg) (list (ir-tag 'err) msg))

;(define (ir-get-tmp-name) (string-append "tmp" (number->string (random 1000))))
(define curr-tmp 0)
(define (ir-get-tmp-name)
   (set! curr-tmp (+ curr-tmp 1))
   (string-append "tmp" (number->string curr-tmp)))


(define fold
   (lambda (combine init lst)
         (if (null? lst)
            init
            (if (not (pair? lst))
               (combine lst init)
               (fold combine (combine (car lst) init) (cdr lst))))))

(define (mymap f lst)
   (if (null? lst)
      '()
      (if (not (pair? lst))
         (cons (f lst) '())
         (cons (f (car lst)) (mymap f (cdr lst))))))

(define (make-tabs ntabs)
   (if (= ntabs 0)
      ""
      (string-append "   " (make-tabs (- ntabs 1)))))

(define (lst->comma-str exp)
   (if (null? exp)
      ""
      (string-append
       (cond ((symbol? (car exp))
              (symbol->string (car exp)))
             ((number? (car exp))
              (number->string (car exp)))
             (else (car exp))) ;lst->comma-str ???
       (if (null? (cdr exp)) "" ", ")
       (lst->comma-str (cdr exp)))))

