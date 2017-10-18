#!/bin/bash -ex
verify_cmd ()
{
  . $@
	result=$?
  cmd=$@

	if [ $result != 0 ]; then
		echo "ERROR. Last command [$cmd] finished with result [$result]"
	else
		echo "SUCCESS. Last command [$cmd] finished with result [$result]"
	fi
  . $SCRIPTS_DIR/jmail.sh $result
}
. $SCRIPTS_DIR/mock_environments


echo BUILD_URL=$BUILD_URL
echo BUILD_NUMBER=$BUILD_NUMBER
echo HW_PLATFORM=$HW_PLATFORM
echo BUILD_VARIANT=$BUILD_VARIANT
echo TRIGGER_LAB_AUTOMATION=$TRIGGER_LAB_AUTOMATION

. $SCRIPTS_DIR/prepare.sh


echo ""

echo "Starting logs capture."
mkdir -p $PATH_TO_CAPTURE_LOGS
echo PATH_TO_CAPTURE_LOGS=$PATH_TO_CAPTURE_LOGS
pkill screen
/usr/bin/screen -dmS slogcat $SCRIPTS_DIR/savelogs-logcat.sh $PATH_TO_CAPTURE_LOGS $ANDROID_SERIAL
/bin/sleep 1
/usr/bin/screen -dmS sminicom $SCRIPTS_DIR/savelogs-minicom.sh $PATH_TO_CAPTURE_LOGS $ANDROID_SERIAL $MINICOM_SERIAL
/bin/sleep 1
