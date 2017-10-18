#!/bin/bash

verify_cmd ()
{
  cmd=$@
  echo "run [$cmd]"
  timeout $DEFAULT_TIMEOUT $@
  result=$?
  if [[ $result != 0 ]]; then
	echo "ERROR. Result [$result]"
    send_mail $result
    exit $result
  else
	echo "SUCCESS. Result [$result]"
  fi
}




verify_file ()
{
  file=$@
  if [ ! -e "${file}" ] ; then
    echo "ERROR. file $file NOT found"
    send_mail $ERROR_FLASH
    exit $ERROR_FLASH
  else
    echo "SUCCESS. file $file found"
  fi
}



verify_string ()
{
	string=$@
	if [ -z $string ]; then
	echo "ERROR. Verify string failed"
	send_mail $ERROR_FLASH
    exit $ERROR_FLASH
	fi
}
