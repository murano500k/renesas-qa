#!/bin/bash
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start prepare-fastboot-test.sh ********$DATE*******"
FASTBOOT_DEVICES="$($FASTBOOT devices)"
if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
  echo fastboot device [$FASTBOOT_SERIAL] NOT found
  . $SCRIPTS_DIR/enable-fastboot.sh
  sleep 5
fi
