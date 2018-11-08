#!/bin/bash

LBX=$HOME/lazybox

cd $LBX
expect remote_cmds.exp hduser sdc-node11 22 dcslab \
	"EXEC_CORES=4 EXEC_MEMORY=29g /home/hduser/spark-bench-legacy/bin/only-run-all.sh" 10
