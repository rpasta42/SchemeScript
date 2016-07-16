
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

cos(90) = 0
sin(90) = 1
x' = x*cosT + y*sinT
y' = -x*sinT + y*cosT
x' = y
y' = -x

TODO:
   on of squares in shape-stable < 0, alert("you lost")

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

