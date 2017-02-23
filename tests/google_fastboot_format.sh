#!/bin/bash
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start google_fastboot_format.sh ******$DATE*********"
prepare_fastboot_test
echo "FLASH_FORMAT_COUNT=$FLASH_FORMAT_COUNT"
for i in $(seq 1 $FLASH_FORMAT_COUNT);
do
  DATE=`date +"%Y_%m_%d-%H_%M_%S"`
  echo "FASTBOOT_FORMAT_TEST Iteration $i. $DATE"
  is_fastboot
  $FASTBOOT_PATH -s $FASTBOOT_SERIAL format userdata;
  sleep 5;
done

sleep 10
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Finish google_fastboot_format.sh ******$DATE********"
echo "ITERATION_COUNT=$ITERATION_COUNT"
echo "ERROR_COUNT=$ERROR_COUNT"
