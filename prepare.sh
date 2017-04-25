#!/bin/bash

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start prepare.sh ********$DATE*******"

#prepare run
echo ""
echo ""
echo ""
echo "**************************************************************"
. $SCRIPTS_DIR/check-build-params.sh
. $SCRIPTS_DIR/workspace.sh
. $SCRIPTS_DIR/setup.sh
echo "**************************************************************"
echo ""
echo ""
echo ""



#Print values
echo ""
echo ""
echo ""
echo "**************************************************************"
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
echo "**************************************************************"
echo ""
echo ""
echo ""

#return
echo "************ Finish prepare.sh ********$DATE*******"
