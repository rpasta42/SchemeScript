var scm = require('./ssstd.js');
ir_store = (function (name, val) {var ret = null;
      ret = list(ir_tag(quote("((irsym)assign)")), exp__kk_gt_ir(name), val);
      return ret;
   });

ir_tag = (function (tag) {var ret = null;
      ret = cons(quote("((irsym)ir)"), tag);
      return ret;
   });

ir_tag_kkqm_ = (function (x) {var ret = null;
      ret = and(pair_kkqm_(x), pair_kkqm_(car(x)), eq_kkqm_(caar(x), quote("((irsym)ir)")));
      return ret;
   });

is_tag_kkqm_ = (function (e) {var ret = null;
      ret = and(pair_kkqm_(e), pair_kkqm_(car(e)), eq_kkqm_(caar(e), quote("((irsym)ir)")));
      return ret;
   });

ir_def_kkqm_ = (function (exp) {var ret = null;
      ret = and(scm.gt(length(exp), 2), or(eq_kkqm_(car(exp), quote("((irsym)define)")), eq_kkqm_(car(exp), quote("((irsym)def)"))));
      return ret;
   });

ir_def_func_kkqm_ = (function (exp) {var ret = null;
      ret = and(ir_def_kkqm_(exp), pair_kkqm_(cadr(exp)), not(symbol_kkqm_(cadr(exp))));
      return ret;
   });

ir_def_ass_kkqm_ = (function (exp) {var ret = null;
      ret = and(ir_def_kkqm_(exp), symbol_kkqm_(cadr(exp)));
      return ret;
   });

ir_lamb_kkqm_ = (function (exp) {var ret = null;
      ret = eq_kkqm_(car(exp), quote("((irsym)lambda)"));
      return ret;
   });

ir_if_kkqm_ = (function (exp) {var ret = null;
      ret = eq_kkqm_(car(exp), quote("((irsym)if)"));
      return ret;
   });

ir_cond_kkqm_ = (function (exp) {var ret = null;
      ret = eq_kkqm_(car(exp), quote("((irsym)cond)"));
      return ret;
   });

ir_let_kkqm_ = (function (exp) {var ret = null;
      ret = eq_kkqm_(car(exp), quote("((irsym)let)"));
      return ret;
   });

ir_begin_kkqm_ = (function (exp) {var ret = null;
      ret = and(pair_kkqm_(exp), eq_kkqm_(car(exp), quote("((irsym)begin)")));
      return ret;
   });

ir_call_kkqm_ = (function (exp) {var ret = null;
      ret = and(pair_kkqm_(exp), scm.gt(length(exp), 0));
      return ret;
   });

ir_gen_if = (function (exp) {var ret = null;
      ret = list(ir_tag(quote("((irsym)if)")), exp__kk_gt_ir(cadr(exp)), exp__kk_gt_ir(caddr(exp)), exp__kk_gt_ir(cadddr(exp)));
      return ret;
   });

ir_gen_cond = (function (exp) {var ret = null;
      ret = list(ir_tag(quote("((irsym)cond)")));
      return ret;
   });

ir_gen_let = (function (exp) {var ret = null;
      ret = list(ir_tag(quote("((irsym)let)")));
      return ret;
   });

ir_gen_call = (function (name, args) {var ret = null;
      ret = list(ir_tag(quote("((irsym)call)")), exp__kk_gt_ir(name), map(exp__kk_gt_ir, args));
      return ret;
   });

ir_gen_lambda = (function (args, body) {var ret = null;
      ret = list(ir_tag(quote("((irsym)lambda)")), map(exp__kk_gt_ir, args), list(map((function (x) {var ret = null;
      ret = exp__kk_gt_ir(x);
      return ret;
   }), body)));
      return ret;
   });

ir_gen_begin = (function (exp) {var ret = null;
      ret = list(ir_tag(quote("((irsym)block)")), map(exp__kk_gt_ir, exp));
      return ret;
   });

gen_ir_cons = (function (exp) {var ret = null;
      ret = get_func_name = (function (exp) {var ret = null;
      ret = letTODO;
      return ret;
   });
;
      ret = letTODO;
      return ret;
   });

ir_gen_null = (function () {var ret = null;
      ret = ir_tag(quote("((irsym)null)"));
      return ret;
   });

ir_gen_num = (function (n) {var ret = null;
      ret = list(ir_tag(quote("((irsym)num)")), n);
      return ret;
   });

ir_gen_str = (function (s) {var ret = null;
      ret = list(ir_tag(quote("((irsym)str)")), s);
      return ret;
   });

ir_gen_sym = (function (s) {var ret = null;
      ret = list(ir_tag(quote("((irsym)sym)")), s);
      return ret;
   });

exp__kk_gt_ir = (function (exp) {var ret = null;
      ret = condTODO;
      return ret;
   });

tag_remove_ir_rec = (function (e) {var ret = null;
      ret = (function() {var __ss__pred = pair_kkqm_(e);
if (__ss__pred) return (function() {var __ss__pred = eq_kkqm_(car(e), quote("((irsym)ir)"));
if (__ss__pred) return (function() {var __ss__pred = pair_kkqm_(cdr(e));
if (__ss__pred) return map(tag_remove_ir_rec, cdr(e));
return cdr(e);})();
return cons((function() {var __ss__pred = is_tag_kkqm_(e);
if (__ss__pred) return cdar(e);
return map(tag_remove_ir_rec, car(e));})(), map(tag_remove_ir_rec, cdr(e)));})();
return e;})();
      return ret;
   });

runner = (function (exp) {var ret = null;
      ret = list(ir_tag(quote("((irsym)block)")), map(exp__kk_gt_ir, exp));
      return ret;
   });

print_ir = (function (ir, nest) {var ret = null;
      ret = (function() {var __ss__pred = pair_kkqm_(ir);
if (__ss__pred) return (function() {var __ss__pred = eq_kkqm_(car(ir), quote("((irsym)block)"));
if (__ss__pred) return (function () {
   display("[");   map((function (x) {var ret = null;
      ret = print_ir(x, scm.sum(nest, 1));
      return ret;
   }), cdr(ir));   display("]");
})();
;
return (function () {
   display("(");   map((function (x) {var ret = null;
      ret = display("(");
      ret = print_ir(x, nest);
      ret = display(")");
      return ret;
   }), ir);   display(")");
})();
;})();
return (function () {
   display(ir);   display(" ");
})();
;})();
      return ret;
   });

print_ir1 = (function (ir, nest) {var ret = null;
      ret = display(car(ir));
      ret = display("
");
      ret = map((function (x) {var ret = null;
      ret = display(x);
      ret = display("
");
      return ret;
   }), cadr(ir));
      ret = display("
");
      return ret;
   });

exp_lisp = quote("((ircall)((irassign)((irsym)x)((ircall)((irsym)+)(((irnum)3)((irnum)5))))(((irassign)((irsym)f)((irlambda)(((irsym)x)((irsym)y))((((ircall)((irsym)-)(((irnum)3)((irnum)10)))((ircall)((irsym)+)(((irsym)x)((irsym)y)((irnum)4)((irnum)2)))))))))");
