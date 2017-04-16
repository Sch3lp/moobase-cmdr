#!/bin/bash

echo "New deploy\n"

cd $HOME
git config --global push.default simple
git config --global user.email "travis@travis-ci.org"
git config --global user.name "travis-ci"
git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/Sch3lp/moobase-cmdr gh-pages 2> /dev/null

mkdir -p gh-pages/app/$TRAVIS_BRANCH
cp $HOME/build/Sch3lp/moobase-cmdr/index.html ./gh-pages/app/$TRAVIS_BRANCH/index.html
cd gh-pages
git add -A
git commit -m "new deploy: $TRAVIS_BUILD_NUMBER" 
git push --quiet 2> /dev/null
