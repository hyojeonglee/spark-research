#!/bin/bash

if [ $# -lt 1 ]
then
	echo "USAGE: $0 <results path>"
	exit 1
fi

BINDIR=`dirname $0`
cd $BINDIR

source ./checkdep.sh

LZPSCR=$LBX/scripts/perf

ODIR=$1

$LBX/scripts/report/memfree_to_used.py $ODIR/memfree > $ODIR/memused
MFTOT=0
NR_MF=0
for mf in `awk '{print $2}' $ODIR/memused`
do
	MFTOT=$(($MFTOT + $mf))
	NR_MF=$(($NR_MF + 1))
done
echo "memsued.avg: " $(($MFTOT / $NR_MF)) > $ODIR/memused.avg

./extractperf.sh $ODIR

if [ -f $ODIR/perf.stat ]
then
	PFS=$ODIR/perf.stat
	grep "insns per cycle" $PFS | awk '{print "ipc: " $4}' > $ODIR/ipc
	grep "page-faults" $PFS | awk '{print "page-faults: " $4}' > $ODIR/pf
	grep "LL-cache hits" $PFS | awk '{print "llcmiss: " $4}' | \
		sed -e 's/%//' > $ODIR/llcmiss
fi

PSWPIN=$ODIR/pswpin
if [ -f $PSWPIN ]
then
	$LBX/scripts/report/recs_to_diff.py $PSWPIN > $ODIR/pswpin.diff
	NR_SWPIN=0
	TOTAL_SWPIN=0
	for swpin in `awk '{print $2}' $ODIR/pswpin.diff`
	do
		TOTAL_SWPIN=$(($TOTAL_SWPIN + $swpin))
		NR_SWPIN=$(($NR_SWPIN + 1))
	done
	echo "swpin.avg: " $(($TOTAL_SWPIN / $NR_SWPIN)) > $ODIR/pswpin.avg
fi

PSWPOUT=$ODIR/pswpout
if [ -f $PSWPOUT ]
then
	$LBX/scripts/report/recs_to_diff.py $PSWPOUT > $ODIR/pswpout.diff
	NR_SWPOUT=0
	TOTAL_SWPOUT=0
	for swpout in `awk '{print $2}' $ODIR/pswpout.diff`
	do
		TOTAL_SWPOUT=$(($TOTAL_SWPOUT + $swpout))
		NR_SWPOUT=$(($NR_SWPOUT + 1))
	done
	echo "swpin.avg: " $(($TOTAL_SWPOUT / $NR_SWPOUT)) > $ODIR/pswpout.avg
fi
