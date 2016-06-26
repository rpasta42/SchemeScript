
(define (get-type ir)
   (if (and (pair? ir) (pair? (car ir)) (eq? (caar ir) 'ir))
      (cdar ir)
      (begin
         (display "bad ir: ")
         (display ir)
         'bad)))

(define (get-data ir)
   (if (and (pair? ir) (pair? (car ir)) (eq? (caar ir) 'ir))
      (cdr ir)
      'bad))

(define (is-type? ir type) (eq? (get-type ir) type))

;(define newl "\n")
(define newl "")
(define semi ";")

(define (gen-js-blk data nest)
   ;(define newl "") ;newl "\n"
   (define semi ";")
   (string-append (make-tabs nest) "(function () {" newl (fold string-append "" (map (lambda (x) (string-append (make-tabs (+ nest 1)) (ir->js x nest))) (reverse data))) newl "})()" semi newl))

(define (iden x) x)

(define (lookup-func name)
   (cond ((string=? name "+") "scm.sum")
         ((string=? name "-") "scm.diff")
         ((string=? name "*") "scm.mul")
         ((string=? name "\\") "scm.obj_dict")
         ((string=? name ">") "scm.gt")
         ((string=? name "<") "scm.lt")
         (else name)))

(define (gen-js-if data nest)
   (string-append
      "(function() {"
      ;"var pred = (function(){" (ir->js (car data))
      "var __ss__pred = " (ir->js (car data) nest) ";"
      "if (__ss__pred) return " (ir->js (cadr data) nest) ";"
      "return " (ir->js (caddr data) nest) ";"
      "})()"))

(define (gen-js-lambda data nest)
   ;"function () { /*lambda*/ }\n"
   ;(display "KK")
   ;(display (cadr data))
   ;(display "KK-----------\n")
   ;(define newl "");(define newl "\n")
   (string-append
      (make-tabs nest)
      "(function ("
      (lst->comma-str (map (lambda (x) (cadr x)) (car data)))
      ") {var ret = null;"
      (fold string-append ""
            (map ;(lambda (x) (string-append newl (make-tabs (+ nest 2)) "ret = " (ir->js x nest)))
                 (lambda (x) (string-append newl (make-tabs (+ nest 2)) "ret = " (ir->js x nest) semi))
                 (reverse (caadr data))))
      newl (make-tabs (+ nest 2)) "return ret;"
      newl (make-tabs ( + nest 1)) "})"))

(define (gen-js-call data nest)
   ;(display data)
   ;(display (cadr data))
   (define map-i 0)
   (define semi "") ;";"

   (let* ((method (lookup-func (ir->js (car data) nest)))
          (arg-mapper
             (lambda (x)
                (set! map-i (+ map-i 1))
                (cond
                  ((and (= map-i 2) (string=? method "scm.obj_dict"))
                   (string-append "\"" (ir->js x nest) "\""))
                  ((and (= map-i 3) (string=? method "scm.obj_dict") (string=? (ir->js x nest) "call"))
                    (string-append "\"__ss_call__\""))
                  (else (ir->js x nest))))))
      (string-append
         method "("
         ;(lst->comma-str (map (lambda (x) (cadr x)) (cadr data)))
         ;(lst->comma-str (map (lambda (x) (ir->js (cadr x) nest)) (cadr data)))
         ;(lst->comma-str (map (lambda (x) (car (ir->js x nest))) (cadr data)))
         ;(lst->comma-str (map (lambda (x) (ir->js x nest)) (cadr data))) ;latest good
         (lst->comma-str (map arg-mapper (cadr data))) ;latest good
         ")" semi)))

(define (gen-js-assign data nest)
   ;(display (cadadr data))
   ;(display (cadr data))
   ;(display "-----------------------")
   ;(display (ir->js (cadr data) nest))
   ;(display "-----------------------")
   ;(define newl "") ;(define newl "\n")

   ;THIS BREAKS MY RETURN BULLSHIT (but mostly works):
   ;(string-append "var " (ir->js (car data) nest) " = " (ir->js (cadr data) nest) ";" newl))
   (string-append (ir->js (car data) nest) " = " (ir->js (cadr data) nest) ";" newl))

(load "scm_lib.scm")
(define (emit-js-init)
   ;(read-f "js_std.js"))
   "var scm = require('./ssstd.js');")

(define (ir->js ir nest)
   (let ((data (get-data ir)))
      (cond
         ((is-type? ir 'block) (gen-js-blk (car data) nest))
         ((is-type? ir 'begin) (gen-js-blk data nest))
         ((is-type? ir 'if) (gen-js-if data nest))
         ((is-type? ir 'lambda) (gen-js-lambda data nest))
         ((is-type? ir 'call) (gen-js-call data nest))
         ((is-type? ir 'assign) (gen-js-assign data nest))
         ((is-type? ir 'num) (number->string (car data))) ;(number->string data)
         ((is-type? ir 'sym) (symbol->string (car data)))
         ((is-type? ir 'str) (string-append "\"" (car data) "\""))
         (else (string-append "BAD IR TYPE:" (symbol->string (get-type ir)))))))

(define (repl-loop)
   (define (helper)
      (define exp (str->exp (stdin-read)))
      (if (eq? exp 'exit)
         '()
         (begin (let ((comp-exp (exp->ir exp)))
                  ;(display (print-ir1 comp-exp 1))
                  ;(display (print-ir1 (list (ir-tag 'block) (list comp-exp)) 1))

                  (display (ir->js comp-exp 0))
                  (display "\n")
                  )
                ;(display "\n")
                ;(display (ir->js (runner `(,exp)) 0))
                '())))
                ;(helper))))
   ;(display (emit-js-init))
   (helper))


(define (comp-file path)
   (define data (read-f path))
   (define exp (str->exp data))
   (display (emit-js-init))
   ;(display (map (lambda (x) (ir->js x 0)) exp)))
   (display (map (lambda (x) (ir->js (exp->ir x) 0)) exp)))

;(display (ir->js (runner exp-lisp) 0))
;(repl-loop)
(comp-file "misc/test.ss")


