#!/bin/bash

. $SCRIPTS_DIR/mock_environments


echo BUILD_URL=$BUILD_URL
echo BUILD_NUMBER=$BUILD_NUMBER
echo HW_PLATFORM=$HW_PLATFORM
echo BUILD_VARIANT=$BUILD_VARIANT
echo TRIGGER_LAB_AUTOMATION=$TRIGGER_LAB_AUTOMATION

if [ $TRIGGER_LAB_AUTOMATION == false ]; then
  echo "TRIGGER_LAB_AUTOMATION not triggered"
  exit
fi

echo ""
echo "************ Start check-vars.sh ***************"
. $SCRIPTS_DIR/check-vars.sh
echo "" >> $OUTPUT_FILE
echo "************ Start main.sh ***************" >> $OUTPUT_FILE
. $SCRIPTS_DIR/main.sh >> $OUTPUT_FILE

cat $OUTPUT_FILE
