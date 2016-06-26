var scm = require('./ssstd.js');
read_f = (function (path) {var ret = null;
      ret = ret = "";
;
      ret = call_with_input_file(path, (function (input_port) {var ret = null;
      ret = letTODO;
      return ret;
   }));
      ret = ret;
      return ret;
   });

str__kk_gt_exp1 = (function (str) {var ret = null;
      ret = read(open_input_string(str));
      return ret;
   });

str__kk_gt_exp = (function (str) {var ret = null;
      ret = _in = open_input_string(str);
;
      ret = rec = (function (_in_) {var ret = null;
      ret = x = read(_in);
;
      ret = (function() {var __ss__pred = not(eof_object_kkqm_(x));
if (__ss__pred) return cons(x, rec(_in));
return quote("(irnull)");})();
      return ret;
   });
;
      ret = rec(_in);
      return ret;
   });

use_modules(ice_9(rdelim))
stdin_read = (function () {var ret = null;
      ret = read_line(current_input_port());
      return ret;
   });
