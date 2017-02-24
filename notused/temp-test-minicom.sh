#!/bin/bash -ex
export MINICOM_SERIAL=/dev/ttyUSB0
relay0
sleep 1
relay1
sleep 1
echo "" >>$MINICOM_SERIAL
sleep 1
echo fastboot >>$MINICOM_SERIAL
sleep 1
echo "" >>$MINICOM_SERIAL
sleep 1
echo "fastboot sent. wait 10 sec"
sleep 10
echo "device should be in fastboot mode"
echo "$($FASTBOOT devices)"
