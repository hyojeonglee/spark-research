#!/bin/bash

BINDIR=`dirname $0`
cd $BINDIR

source ./checkdep.sh
source ./cfg.sh

for w in $WORKLOADS
do
	for v in $VARIANTS
	do
		for d in results/$w/$v/0*
		do
			./post_profile.sh $d
		done
	done
done
