(load "helpers.scm")

(define (list-set! list k val)
    (if (zero? k)
        (set-car! list val)
        (list-set! (cdr list) (- k 1) val)))

(define (list-prepend! lst val)
   (if (not (eq? lst '()))
      (begin (set-cdr! lst lst)
             (set-car! lst val))
      (set! lst (list val))));(set-car! lst val

;(list tags attrs styles)
(define (new-html-obj) (list name (hash-new) (hash-new) (hash-new)))

(define (ho-get-name ho) (car ho))
(define (ho-get-tags ho) (cadr ho))
(define (ho-get-attrs ho) (caddr ho))
(define (ho-get-styles ho) (cadddr ho))

(define (ho-set-name ho name) (set-car! ho name))
(define (ho-add-tag ho tag)     (hash-add (ho-get-tags ho) (ir-get-tmp-name) tag))
(define (ho-add-attr ho attr)   (hash-add (ho-get-attrs ho) (ir-get-tmp-name) attr))
(define (ho-add-style ho style) (hash-add (ho-get-styles ho) (itr-get-tmp-name) style))

(define (html-syntax-macro-pair-sym doc exp)
   (define obj-type (car exp))
   (cond
      ((eq? obj-type 'tag) (ho-set-name doc (cadr exp)))
      (;(ho-add-tag doc (cadr exp)))
      (else (ho-add-style doc "random style"))))

(define (html-syntax-macro doc exp)
   (cond
      ((not (pair? exp)) exp)
      ((symbol? (car exp))
       (begin (html-syntax-macro-pair-sym doc exp)
              doc))
      (else (cons (html-syntax-macro doc (car exp) (html-syntax-macro doc (cdr exp)))))))

(define test-exp-pic
   '(define my-pic (tag img (attr src "test.png"))))

(define test-exp
   '(tag div
      (attr (color red) (id "yo") (class "hi"))
      (style (background-color red) (border-radius 10))
      (tag h1 "hello")
      (tag a "ha")
      (ref mypic)))

(define main-doc (new-html-obj))
(define result (html-syntax-macro main-doc test-exp))
(map (lambda (x) (display (car x)) (display "\n") x) result)
result

;should output
;<div color='red' id='yo' class='hi' style='background-color: red; border-radius: 10'>
;  <h1>hello</h1>
;  <a>ha</a>
;</div>

