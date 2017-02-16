#!/bin/bash
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

export FASTBOOT_CMD="$FASTBOOT -s $FASTBOOT_SERIAL"

echo Installing build from $BUILD_DIR
echo FASTBOOT_CMD=$FASTBOOT_CMD

cp $SCRIPTS_DIR/myfastboot.sh $BUILD_DIR/fastboot.sh
#cp $SCRIPTS_DIR/fastboot $BUILD_DIR/fastboot


cd $BUILD_DIR
echo 			 Run fastboot.sh
./fastboot.sh
echo "fastboot.sh finished successfully"
