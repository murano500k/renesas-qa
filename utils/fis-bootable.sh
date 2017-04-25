#!/bin/bash
is_bootable ()
{
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start verify-isbootable.sh ********$DATE*******"

ADB_DEVICES="$(adb devices)"
if [[ $ADB_DEVICES != *$ADB_SERIAL* ]]; then
  timeout 60 adb -s $ADB_SERIAL wait-for-device
  result=$?
  if [ $result != 0 ]; then
		echo "adb wait-for-device exit on timeout"
    echo "Try hard reset by phidget"
    sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s0
    sleep 1
    sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s1
    sleep 60
    echo "Wait for device 2"
    timeout 60 adb -s $ADB_SERIAL wait-for-device
    result=$?
    if [ $result != 0 ]; then
      echo "ERROR. Adb still don't see device"
      echo "Perhaps device is not bootable after flash new build"
      send_mail $ERROR_NOT_BOOTABLE
      exit $ERROR_NOT_BOOTABLE
    fi
	fi
fi
echo "device $ADB_SERIAL found"
echo "Check bootcomplete"
export BOOT_COMPLETE=`adb -s $ADB_SERIAL shell getprop | grep bootcomplete`
}
