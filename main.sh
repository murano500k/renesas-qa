#!/bin/bash

echo ""
echo "************ Start run-pkill.sh ***************"
. $SCRIPTS_DIR/run-pkill.sh
echo ""
echo "************ Start download-build.sh ***************"
. $SCRIPTS_DIR/download-build.sh
echo ""
echo "************ Start enable-fastboot.sh ***************"
. $SCRIPTS_DIR/enable-fastboot.sh
echo ""
echo "************ Start install-build.sh ***************"
. $SCRIPTS_DIR/install-build.sh
echo ""
echo "************ Start verify-isbootable.sh ***************"
. $SCRIPTS_DIR/verify-isbootable.sh
echo ""
echo "************ Start run-autotest.sh ***************"
. $SCRIPTS_DIR/run-autotest.sh
echo ""
echo "************ FINISH ***************"
