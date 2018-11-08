#!/bin/bash

LBX=$HOME/lazybox

DEPS="$LBX"

for D in $DEPS
do
	if [ ! -d $D ]
	then
		echo "[FAIL] $D not exists"
		exit 1
	fi
done
