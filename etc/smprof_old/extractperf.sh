#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <results path>"
	exit 1
fi

ODIR=$1
TARGET=$ODIR/perf
COMMLOG=$ODIR/commlog
WORKLOAD=`echo $ODIR | awk -F'/' '{print $2}'`

if [ $WORKLOAD == "memwalk" ]
then
	echo "init" `sed '2q;d' $COMMLOG | awk '{print $1}' | sed -e 's/,//g'` > $TARGET
	echo "access" `sed '3q;d' $COMMLOG | awk '{print $1}' | sed -e 's/,//g'` >> $TARGET
fi

# SPEC
if [ $WORKLOAD == "mcf" ] || [ $WORKLOAD == "omnetpp" ] ||
	[ $WORKLOAD == "bzip2" ] || [ $WORKLOAD == "gcc" ] ||
	[ $WORKLOAD == "gobmk" ] || [ $WORKLOAD == "h264ref" ] ||
	[ $WORKLOAD == "hmmer" ] || [ $WORKLOAD == "lbm" ] ||
	[ $WORKLOAD == "libquantum" ] || [ $WORKLOAD == "mcf" ] ||
	[ $WORKLOAD == "milc" ] || [ $WORKLOAD == "sjeng" ] ||
	[ $WORKLOAD == "sphinx3" ] || [ $WORKLOAD == "wrf" ]
then
	echo "runtime" `grep runtime $COMMLOG | awk -F= '{print $3}'` > $TARGET
fi

# PARSEC
if [ $WORKLOAD == "canneal" ]
then
	runtime=`grep real $COMMLOG | awk '{print $2}'`
	min=`echo $runtime | awk -Fm '{print $1}'`
	sec=`echo $runtime | awk -Fm '{print $2}' | awk -F. '{print $1}'`
	echo "runtime" $(($min*60 + sec)) > $TARGET
fi

# TPCH
if [ $WORKLOAD == "tpch" ]
then
	tail -n 23 $COMMLOG > $TARGET
fi

# TPCDS
if [ $WORKLOAD == "tpcds" ]
then
	tail -n 49 $COMMLOG > $TARGET
fi

# CLOUDSUITE
DCPATH=$HOME/lazybox/workloads/cloudsuite/datacaching
if [ $WORKLOAD == "datacaching" ]
then
	avr=`cat $COMMLOG | $DCPATH/average_60results.py | tail -n 1`
	echo "rps " `echo $avr | awk -F, '{print $2}'` > $TARGET
	echo "lat " `echo $avr | awk -F, '{print $8}'` >> $TARGET
	echo "90th " `echo $avr | awk -F, '{print $9}'` >> $TARGET
	echo "95th " `echo $avr | awk -F, '{print $10}'` >> $TARGET
	echo "99th " `echo $avr | awk -F, '{print $11}'` >> $TARGET
fi

if [ $WORKLOAD == "masim" ]
then
	echo "accesses_per_msec" `cat $COMMLOG | awk '{print $4}' | \
		awk -F, '{print $1 $2}'` > $TARGET
fi

# SPARK-BENCH
if [ $WORKLOAD == "PageRank" ]
then
	grep '\[runtime\]' $COMMLOG | awk '{print "runtime " $2}' > $TARGET
fi
