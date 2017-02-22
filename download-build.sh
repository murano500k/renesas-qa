#!/bin/bash
DATE=`date +"%Y_%m_%d-%H_%M_%S"`
echo ""
echo "************ Start download-build.sh ********$DATE*******"
#check args
if [ -z $BUILD_URL ]; then
	echo "BUILD_URL not set"
  return -1
fi
if [ -z $BUILD_DIR ]; then
	echo "BUILD_DIR not set"
  return -1
fi
if [ -z $JENKINS_USER -o -z $JENKINS_TOKEN ]; then
	echo "Variable JENKINS_USER or JENKINS_TOKEN not set"
  return 1
fi

#Print values

echo BUILD_URL=$BUILD_URL
echo BUILD_DIR=$BUILD_DIR
echo NCAR_BUILD_NAME=$NCAR_BUILD_NAME

#delete temp files
rm -rf $BUILD_DIR
#create dir to download
mkdir -p $BUILD_DIR
echo "downloading build"
wget -q --http-user $JENKINS_USER  --http-password $JENKINS_TOKEN --auth-no-challenge $BUILD_URL -O $BUILD_DIR/$NCAR_BUILD_NAME
#untar it
echo download finished
echo unpacking archive
tar xf $BUILD_DIR/$NCAR_BUILD_NAME -C $BUILD_DIR
echo "unpack build archive success"
