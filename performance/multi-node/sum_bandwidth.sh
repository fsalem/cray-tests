#!/bin/bash

FILE_NAME="$1"
OUT_FILE_NAME="$FILE_NAME.agg"
#printf 'Size\tAgg. bw.\tAvg. bw.\tMin. bw.\tMax bw.\tAvg. lat.\tMin. lat.\tMax lat.\n'  > $OUT_FILE_NAME
printf '#bytes\tt_min[usec]\tt_max[usec]\tt_avg[usec]\tb_min[MB/s]\tb_max[MB/s]\tb_avg[MB/s]\tb_agg[MB/s]\n'  > $OUT_FILE_NAME

SIZE=2

while :
do
        SUM_BW=0
	SUM_LAT=0
        COUNT=$(awk -v SIZE=$SIZE '$1 == SIZE' $FILE_NAME | wc -l)
        CUR_COUNT=0
	MIN_BW=1000000
	MAX_BW=0
	MIN_LAT=1000000
        MAX_LAT=0
        awk -v SIZE=$SIZE '$1 == SIZE' $FILE_NAME | while read -r line ; do
                IFS=' ' read -r -a array <<< "$line"
        IFS=$'\t' read -r -a bw_array <<< "${array[1]}"
	IFS=$'\t' read -r -a lat_array <<< "${array[2]}"
        CUR_BAND=${bw_array[0]}
	if (( $(echo "$MIN_BW > $CUR_BAND" |bc -l) )); then
		MIN_BW=$CUR_BAND
	fi
	if (( $(echo "$MAX_BW < $CUR_BAND" |bc -l) )); then
                MAX_BW=$CUR_BAND
        fi
        SUM_BW=$(echo "$SUM_BW+$CUR_BAND" | bc)
	
	IFS=$'\t' read -r -a lat_array <<< "${array[2]}"
	CUR_LAT=${lat_array[0]}
        if (( $(echo "$MIN_LAT > $CUR_LAT" |bc -l) )); then
                MIN_LAT=$CUR_LAT
        fi
        if (( $(echo "$MAX_LAT < $CUR_LAT" |bc -l) )); then
                MAX_LAT=$CUR_LAT
        fi
        SUM_LAT=$(echo "$SUM_LAT+$CUR_LAT" | bc)
        CUR_COUNT=$((CUR_COUNT+1))
	#echo "CUR_COUNT=$CUR_COUNT, SUM_BW=$SUM_BW, CUR_BAND=$CUR_BAND, MIN_BW=$MIN_BW, MAX_BW=$MAX_BW"
        if [[ $COUNT == $CUR_COUNT ]]; then
           #echo "$SIZE             $SUM" >> $OUT_FILE_NAME
	   AVG_BW=$(echo $SUM_BW/$CUR_COUNT | bc -l)
	   AVG_LAT=$(echo $SUM_LAT/$CUR_COUNT | bc -l)
	   printf '%s\t%0.2f\t%0.2f\t%0.2f\t%0.2f\t%0.2f\t%0.2f\t%0.2f\n' $SIZE $MIN_LAT $MAX_LAT $AVG_LAT $MIN_BW $MAX_BW $AVG_BW $SUM_BW >> $OUT_FILE_NAME
        fi
        done
        if [[ $COUNT == 0 ]]; then
                break
        fi

        SIZE=$((SIZE*2))

done

echo "DONE! no rows for SIZE=$SIZE"
