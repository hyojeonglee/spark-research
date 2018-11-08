#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Usage: $0 <workload/variant> <workload run script>"
	exit 1
fi

BINDIR=`dirname $0`
cd $BINDIR

source ./checkdep.sh

./mklbxscr.sh "$1" "$2" | sudo $LBX/run_exps.py stdin
