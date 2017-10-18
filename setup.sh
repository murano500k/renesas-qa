#!/bin/bash

#set device ids
if [ "$TARGET_BOARD_PLATFORM" == *"r8a7795"* ]; then
  export FASTBOOT_SERIAL=$ADBFASTBOOT_H3
  export MINICOM_PORT_NUMBER=$MINICOM_H3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_H3
elif [ "$TARGET_BOARD_PLATFORM" == *"r8a7796"*  ]; then
  export FASTBOOT_SERIAL=$ADBFASTBOOT_M3
  export MINICOM_PORT_NUMBER=$MINICOM_M3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_M3
else
  export FASTBOOT_SERIAL=$ADBFASTBOOT_H3
  export MINICOM_PORT_NUMBER=$MINICOM_H3
  export PHIDGET_SERIAL=$PHIDGET_SERIAL_H3
fi
export MINICOM_SERIAL=/dev/ttyUSB$MINICOM_PORT_NUMBER
export ADB_SERIAL=$FASTBOOT_SERIAL

#Set url
#http://build.globallogic.com.ua/view/Renesas/job/Renesas-GEN3-O/641/
TEMP="${BUILD_URL#*job\/}"
TEMP="${TEMP%\/*}"
JOB_NAME="${TEMP%\/*}"



URL_JSON=${BUILD_URL}api/json
mkdir -p $BUILD_DIR
rm -f $BUILD_DIR/json
wget -q --http-user $JENKINS_USER  --http-password $JENKINS_TOKEN --auth-no-challenge $URL_JSON  -O $BUILD_DIR/json
BUILD_TAR_NAME=$(echo `cat $BUILD_DIR/json` | jq '.artifacts[] | .displayPath'  | cut -d'"' -f 2 | grep "${BUILD_VARIANT}_${TARGET_BOARD_PLATFORM}.tar.gz")
export BUILD_NAME=$BUILD_TAR_NAME
export BUILD_TAR_URL=${BUILD_URL}artifact/build/${BUILD_TAR_NAME}


export LDIRNAME="${BUILD_NAME%.tar.gz*}"
export PATH_TO_CAPTURE_LOGS=$LOG_DIR/$ADB_SERIAL/$LDIRNAME
export OUTPUT_FILE=$PATH_TO_CAPTURE_LOGS/output.txt


#http://build.globallogic.com.ua/view/Renesas/job/Renesas-GEN3-O/641/
TEMP="${BUILD_NAME#Renesas-GEN3-O_*}"
BUILD_NUMBER="${TEMP%%_${BUILD_VARIANT}_${TARGET_BOARD_PLATFORM}.tar.gz}"

export BUILD_URL=http://build.globallogic.com.ua/view/Renesas/job/$JOB_NAME/$BUILD_NUMBER/artifact/build/$BUILD_NAME
echo BUILD_URL=$BUILD_URL
