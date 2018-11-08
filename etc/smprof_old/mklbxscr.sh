#!/bin/bash

# Make lazybox script for memory characteristic profile.  Users may pipe the
# generated configuration to the `run_exps.py` for actual start of the profile.

if [ $# -ne 2 ]
then
	echo "USAGE: $0 <expname> <command>"
	echo ""
	echo "expname should be in <workload>/<variance> format"
	exit 1
fi

LAZYBOX=$HOME/lazybox

BINDIR=`dirname $0`
FULLCMD=$2
COMM_ARR=($FULLCMD)
COMM=`basename ${COMM_ARR[0]}`
EXPNAME=$1
ODIR_ROOT=results
ODIR=$ODIR_ROOT/$EXPNAME

MAX_REPEAT=10
for (( unqid=1; unqid <= $MAX_REPEAT; unqid+=1 ))
do
	CANDIDATE=$ODIR/`printf "%02d" $unqid`
	if [ ! -d $CANDIDATE ]
	then
		ODIR=$CANDIDATE
		break
	fi
	if [ $unqid -eq $MAX_REPEAT ]
	then
		echo "[Error] $MAX_REPEAT repeated results already exists!!!"
		exit 1
	fi
done

GROUP=`groups $USER | awk '{print $3}'`


echo "
start echo 3 > sudo /proc/sys/vm/drop_caches
start mkdir -p $ODIR
main sudo perf stat -a -d -o $ODIR/perf.stat -- $FULLCMD | tee $ODIR/commlog
back while :; \\
	do sudo cat /proc/meminfo | grep MemFree >> $ODIR/memfree; sleep 1; done
back while :; \\
	do sudo cat /proc/vmstat | grep pswpin >> $ODIR/pswpin; sleep 1; done
back while :; \\
	do sudo cat /proc/vmstat | grep pswpout >> $ODIR/pswpout; sleep 1; done
back sudo vmstat 1 >> $ODIR/vmstats
back sudo $LAZYBOX/scripts/memfp.sh \"$FULLCMD\" >> $ODIR/memfps
end sudo chown -R $USER:$GROUP $ODIR_ROOT"
