## WARNING: THIS PROJECT IS IN VERY EARLY STAGE OF DEVELOPMENT
# SchemeScript

#node test
guile main.scm >misc/efcart/test.tmp.js


left off on special (tag/style/attr. added to ir.scm, now add to jsgen.scm

guile main.scm >/root/nginx-html/test1.html
cp ssstd.js ~/nginx-html/
chmod u+r ~/nginx-html/ssstd.js

guile html.scm >/tmp/site.html; google-chrome /tmp/site.html
guile html.scm >/tmp/test.html; firefox /tmp/test.html
http://www.biwascheme.org/doc/reference.html
(define-macro (test expr) `(if ,expr #t (print (format "test failed: ~a" (quote ,expr)))))
(test (= 1 2))

guile main.scm; guile main.scm  >ss_ir_test.js; nodejs ss_ir_test.js
guile main.scm >/tmp/racing.js; nodejs /tmp/racing.js

Experimental Scheme->Javascript REPL and cross compiler written in Scheme.

 from subset of Scheme to Javascript.

Scheme -> Javascript generation code (located in ir.scm) is extremely messy and incomplete. So far it's only 300 lines and only supports tiny subset of Scheme.

Currently ir.scm runs in Guile, but I plan to test it out on racket and my experimental [Scheme interpreter written in rust](https://github.com/kostyakow/lambdaoxide).

Code generation works by recursively compiling lisp to intermediate S-Expression format with type annotations, and then generating the Javascript from the IR.

Scheme REPL works by piping output of ir.scm to a V8 Javascript repl. I'm in the process of deciding which v8 engine to use, and I have been testing the Scheme repl with node and PhantomJS.

I'm also planning on implementing SchemeScript library for creating UI's and manipulating DOM.

ui/repl.sh is a basic SchemeScript repl which can call JQuery to modify DOM of a WebKit window (some examples can be found in misc/COOL.notes).

UI REPL works by piping output of ir.scm to a [Python script](https://github.com/KostyaKow/pwkg) which sets up WebkitGTK window and executes Javascript received from stdin.

Features:
- [x] Strings & Numbers
- [x] Basic functions (define (f x y) (+ x y 10))
- [x] Creating variables (define x 10)
- [x] Addition and subtraction

High priority TODO's:
- [ ] main.scm should accept different argument types
- [ ] better REPL for UI
- [ ] if and cond statements
- [ ] efficient recursion or iteration mechanism
- [ ] ways to create and access javascript objects (maybe use . or # or $ etc)
   - [ ] possibly rework \ to be first argument of functions. if it is, then assume we aren't calling normal function and do everything properly
   - [ ] js arrays
   - [ ] setting dictionary members
      - [ ] check gen-js-call and add stuff that's missing to argmapper
      - [ ] check scm_obj_dict and add support for setting members
- [ ] create example games
   - [ ] Write a graphical Risk game
- [ ] break up ir.scm into different parts
- [ ] tool for compiling files instead of just having REPL
- [ ] make if support full range of Scheme expressions

Other unsupported things and TODO's:
- [ ] error checking on ssstd.js
- [ ] possibly rename to ssstd.js to stdss.js
- [ ] expose read to SchemeScript (i.e. re-write Sexps parser in JavaScript)
- [ ] expose eval to SchemeScript (i.e. re-write SchemeScript in SchemeScript)
- [ ] Test out on LambdaOxide
- [ ] cond statements
- [ ] Division and multiplication
- [ ] Efficient Javascript generation
- [ ] cons, list, car, cdr

Flatris:

width: 10
height: 20

xx
 xx

xx
xx

xxxx

 x
xxx

x
xxx

  x
xxx

