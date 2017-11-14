#!/bin/bash
#MSUB -e job$MOAB_JOBID.err
#MSUB -o job$MOAB_JOBID.out
#MSUB -l walltime=05:00:00
##MSUB -l feature='c0-0c1||c0-0c0'
##MSUB -l nodes='28:c0-0c0+1:c0-0c1s12n0+1:c0-0c1s13n0+1:c0-0c1s14n0+1:c0-0c1s15n0'
##MSUB -l nodes='31:c0-0c1+1:c0-0c0s8n1'
##MSUB -l nodes='4:c0-0c0s12+4:c0-0c0s13+4:c0-0c0s14+4:c0-0c0s15+4:c0-0c1s12+4:c0-0c1s13+4:c0-0c1s14+4:c0-0c1s15'
source env_variables.sh

if [ -z "$COMPUTE" ]; then
        INPUT=$((PBS_NUM_NODES/2))
        COMPUTE=$((PBS_NUM_NODES - INPUT))
fi

FOLDER_NAME="$MOAB_JOBID-$PBS_NUM_NODES-$PROCESSES-$THREADS-$WIN_SIZE"
#mkdir "jobs/$FOLDER_NAME"

aprun -N$PROCESSES -n$(( PBS_NUM_NODES*PROCESSES )) ./multi_rdm_one_sided_MPI_barrier -t$THREADS -i$WIN_SIZE >> jobs/$FOLDER_NAME.out 2>&1

wait
rm "lock"
