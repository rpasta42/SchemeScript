#!/bin/bash

yes | rm -Rf ui/pwkg
git clone https://github.com/KostyaKow/pwkg
mv pwkg ui
cd ui/pwkg; ./setup.sh
