#!/bin/bash

FILE_NAME="jobs/$1"
OUT_FILE_NAME="$FILE_NAME.rate.agg"
echo '' > $OUT_FILE_NAME

less $FILE_NAME | awk '
  NR > 1 {count[$2]++}
  { sum[$2] += $4 }
  END {
    for (i in sum) {
      printf "%-15s\t%s\t%s\n", i,count[i], sum[i];
    }
  }
' >> $OUT_FILE_NAME