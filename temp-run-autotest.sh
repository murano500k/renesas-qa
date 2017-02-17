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


#prepare test
. $SCRIPTS_DIR/hard-reset.sh
export ADB_CMD="adb"
#Create clean dir to capture logs
#Start capture
echo "Starting logs capture."
mkdir -p $PATH_TO_CAPTURE_LOGS
echo PATH_TO_CAPTURE_LOGS=$PATH_TO_CAPTURE_LOGS
pkill screen
/usr/bin/screen -dmS slogcat $SCRIPTS_DIR/savelogs-logcat.sh $PATH_TO_CAPTURE_LOGS $ANDROID_SERIAL
/bin/sleep 1
/usr/bin/screen -dmS sminicom $SCRIPTS_DIR/savelogs-minicom.sh $PATH_TO_CAPTURE_LOGS $ANDROID_SERIAL $MINICOM_SERIAL
/bin/sleep 1
echo "Start google-test"
#Start test
export ERROR_COUNT=0
. $SCRIPTS_DIR/tests/google_fastboot_format.sh
echo " google-test finished"
