#! /bin/bash

PIDS=$(ps -elf | awk '{ if ($0 ~ /openresty\/nginx/) cont = 1; if (cont && $16 == "worker") print $4 }')

for PID in $PIDS
do
  PAGES=$(./pagemap2 $PID | grep -e 'file/shared 0 .*present 1.*heap' | wc -l)
  if [ $PAGES -ge 262144 ]
  then
    SIZE=$(bc <<< "scale=3; $PAGES * 4 / 1024 / 1024") GB
  else
    SIZE=$(bc <<< "scale=3; $PAGES * 4 / 1024") MB
  fi
  echo $PID Heap size: $SIZE
done