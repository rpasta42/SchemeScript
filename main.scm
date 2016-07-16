(load "jsgen.scm")
;(display (ir->js (runner exp-lisp) 0))

(define newl "")
(repl-iter)

(define newl "\n")
;server code
;(comp-file "misc/efcart/serv.ss")
;client
;(comp-file "misc/efcart/efcart.ss")

;TODO uncomment when using comp-file
;(display newl)
;(comp-file "misc.test/cc") ;"ir.scm", "scm_lib.scm"
;(comp-file "/home/kkostya/fun/rust/skomakare/examples/racing.lo")
;(comp-file "ir.scm")
;(define newl "\n")
;(repl-js)


;(define newl "\n")
;"misc/examples_kittens_btns_moving.ss", "misc/efcart.ss", "misc/test.ss"
;(comp-jshtml "misc/tetlisp.ss")
