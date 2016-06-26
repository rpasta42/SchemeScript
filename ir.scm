;for generic helpers

(define (ir-store name val)
;   `(,(ir-tag 'assign) (,(ir-tag 'sym) ,name) ,(exp->ir val)))
   (list (ir-tag 'assign) (exp->ir name) val))

(define (ir-tag tag)
   (cons 'ir tag))
(define (ir-tag? x)
   (and (pair? x) (pair? (car x)) (eq? (caar x) 'ir)))
(define (is-tag? e) (and (pair? e) (pair? (car e)) (eq? (caar e) 'ir)))

;end generic helpers

;for gen-ir-cons
(define (ir-def? exp)
   (and (> (length exp) 2)
        (or (eq? (car exp) 'define) (eq? (car exp) 'def))))

(define (ir-def-func? exp)
   (and (ir-def? exp) (pair? (cadr exp)) (not (symbol? (cadr exp)))))
(define (ir-def-ass? exp)
   (and (ir-def? exp) (symbol? (cadr exp))))

(define (ir-lamb? exp) (eq? (car exp) 'lambda)) ;check format
(define (ir-if? exp) (eq? (car exp) 'if)) ;check more stuff here
(define (ir-cond? exp) (eq? (car exp) 'cond)) ;check this stuff
(define (ir-let? exp) (eq? (car exp) 'let))
(define (ir-begin? exp) (and (pair? exp) (or (eq? (car exp) 'do) (eq? (car exp) 'begin))))
(define (ir-call? exp)
   (and (pair? exp) (> (length exp) 0)))
(define (ir-special? exp)
   (and (ir-call? exp)
        (or (eq? (car exp) 'tag) (eq? (car exp) 'style) (eq? (car exp) 'attr))))

(define (ir-gen-if exp)
   (list (ir-tag 'if) (exp->ir (cadr exp)) (exp->ir (caddr exp)) (exp->ir (cadddr exp))))
(define (ir-gen-cond exp)
   (list (ir-tag 'cond)));(ir-gen-err (list (ir-tag 'cond)))) ;"cond not supported yet"))
(define (ir-gen-let exp)
   (list (ir-tag 'let)));(ir-gen-err (list (ir-tag 'let)))) ;(ir-gen-err "unsupported let"))
(define (ir-gen-call name args)
   (list (ir-tag 'call) (exp->ir name) (map exp->ir args)))

(define (ir-gen-lambda args body)
;   `(,(ir-tag 'lambda) ,(map exp->ir args) ,(exp->ir body)))
   (list (ir-tag 'lambda) (map exp->ir args) (list (map (lambda (x) (exp->ir x)) body))))
(define (ir-gen-special name exp)
   (list (ir-tag 'special) (exp->ir name) exp))
(define (ir-gen-begin exp)
   (list (ir-tag 'block) (map exp->ir exp)))

;end gen-ir-cons

(define (gen-ir-cons exp)
   (define (get-func-name exp)
      (let ((test-name (car exp)))
         (cond ((symbol? test-name) test-name)
               ((pair? test-name)
                (let ((tmp-name (ir-get-tmp-name)))
                  (ir-store tmp-name (exp->ir test-name))
                  (string->symbol tmp-name)))
               (else ir-gen-err (string-append "bad function name: " (to-string test-name))))))

   (let ((args (cdr exp))
         (name (get-func-name exp)))
      (cond
         ((ir-def-func? exp) (ir-store (caar args) (ir-gen-lambda (cdr (car args)) (cdr args)))) ;last was (cadr args)
         ((ir-lamb? exp) (ir-gen-lambda (car args) (cdr args)))
         ((ir-def-ass? exp) (ir-store (car args) (exp->ir (cadr args))))
         ((ir-begin? exp) (ir-gen-begin args)) ;exp or args???
         ((ir-if? exp) (ir-gen-if exp))
         ((ir-cond? exp) (ir-gen-cond exp))
         ((ir-let? exp) (ir-gen-let exp))
         ((ir-special? exp) (ir-gen-special (car exp) (cdr exp)))
         ((ir-call? exp) (ir-gen-call (car exp) (cdr exp)))
         (else (ir-gen-err "bad gen-ir-cons cond")))))

;for exp->ir
(define (ir-gen-null) (ir-tag 'null)) ;'ir-null)
(define (ir-gen-num n) (list (ir-tag 'num) n))
(define (ir-gen-str s) (list (ir-tag 'str) s))
(define (ir-gen-sym s) (list (ir-tag 'sym) s))
;end exp->ir

(define (exp->ir exp)
   (cond
      ((ir-tag? exp) exp)
      ((null? exp) (ir-gen-null))
      ((number? exp) (ir-gen-num exp))
      ((string? exp) (ir-gen-str exp))
      ((symbol? exp) (ir-gen-sym exp))
      ((pair? exp) (gen-ir-cons exp)) ;(cons 'block (gen-ir-cons exp)))
      (else (ir-gen-err "exp->ir call else called"))))

(define (tag-remove-ir-rec e)
   (if (pair? e)
      (if (eq? (car e) 'ir)
         (if (pair? (cdr e)) (map tag-remove-ir-rec (cdr e)) (cdr e))
         (cons (if (is-tag? e) (cdar e) (map tag-remove-ir-rec (car e)))
               (map tag-remove-ir-rec (cdr e))))
      e))

(define (runner exp)
   (list (ir-tag 'block) (map exp->ir exp)))

(define (print-ir ir nest)
   (if (pair? ir)
      (if (eq? (car ir) 'block)
         (begin
            (display "[")
            (map (lambda (x) (print-ir x (+ nest 1))) (cdr ir))
            (display "]"))
         (begin
            (display "(")
            (map (lambda (x) (display "(") (print-ir x nest) (display ")")) ir)
            (display ")")))
      (begin (display ir) (display " "))))

(define (print-ir1 ir nest)
   (display (car ir)) (display "\n")
   (map (lambda (x)
          (display x)
          (display "\n"))
        (cadr ir)) ;(cadr ir)) ;to display block, just use ir
   (display "\n"))

;(define exp-lisp '((define (f x y) (- 3 10) (+ x 4 2))))
;(display (ir->js (exp->ir exp-lisp)))
(define exp-lisp '((define x (+ 3 5)) (define (f x y) (- 3 10) (+ x y 4 2)))) ;works
;(define exp-lisp '((define x (+ 3 5)) (define (f x y) (- 3 10) (+ x y 4 2))) (f 3 5)) ;broken

;(define exp-lisp '((begin (+ 3 2) (- 2 16)) (def (f x) (+ x 5)) (def y 10) (if (> (f y) 15) (console.log "greater") (console.log "smaller"))))
;(define exp-lisp '((def y 15))) ;broken
;(define exp-lisp '((+ 3 (- 5 10))))
;(define exp-lisp '((define x (+ 3 5))))
;(display (to-ir exp-lisp 0))

;(print-ir1 (runner exp-lisp) 0)
;(print-ir1 (tag-remove-ir-rec (runner exp-lisp)) 0)


