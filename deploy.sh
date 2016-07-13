#!/bin/bash

outdir=/root/nginx-html/sscript
mkdir -p $outdir
guile --no-auto-compile main.scm #>$outdir/index.html
#rm $outdir/ssstd.js
#cp ssstd.js $outdir/
#cp ui/pwkg/jquery-2.2.4.min.js $outdir/
#chmod a+r $outdir/ssstd.js
#chmod a+r $outdir/jquery-2.2.4.min.js
#
#echo "`hostname`/sscript/"
