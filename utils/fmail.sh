#!/bin/bash -x
export SCRIPTS_DIR=/home/jenkins/workspace/workspace/renesas-qa/scripts
export WORKSPACE=/home/jenkins/workspace/workspace/renesas-qa
export HTTP_SERVER="172.22.89.21:8000"

export jj_send_notification=true
#export jj_smtp=smtp-ua.synapse.com
export jj_proj="Renesas"
export jj_name="renesas-qa"
#export jj_from="${BUILD_USER_EMAIL:-andriy.chepurnyy@globallogic.com}"
export jj_from='"Jenkings CI" <jenkins-no-replay@globallogic.com>'
#export jj_to="renesas-android-general@globallogic.com"
export jj_to="andriy.chepurnyy@globallogic.com"
export jj_cc="artem.radchenko@globallogic.com"

if_error_mail_exit ()
{
  . $@
	result=$?
  cmd=$@

	if [ $result != 0 ]; then
		echo "ERROR. Last command [$cmd] finished with result [$result]"
    send_mail $result
    exit $result
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
  exit $result
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

  Autotest completed with result $RESULT
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
