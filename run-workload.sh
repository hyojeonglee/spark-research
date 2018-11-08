#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <workload>"
	exit 1
fi

WORKLOAD=$1
LBX=$HOME/lazybox

cd $LBX
NSEC=`date +%s%N`
expect remote_cmds.exp hduser sdc-node11 22 dcslab \
	"EXEC_MEMORY=29g EXEC_CORES=4 /home/hduser/spark-bench-legacy/$WORKLOAD/bin/run.sh" 3
echo "[runtime] "$(((`date +%s%N` - $NSEC) / 1000 / 1000))
