#!/bin/bash
reset_adb ()
{
echo "RESET AND WAIT ADB"
ADB_DEVICES="$(adb devices)"
if [[ $ADB_DEVICES != *$ADB_SERIAL* ]]; then
  sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s0
  sleep 1
  sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s1
  sleep 1
  timeout 60 adb -s $ADB_SERIAL wait-for-device
  result=$?
  if [ $result != 0 ]; then
		echo "adb wait-for-device exit on timeout"
    echo "Try hard reset by phidget"
    sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s0
    sleep 1
    sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s1
    echo "sleep 20"
    sleep 20
    echo "Wait for device 2"
    timeout 60 adb -s $ADB_SERIAL wait-for-device
    result=$?
    if [ $result != 0 ]; then
      echo "ERROR. Adb still don't see device"
      echo "Perhaps device is not bootable after flash new build"
      send_mail $ERROR_ADB
      exit $ERROR_ADB
    fi
	fi
fi
echo "device $ADB_SERIAL found"
}
