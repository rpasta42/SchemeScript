(define (ir-store name val)
;   `(,(ir-tag 'assign) (,(ir-tag 'sym) ,name) ,(exp->ir val)))
   (list (ir-tag 'assign) (exp->ir name) val))

(define (ir-gen-cond exp)
   (list (ir-tag 'cond)));(ir-gen-err (list (ir-tag 'cond)))) ;"cond not supported yet"))
(define (ir-gen-let exp)
   (list (ir-tag 'let)));(ir-gen-err (list (ir-tag 'let)))) ;(ir-gen-err "unsupported let"))
(define (ir-gen-call name args)
   (list (ir-tag 'call) (exp->ir name) (map exp->ir args)))
(define (ir-gen-lambda args body)
;   `(,(ir-tag 'lambda) ,(map exp->ir args) ,(exp->ir body)))
   (list (ir-tag 'lambda) (map exp->ir args) (list (map (lambda (x) (exp->ir x)) body))))


(define (ir-gen-null) (ir-tag 'null)) ;'ir-null)

;;;;in exp->ir
      ((pair? exp) (gen-ir-cons exp)) ;(cons 'block (gen-ir-cons exp)))

;bottom comments
;(print-ir1 (exp->ir (read)) 0)
;(ir-repl)

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
