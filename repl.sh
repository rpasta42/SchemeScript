#!/bin/bash

#SchemeScript repl

#When called with gen flag, starts a REPL which
#generates JavaScript and prints it to stdout

#If called without any options, then it runs itself
#with gen flag and pipes output to a javascript REPL.

if [[ $@ == **gen** ]]
then
   ###REPL HELPER
   printf "var scm = require('./ssstd.js');\n"

   while true; do
      guile ir.scm 2>/tmp/bad_guile.log
   done
   ###END REPL HELPER
fi

#printf "var scm = require('./js_std.js');"

#jsengine=phantomjs
#jsengine="node -i"
jsengine=./ui/run.py

$0 gen | $jsengine
