#!/bin/bash

DATE=`date +"%Y_%m_%d-%H_%M_%S"`

echo ""
echo "************ Start google_fastboot_reboot.sh ********$DATE*******"
. $SCRIPTS_DIR/tests/prepare-fastboot-test.sh
for i in {1..100};
do
  DATE=`date +"%Y_%m_%d-%H_%M_%S"`
  echo "FASTBOOT_REBOOT_TEST Iteration $i. $DATE"
  . $SCRIPTS_DIR/tests/verify-fastboot.sh
  $FASTBOOT -s $FASTBOOT_SERIAL reboot-bootloader;
  sleep 5;
done

sleep 10
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Finish google_fastboot_reboot.sh ********$DATE*******"
echo "ITERATION_COUNT=$ITERATION_COUNT"
echo "ERROR_COUNT=$ERROR_COUNT"
