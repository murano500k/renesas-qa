#!/bin/bash

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start savelogs-logcat.sh ********$DATE*******"
if [ -z $1 ]; then
  echo log dir not set. Exiting...
  return $ERROR_PREPARE
fi

if [ -z $2 ]; then
  echo ADB_SERIAL not set. Exiting...
  return $ERROR_PREPARE
fi

LOG_DIR=$1
ADB_SERIAL=$2
LOG_FILE=$LOG_DIR/logcat-$ADB_SERIAL.txt

echo "Started logcat capture"
echo "DEVICE=$ADB_SERIAL"
echo "LOG_FILE=$LOG_FILE"

i=0;
while true;
do
	DATE=`date +"%Y_%m_%d-%H_%M_%S"`
	echo "################################################" >> $LOG_FILE
	echo "												  Iteration $i. $DATE" >> $LOG_FILE
	echo "################################################" >> $LOG_FILE
	sleep 1
	adb -s $ADB_SERIAL wait-for-device
	adb -s $ADB_SERIAL logcat >> $LOG_FILE
	let "i+=1"
done;
