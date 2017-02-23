#!/bin/bash -ex

. $SCRIPTS_DIR/prepare/export-mock-environments
. $SCRIPTS_DIR/prepare.sh
reset_adb
reset_fastboot
. $SCRIPTS_DIR/main.sh
