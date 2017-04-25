#!/bin/bash
reset_fastboot ()
{
  DATE=`date +"%Y_%m_%d-%H_%M_%S"`
  echo ""
  echo "************ Start reset_fastboot ********$DATE*******"
  RESET_ITER=0
  while [[ $RESET_ITER < 3 ]];
  do
    echo "Reset fastboot, iteration $RESET_ITER"
    RESET_ITER=$((RESET_ITER+1))
    echo "$($FASTBOOT_PATH devices)"
    FASTBOOT_DEVICES="$($FASTBOOT_PATH devices)"
    echo "$FASTBOOT_DEVICES"
    if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
      echo "fastboot device [$FASTBOOT_SERIAL] NOT found"
      if [[ $RESET_ITER > 3 ]]; then
        echo "Now return with error."
        send_mail $ERROR_FASTBOOT
        exit $ERROR_FASTBOOT
      else
        sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s0
        sleep 1
        sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s1
        sleep 1
        echo "" >>$MINICOM_SERIAL
        sleep 1
        echo "fastboot" >>$MINICOM_SERIAL
        sleep 1
        echo "" >>$MINICOM_SERIAL
        sleep 1
        echo "fastboot sent. wait 10 sec"
        sleep 10
        echo "device should be in fastboot mode"
        echo "$($FASTBOOT_PATH devices)"
      fi
    else
      echo "fastboot device [$FASTBOOT_SERIAL] found"
      break;
    fi
  done
}
