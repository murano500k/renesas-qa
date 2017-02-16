#! /bin/bash
verify_cmd ()
{
  $@
	result=$?
  cmd=$@

	if [ $result != 0 ]; then
		echo "ERROR. Last command [$cmd] finished with result [$result]"
		exit $result
	else
		echo "SUCCESS. Last command [$cmd] finished with result [$result]"
	fi
}

echo SCRIPTS_DIR=$SCRIPTS_DIR
echo BUILD_DIR=$BUILD_DIR
echo BUILD_URL=$BUILD_URL
echo FASTBOOT_SERIAL=$FASTBOOT_SERIAL
echo MINICOM_SERIAL=$MINICOM_SERIAL
echo PHIDGET_SERIAL=$PHIDGET_SERIAL
echo FASTBOOT=$FASTBOOT
echo PATH_TO_CAPTURE_LOGS=$PATH_TO_CAPTURE_LOGS

ADB_DEVICES="$(adb devices)"

if [[ $ADB_DEVICES != *$ANDROID_SERIAL* ]]; then
  echo "adb don't see device"
  echo "trying wait-for-device with timeout 60"
  verify_cmd timeout 60 adb -s $ANDROID_SERIAL wait-for-device
fi
echo "device $ANDROID_SERIAL found"


#prepare test
export ADB_CMD="adb"
export REBOOT_TEST_ITERATIONS_COUNT=100
export FLASH_WIPE_TEST_ITERATIONS_COUNT=10
#Create clean dir to capture logs
mkdir -p $PATH_TO_CAPTURE_LOGS
echo "Starting logs capture."
echo "ADB_CMD=$ADB_CMD"
echo "ANDROID_SERIAL=$ANDROID_SERIAL"
echo "MINICOM_SERIAL=$MINICOM_SERIAL"
echo "TEST_ITERATIONS_COUNT=$TEST_ITERATIONS_COUNT"
echo "FLASH_WIPE_TEST_ITERATIONS_COUNT=$FLASH_WIPE_TEST_ITERATIONS_COUNT"
echo "PATH_TO_CAPTURE_LOGS=$PATH_TO_CAPTURE_LOGS"
#Start capture
pkill screen
/usr/bin/screen -dmS slogcat $SCRIPTS_DIR/savelogs-logcat.sh $PATH_TO_CAPTURE_LOGS $ANDROID_SERIAL
/bin/sleep 1
/usr/bin/screen -dmS sminicom $SCRIPTS_DIR/savelogs-minicom.sh $PATH_TO_CAPTURE_LOGS $ANDROID_SERIAL $MINICOM_SERIAL
/bin/sleep 1
echo "Start google-test"
#Start test
. $SCRIPTS_DIR/google-test.sh
echo " google-test finished"
