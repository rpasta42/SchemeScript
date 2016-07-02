//SCHEME SCRIPT STANDARD LIBRARY

/*TODO: add
   needed:
      setting dict members
      creating new arrays and dicts
      rem (%), divide (/), mul (*)
      <=, >=,
      arrRange(start, [step], end) (js array range)
*/
function scm_arr_push(arr, e) {arr.push(e)}
function scm_arr_i(arr, i) {  return arr[i]; }//index

function scm_not(e) { return !e; }
function scm_for_each(lst, f) {
   var ret_ = [];
   for (var i in lst) {
      ret_.push(f(i, lst[i]));
   }
   return ret_;
}
function scm_cons(a, b) { return [a, b]; }
function scm_car(x) { return x[0]; }
function scm_cdr(x) { return x[1]; }
function scm_new_dict() {
	return {};
}
function scm_new_arr() {
   var args = Array.prototype.slice.call(arguments);
   return args;
}
function scm_arr_set(arr, i, val) {
   arr[i] = val;
}
function scm_or() { //TODO: short circuit
   var args = scm_or.arguments;
   for (var i in args) {
      if (args[i]) return args[i];
   }
   return false;
}
function scm_and() { //TODO: short circuit
   var args = scm_and.arguments;
   for (var i in args) {
      if (!args[i]) return false;
   }
   return true;
}
//TODO: (* "hello" 5) or (* 5 "hello")
function scm_mul() {
   var args = scm_mul.arguments;
   var ret = 1;
   for (var arg in args) {
      ret *= args[arg];
   }
   return ret;
}
function scm_range() {
   var args = Array.prototype.slice.call(arguments);
   var start = args[0];

   var end = start;
   var step = 1;

   if (args.length == 3) {
      step = args[1];
      end = args[2];
   } else if (args.length == 2) {
      end = args[1];
      if (end < start)
         step = -1;
   } else { alert("scm_range error"); }

   var is_done = function (i, end) {
      if (step > 0)
         return i > end;
      else return i < end;
   }

   var ret = [];
   for (; !is_done(start, end); start+=step) {
      ret.push(start);
   }
   return ret;
}
function scm_sum() {
   var args = scm_sum.arguments;
   var ret = (typeof args[0] == 'string') ? '' : 0;
   for (var arg in args) {
      ret += args[arg];
   }
   return ret;
}
function scm_diff() {
   var args = scm_diff.arguments;
   var diff = args[0];
   var first = true;
   for (var arg in args) {
      if (first) first = false;
      else diff -= args[arg];
   }
   return diff;
}
function scm_gt(a, b) {
   return a > b;
}
function scm_lt(a, b) {
   return a < b;
}
function scm_gt_eq(a, b) {
   return a>=b;
}
function scm_lt_eq(a, b) {
   return a <= b;
}
function scm_eq(a, b) {
   return a == b;
}

//first is object, second method, rest are arguments
function scm_obj_dict() {
   var args = Array.prototype.slice.call(arguments);
   var obj = args[0];
   var member = args[1];

   if (args.length == 2) {
      //alert('getting dict member');
      return obj[member];
   }
   else if (args.length > 2) {
      //alert('prolly calling');
      //return obj[member];
      if (args[2] == "__ss_call__") {
         //alert('call no arguments');

         //var args = args.slice(3);
         //return obj[member].apply(this, args);
         //return obj[member].call(); //obj[member].apply(this, null);

         //return obj[member](); //!!!! this works too!!!
         return obj[member].apply(obj, null);

      }
      //alert('call with arguments');
      //return obj[member].apply(this, args.slice(2, args.length));
      return obj[member].apply(obj, args.slice(2, args.length));

   } else { /* TODO */ }
}

function scm_string_append() {}

if (typeof module == 'undefined' || !module.exports)
   exports = scm = {};

exports.not = scm_not;
exports.for_each = scm_for_each;
exports.cons = scm_cons;
exports.car = scm_car;
exports.cdr = scm_cdr;
exports.new_dict = scm_new_dict;
exports.new_arr = scm_new_arr;
exports.arr_set = scm_arr_set;
exports.or = scm_or;
exports.and = scm_and;
exports.range = scm_range;
exports.sum = scm_sum;
exports.mul = scm_mul,
exports.diff = scm_diff;
exports.gt = scm_gt;
exports.lt = scm_lt;
exports.gt_eq = scm_gt_eq;
exports.lt_eq = scm_lt_eq;
exports.eq = scm_eq;
exports.obj_dict = scm_obj_dict;
exports.arr_i = scm_arr_i;
exports.arr_push = scm_arr_push;
