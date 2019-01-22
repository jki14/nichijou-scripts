#! /bin/bash

#add *.py files
find . -name '*.py' -not -path './.git/*' -exec git add {} \;

#add *.lua files
find . -name '*.lua' -not -path './.git/*' -exec git add {} \;

#add *.sh files
find . -name '*.sh' -not -path './.git/*' -exec git add {} \;

#add *.terminal files
find . -name '*.terminal' -not -path './.git/*' -exec git add {} \;

#add .gitignore 
git add .gitignore

#add README.md
git add README.md
