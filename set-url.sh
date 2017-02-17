#!/bin/bash
#export BUILD_URL="http://build.globallogic.com.ua/job/Renesas-GEN3-NCar/478/"
#export BUILD_NUMBER=478
#export HW_PLATFORM="salvator_car_h3"
#export BUILD_VARIANT="userdebug"
#export TRIGGER_LAB_AUTOMATION=true


URL_JSON=${BUILD_URL}api/json
echo URL_JSON=$URL_JSON
mkdir -p $BUILD_DIR
rm -f $BUILD_DIR/json
wget --http-user $JENKINS_USER  --http-password $JENKINS_TOKEN --auth-no-challenge $URL_JSON  -O $BUILD_DIR/json
BUILD_TAR_NAME=$(echo `cat $BUILD_DIR/json` | jq '.artifacts[] | .displayPath'  | cut -d'"' -f 2 | grep "$BUILD_VARIANT.tar.gz")
export NCAR_BUILD_NAME=$BUILD_TAR_NAME
export BUILD_TAR_URL=${BUILD_URL}artifact/build/${BUILD_TAR_NAME}
