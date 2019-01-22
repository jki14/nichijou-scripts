#! /bin/bash

#fix *.py files
find . -name '*.py' -not -path './.git/*' -exec chmod 644 {} \;

#fix *.lua files
find . -name '*.lua' -not -path './.git/*' -exec chmod 644 {} \;

#fix *.sh files
find . -name '*.sh' -not -path './.git/*' -exec chmod 644 {} \;

#fix .gitignore 
chmod 644 .gitignore

#fix README.md
chmod 644 README.md
