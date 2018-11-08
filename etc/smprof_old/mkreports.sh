#!/bin/bash

BINDIR=`dirname $0`
cd $BINDIR

source ./checkdep.sh
source ./cfg.sh

REPORT_DIR=reports
mkdir -p $REPORT_DIR

# Text report for each workload/variant
for w in $WORKLOADS
do
	for v in $VARIANTS
	do
		RDIR=results/$w/$v/avg
		REPORT=$REPORT_DIR/report-$w-$v
		echo > $REPORT
		for f in perf ipc llcmiss memused.avg pf
		do
			cat $RDIR/$f >> $REPORT
		done
	done
done

# Plot metric results for all workload/variant
for m in perf ipc llcmiss memused.avg pf
do
	REPORT=$REPORT_DIR/$m
	printf "metric" > $REPORT
	for w in $WORKLOADS
	do
		for v in $VARIANTS
		do
			printf "\t%s" $w/$v >> $REPORT
		done

	done
	printf "\n" >> $REPORT
done
for m in perf ipc llcmiss memused.avg pf
do
	REPORT=$REPORT_DIR/$m
	printf $m >> $REPORT
	for w in $WORKLOADS
	do
		for v in $VARIANTS
		do
			printf "\t%s" `cat results/$w/$v/avg/$m | \
				awk '{print $2}'` >> $REPORT
		done

	done
	printf "\n" >> $REPORT
done

HTML_RPT=$REPORT_DIR/report.html
echo "<center>" > $HTML_RPT
for m in perf ipc llcmiss memused.avg pf
do
	REPORT=$REPORT_DIR/$m
	cat $REPORT | $LBX/gnuplot/plot_stdin.sh clustered_box "" "$m"
	mv plot.pdf $REPORT.pdf

	$LBX/gnuplot/pdftopng $REPORT
	echo "$m<br>" >> $HTML_RPT
	echo "<img src=$m.png><br>" >> $HTML_RPT
done

REPORT=$REPORT_DIR/memused
echo > $REPORT
for w in $WORKLOADS
do
	for v in $VARIANTS
	do
		echo $w/$v >> $REPORT
		cat results/$w/$v/avg/memused >> $REPORT
		echo >> $REPORT
		echo >> $REPORT
	done
done

head -n -2 $REPORT > tmp.txt
mv tmp.txt $REPORT
cat $REPORT | $LBX/gnuplot/plot_stdin.sh scatter "Time (seconds)" "Memory used (kB)"
mv plot.pdf $REPORT.pdf
$LBX/gnuplot/pdftopng $REPORT
echo "memused<br>" >> $HTML_RPT
echo "<img src=memused.png><br>" >> $HTML_RPT
