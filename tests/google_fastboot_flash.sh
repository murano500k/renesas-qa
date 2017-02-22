#!/bin/bash
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start google_fastboot_flash.sh *********$DATE******"
prepare_fastboot_test
for i in {1..100};
do
  DATE=`date +"%Y_%m_%d-%H_%M_%S"`
  echo "FASTBOOT_REBOOT_TEST Iteration $i. $DATE"
  is_fastboot
  $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash system $BUILD_DIR/system.img;
  sleep 5;
done

sleep 10
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ FINISH google_fastboot_flash.sh *********$DATE******"
echo "ITERATION_COUNT=$ITERATION_COUNT"
echo "ERROR_COUNT=$ERROR_COUNT"
