#!/bin/bash

outdir=/root/nginx-html/sscript
mkdir -p $outdir
guile main.scm >$outdir/index.html
rm $outdir/ssstd.js
cp ssstd.js $outdir/
chmod a+r $outdir/ssstd.js
