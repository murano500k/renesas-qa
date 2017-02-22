#!/bin/bash
capture_log ()
{
  echo "Starting log capture."
  mkdir -p $PATH_TO_CAPTURE_LOGS
  echo PATH_TO_CAPTURE_LOGS=$PATH_TO_CAPTURE_LOGS
  sudo screen -S sminicom -X quit
  sudo screen -S slogcat -X quit
  sudo rm -f /tmp/LCK..ttyUSB$MINICOM_PORT_NUMBER
  sudo killall -9 minicom
  sleep 5
  /usr/bin/screen -dmS slogcat $SCRIPTS_DIR/savelogs-logcat.sh $PATH_TO_CAPTURE_LOGS $ADB_SERIAL
  /bin/sleep 1
  /usr/bin/screen -dmS sminicom $SCRIPTS_DIR/savelogs-minicom.sh $PATH_TO_CAPTURE_LOGS $ADB_SERIAL $MINICOM_SERIAL
  /bin/sleep 1
}
