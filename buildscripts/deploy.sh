#!/bin/bash

echo "New deploy\n"

cd $HOME
git config --global push.default simple
git config --global user.email "travis@travis-ci.org"
git config --global user.name "travis-ci"
git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/robisrob/buildradiator gh-pages 2> /dev/null

mkdir -p gh-pages/app/scripts
cp $HOME/build/robisrob/moobase-cmdr/index.html ./gh-pages/app/index.html

cd gh-pages
git add -A
git commit -m "new deploy: $TRAVIS_BUILD_NUMBER" 
git push --quiet 2> /dev/null
