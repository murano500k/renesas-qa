#!/bin/bash -x

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start run-autotest.sh ********$DATE*******"
#prepare test
capture_log
echo " ### Start google-test ### "
#Start test
if [ $DEV == true ]; then
  echo ""
  echo "************WARNING! This is dev version of autotest *******"
  echo ""
  . $SCRIPTS_DIR/tests/google_adb_reboot.sh
else
  . $SCRIPTS_DIR/tests/google_adb_reboot.sh
  . $SCRIPTS_DIR/tests/google_fastboot_reboot.sh
  . $SCRIPTS_DIR/tests/google_fastboot_flash.sh
  . $SCRIPTS_DIR/tests/google_fastboot_format.sh
fi
echo " ### google-test finished ### "
