#!/bin/bash
#MSUB -e job$MOAB_JOBID.err
#MSUB -o job$MOAB_JOBID.out
#MSUB -l walltime=10:00:00

source env_variables.sh

if [ -z "$COMPUTE" ]; then
	INPUT=$((PBS_NUM_NODES/2))
	COMPUTE=$((PBS_NUM_NODES - INPUT))
fi

FOLDER_NAME="$MOAB_JOBID-$PBS_NUM_NODES-$PROCESSES-$THREADS-$WIN_SIZE"
#mkdir "jobs/$FOLDER_NAME"

aprun -N$PROCESSES -n$(( PBS_NUM_NODES*PROCESSES )) ./multi_rdm_one_sided -t$THREADS -i$WIN_SIZE >> jobs/$FOLDER_NAME.out 2>&1
wait
rm "lock"


