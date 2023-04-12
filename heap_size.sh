#! /bin/bash

PAGES=$(./pagemap2 $1 | grep -e 'file/shared 0 .*present 1.*heap' | wc -l)
if [ $PAGES -ge 262144 ]
then
  echo Heap size: $(bc <<< "scale=3; $PAGES * 4 / 1024 / 1024") G
else
  echo Heap size: $(bc <<< "scale=3; $PAGES * 4 / 1024") M
fi
