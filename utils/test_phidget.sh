#!/bin/bash
sudo phidget-lite-x86_64 -r0 -s0
sudo phidget-lite-x86_64 -r1 -s0
sudo phidget-lite-x86_64 -r2 -s0
sudo phidget-lite-x86_64 -r3 -s0
sleep 1
sudo phidget-lite-x86_64 -r0 -s1
sudo phidget-lite-x86_64 -r1 -s1
sudo phidget-lite-x86_64 -r2 -s1
sudo phidget-lite-x86_64 -r3 -s1
sleep 1
echo `ls /dev/ | grep ttyUSB`
