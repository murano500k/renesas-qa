#!/bin/bash
is_fastboot ()
{
DATE=`date +"%Y_%m_%d-%H_%M_%S"`

FASTBOOT_DEVICES="$($FASTBOOT_PATH devices)"

echo "$DATE verify: FASTBOOT_DEVICES=$FASTBOOT_DEVICES"

if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then

  echo "ERROR. fastboot device [$FASTBOOT_SERIAL] NOT found"
  export ERROR_COUNT=$((ERROR_COUNT+1))
  echo "ITERATION_COUNT=$i"
  echo "ERROR_COUNT=$ERROR_COUNT"
  send_mail $ERROR_FASTBOOT
  exit $ERROR_FASTBOOT
fi
}
