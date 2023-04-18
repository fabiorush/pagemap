#! /bin/bash

PIDS=$(ps -elf | awk '{ if ($0 ~ /openresty\/nginx/) cont = 1; else if (cont && $16 == "worker") print $4; else cont = 0 }')

date
for PID in $PIDS
do
  RSS=$(ps auxw | awk "\$2 == $PID { print \$6 }")
  PAGES=$(./pagemap2 $PID | grep -e 'file/shared 0 .*present 1.*heap' | wc -l)
  if [ $PAGES -ge 262144 ]
  then
    HEAP_SIZE=$(bc <<<"scale=3; $PAGES * 4 / 1024 / 1024")
    HEAP_SIZE="$HEAP_SIZE GB"
    RSS_SIZE=$(bc <<<"scale=3; $RSS / 1024 / 1024")
    RSS_SIZE="$RSS_SIZE GB"
  else
    HEAP_SIZE=$(bc <<<"scale=3; $PAGES * 4 / 1024")
    HEAP_SIZE="$HEAP_SIZE MB"
    RSS_SIZE=$(bc <<<"scale=3; $RSS / 1024")
    RSS_SIZE="$RSS_SIZE MB"
  fi
  echo Worker $PID - RSS size: $RSS_SIZE - Heap size: $HEAP_SIZE
done