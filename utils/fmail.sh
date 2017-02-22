#!/bin/bash -x


if_error_mail_exit ()
{
  . $@
	result=$?
  cmd=$@

	if [ $result != 0 ]; then
		echo "ERROR. Last command [$cmd] finished with result [$result]"
    send_mail $result
    return $result
	else
		echo "SUCCESS. Last command [$cmd] finished with result [$result]"
	fi
}





mail_exit ()
{
  . $@
	result=$?
  cmd=$@

	if [ $result != 0 ]; then
		echo "ERROR. Last command [$cmd] finished with result [$result]"
	else
		echo "SUCCESS. Last command [$cmd] finished with result [$result]"
	fi
  send_mail $result
  return $result
}





send_mail ()
{
  RESULT=$@
  if [ ${jj_send_notification} = 'true' ]; then
    cd ${WORKSPACE}
    cat <<EOF > msmtp.ti
account ti
tls off
auth off
host ${jj_smtp}

## Set a default account
account default : ti
EOF

    chmod 0600 msmtp.ti

    echo "From: ${jj_from}
To: ${jj_to}
Cc: ${jj_cc}
Subject: [${jj_proj}] ${jj_name} - ${HW_PLATFORM} ${BUILD_VARIANT} build #${BUILD_NUMBER}

Dear All,

Autotest build #${BUILD_NUMBER} finished with result $RESULT.

Logs and output can be found at:

$HTTP_SERVER/logs/$ADB_SERIAL/$LDIRNAME

" | tee ${WORKSPACE}/notification_message

    rm -fv ${WORKSPACE}/msmtp.cfg
    /usr/bin/curl http://build.globallogic.com.ua/upload/ci_scripts/generic/msmtp.cfg > ${WORKSPACE}/msmtp.cfg
    # Without this step msmtp report error
    chmod 400 ${WORKSPACE}/msmtp.cfg

    cat ${WORKSPACE}/notification_message | msmtp -C ${WORKSPACE}/msmtp.cfg -t
  fi
}
