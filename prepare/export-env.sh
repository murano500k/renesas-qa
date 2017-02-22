#!/bin/bash
export SCRIPTS_DIR=/home/jenkins/workspace/workspace/renesas-qa/scripts
export JENKINS_USER="artem.radchenko@globallogic.com"
export JENKINS_TOKEN="50b54d8fcb18c3c365445d4b46c0cebc"
export BUILD_DIR=/tmp/build
export LOG_DIR=/home/jenkins/workspace/workspace/renesas-qa/logs
export WORKSPACE=/home/jenkins/workspace/workspace/renesas-qa
export HOME=/home/jenkins
export ANDROID_HOME=$HOME/bin
export PATH=$SCRIPTS_DIR:$PATH
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=/usr/bin:$PATH
export ADB_CMD="adb"
export FASTBOOT_PATH="$SCRIPTS_DIR/fastboot"
export HTTP_SERVER="http://172.22.89.21:8000"
export jj_send_notification=true
#export jj_smtp=smtp-ua.synapse.com
export jj_proj="Renesas"
export jj_name="renesas-qa"
#export jj_from="${BUILD_USER_EMAIL:-andriy.chepurnyy@globallogic.com}"
export jj_from='"Jenkings CI" <jenkins-no-replay@globallogic.com>'
#export jj_to="renesas-android-general@globallogic.com"
if [ $DEV == true ]; then
  export jj_to="artem.radchenko@globallogic.com"
  export jj_proj="TEST"
  export jj_name="test-renesas-qa"
else
  export jj_to="andriy.chepurnyy@globallogic.com"
  export jj_proj="Renesas"
  export jj_name="renesas-qa"
fi
export jj_cc="artem.radchenko@globallogic.com"
