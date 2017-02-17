#!/bin/bash
if [ -z $NCAR_BUILD_NAME ]; then
  echo $SCRIPTS_DIR/set-url.sh failed. NCAR_BUILD_NAME not set.  Exiting...
  exit 1
fi
if [ -z $BUILD_TAR_URL ]; then
  echo $SCRIPTS_DIR/set-url.sh failed. BUILD_TAR_URL not set.  Exiting...
  exit 1
fi
echo create-out BUILD_TAR_URL=$BUILD_TAR_URL
echo create-out NCAR_BUILD_NAME=$NCAR_BUILD_NAME
LDIRNAME="${NCAR_BUILD_NAME%.tar.gz*}"
export PATH_TO_CAPTURE_LOGS=$LOG_DIR/$LDIRNAME
export OUTPUT_FILE=$PATH_TO_CAPTURE_LOGS/output.txt
mkdir -p $PATH_TO_CAPTURE_LOGS
touch $OUTPUT_FILE

#http://build.globallogic.com.ua/view/Renesas/job/Renesas-GEN3-NCar//artifact/build/renesas_466_20170213_salvator_car_h3_userdebug.tar.gz
TEMP="${NCAR_BUILD_NAME#renesas_*}"
BUILD_NUMBER="${TEMP%%_*.tar.gz}"
export BUILD_URL=http://build.globallogic.com.ua/view/Renesas/job/Renesas-GEN3-NCar/$BUILD_NUMBER/artifact/build/$NCAR_BUILD_NAME
echo create-out BUILD_URL=$BUILD_URL
