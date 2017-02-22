#!/bin/bash
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
FASTBOOT_DEVICES="$($FASTBOOT devices)"
echo $DATE verify: FASTBOOT_DEVICES=$FASTBOOT_DEVICES
if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
  echo ERROR. fastboot device [$FASTBOOT_SERIAL] NOT found
  export ERROR_COUNT=$((ERROR_COUNT+1))
  echo "ITERATION_COUNT=$i"
  echo "ERROR_COUNT=$ERROR_COUNT"
  exit 1
fi
