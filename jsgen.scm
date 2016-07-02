(load "scm_lib.scm")
(load "ir.scm")
(load "helpers.scm")

;(define newl "")
(define (br) (display newl))
(define semi ";")
(define (iden x) x)
(define (is-type? ir type) (eq? (get-type ir) type))

(define (get-type ir)
   (if (and (pair? ir) (pair? (car ir)) (eq? (caar ir) 'ir))
      (cdar ir)
      (begin
         ;(display "bad ir: ")
         ;(display ir)
         'bad)))

(define (get-data ir)
   (if (and (pair? ir) (pair? (car ir)) (eq? (caar ir) 'ir))
      (cdr ir)
      'bad))

(define (gen-js-blk data nest)
   ;(define newl "") ;newl "\n"
   (define semi ";")
   (string-append ;"kkkk"
      (make-tabs nest)
      "(function () {" newl
      (fold string-append
            ""
            (map (lambda (x)
                  (string-append
                     (make-tabs (+ nest 1)) ;(make-tabs nest)
                     (ir->js x nest) ";"))
                 (reverse data)))
      newl
      "})()" semi newl))

(define (clean-lisp-stuff name)
   (define prev #\<)
   (string-fold-right
      (lambda (c str)
         (define prep
            (if (char=? prev #\-)
               (if (char=? c #\>)
                  "__TO__"
                  "_")
               ""))
         (set! prev c)
         (cond ;((char=? c #\=)
               ;  (string-append "_kkeq_" str))
               ((char=? c #\-)
                 ;(string-append "_kkmin_" str))
                 str);(string-append "_" str))
               ((and (char=? c #\-) (char=? prev #\>)) "_TO_")
               ((char=? c #\?)
                 (string-append "_kkqm_" prep str))
               ((char=? c #\>)
                (string-append "_kk_gt_" prep str))
               (else (string-append (string c) prep str))))
      ""
      (if (symbol? name)
         (if (eq? name 'in)
            "_in_"
            (symbol->string name))
         (if (string=? name "in")
            "_in"
            name))))

(define (lookup-func name)
   (define (check c)
      (string=? name c))

   (cond ((or (check "!") (check "not"))
          "scm.not")
         ((check "+") "scm.sum")
         ((check "/") "scm.div")
         ((check "-") "scm.diff")
         ((check "=") "scm.eq")
         ((check "*") "scm.mul")
         ((check "\\") "scm.obj_dict")
         ((check ">") "scm.gt")
         ((check "<") "scm.lt")
         ((check ">=") "scm.gt_eq")
         ((check "<=") "scm.lt_eq")
         ((check "cons") "scm.cons")
         ((check "car") "scm.car")
         ((check "cdr") "scm.cdr")
         ((or (check "for-each")
              #f) ;(check "map"))
          "scm.for_each")
         ((check "new-dict")"scm.new_dict")
         ((check "new-arr")"scm.new_arr")
         ;just use normal obj syntax
         ((check "arr-push")"scm.arr_push")
         ((check "arr-i")"scm.arr_i")
         ((check "arr-set")"scm.arr_set")
         ((check "or")"scm.or")
         ((check "and")"scm.and")
         ((check "range")"scm.range")
         (else (clean-lisp-stuff name))))

(define (gen-js-if data nest)
   (string-append
      "(function() {"
      ;"var pred = (function(){" (ir->js (car data))
      "var __ss__pred = " (ir->js (car data) nest) ";" newl
      "if (__ss__pred) return " (ir->js (cadr data) nest) ";" newl
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
      (lst->comma-str (map (lambda (x) (clean-lisp-stuff (cadr x))) (car data)))
      ") {var ret = null;"
      (fold string-append ""
            (map
                 (lambda (x)
                  (define t (make-tabs (+ nest 1))) ;(+ nest 2)))
                  (string-append newl t "ret = " (ir->js x nest) semi))
                 (reverse (caadr data))))
      newl
      (make-tabs (+ nest 1)) ;(+ nest 2))
      "return ret;"
      newl (make-tabs nest) "})")) ;newl (make-tabs ( + nest 1)) "})"))

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
                  ((and (string=? method "quote") (= map-i 1))
                   (string-append "\"" (to-string x) "\""))
                  ((and (= map-i 2) (string=? method "scm.obj_dict"))
                   (string-append "\"" (ir->js x nest) "\""))
                  ((and (= map-i 3) (string=? method "scm.obj_dict")
                        (string=? (ir->js x nest) "call"))
                    (string-append "\"__ss_call__\""))
                  (else (ir->js x nest))))))
                  ;(else (clean-lisp-stuff (ir->js x nest)))))))
      (string-append
         method "("
         (lst->comma-str (map arg-mapper (cadr data)))
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
   (string-append
      (clean-lisp-stuff (ir->js (car data) nest))
      " = "
      (ir->js (cadr data) nest) ";" newl))

(define (emit-js-init)
   ;(read-f "js_std.js")
   "var scm = require('./ssstd.js');")

(define (gen-js-macro data)
   (define name (car data))
   (define args (cadr data))
   (define body (caddr data))
   ;(display "generating macro\name: ")
   ;(display name) (display "\nargs: ")
   ;(display args) (display "\nbody: ")
   ;(display body) (display "\n")
   (string-append
      "\n" (to-string name) " = function/*macro*/("
      ;(lst->comma-str args) ") { \"" (to-string body) "\""))
      (lst->comma-str args) ") { \""
      (fold string-append
         ""
         (map (lambda (x) (ir->js x 0)) body))
      "\""))

(define (gen-js-macro-call data nest)
   ;(display data)
   ;(display (cadr data))
   (define map-i 0)
   (define semi "") ;";"
   ;"calling macro")
   ;(define method (lookup-func (ir->js (car data) nest)))
   (define method (car data))
   (string-append
      (symbol->string (cadr method)) "("
      (lst->comma-str (map (lambda (x) (string-append " " (to-string x))) (cadr data)))
      ")" semi))

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
         ((is-type? ir 'sym) (lookup-func (symbol->string (car data)))) ;symbol->stirng (car data)
         ((is-type? ir 'str) (string-append "\"" (car data) "\""))
         ((is-type? ir 'macro-def) (gen-js-macro data))
         ((is-type? ir 'macro-call) (gen-js-macro-call data nest))
         ((is-type? ir 'qq) ;(ir->js (exp->ir data))) ;"!!!quasiquote!!!")
          (string-append "!!!QQ!!!" (to-string data)))
         ((is-type? ir 'uq) ;"!!!unquote!!!")
         ;(eval (cdr exp)))
          (ir->js (exp->ir (caar data)) 0))
         ((is-type? ir 'q) ;"!!!quote!!!") ;(to-string data)) ;(to-string (str->exp data)))
          (string-append "!!!Q!!!" (to-string data)))
         ((is-type? ir 'cond) "condTODO")
         ((is-type? ir 'let) "letTODO")
         ((is-type? ir 'null) "nullTODO")
         (else
            (begin
               ;(display "UNKNOWN IR:") (display ir) (display "\n")
               ;(string-append "BAD IR TYPE:" (symbol->string (get-type ir)))
               ;(display ir)
               "")))))

(define (repl-iter)
   (define exp (str->exp1 (stdin-read)))
   (if (eq? exp 'exit)
      '()
      (begin (let ((comp-exp (exp->ir exp)))
               ;(display (print-ir1 comp-exp 1))
               ;(display (print-ir1 (list (ir-tag 'block) (list comp-exp)) 1))
               (display (ir->js comp-exp 0))
               (display "\n"))
             ;(display "\n")
             ;(display (ir->js (runner `(,exp)) 0))
             )))
   ;(display (emit-js-init))

(define (comp-file path)
   (define data (read-f path))
   (define exp (str->exp data))
   (display (emit-js-init))
   ;(display (map (lambda (x) (ir->js x 0)) exp)))
   ;(display (map (lambda (x) (ir->js (exp->ir x) 0)) exp)))
   (map (lambda (x) (br) (display (ir->js (exp->ir x) 0))) exp))
   ;(map (lambda (x) (map (lambda (y) (display "\n") (display (ir->js (exp->ir y) 0))) x)) exp))

(define (repl-js)
   (repl-iter)
   (repl-js))

(load "html.scm")
(define (comp-jshtml path)
   (define data (read-f path))
   (define exp (str->exp data))
   (display
      (string-append
         "<html><head>\n"
         "<script src='jquery-2.2.4.min.js'></script>\n"
         "<script src='ssstd.js'></script>\n"
         "\n<script>$(document).ready(function() {"
         (fold (lambda (next prev)
                  (string-append prev ";\n" (ir->js (exp->ir next) 0)))
               ""
               exp)
         "})</script>"
         ;(map
         ;   (lambda (x) (br)
         ;      (ir->js (exp->ir x) 0))
         ;   exp)
         "</head>"
         html-data
         "</html>")))

