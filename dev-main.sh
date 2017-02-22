#!/bin/bash -ex

. $SCRIPTS_DIR/prepare/mock_environments.sh
. $SCRIPTS_DIR/prepare.sh
reset_adb
reset_fastboot
. $SCRIPTS_DIR/main.sh
