#!/bin/bash -ex
screen -S sminicom -X quit
screen -S slogcat -X quit
sudo rm -rf /var/lock/LCK..ttyUSB*
sudo pkill minicom
sudo pkill expect
sudo pkill adb
sudo pkill fastboot
sudo pkill screen
sudo pkill spawn
sleep 5
