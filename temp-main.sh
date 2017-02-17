#!/bin/bash

. $SCRIPTS_DIR/mock_environments


echo BUILD_URL=$BUILD_URL
echo BUILD_NUMBER=$BUILD_NUMBER
echo HW_PLATFORM=$HW_PLATFORM
echo BUILD_VARIANT=$BUILD_VARIANT
echo TRIGGER_LAB_AUTOMATION=$TRIGGER_LAB_AUTOMATION

. $SCRIPTS_DIR/prepare.sh


echo ""
echo "************ Start run-pkill.sh ***************"
. $SCRIPTS_DIR/run-pkill.sh
echo ""
echo "************ Start run-autotest.sh ***************"
. $SCRIPTS_DIR/temp-run-autotest.sh
echo ""
echo "************ FINISH ***************"
