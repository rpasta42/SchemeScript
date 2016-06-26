#!/bin/bash

#SchemeScript repl

#When called with gen flag, starts a REPL which
#generates JavaScript and prints it to stdout

#If called without gen flag, then it runs itself
#with gen flag and pipes output to a javascript REPL.

#If called with ui flag, then starts GUI repl.

if [[ $@ == **gen** ]]
then
   ###REPL HELPER
   if [[ $@ != **ui** ]]
   then
      printf "var scm = require('./ssstd.js');\n"
   fi

   while true; do
      #guile ir.scm 2>/tmp/bad_guile.log
      #guile main.scm 2>/tmp/bad_guile.log
      guile main.scm --no-auto-compile
   done
   ###END REPL HELPER
fi

extra=""

#jsengine=phantomjs
jsengine="nodejs -i"
if [[ $@ == *ui* ]]
then
   jsengine=./ui/run.py
   extra=ui
fi

$0 gen $extra | $jsengine
