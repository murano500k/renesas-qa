#!/bin/bash
if [ -z $NCAR_BUILD_NAME ]; then
  echo $SCRIPTS_DIR/set-url.sh failed. NCAR_BUILD_NAME not set.  Exiting...
  return 1
fi
if [ -z $BUILD_TAR_URL ]; then
  echo $SCRIPTS_DIR/set-url.sh failed. BUILD_TAR_URL not set.  Exiting...
  return 1
fi
export LDIRNAME="${NCAR_BUILD_NAME%.tar.gz*}"
export PATH_TO_CAPTURE_LOGS=$LOG_DIR/$ADB_SERIAL/$LDIRNAME
export OUTPUT_FILE=$PATH_TO_CAPTURE_LOGS/output.txt


#http://build.globallogic.com.ua/view/Renesas/job/Renesas-GEN3-NCar//artifact/build/renesas_466_20170213_salvator_car_h3_userdebug.tar.gz
TEMP="${NCAR_BUILD_NAME#renesas_*}"
BUILD_NUMBER="${TEMP%%_*.tar.gz}"
export BUILD_URL=http://build.globallogic.com.ua/view/Renesas/job/Renesas-GEN3-NCar/$BUILD_NUMBER/artifact/build/$NCAR_BUILD_NAME
