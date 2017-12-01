#!/bin/bash

FILE_NAME="jobs/$1"
OUT_FILE_NAME="$FILE_NAME.rate.agg"
echo '' > $OUT_FILE_NAME

awk '
  NR > 1 {count[$2]++}
  { sum[$2] += $4 }
  END {
    for (i in sum) {
      printf "%-15s\t%s\t%s\n", i,count[i], sum[i];
    }
  }
' $FILE_NAME >> $OUT_FILE_NAME


awk -v max=0 '{if($3>max){want=$2; max=$3}}END{print want,max} ' $OUT_FILE_NAME