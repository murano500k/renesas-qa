#!/bin/bash

#Check if required vars are set
echo "****"
echo  "Build params: "
echo BUILD_URL=$BUILD_URL
echo BUILD_NUMBER=$BUILD_NUMBER
echo HW_PLATFORM=$HW_PLATFORM
echo BUILD_VARIANT=$BUILD_VARIANT
echo TRIGGER_LAB_AUTOMATION=$TRIGGER_LAB_AUTOMATION
echo "****"
if [ -z $BUILD_URL ]; then
  echo BUILD_URL not set. Exiting...
  return 1
fi

if [ -z $BUILD_NUMBER ]; then
  echo BUILD_NUMBER not set. Exiting...
  return 1
fi
if [ -z $HW_PLATFORM ]; then
  echo HW_PLATFORM not set. Exiting...
  return 1
fi
if [ -z $BUILD_VARIANT ]; then
  echo BUILD_VARIANT not set. Exiting...
  return 1
fi
#Check if trigger is true
if [ $TRIGGER_LAB_AUTOMATION != true ]; then
  echo "Autotest not triggered."
  return 0
fi
