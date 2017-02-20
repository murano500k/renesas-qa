#!/bin/bash
verify_cmd ()
{
  . $@
	result=$?
  cmd=$@

	if [ $result != 0 ]; then
		echo "ERROR. Last command [$cmd] finished with result [$result]"
	else
		echo "SUCCESS. Last command [$cmd] finished with result [$result]"
	fi
  . $SCRIPTS_DIR/jmail.sh $result
}
. $SCRIPTS_DIR/mock_environments


echo BUILD_URL=$BUILD_URL
echo BUILD_NUMBER=$BUILD_NUMBER
echo HW_PLATFORM=$HW_PLATFORM
echo BUILD_VARIANT=$BUILD_VARIANT
echo TRIGGER_LAB_AUTOMATION=$TRIGGER_LAB_AUTOMATION

. $SCRIPTS_DIR/prepare.sh


echo ""
echo "************ Start run-pkill.sh ***************"
verify_cmd $SCRIPTS_DIR/qwenable-fastboot.sh
