#!/bin/bash

verify_cmd ()
{
  $@
	result=$?
  cmd=$@

	if [ $result != 0 ]; then
		echo "ERROR. Last command [$cmd] finished with result [$result]"
		return $result
	else
		echo "SUCCESS. Last command [$cmd] finished with result [$result]"
	fi
}

verify_file ()
{
  file=$@
	if [ ! -f "$file" ]; then
		echo "ERROR. File [$file] not found"
		return 13
	else
		echo "SUCCESS. File [$file] found"
	fi
}
verify_string ()
{
	string=$@
	if [ -z $string ]; then
		echo "ERROR. Verify string failed"
		return 14
	fi
}
