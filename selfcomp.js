


/* TO IMPLEMENT:
not
string=?
number?
string?
symbol?
pair?
list?
string-append
fold
cond
' quote
, comma
` qusiquote
null?
let*
let
cons
cdr
car
eq?
list
number->string
correct if
display
correct return statements
tail-call
garbage collection
come up with built in types
(eq? null/nil '())
not
(define (_hash-op hash f . args) (apply f args))
(eval "")
(read)


guile/scheme std:
write text to file
(call-with-output-file "b.txt"
   (lambda (output-port)
      (display "hello, world" output-port)))

(define (stdin-read)
   ;(define ret "")
   ;(let loop ((x (read-char (current-input-port))))
   ;   (if (not (eof-object? x))
   ;      (begin
   ;         ;(display x)
   ;         (set! ret (string-append ret (string x)))
   ;         (loop (read-char (current-input-port))))))
   ;ret)
   (read-line (current-input-port)))

(define (read-f path)
   (define ret "")
   (call-with-input file path
      (lambda (input-port)
         (let loop ((x (read-char input-port)))
            (if (not (eof-object? x))
               (begin
                  ;(display x)
                  (set! ret (string-append ret (string x)))
                  (loop (read-char input-port)))))))
   ret)

(define (str-exp1 str) (read (open-input-string str)))

(define (str-exp str)
   (define in (open-input-string str))
   (define (rec in)
      (define x (read in))
      (if (not (eof-object? x))
         (cons x (rec in))
         '()))
   (rec in))
   ;(read in))
   ;(read (open-input-string str))))

   ;(let loop ((x (read-char (current-input-port))))
   ;   (if (not (eof-object? x))
   ;      (begin
   ;         ;(display x)
   ;         (set! ret (string-append ret (string x)))
   ;         (loop (read-char (current-input-port))))))
   ;ret)
   (read-line (current-input-port)))
*/

function symbol_kkqm_(exp) { //symbol?
   if (typeof exp === 'object' &&
       exp['ss_type'] != undefined &&
       exp['ss_type'] == 'ss_sym') {

   }
}

function to_string(exp) {

}
