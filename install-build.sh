#!/bin/bash -x
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start install-build.sh ********$DATE*******"
if [ -z "$FASTBOOT" ]; then
	echo "FASTBOOT path not provided"
  exit 1
fi

if [ -z $FASTBOOT_SERIAL ]; then
	echo "FASTBOOT_SERIAL not provided"
  exit 1
fi

if [ -z $BUILD_DIR -o -z $SCRIPTS_DIR ]; then
	echo "BUILD_DIR or SCRIPTS_DIR not provided"
  exit 1
fi




. $SCRIPTS_DIR/download-build.sh
. $SCRIPTS_DIR/enable-fastboot.sh

cp $SCRIPTS_DIR/myfastboot.sh $BUILD_DIR/fastboot.sh
#cp $SCRIPTS_DIR/fastboot $BUILD_DIR/fastboot
echo 			 Run fastboot.sh
cd $BUILD_DIR
echo Installing build from $BUILD_DIR
. ./fastboot.sh
result=$?
if [ $result != 0 ]; then
	echo "ERROR. fastboot.sh finished with result [$result]"
	exit $result
else
	echo "fastboot.sh finished successfully"
fi

. $SCRIPTS_DIR/verify-isbootable.sh
