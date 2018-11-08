#!/bin/bash

MEMCG_ORIG_DIR=/sys/fs/cgroup/memory/
MEMCG_DIR=/sys/fs/cgroup/memory/run_memcg_lim_$USER

while read pid; do
	sudo bash -c "echo $pid > $MEMCG_ORIG_DIR/tasks"
done < $MEMCG_DIR/tasks

sudo rmdir $MEMCG_DIR
