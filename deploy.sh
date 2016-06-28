#!/bin/bash

outdir=/root/nginx-html/sscript
mkdir -p $outdir
guile --no-auto-compile main.scm >$outdir/index.html
rm $outdir/ssstd.js
cp ssstd.js $outdir/
chmod a+r $outdir/ssstd.js

echo "`hostname`/sscript/"
