#!/bin/bash
if [ -z $1 ]; then
  echo log dir not set. Exiting...
  exit 1
fi

if [ -z $2 ]; then
  echo ANDROID_SERIAL not set. Exiting...
  exit 1
fi

LOG_DIR=$1
ANDROID_SERIAL=$2
LOG_FILE=$LOG_DIR/logcat-$ANDROID_SERIAL.txt

echo "Started logcat capture"
echo "DEVICE=$ANDROID_SERIAL"
echo "LOG_FILE=$LOG_FILE"

i=0;
while true;
do
	DATE=`date +"%Y_%m_%d-%H_%M_%S"`
	echo "################################################" >> $LOG_FILE
	echo "												  Iteration $i. $DATE" >> $LOG_FILE
	echo "################################################" >> $LOG_FILE
	sleep 1
	adb -s $ANDROID_SERIAL wait-for-device
	adb -s $ANDROID_SERIAL logcat >> $LOG_FILE
	let "i+=1"
done;
