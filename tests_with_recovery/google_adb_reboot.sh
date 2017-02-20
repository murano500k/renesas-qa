#!/bin/bash

echo ""
echo "************ Start google_adb_reboot.sh ***************"
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
    export ERROR_COUNT=$((ERROR_COUNT+1))
		export ITERATION_COUNT=$i
    . $SCRIPTS_DIR/hard-reset.sh
		break;
	fi;
	sleep 20;
done;
sleep 20
echo ""
echo "************ Finish google_adb_reboot.sh ***************"
echo "ITERATION_COUNT=$ITERATION_COUNT"
echo "ERROR_COUNT=$ERROR_COUNT"
