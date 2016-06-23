//SCHEME SCRIPT STANDARD LIBRARY

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

if (typeof module !== 'undefined' && module.exports) {
   exports.sum = scm_sum;
   exports.diff = scm_diff;
   exports.obj_dict = scm_obj_dict;
   exports.screenshot = phantom_screenshot;
} else {
   scm = {'sum': scm_sum, 'diff': scm_diff, 'obj_dict': scm_obj_dict};
}

