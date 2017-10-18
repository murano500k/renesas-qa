#!/bin/bash

#Create lock file in WORKSPACE dir to indicate job is running

export LOCK_FILE="$WORKSPACE/lock/$HW_PLATFORM"

mkdir -p $WORKSPACE/lock
touch $LOCK_FILE
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo "Started at $DATE" >$LOCK_FILE

echo "Lock file created: $LOCK_FILE"
