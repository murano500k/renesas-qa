#/bin/bash

BUILD_URL=http://build.globallogic.com.ua/job/Renesas-GEN3-NCar/538/
TEMP="${BUILD_URL#*job\/}"
TEMP="${TEMP%\/*}"
JOB_NAME="${TEMP%\/*}"

echo JOB_NAME=$JOB_NAME