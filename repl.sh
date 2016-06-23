#!/bin/bash

if [[ $@ == **gen** ]]
then
   ###REPL HELPER
   echo "var scm = require('./js_std');"

   while true; do
      guile ir.scm 2>/tmp/bad_guile.log
   done
   ###END REPL HELPER
fi

#printf "var scm = require('./js_std.js');"

evu=phantomjs
#evu="node -i"
#evu=./scheme-electron/run.py
#(scm.screenshot "http://github.com" "test.png")

$0 gen | $evu
