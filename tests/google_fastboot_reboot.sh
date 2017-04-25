#!/bin/bash
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo "************ Start google_fastboot_reboot.sh ********$DATE*******"
prepare_fastboot_test
echo "REBOOT_COUNT=$REBOOT_COUNT"
for i in $(seq 1 $REBOOT_COUNT);
do
  DATE=`date +"%Y_%m_%d-%H_%M_%S"`
  echo "FASTBOOT_REBOOT_TEST Iteration $i. $DATE"
  is_fastboot
  timeout $DEFAULT_TIMEOUT $FASTBOOT_PATH -s $FASTBOOT_SERIAL reboot-bootloader;
  sleep 5;
done

sleep 10
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Finish google_fastboot_reboot.sh ********$DATE*******"
echo "ITERATION_COUNT=$ITERATION_COUNT"
echo "ERROR_COUNT=$ERROR_COUNT"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
