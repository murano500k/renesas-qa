#!/bin/bash -x

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start run-autotest.sh ********$DATE*******"
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
#. $SCRIPTS_DIR/hard-reset.sh
export ADB_CMD="adb"
#Create clean dir to capture logs
#Start capture
echo "Starting logs capture."
mkdir -p $PATH_TO_CAPTURE_LOGS
echo PATH_TO_CAPTURE_LOGS=$PATH_TO_CAPTURE_LOGS
sudo screen -S sminicom -X quit
sudo screen -S slogcat -X quit
sleep 5
/usr/bin/screen -dmS slogcat $SCRIPTS_DIR/savelogs-logcat.sh $PATH_TO_CAPTURE_LOGS $ADB_SERIAL
/bin/sleep 1
/usr/bin/screen -dmS sminicom $SCRIPTS_DIR/savelogs-minicom.sh $PATH_TO_CAPTURE_LOGS $ADB_SERIAL $MINICOM_SERIAL
/bin/sleep 1
echo " ### Start google-test ### "
#Start test
export ERROR_COUNT=0
. $SCRIPTS_DIR/tests/google_adb_reboot.sh
echo " ### google-test finished ### "
