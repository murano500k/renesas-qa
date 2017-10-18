#!/bin/bash

#Check if lock file exist
#if true exit 1

export LOCK_FILE="$WORKSPACE/lock/$HW_PLATFORM"

if [ -f $LOCK_FILE ]; then
    echo "Lock file found, assuming $HW_PLATFORM is busy"
    exit 1
else
    echo "Lock file NOT found, assuming no jobs are running on $HW_PLATFORM"
    return 0
fi
