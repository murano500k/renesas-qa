#!/bin/bash
ADBFASTBOOT_H3=h3
ADBFASTBOOT_M3=m3
MINICOM_H3=/dev/ttyUSB0
MINICOM_M3=/dev/ttyUSB1
PHIDGET_SERIAL_H3=1
PHIDGET_SERIAL_M3=2

echo BUILD_URL=$BUILD_URL
echo BUILD_NUMBER=$BUILD_NUMBER
echo HW_PLATFORM=$HW_PLATFORM
echo BUILD_VARIANT=$BUILD_VARIANT
echo TRIGGER_LAB_AUTOMATION=$TRIGGER_LAB_AUTOMATION

#Check if required vars are set

if [ -z $BUILD_URL ]; then
  echo BUILD_URL not set. Exiting...
  exit 1
fi

if [ -z $BUILD_NUMBER ]; then
  echo BUILD_NUMBER not set. Exiting...
  exit 1
fi
if [ -z $HW_PLATFORM ]; then
  echo HW_PLATFORM not set. Exiting...
  exit 1
fi
if [ -z $BUILD_VARIANT ]; then
  echo BUILD_VARIANT not set. Exiting...
  exit 1
fi
if [ -z $TRIGGER_LAB_AUTOMATION ]; then
  echo TRIGGER_LAB_AUTOMATION not set. Exiting...
  exit 1
fi
#Check if trigger is true
if [ $TRIGGER_LAB_AUTOMATION != true ]; then
  echo "Autotest not triggered."
  exit 0
fi
#Export vars required for scripts
#% before, # after
. set-url.sh

if [ -z $NCAR_BUILD_NAME ]; then
  echo set-url.sh failed. NCAR_BUILD_NAME not set.  Exiting...
  exit 1
fi
if [ -z $BUILD_TAR_URL ]; then
  echo set-url.sh failed. BUILD_TAR_URL not set.  Exiting...
  exit 1
fi

LDIRNAME="${NCAR_BUILD_NAME%.tar.gz*}"
export PATH_TO_CAPTURE_LOGS=$LOG_DIR/$LDIRNAME
export OUTPUT_FILE=$PATH_TO_CAPTURE_LOGS/output.txt
mkdir -p $PATH_TO_CAPTURE_LOGS
touch $OUTPUT_FILE

#http://build.globallogic.com.ua/view/Renesas/job/Renesas-GEN3-NCar//artifact/build/renesas_466_20170213_salvator_car_h3_userdebug.tar.gz
TEMP="${NCAR_BUILD_NAME#renesas_*}"
BUILD_NUMBER="${TEMP%%_*.tar.gz}"
export BUILD_URL=http://build.globallogic.com.ua/view/Renesas/job/Renesas-GEN3-NCar/$BUILD_NUMBER/artifact/build/$NCAR_BUILD_NAME


if [ "$HW_PLATFORM" == "full_salvator_h3" ]; then
  export FASTBOOT_SERIAL=$ADBFASTBOOT_H3
  export MINICOM_SERIAL=$MINICOM_H3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_H3
elif [ "$HW_PLATFORM" == "full_salvator_m3" ]; then
  export FASTBOOT_SERIAL=$ADBFASTBOOT_M3
  export MINICOM_SERIAL=$MINICOM_M3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_M3
elif [ "$HW_PLATFORM" == "salvator_car_h3" ]; then
  export FASTBOOT_SERIAL=$ADBFASTBOOT_H3
  export MINICOM_SERIAL=$MINICOM_H3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_H3
elif [ "$HW_PLATFORM" == "salvator_car_m3" ]; then
  export FASTBOOT_SERIAL=$ADBFASTBOOT_M3
  export MINICOM_SERIAL=$MINICOM_M3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_M3
fi

export ANDROID_SERIAL=$FASTBOOT_SERIAL
export ADB_CMD="adb"
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
