## WARNING: THIS PROJECT IS IN VERY EARLY STAGE OF DEVELOPMENT
# SchemeScript
## λλλλλλλλλλλλλλλλλλλλλλλλ

Experimental Scheme REPL and Scheme->Javascript transcompiler written in Scheme. Currently the transcompiler code runs on guile, but I'm in the process of making SchemeScript to be able to transcompile it's own source code to JavaScript.

Scheme -> Javascript generation code (located in ir.scm) is messy and incomplete. So far it only supports tiny subset of Scheme.

Code generation works by recursively compiling lisp to intermediate S-Expression format with type annotations, and then generating the Javascript from the IR.

Scheme REPL works by piping output of ir.scm to a V8 Javascript repl. I'm in the process of deciding which v8 engine to use, and I have been testing the Scheme repl with node and PhantomJS.

I'm also planning on implementing SchemeScript library for creating UI's and manipulating DOM on a higher level.
I have a tiny macro system which generates HTML and css from S-expressions, and example tetris-like game (which is still very buggy).

0.0.2 goals:

- [ ] clean up ir.scm, jsgen.scm
- [ ] implement parser/read
- [ ] implement fake command line shell in HTML/CSS for user input
- [ ] declare variables as var, don't pollute global namespace
   - [ ] return only last expression from function or begin
- [ ] consistent interface, and standard Scheme functions
   - [ ] figure out selfcomp.js/reader.js/ssstd.js mess, and make one unified interface
- [ ] clean up HTML code
- [ ] improve server side code, deployement scripts





