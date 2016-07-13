function is_func(v) {
   return typeof v === "function";
}


function factorial_bad(n) {
   if (n == 0) return 1.0; return n*factorial_bad(n-1);
}


function factorial_tailcall(n) {
   function helper(n, acc) {
      if (n == 0) return acc;
      return helper(n-1, acc*n);
   }
   return helper(n, 1);
}

function factorial_tramp(n) {
   function tramp(n, acc) {
      if (n == 0)
         return acc;
      return (function () { return tramp(n-1, acc*(n % 10)+1); } );
   }

   var result = tramp(n, 1);

   while (is_func(result)) {
      result = result();
   }

   return result;
}

var res = factorial_tramp(32768.0); //var res = factorial_tramp(3);
console.log(res);



