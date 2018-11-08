#!/bin/bash

BINDIR=`dirname $0`
cd $BINDIR

source ./checkdep.sh
source ./cfg.sh

for w in $WORKLOADS
do
	for v in $VARIANTS
	do
		echo "Calculate stat of $w/$v"
		./stat.sh results/$w/$v results/$w/$v/0*
	done
done
