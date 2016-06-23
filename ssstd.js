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
   var args = scm_obj_dict.arguments;

   var obj = args[0];
   var member = args[1];

   if (args == 2)
      return obj[member];
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

