#!/bin/bash -x

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start run-autotest.sh ********$DATE*******"

#prepare test
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
. $SCRIPTS_DIR/tests/google_fastboot_reboot.sh
. $SCRIPTS_DIR/tests/google_fastboot_flash.sh
. $SCRIPTS_DIR/tests/google_fastboot_format.sh
echo " ### google-test finished ### "
