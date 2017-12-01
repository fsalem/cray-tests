#!/bin/bash

FILE_NAME="jobs/$1"
OUT_FILE_NAME="$FILE_NAME.agg"
echo '' > $OUT_FILE_NAME

SIZE=2

while :
do
        SUM=0
        COUNT=$(awk -v SIZE=$SIZE '$1 == SIZE' $FILE_NAME | wc -l)
        CUR_COUNT=0
        awk -v SIZE=$SIZE '$1 == SIZE' $FILE_NAME | while read -r line ; do
                IFS=' ' read -r -a array <<< "$line"
        IFS=$'\t' read -r -a bw_array <<< "${array[1]}"
        CUR_BAND=${bw_array[0]}
        SUM=$(echo "$SUM+$CUR_BAND" | bc)
        CUR_COUNT=$((CUR_COUNT+1))
        if [[ $COUNT == $CUR_COUNT ]]; then
                        echo "$SIZE             $SUM" >> $OUT_FILE_NAME
                fi
        done
        if [[ $COUNT == 0 ]]; then
                break
        fi

        SIZE=$((SIZE*2))

done

echo "DONE! no rows for SIZE=$SIZE"
