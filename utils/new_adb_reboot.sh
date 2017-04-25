#!/bin/bash
export REBOOT_COUNT=100000
export DEFAULT_TIMEOUT=360
if [ -z $1 ] ; then
echo "ADB serial not set. Exiting..."
exit 1
else
ADB_SERIAL=$1
fi

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start new_adb_reboot.sh ********$DATE*******"
echo "REBOOT_COUNT=$REBOOT_COUNT"
for i in $(seq 1 $REBOOT_COUNT);
do
	DATE=`date +"%Y_%m_%d-%H_%M_%S"`
	echo "ADB_REBOOT_TEST. Iteration $i. $DATE"
	timeout $DEFAULT_TIMEOUT adb -s $ADB_SERIAL reboot;
	while [[ -n "`adb devices | grep ${ADB_SERIAL}`" ]];
		do sleep 1;
	done;
	timeout $DEFAULT_TIMEOUT adb -s $ADB_SERIAL wait-for-device;
	UP=`adb -s $ADB_SERIAL shell cat /proc/uptime | cut -d. -f1 | tr -d [:space:]`;
	BC=`adb -s $ADB_SERIAL shell getprop | grep bootcomplete`;

	if [ -z "${BC}" ] ; then
		echo "dev.bootcomplete property not set. Device UI didn't start";
        export ERROR_COUNT=$((ERROR_COUNT+1))
        echo "ITERATION_COUNT=$i"
        echo "ERROR_COUNT=$ERROR_COUNT"
        exit 2
	else
		echo "bootcomplete: ${BC}"
	fi
	if [ -z "${UP}" ] || [ "${UP}" -gt 30 ]; then
		echo "Uptime not detected or longer than 30s: ${UP}";
        export ERROR_COUNT=$((ERROR_COUNT+1))
        echo "ITERATION_COUNT=$i"
        echo "ERROR_COUNT=$ERROR_COUNT"
        exit 3
	else
		echo "Uptime: ${UP}"
	fi
	sleep 10;
done
echo ""
echo "************ Finish google_adb_reboot.sh ********$DATE*******"