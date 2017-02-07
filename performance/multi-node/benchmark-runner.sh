#!/bin/bash

WIN_SIZE=1024
MAX_THREADS=20
MAX_PROCESSES=20
MAX_NODES=80

NODES_COUNTER=10

FILENAME="env_variables.sh"
FILENAME_LOCK="lock"

while [ $NODES_COUNTER -le $MAX_NODES ]; do
	THREADS_COUNTER=1
	while [ $THREADS_COUNTER -le $MAX_THREADS ]; do
		PROCESSES_COUNTER=1
		while [ $PROCESSES_COUNTER -le $MAX_PROCESSES ]; do
			echo -e "\n# The list of used enviromental variables.\n" > $FILENAME
			echo "PROCESSES=$PROCESSES_COUNTER" >> $FILENAME
			echo "THREADS=$THREADS_COUNTER" >> $FILENAME
			echo "WIN_SIZE=$WIN_SIZE" >> $FILENAME

			echo "NODES_COUNTER=$NODES_COUNTER THREADS_COUNTER=$THREADS_COUNTER PROCESSES_COUNTER=$PROCESSES_COUNTER WIN_SIZE=$WIN_SIZE msub -l nodes=$NODES_COUNTER libfabric_msub.sh"
			
			echo -e "" > $FILENAME_LOCK
			msub -l nodes=$NODES_COUNTER libfabric_msub.sh
			
			while [ -f "$FILENAME_LOCK" ]; do
				sleep 5
			done
			if [ $PROCESSES_COUNTER -eq "1" ]; then
				let PROCESSES_COUNTER=5
			else
				let PROCESSES_COUNTER*=2
			fi
		done
		if [ $THREADS_COUNTER -eq "1" ]; then
			let THREADS_COUNTER=5
		else
			let THREADS_COUNTER*=2
		fi
	done
	let NODES_COUNTER*=2
done
echo "done!"
wait



