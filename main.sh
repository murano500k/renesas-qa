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
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "************ START *********$DATE******" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE

echo "************ Script output can be found here:"
if [ $DEV == true ]; then
    log_dir_name="devlogs"
else
    log_dir_name="logs"
fi


echo "************ $HTTP_SERVER/$log_dir_name/$ADB_SERIAL/$LDIRNAME"

echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE

capture_log

echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE

if [ $DEV == true ]; then
  echo ""
  echo "************WARNING! This is dev version of autotest *******"
  echo ""
#  if_error_mail_exit $SCRIPTS_DIR/install-build.sh >>$OUTPUT_FILE
  mail_exit $SCRIPTS_DIR/run-autotest.sh >>$OUTPUT_FILE
else
  if_error_mail_exit $SCRIPTS_DIR/install-build.sh >>$OUTPUT_FILE
  mail_exit $SCRIPTS_DIR/run-autotest.sh >>$OUTPUT_FILE
fi



echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
echo "" >>$OUTPUT_FILE
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo "" >>$OUTPUT_FILE
echo "************ FINISH *********$DATE******" >>$OUTPUT_FILE

