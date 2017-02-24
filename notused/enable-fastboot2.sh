#!/bin/bash -x
#help func
#ps aux | grep minicom
#pgrep minicom
#killall -9 minicom

export MINICOM_SERIAL=/dev/ttyUSB0
export FASTBOOT_SERIAL=h3
export FASTBOOT=fastboot
verify_cmd ()
{
  $@
	result=$?
  cmd=$@
  #./enable-fastboot2.sh

	if [ $result != 0 ]; then
		echo "ERROR. Last command [$cmd] finished with result [$result]"
		exit $result
	else
		echo "SUCCESS. Last command [$cmd] finished with result [$result]"
	fi
}
hard_reset ()
{
  echo "Trying to enable fastboot on [$FASTBOOT_SERIAL]"
  sleep 1
  #sudo killall -9 minicom
  sleep 5
  sudo phidget-lite-x86_64 -r1 -s0
  sleep 1
  sudo phidget-lite-x86_64 -r1 -s1
  sleep 2
  echo " " >>/dev/ttyUSB0
  sleep 2
  echo fastboot >>/dev/ttyUSB0
  sleep 10

}

FASTBOOT_DEVICES="$($FASTBOOT devices)"
if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
  echo fastboot device [$FASTBOOT_SERIAL] NOT found
  hard_reset
fi

FASTBOOT_DEVICES="$($FASTBOOT devices)"
if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
  echo First try failed. Try one more time
  hard_reset
fi

#If still don't see device then fail
FASTBOOT_DEVICES="$($FASTBOOT devices)"
if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
  echo "ERROR. fastboot device [$FASTBOOT_SERIAL] NOT found"
  exit -100
fi
#Success

echo fastboot device [$FASTBOOT_SERIAL] found
