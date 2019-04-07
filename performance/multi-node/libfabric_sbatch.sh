#!/bin/bash
##BATCH -A <account>
#SBATCH --exclusive
##SBATCH -C flat,quad
#SBATCH --time=00:50:00
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out
##SBATCH -C c0-0c0|c0-0c1
source env_variables.sh

module load craype-hugepages2M

FOLDER_NAME="$SLURM_JOB_ID-$SLURM_JOB_NUM_NODES-$PROCESSES-$THREADS-$WIN_SIZE"
#mkdir "jobs/$FOLDER_NAME"

#srun -N$SLURM_JOB_NUM_NODES -n$(( SLURM_JOB_NUM_NODES*PROCESSES )) ./rdm_mbw_mr -t$THREADS -i$WIN_SIZE >> jobs/$FOLDER_NAME.out 2>&1
srun -N$SLURM_JOB_NUM_NODES -n$(( SLURM_JOB_NUM_NODES*PROCESSES )) ./multi_rdm_one_sided_MPI_barrier_rate -t$THREADS -i$WIN_SIZE >> jobs/$FOLDER_NAME.out 2>&1
#srun -N$SLURM_JOB_NUM_NODES -n$(( SLURM_JOB_NUM_NODES*PROCESSES )) ./multi_rdm_one_sided_MPI_barrier -t$THREADS -i$WIN_SIZE >> jobs/$FOLDER_NAME.out 2>&1
#srun -N$SLURM_JOB_NUM_NODES -n$(( SLURM_JOB_NUM_NODES*PROCESSES )) ./multi_rdm_one_sided -t$THREADS -i$WIN_SIZE >> jobs/$FOLDER_NAME.out 2>&1

wait
rm "lock"
