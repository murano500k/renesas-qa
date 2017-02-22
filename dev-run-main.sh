#!/bin/bash -x

. $SCRIPTS_DIR/mock_environments
. $SCRIPTS_DIR/prepare.sh

. $SCRIPTS_DIR/utils/fmail.sh
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ START *********$DATE******"
if_error_mail_exit $SCRIPTS_DIR/dev-run-autotest.sh
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ FINISH *********$DATE******"
