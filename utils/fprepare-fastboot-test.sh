#!/bin/bash
prepare_fastboot_test ()
{
  DATE=`date +"%Y_%m_%d-%H_%M_%S"`
  echo ""
  echo "************ Start prepare-fastboot-test.sh ********$DATE*******"
  FASTBOOT_DEVICES="$($FASTBOOT_PATH devices)"
  if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
    echo "fastboot device [$FASTBOOT_SERIAL] NOT found"
    reset_fastboot
    sleep 5
  fi
}
