#!/bin/bash
#help func
verify_cmd ()
{
  $@
	result=$?
  cmd=$@

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
  sleep 5
  . $SCRIPTS_DIR/run-pkill.sh
  sleep 10
  sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s0
  sleep 1
  sudo phidget-lite-x86_64 -r$PHIDGET_SERIAL -s1
  sleep 1
  expect-fastboot.sh $MINICOM_SERIAL
}
#Check fastboot location
echo FASTBOOT=$FASTBOOT

if [ -z $FASTBOOT_SERIAL ]; then
	echo "FASTBOOT_SERIAL not set"
  exit -1
fi
if [ -z $MINICOM_SERIAL ]; then
	echo "MINICOM_SERIAL not set"
  exit -1
fi
if [ -z $PHIDGET_SERIAL ]; then
	echo "PHIDGET_SERIAL not set"
  exit -1
fi

MINICOM_PATH=$(which minicom)
echo MINICOM_PATH=$MINICOM_PATH

if [ -z $MINICOM_PATH ]; then
	echo "MINICOM_PATH not set"
  exit -1
fi

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
