#!/bin/bash
if [ -z $1 ]; then
  echo log dir not set. Exiting...
  exit 1
fi

if [ -z $2 ]; then
  echo ANDROID_SERIAL not set. Exiting...
  exit 1
fi

if [ -z $3 ]; then
  echo MINICOM_SERIAL not set. Exiting...
  exit 1
fi

LOG_DIR=$1
ANDROID_SERIAL=$2
MINICOM_SERIAL=$3
LOG_FILE=$LOG_DIR/minicom-$ANDROID_SERIAL.txt

echo "Started minicom capture"
echo "DEVICE=$MINICOM_SERIAL"
echo "LOG_FILE=$LOG_FILE"

minicom -D $MINICOM_SERIAL --capturefile=$LOG_FILE
