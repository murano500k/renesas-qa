#!/bin/bash

#Delete lock file in WORKSPACE dir to indicate job is finished
export LOCK_FILE="$WORKSPACE/lock/$HW_PLATFORM"

rm -v $LOCK_FILE
echo "Lock file deleted: $LOCK_FILE"
export LOCK_FILE=
