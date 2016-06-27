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

;(list name tags attrs styles other)
(define (new-html-obj) (list "" (hash-new) (hash-new) (hash-new) (hash-new)))

(define (ho-get-name ho) (car ho))
(define (ho-get-tags ho) (cadr ho))
(define (ho-get-attrs ho) (caddr ho))
(define (ho-get-styles ho) (cadddr ho))
(define (ho-get-others ho) (cadr (cdddr ho)))

(define (ho-set-name ho name) (set-car! ho name))
(define (ho-add-tag ho tag)     (hash-add (ho-get-tags ho) (ir-get-tmp-name) tag))
(define (ho-add-attr ho attr)   (hash-add (ho-get-attrs ho) (ir-get-tmp-name) attr))
(define (ho-add-style ho style) (hash-add (ho-get-styles ho) (ir-get-tmp-name) style))
(define (ho-add-other ho other) (hash-add (ho-get-others ho) (ir-get-tmp-name) other))

(define (html-style-gen hobj styles)
   (if (null? styles)
      '()
      (begin (ho-add-style hobj (car styles))
             (html-style-gen hobj (cdr styles)))))

(define (html-attr-gen hobj attrs)
   (if (null? attrs)
      '()
      (begin (ho-add-attr hobj (car attrs))
             (html-attr-gen hobj (cdr attrs)))))

(define (html-syntax-macro-pair-sym hobj exp)
   (define obj-type (car exp))
   (cond
      ((eq? obj-type 'tag)
       (let ((d (new-html-obj)))
         (ho-set-name d (cadr exp))
         ;(ho-set-name hobj (cadr exp))
         (map (lambda (x) (html-syntax-macro d x)) (cddr exp)) ;cddr or caddr??
         (ho-add-tag hobj d)))
      ((eq? obj-type 'style) ;(ho-add-tag hobj (cadr exp)))
       ;(cons "style" hobj));kkkk latest
       (html-style-gen hobj (cdr exp)))
      ((eq? obj-type 'attr)
       (html-attr-gen hobj (cdr exp)))
      ((eq? obj-type 'ref) ;TODO: check ref type and add it to one of other categories
       (let* ((new (new-html-obj)) ;todo: copy tag example
              (obj (html-syntax-macro new (eval-string (symbol->string (cadr exp))))))
         (ho-add-tag hobj new)))
      (else (ho-add-other hobj exp))) ;(display "bad option in html parser"))))
   ;(ho-add-style hobj "random style"))))
   hobj)

(define (html-syntax-macro hobj exp)
   (cond
      ((not (pair? exp)) (ho-add-other hobj exp)) ;(cons 'kkkzz (cons exp hobj)))
      ((symbol? (car exp))
       (begin (html-syntax-macro-pair-sym hobj exp)
              hobj))
      (else (cons
               (html-syntax-macro hobj (car exp))
               (html-syntax-macro hobj (cdr exp))))))

(define test-exp-fake
   '(tag div
      (style (test a) (test b))))

(define test-exp-pic '(tag img (attr src "test.png")))
;(define mypic (html-syntax-macro (new-html-obj) test-exp-pic))

(define test-exp ;-real
   '(tag div
      (attr (color red) (id "yo") (class "hi"))
      (style (background-color red) (border-radius 10))
      (tag h1 "hello")
      ;(ref mypic)
      (tag a "ha")))

(define main-doc (new-html-obj))
(ho-set-name main-doc "body")
(define result (html-syntax-macro main-doc test-exp))

(define (draw-t n) (display (make-tabs n)))

(define counter 0)

(define (gen-html-obj obj tabs)
   (define attr-text "")
   (define style-text "")
   (define children "")
   (define other "")

   (hash-map
      (ho-get-attrs obj)
      (lambda (key entry)
         (set! attr-text (string-append attr-text " " (to-string (car entry)) "='" (to-string (cadr entry)) "' "))))
   (hash-map
      (ho-get-styles obj)
      (lambda (key entry)
         (set! style-text (string-append style-text (to-string (car entry)) ":" (to-string (cadr entry)) ";"))))
   (hash-map
      (ho-get-tags obj)
      (lambda (key entry)
         (set! children (string-append children (gen-html-obj entry (+ tabs 1))))))
   (hash-map
      (ho-get-others obj)
      (lambda (key entry)
         (set! other (string-append other " " entry))))

   (if (< counter 2)
      (begin
         (set! counter (+ counter 1))
         children)
      (string-append
         "<" (to-string (ho-get-name obj))
         attr-text " style='" style-text "'>"
         children " " other
         "</" (to-string (ho-get-name obj)) ">")))

(define (display-html-obj obj tabs)
   (define (t) (display "\n") (draw-t tabs))
   ;(display ";;;;;;;;;;;;;;;;;")
   (draw-t tabs) (display "name: ")
   (display (ho-get-name obj))
   (t) (display "other:")
   (hash-map
      (ho-get-others obj)
      (lambda (key entry) (display "\n") (draw-t (+ tabs 1)) (display entry)))
   (t) (display "attrs:")
   (hash-map
      (ho-get-attrs obj)
      (lambda (key entry) (display "\n") (draw-t (+ tabs 1)) (display entry)))
   (t) (display "styles:")
   (hash-map
      (ho-get-styles obj)
      (lambda (key entry) (display "\n") (draw-t (+ tabs 1)) (display entry)))
   (t) (display "memebers:")
   (hash-map
      (ho-get-tags obj)
      (lambda (key entry) (display "\n") (display-html-obj entry (+ tabs 1)))))

(display-html-obj result 0)
(display "\n")
(display (gen-html-obj result 0))
(display "\n")

;(display result)

;(map (lambda (x) (display (if (pair? x) (car x) x)) (display "\n") x) (cdr result))
;(map (lambda (x) (display (if (pair? x) (car x) x)) (display "\n") x) result)
;(map (lambda (x) (display (if (pair? x) (mymap display x) x)) (display "\n") x) (cdr result))
;(map (lambda (x) (display (map display (if (pair? x) (car x) x)) (display "\n") x) result)


result

;should output
;<div color='red' id='yo' class='hi' style='background-color: red; border-radius: 10'>
;  <h1>hello</h1>
;  <a>ha</a>
;</div>

