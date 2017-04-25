#!/bin/bash
export SCRIPTS_DIR=/home/jenkins/workspace/workspace/renesas-qa/scripts
export JENKINS_USER="artem.radchenko@globallogic.com"
export JENKINS_TOKEN="50b54d8fcb18c3c365445d4b46c0cebc"
export BUILD_DIR=/tmp/build
export WORKSPACE=/home/jenkins/workspace/workspace/renesas-qa
export PATH=$SCRIPTS_DIR:$PATH
export HOME=/home/jenkins
export ANDROID_HOME=$HOME/bin
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=/usr/bin:$PATH
export ADB_CMD="adb"
export FASTBOOT_PATH="$SCRIPTS_DIR/fastboot"
export HTTP_SERVER="http://172.22.89.21:8000"
export jj_send_notification=true
export jj_proj="Renesas"
export jj_name="renesas-qa"
export jj_from='"Jenkings CI" <jenkins-no-replay@globallogic.com>'
export jj_cc="artem.radchenko@globallogic.com"

#export jj_from="${BUILD_USER_EMAIL:-andriy.chepurnyy@globallogic.com}"
#export jj_to="renesas-android-general@globallogic.com"

if [ -z "$DEV" ]; then
	export DEV=false
fi

if [ $DEV == true ]; then
  export LOG_DIR=/home/jenkins/workspace/workspace/renesas-qa/devlogs
  export jj_to="artem.radchenko@globallogic.com"
  export jj_proj="DEV-integration"
  export jj_name="DEV-integration"
  export FLASH_FORMAT_COUNT=1
  export REBOOT_COUNT=2
  export DEFAULT_TIMEOUT=600
else
  export LOG_DIR=/home/jenkins/workspace/workspace/renesas-qa/logs
  export jj_to="andriy.chepurnyy@globallogic.com"
  export jj_cc="artem.radchenko@globallogic.com, oleksander.masechko@globallogic.com"
  export jj_proj="Renesas"
  export jj_name="renesas-qa"
  export FLASH_FORMAT_COUNT=10
  export REBOOT_COUNT=100
  export DEFAULT_TIMEOUT=600

fi



export ADBFASTBOOT_H3=h3-A15F
export ADBFASTBOOT_M3=m3-A305
export MINICOM_H3=0
export MINICOM_M3=1
export PHIDGET_SERIAL_H3=1
export PHIDGET_SERIAL_M3=3

export ERROR_COUNT=0

#Error codes
# if code < 0 - error during flash build
# if code > 0 - error during test run
export ERROR_PREPARE=-1
export ERROR_DEVICE_NOT_FOUND=-2
export ERROR_DOWNLOAD_BUILD=-3
export ERROR_FLASH=-4
export ERROR_NOT_BOOTABLE=-5

export ERROR_ADB=1
export ERROR_FASTBOOT=2
export ERROR_TIMEOUT=3

. $SCRIPTS_DIR/utils/fis-bootable.sh
. $SCRIPTS_DIR/utils/fis-fastboot.sh
. $SCRIPTS_DIR/utils/fkill-minicom.sh
. $SCRIPTS_DIR/utils/fmail.sh
. $SCRIPTS_DIR/utils/fprepare-fastboot-test.sh
. $SCRIPTS_DIR/utils/freset-adb.sh
. $SCRIPTS_DIR/utils/freset-fastboot.sh
. $SCRIPTS_DIR/utils/fcapture-log.sh
. $SCRIPTS_DIR/utils/fverify-cmd.sh

