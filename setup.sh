#!/bin/bash

sudo apt-get install guile-2.0
#sudo apt-get install phantomjs nodejs

yes | rm -Rf ui/pwkg
git clone https://github.com/KostyaKow/pwkg
mv pwkg ui
cd ui/pwkg; ./setup.sh
