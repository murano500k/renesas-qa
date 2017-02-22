#!/bin/bash -x

. $SCRIPTS_DIR/utils/fmail.sh
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ START *********$DATE******"
if_error_mail_exit $SCRIPTS_DIR/install-build.sh
mail_exit $SCRIPTS_DIR/run-autotest.sh

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ FINISH *********$DATE******"
