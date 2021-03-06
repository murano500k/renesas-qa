#!/bin/bash

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start google_adb_reboot.sh ********$DATE*******"
reset_adb
echo "REBOOT_COUNT=$REBOOT_COUNT"
for i in $(seq 1 $REBOOT_COUNT);
do
	DATE=`date +"%Y_%m_%d-%H_%M_%S"`
	echo "ADB_REBOOT_TEST. Iteration $i. $DATE"
	timeout $DEFAULT_TIMEOUT $ADB_CMD -s $ADB_SERIAL reboot;
	while [[ -n "`$ADB_CMD devices | grep ${ADB_SERIAL}`" ]];
		do sleep 1;
	done;
	timeout $DEFAULT_TIMEOUT $ADB_CMD -s $ADB_SERIAL wait-for-device;
	UP=`$ADB_CMD -s $ADB_SERIAL shell cat /proc/uptime | cut -d. -f1 | tr -d [:space:]`;
	if [ -z "${UP}" ] || [ "${UP}" -gt 30 ]; then
		echo "Uptime not detected or longer than 30s: ${UP}";
        export ERROR_COUNT=$((ERROR_COUNT+1))
        echo "ITERATION_COUNT=$i"
        echo "ERROR_COUNT=$ERROR_COUNT"
        send_mail $ERROR_ADB
        exit $ERROR_ADB
	fi
	sleep 10;
done;
echo ""
echo "************ Finish google_adb_reboot.sh ********$DATE*******"
echo "ITERATION_COUNT=$ITERATION_COUNT"
echo "ERROR_COUNT=$ERROR_COUNT"
#################################################
#
#
#Test execution estimate time 2h5m
#
#
#
#########################