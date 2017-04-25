#!/bin/bash

DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start run-httpserver.sh ********$DATE*******"
cd /home/jenkins/workspace/workspace/renesas-qa/logs
python3 -m http.server

#crontab -e
#@reboot /home/jenkins/workspace/workspace/renesas-qa/scripts/run-httpserver.sh
