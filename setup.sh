#!/bin/bash

sudo apt-get install guile-2.0
#sudo apt-get install phantomjs nodejs

#electron
#wget https://nodejs.org/dist/v6.2.2/node-v6.2.2-linux-x64.tar.xz
#tar -xf node-v6.2.2-linux-x64.tar.xz

#bad
#sudo apt-get install npm
#sudo npm install electron-prebuilt -g

yes | rm -Rf ui/pwkg
git clone https://github.com/KostyaKow/pwkg
mv pwkg ui
cd ui/pwkg; ./setup.sh
