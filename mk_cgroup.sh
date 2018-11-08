#!/bin/bash
#
# Run a command with memory cgroup that has specific memory limit

if [ $# -ne 1 ]
then
	echo "Usage: $0 <mem limit in MiB>"
	exit 1
fi

MEMLIM=$(($1 * 1024 * 1024))

MEMCG_ORIG_DIR=/sys/fs/cgroup/memory/
MEMCG_DIR=/sys/fs/cgroup/memory/run_memcg_lim_$USER
sudo mkdir $MEMCG_DIR
sudo bash -c "echo $$ > $MEMCG_DIR/tasks"
sudo bash -c "echo $MEMLIM > $MEMCG_DIR/memory.limit_in_bytes"

