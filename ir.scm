(load "helpers.scm")

;for generic helpers
(define (ir-store name val)
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
   (list
      (ir-tag 'if)
      (exp->ir (cadr exp))
      (exp->ir (caddr exp))
      (exp->ir (cadddr exp))))

(define (ir-gen-cond exp)
   (list (ir-tag 'cond)))
(define (ir-gen-let exp)
   (list (ir-tag 'let)))
(define (ir-gen-call name args)
   (list (ir-tag 'call) (exp->ir name) (map exp->ir args)))
(define (ir-gen-lambda args body)
   (list (ir-tag 'lambda) (map exp->ir args) (list (map (lambda (x) (exp->ir x)) body))))
(define (ir-gen-special name exp)
   (list (ir-tag 'special) (exp->ir name) exp))
(define (ir-gen-begin exp)
   (list (ir-tag 'block) (map exp->ir exp)))

;end gen-ir-cons

;MACRO NOTES
;ir macro stored as "name" : (cons (macro args) (macro body))
;TODO: might have to save every macro to file if we are getting called in js repl
;TODO: try macros in file generation
(define macros (hash-new))

(define (gen-ir-cons exp)
   (define (ir-def-macro? exp) ;"did we encountered new macro definition?" check
      (and (> (length exp) 2) (pair? (cadr exp))
           (not (symbol? (cadr exp))) (eq? (car exp) 'define-macro)))

   (define (ir-gen-macro args body) ;add the new macro to macros hash and return '()
      ;(display "ir-gen-macro\n") (display args) (display "\n") (display body)
      (hash-add macros (car args) (cons (cdr args) body)) ;(list (ir-tag 'macro-invoke) '(cons (cdr args) body)))
      ;(ir-gen-null))
      ;(ir-store (car args) (list (ir-tag 'lambda) (map exp->ir (cdr args)) body)))
      (list (ir-tag 'macro-def) (car args) (cdr args) (map exp->ir (car body))))
      ;(ir-gen-str (string-append "generated macro: " (symbol->string (car args)))))

   ;invocation of macro => ir
   (define (ir-macro-call? exp)
      ;(define macro (ir-macro-call-get-macro exp))
      ;(define is-macro-call (if (eq? macro '()) #f #t))
      ;(if is-macro-call (display "calling macro") (display "not macro!"))
      ;is-macro-call)
      (not (eq? (ir-macro-call-get-macro exp) '())))

   (define (ir-macro-call-get-macro exp)
      (define name (car exp)) ;macro name (symbol?) to look up in macros
      (define macro (hash-get macros name))
      ;(display "macro name:") (display name) (display "\n")
      ;(display "macro content:") (display macro) (display "\n")
      macro)

   ;call
   (define (ir-expand-macro exp)
      (define macro (ir-macro-call-get-macro exp))
      (define func '())
      ;(display "expanding macro")
      (list (ir-tag 'macro-call) (exp->ir (car exp)) (cdr exp)))
      ;(ir-gen-str "macro expanding"))
      ;(ir-gen-str "test")

   (define (get-func-name exp)
      (let ((test-name (car exp)))
         (cond ((symbol? test-name) test-name)
               ((pair? test-name)
                (let ((tmp-name (ir-get-tmp-name)))
                  (ir-store tmp-name (exp->ir test-name))
                  (string->symbol tmp-name)))
               (else (ir-gen-err
                        (string-append "bad function name: "
                                       (to-string test-name)))))))

   (let ((args (cdr exp))
         (name (get-func-name exp)))
      (cond
         ((and (symbol? (car exp)) (eq? (car exp) 'tag) (tag-ir exp)))
         ((ir-def-macro? exp) (ir-gen-macro (car args) (cdr args)))
         ((ir-macro-call? exp) (ir-expand-macro exp)) ;TODO
         ((ir-def-func? exp)
          (ir-store (caar args) (ir-gen-lambda (cdr (car args)) (cdr args)))) ;last was (cadr args)
         ((ir-def-ass? exp) (ir-store (car args) (exp->ir (cadr args))))
         ((ir-lamb? exp) (ir-gen-lambda (car args) (cdr args)))
         ((ir-begin? exp) (ir-gen-begin args)) ;exp or args???
         ((ir-if? exp) (ir-gen-if exp))
         ((ir-cond? exp) (ir-gen-cond exp))
         ((ir-let? exp) (ir-gen-let exp))
         ((ir-special? exp) (ir-gen-special (car exp) (cdr exp)))
         ((ir-call? exp) (ir-gen-call (car exp) (cdr exp))) ;kk comment for debug
         ;((ir-call? exp) (begin (display macros) (ir-gen-call (car exp) (cdr exp)))) ;kk debug line uncomment for printing macros on function call
         (else (ir-gen-err "bad gen-ir-cons cond")))))

;for exp->ir
(define (ir-gen-null) (ir-tag 'null))
(define (ir-gen-num n) (list (ir-tag 'num) n))
(define (ir-gen-str s) (list (ir-tag 'str) s))
(define (ir-gen-sym s) (list (ir-tag 'sym) s))

(define (ir-gen-quasiquote exp) (list (ir-tag 'qq) exp))
(define (ir-gen-unquote exp) (list (ir-tag 'uq) exp))
(define (ir-gen-quote exp) (list (ir-tag 'q) exp))
;end exp->ir

(define (exp->ir exp)
   (cond
      ((ir-tag? exp) exp)
      ((null? exp) (ir-gen-null))
      ((number? exp) (ir-gen-num exp))
      ((string? exp) (ir-gen-str exp))
      ((symbol? exp) (ir-gen-sym exp))
      ((and (pair? exp) (eq? (car exp) 'quasiquote))
       (ir-gen-quasiquote (cdr exp)))
      ((and (pair? exp) (eq? (car exp) 'unquote))
       (ir-gen-unquote (cdr exp)))
      ((and (pair? exp) (eq? (car exp) 'quote))
       (ir-gen-quote (cdr exp)))
      ((pair? exp) (gen-ir-cons exp))
      (else (ir-gen-err (string-append "exp->ir call else called: " (to-string exp))))))

(define (tag-remove-ir-rec e)
   (if (pair? e)
      (if (eq? (car e) 'ir)
         (if (pair? (cdr e)) (mymap tag-remove-ir-rec (cdr e)) (cdr e))
         (cons (if (is-tag? e) (cdar e) (mymap tag-remove-ir-rec (car e)))
               (mymap tag-remove-ir-rec (cdr e))))
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

(define (ir-repl)
   (exp->ir (read))
   (print-ir1 (exp->ir (read)) 0)
   (ir-repl))

