#!/bin/bash

LBX=$HOME/lazybox

cd $LBX
NSEC=`date +%s%N`
expect remote_cmds.exp hduser sdc-node11 22 dcslab \
	"EXEC_CORES=4 EXEC_MEMORY=30g /home/hduser/spark-bench-legacy/SVDPlusPlus/bin/run.sh" 3
echo "[runtime] "$(((`date +%s%N` - $NSEC) / 1000 / 1000))
