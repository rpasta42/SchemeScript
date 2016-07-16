
Lex/Parse TODO:
- [ ] lexing "|#" as error, and lexer eats # character at the moment
- [ ] automate unit tests

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

Currently ir.scm runs in Guile, but I plan to test it out on racket and my experimental [Scheme interpreter written in rust](https://github.com/kostyakow/lambdaoxide).


