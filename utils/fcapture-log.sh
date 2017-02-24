#!/bin/bash
capture_log ()
{
  echo "Starting log capture."
  mkdir -p $PATH_TO_CAPTURE_LOGS
  echo PATH_TO_CAPTURE_LOGS=$PATH_TO_CAPTURE_LOGS
  sudo screen -S sminicom$ADB_SERIAL -X quit
  sudo screen -S slogcat$ADB_SERIAL -X quit
  sudo rm -f /tmp/LCK..ttyUSB$MINICOM_PORT_NUMBER
  sleep 5
  /usr/bin/screen -dmS slogcat$ADB_SERIAL $SCRIPTS_DIR/utils/savelogs-logcat.sh $PATH_TO_CAPTURE_LOGS $ADB_SERIAL
  sleep 1
  /usr/bin/screen -dmS sminicom$ADB_SERIAL $SCRIPTS_DIR/utils/savelogs-minicom.sh $PATH_TO_CAPTURE_LOGS $ADB_SERIAL $MINICOM_SERIAL
  sleep 1
}
