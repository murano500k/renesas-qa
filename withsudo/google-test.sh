#!/bin/bash

if [ -z "$ADB_CMD" ]; then
  echo "ADB_CMD not set. Exiting..."
  exit 1
fi
if [ -z $ANDROID_SERIAL ]; then
  echo "ANDROID_SERIAL not set. Exiting..."
  exit 1
fi
echo "Google test. ADB_CMD='$ADB_CMD'. ANDROID_SERIAL=$ANDROID_SERIAL"
for i in {1..100};
do
	echo "ADB_REBOOT_TEST. Iteration $i";
	$ADB_CMD -s $ANDROID_SERIAL reboot;
	while [[ -n "`$ADB_CMD devices | grep ${ANDROID_SERIAL}`" ]];
		do sleep 1;
	done;
	$ADB_CMD -s $ANDROID_SERIAL wait-for-device;
	UP=`$ADB_CMD -s $ANDROID_SERIAL shell cat /proc/uptime | cut -d. -f1 | tr -d [:space:]`;
	if [ -z "${UP}" ] || [ "${UP}" -gt 30 ];
	then
		echo "Uptime not detected or longer than 30s: ${UP}";
		echo "ADB_REBOOT_TEST. Iteration $i FAILED!";
		break;
	fi;
	sleep 20;
done;
sleep 20

$ADB_CMD -s $ANDROID_SERIAL reboot bootloader
sleep 20
for i in {1..100};
do echo "FASTBOOT_REBOOT_TEST Iteration $i";
$FASTBOOT -s $FASTBOOT_SERIAL reboot-bootloader;
sleep 5;
done

sleep 20
for i in {1..10};
do
	echo "FLASH_SYSTEM_TEST Iteration $i";
	$FASTBOOT -s $FASTBOOT_SERIAL flash system system.img;
	sleep 5;
done

sleep 20
for i in {1..10};
do
	echo "FORMAT_TEST Iteration $i";
	$FASTBOOT -s $FASTBOOT_SERIAL format userdata;
	sleep 5;
done
