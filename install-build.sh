#!/bin/bash -x
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo ""
echo ""
echo ""
echo "**************************************************************"
echo "************ Start install-build.sh ********$DATE*******"
if [ -z "$FASTBOOT_PATH" ]; then
	echo "FASTBOOT_PATH path not provided"
  return $ERROR_PREPARE
fi

if [ -z "$FASTBOOT_SERIAL" ]; then
	echo "FASTBOOT_SERIAL not provided"
  return $ERROR_PREPARE
fi

if [ -z $BUILD_DIR -o -z $SCRIPTS_DIR ]; then
	echo "BUILD_DIR or SCRIPTS_DIR not provided"
  return $ERROR_PREPARE
fi



reset_fastboot

. $SCRIPTS_DIR/download-build.sh
cp $SCRIPTS_DIR/myfastboot.sh $BUILD_DIR/fastboot.sh

cd $BUILD_DIR

echo "Installing build from $BUILD_DIR"
. ./fastboot.sh
is_bootable
echo "fastboot.sh finished successfully"
echo "**************************************************************"
echo ""
echo ""
echo ""
echo ""
