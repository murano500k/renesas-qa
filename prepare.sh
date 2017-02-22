#!/bin/bash

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start prepare.sh ********$DATE*******"
ADBFASTBOOT_H3=h3-A39E
ADBFASTBOOT_M3=m3
MINICOM_H3=0
MINICOM_M3=1
PHIDGET_SERIAL_H3=1
PHIDGET_SERIAL_M3=2
#Export vars required for scripts
#% before, # after

. $SCRIPTS_DIR/prepare/check-build-params.sh
. $SCRIPTS_DIR/prepare/export-env
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
export FASTBOOT_CMD="$FASTBOOT -s $FASTBOOT_SERIAL"
export ERROR_COUNT=0


. $SCRIPTS_DIR/prepare/create-output-dir.sh

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

#Exit
