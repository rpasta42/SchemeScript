
var reader = require('./reader.js');
function ss_mk_var(type, val) {
   var v = {};
   v.ss_type = type;
   if (val != undefined)
      v.value = val;
   return v;
}
function ss_is_type(val, t) {
   if (typeof val === 'object' && val.ss_type != undefined) {
      return val.ss_type == t;
   }
   return null;
}
function ss_get_val(x) { //TODO: check for other stuff like pair
   if (x.ss_type != undefined && x.ss_type != SS_ERR)
      return x.value;
   return null;
}
//var ss_mk_var = reader.ss_mk_var;
//var SS_CON = reader.SS_CON;
var SS_ERR = 'ss_err';
var SS_CON = 'ss_con';
var SS_NIL = 'ss_nil';

/* TO IMPLEMENT:
not

number?, string?, symbol?, pair?, list?
procedure?
   http://stackoverflow.com/questions/9597548/how-to-check-if-a-symbol-is-a-procedure-or-not
string=?, null?, eq?
string-append
fold, map, etc
' quote
, comma
` qusiquote
let*, let, cond
cons, cdr, car, list, length
number->string
display

misc
   (eval ""), (read)
   correctly do if
   correct return statements
   tail-call
   garbage collection
   come up with built in types
   (eq? null/nil '())
   (define (_hash-op hash f . args) (apply f args))

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

function arr_to_lst(arr_) {
   var arr = arr_.reverse();
   var ret = ss_mk_var(SS_NIL);

   for (var i in arr) {
      ret = cons(arr[i], ret);
   }
   return ret;
}
function lst_to_arr(lst) {
   var ret = [];
   while (ss_is_type(lst, SS_CON)) {
      ret.push(car(lst));
      lst = cdr(lst);
   }
   return ret;
}

/*function reverse_list(lst) {
   if (ss_is_type(lst, SS_NIL))
      return SS_NIL;
}*/

function cons_map(exp, f) { //map
   if (ss_is_type(exp, SS_CON))
      cons(f(car(exp)), cons_map(cdr(exp), f));
   return ss_mk_var(SS_NIL);
}

function cons(a, b) {
   return ss_mk_var(SS_CON, [a, b]);
}
function car(lst) {
   if (ss_is_type(lst, SS_CON))
      return ss_get_val(lst)[0];
   return null;
}
function cdr(lst) {
   if (ss_is_type(lst, SS_CON))
      return ss_get_val(lst)[1];
   return null;
}
function list() {
   var args = Array.prototype.slice.call(arguments);
   return arr_to_lst(args); //args;
}

function procedure_kkqm_(exp) { //procedure?
   return typeof exp === "function";
}
function symbol_kkqm_(exp) { //symbol?
   /*if (typeof exp === 'object' &&
       exp['ss_type'] != undefined &&
       exp['ss_type'] == 'ss_sym') {

   }*/
   return ss_is_type(exp, SS_SYM);
}
function pair_kkqm_(exp) { //pair? //TODO: what about SS_ARR?
   //if (Array.isArray(exp))
   return ss_is_type(exp, SS_CON); //|| ss_is_type(exp, SS_LST);
}
function list_kkqm_(exp) { //list?
   if (ss_is_type(exp, SS_CON)) {
      var val = exp; //ss_get_val(exp);
      while (ss_is_type(val, SS_CON))
         val = cdr(val);
      if (ss_is_type(val, SS_NIL))
         return true;
      return false;
   }
   return false;
}
function null_kkqm_(exp) { //null?
   return ss_is_type(exp, SS_NIL);
}

function to_string(exp) {}

exports.cons = cons;
exports.car = car;
exports.cdr = cdr;
exports.list = list;
exports.cons_map = cons_map;
exports.arr_to_lst = arr_to_lst;
exports.lst_to_arr = lst_to_arr;
