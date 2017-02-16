#!/bin/bash

cd /home/jenkins/workspace/workspace/renesas-qa
python3 -m http.server

#crontab -e
#@reboot /home/jenkins/workspace/workspace/renesas-qa/scripts/run-httpserver.sh
