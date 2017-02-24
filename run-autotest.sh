#!/bin/bash -x

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start run-autotest.sh ********$DATE*******"
echo " ### Start google-test ### "
#Start test
if [ $DEV == true ]; then
  echo ""
  echo "************WARNING! This is dev version of autotest *******"
  echo ""
  . $SCRIPTS_DIR/tests/google_fastboot_reboot.sh
else
  . $SCRIPTS_DIR/tests/google_adb_reboot.sh
  . $SCRIPTS_DIR/tests/google_fastboot_reboot.sh
  . $SCRIPTS_DIR/tests/google_fastboot_flash.sh
  . $SCRIPTS_DIR/tests/google_fastboot_format.sh
fi
echo " ### google-test finished ### "
#09-26 15:23:21.849  1999  2045 I art     : Explicit concurrent mark sweep GC freed 8128(679KB) AllocSpace objects, 6(324KB) LOS objects, 33% free, 7MB/10MB, paused 646us total 38.880ms