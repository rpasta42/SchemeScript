//SCHEME SCRIPT STANDARD LIBRARY

function scm_sum() {
   var args = scm_sum.arguments;
   var sum = 0;
   for (var arg in args) {
      sum += args[arg];
   }
   return sum;
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

//broken, see this: https://github.com/ariya/phantomjs/issues/10518
function phantom_screenshot(url, filename) {
   var page = require('webpage').create();
   page.open(url, function() {
     page.render(filename);
     phantom.exit();
   });
}

exports.sum = scm_sum;
exports.diff = scm_diff;
exports.screenshot = screenshot;
