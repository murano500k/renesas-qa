#!/bin/bash -x

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start savelogs-minicom.sh ********$DATE*******"
if [ -z $1 ]; then
  echo log dir not set. Exiting...
  exit 1
fi

if [ -z $2 ]; then
  echo ADB_SERIAL not set. Exiting...
  exit 1
fi

if [ -z $3 ]; then
  echo MINICOM_SERIAL not set. Exiting...
  exit 1
fi

LOG_DIR=$1
ADB_SERIAL=$2
MINICOM_SERIAL=$3
LOG_FILE=$LOG_DIR/minicom-$ADB_SERIAL.txt

echo "Started minicom capture"
echo "DEVICE=$MINICOM_SERIAL"
echo "LOG_FILE=$LOG_FILE"

minicom -D $MINICOM_SERIAL --capturefile=$LOG_FILE
