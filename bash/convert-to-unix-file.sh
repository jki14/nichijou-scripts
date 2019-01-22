#! /bin/bash
find . -type 'f' -exec perl -i -pe 's/\r+$//' {} \;
