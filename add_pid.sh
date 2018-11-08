#!/bin/bash

MEMCG_DIR=/sys/fs/cgroup/memory/run_memcg_lim_$USER

PIDS=`pidof java`
echo "$PIDS"
for pid in $PIDS
do
	sudo bash -c "echo $pid > $MEMCG_DIR/tasks"
done

