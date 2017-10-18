#!/bin/bash
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo "************ Start google_fastboot_flash.sh *********$DATE******"
prepare_fastboot_test
echo "FLASH_FORMAT_COUNT=$FLASH_FORMAT_COUNT"
for i in $(seq 1 $FLASH_FORMAT_COUNT);
do
  DATE=`date +"%Y_%m_%d-%H_%M_%S"`
  echo "FASTBOOT_FLASH_TEST Iteration $i. $DATE"
  is_fastboot
  timeout $DEFAULT_TIMEOUT $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash system $BUILD_DIR/system.img;
  sleep 5;
done

sleep 10
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ FINISH google_fastboot_flash.sh *********$DATE******"
echo "ITERATION_COUNT=$ITERATION_COUNT"
echo "ERROR_COUNT=$ERROR_COUNT"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
