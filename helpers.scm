(define (to-string exp)
   (cond ((symbol? exp) (symbol->string exp))
         ((number? exp) (number->string exp))
         ((string? exp) (string-append "\"" exp "\"")) ;exp)
         ((pair? exp)
          (string-append
            "("
            (fold (lambda (new old)
                     (string-append old (to-string new)))
                  ""
                  exp)
            ")"))
         (else "to-string: unknown type to convert to string")))

(define (to-string1 s)
   (cond ((symbol? s) (symbol->string s))
         ((number? s) (number->string s))
         ((string? s) s)
         (else s)))

;TODO: should work for numbers, strings, symbols. cast everything to string
(define (my=? a b)
   (string=? (to-string a) (to-string b)))

(define (_hash-strip-tag hash) (car hash))
(define (_hash-add-tag _hash) (cons _hash 'hash))
;internal hash operation
(define (_hash-op hash f . args) (_hash-add-tag (apply f (cons (_hash-strip-tag hash) args))))

;TODO: sort and do tree stuff
(define (_hash-add _hash key val)
   (cons (cons key val) _hash))
(define (_hash-get _hash key)
   (if (null? _hash)
      '()
      (let ((first (car _hash))
            (rest (cdr _hash)))
         (if (my=? (car first) key)
            (car first)
            (_hash-get (cdr _hash) key)))))

(define (hash? hash) (and (pair? hash) (symbol? (cdr hash)) (eq? (cdr hash) 'hash)))
(define (hash-new) (cons '() 'hash))

(define (hash-add hash key val)
   ;(_hash-op hash _hash-add key val))
   (set-car! hash (_hash-add (_hash-strip-tag hash) key val)))
(define (hash-get hash key)
   ;(_hash-op hash _hash-get key))
   (_hash-get (_hash-strip-tag hash) key))


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

