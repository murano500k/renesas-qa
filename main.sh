#!/bin/bash -x
if [ -z $PATH_TO_CAPTURE_LOGS -o -z $OUTPUT_FILE ]; then
  echo "Something wrong with out path..."
  return $ERROR_PREPARE
fi
mkdir -p $PATH_TO_CAPTURE_LOGS
rm -fv $OUTPUT_FILE
touch $OUTPUT_FILE
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo "" >>$OUTPUT_FILE
echo "************ START *********$DATE******" >>$OUTPUT_FILE
echo "Script output can be found here:"
echo "$HTTP_SERVER/logs/$ADB_SERIAL/$LDIRNAME"

if_error_mail_exit $SCRIPTS_DIR/install-build.sh >>$OUTPUT_FILE

if [ $DEV == false ]; then
  mail_exit $SCRIPTS_DIR/run-autotest.sh >>$OUTPUT_FILE
fi

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo "" >>$OUTPUT_FILE
echo "************ FINISH *********$DATE******" >>$OUTPUT_FILE
