#!/bin/bash

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start prepare.sh ********$DATE*******"

#Export vars required for scripts
#% before, # after

. $SCRIPTS_DIR/prepare/check-build-params.sh
. $SCRIPTS_DIR/prepare/export-env-jenkins
. $SCRIPTS_DIR/prepare/export-funcs
. $SCRIPTS_DIR/prepare/export-error-codes

. $SCRIPTS_DIR/prepare/set-url.sh

if [ "$HW_PLATFORM" == "salvator_car_h3" ]; then
  export FASTBOOT_SERIAL=$ADBFASTBOOT_H3
  export MINICOM_PORT_NUMBER=$MINICOM_H3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_H3
elif [ "$HW_PLATFORM" == "salvator_car_m3" ]; then
  export FASTBOOT_SERIAL=$ADBFASTBOOT_M3
  export MINICOM_PORT_NUMBER=$MINICOM_M3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_M3
fi
export MINICOM_SERIAL=/dev/ttyUSB$MINICOM_PORT_NUMBER
export ADB_SERIAL=$FASTBOOT_SERIAL
export ADB_CMD="adb"

export ERROR_COUNT=0


. $SCRIPTS_DIR/prepare/create-output-dir.sh
if [ -z "$DEV" ]; then
	export DEV=false
fi
#Print values

echo SCRIPTS_DIR=$SCRIPTS_DIR
echo BUILD_DIR=$BUILD_DIR
echo BUILD_URL=$BUILD_URL
echo FASTBOOT_SERIAL=$FASTBOOT_SERIAL
echo MINICOM_SERIAL=$MINICOM_SERIAL
echo PHIDGET_SERIAL=$PHIDGET_SERIAL
echo PATH_TO_CAPTURE_LOGS=$PATH_TO_CAPTURE_LOGS
echo OUTPUT_FILE=$OUTPUT_FILE
echo ADB_CMD=$ADB_CMD
echo DEV=$DEV


#return
echo "************ Finish prepare.sh ********$DATE*******"
