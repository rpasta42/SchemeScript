//SCHEME SCRIPT STANDARD LIBRARY

/*TODO: add
   needed:
      setting dict members
      creating new arrays and dicts
      rem (%), divide (/), mul (*)
      <=, >=,
      arrRange(start, [step], end) (js array range)
*/

function scm_for_each(lst, f) {
   for (var i in lst) {
      f(i, lst[i]);
   }
}
function scm_new_dict() {
	return {};
}
function scm_new_arr() {
	return [];
}
function scm_arr_push(arr, e) {
	arr.push(e)
}


function scm_not(e) { return !e; }
function scm_or() {
   var args = scm_not.arguments;
   for (var i in args) {
      if (args[i]) return true;
   }
   return false;
}
function scm_and() {
   var args = scm_not.arguments;
   for (var i in args) {
      if (!args[i]) return false;
   }
   return true;
}
function scm_mul() {
}


//TODO: end add

function scm_sum() {
   var args = scm_sum.arguments;
   var ret = 0;
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

/*
(\ test_obj test call)
(\ test_obj test set newval)

(: (a 1) (b 2)) == (dict (a 1) (b 2)) == { a: 1, b:2 }
(arr a b c) = [a, b, c]
*/
//first is object, second method, rest are arguments
function scm_obj_dict() {
   var args = Array.prototype.slice.call(arguments);
   //alert(args);
   //var args = scm_obj_dict.arguments;

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

//(alert (\ dict_tester ha))
var dict_tester = {
   'ha' : 3,
   'blah' : [1, 2, 3],
}

var test_obj = {
   type: 'blah',
   test : function() { alert('ha'); alert(this.type); },
   test2 : function(a) { alert(a + this.type); }
}

//broken, see this: https://github.com/ariya/phantomjs/issues/10518
function phantom_screenshot(url, filename) {
   var page = require('webpage').create();
   page.open(url, function() {
      page.render(filename);
      phantom.exit();
   });
}

//
/*
(define my-pic (tag img (src "test.png")))

;TODO: should attr's (style, id, class) be in a list?
;TODO: should children be in a list or by themselves?
;TODO: should style be attr or it's own property?

;winner!! good
(define my-pic (tag img (attr (src "test.png"))))

(attr (src "blah") (test "da")) = (attr src "blah") (attr test "da")
(style background-color red) (style border-radius 10) = (style (background-color red) (border-radius 10))

(tag (div "ha") (ref mypic)) = (tag div "ha") (ref mypic)

(tag div
     (attr (color red) (id "yo") (class "hi"))
     (style (background-color red) (border-radius 10))
     (tag h1 "hello")
     (tag a "ha")
     (ref mypic))

;more winrar examples
(define ss (style ...))
(tag div
     (ref ss) ;set style from variable
     (style (text-size 10))) ;add more style manually
;end winrar

(tag a
     (style ())
     (attr ())
     (tag h1 "blah"))

;bad
(tag (name div)
     (style (background-color red))
     (attr (id "yo") (class "ha"))
     (children (tag (name "ha"))))

(tag
   div
   (attr
      (style (border-radius 10) (background-color red))
      (color red)
      (id "yo")
      (class "yo"))
   ((tag a "test")
    (tag h1 "yolo")
    (ref my-pic)))

(div
   (style
      (border-radius 10)
      (color red))
   (id "test")
   (class "yo")
   ((tag a "test") ;last array/element is always content
    (tag h1 "yolo")
    (ref my-pic)) ;ref = reference to different element
*/
function scm_el(name, attrs) {
}
//


if (typeof module !== 'undefined' && module.exports) {
   exports.new_arr = scm_new_arr;
   exports.for_each = scm_for_each;
   exports.sum = scm_sum;
   exports.diff = scm_diff;
   exports.gt = scm_gt;
   exports.lt = scm_lt;
   exports.obj_dict = scm_obj_dict;
   exports.screenshot = phantom_screenshot;
} else {
   scm = {
      'new_arr': scm_new_arr,
      'for_each': scm_for_each,
      'sum': scm_sum,
      'diff': scm_diff,
      'gt': scm_gt,
      'lt': scm_lt,
      'obj_dict': scm_obj_dict,
      'mul' : scm_sum //TODO
   };
}

