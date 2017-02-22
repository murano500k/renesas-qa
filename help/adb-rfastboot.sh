#!/bin/bash
echo "run adb reboot fastboot script"
$ADB_CMD -s $ANDROID_SERIAL reboot bootloader
sleep 10

FASTBOOT_DEVICES="$($FASTBOOT devices)"
if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
  echo ERROR. fastboot device [$FASTBOOT_SERIAL] NOT found
  exit 1
fi
