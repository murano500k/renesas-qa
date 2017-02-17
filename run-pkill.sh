#!/bin/bash
sudo rm -rf /var/lock/LCK..ttyUSB*

sudo pkill minicom
sudo pkill expect
sudo pkill adb
sudo pkill fastboot
sudo pkill screen
sudo pkill spawn
