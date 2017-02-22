#!/bin/bash
#minicom $minicom_profile -S $minicom_file
echo ""
echo "kill all running sessions"
echo "screen -S sminicom"
sudo screen -S sminicom -X quit
sleep 1
echo "screen -S slogcat"

sudo screen -S slogcat -X quit
sleep 1
echo 'sudo pkill "minicom -D $MINICOM_SERIAL --capturefile'
sudo pkill 'minicom -D $MINICOM_SERIAL --capturefile=$PATH_TO_CAPTURE_LOGS/minicom-$ADB_SERIAL.txt'
sleep 1
echo 'sudo pkill "minicom -D $MINICOM_SERIAL'
sudo pkill 'minicom -D $MINICOM_SERIAL'
sleep 1
echo "sudo killall"
sudo killall -9 minicom
sleep 1
echo "sudo pkill"
sudo pkill minicom
sleep 1
echo "sudo rm -f /tmp/LCK"
sudo rm -f /tmp/LCK..ttyUSB$MINICOM_PORT_NUMBER
sleep 1
echo end
