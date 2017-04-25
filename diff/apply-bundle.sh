#!/bin/bash
if [ -z "$1" ];then
		echo "Lack of parameters. Use: $0 [LOCAL_REPO_ROOT_DIR]"
		echo "run from dir REMOTE_changes_BRANCH1_not_BRANCH2"
		exit
fi
PTH="$1"
WORKD=$(pwd)

#% before, # after

TEMP_STR="${WORKD%_not_*}"
BRANCH_NEW="${TEMP_STR#*_changes_}"
BRANCH_OLD="${WORKD#*_not_}"
echo "####apply-bundle#### PTH: $PTH"
echo "####apply-bundle#### WORKD: $WORKD"
echo "####apply-bundle#### BRANCH_OLD: $BRANCH_OLD"
echo "####apply-bundle#### BRANCH_NEW: $BRANCH_NEW"

cd $PTH
while read prj; do
if [ -n "$prj" ]; then
	cd $prj
	RES="$?"
	if [[ $RES != 0 ]];then 
		echo "AAAA!!111 "
		exit
	fi
	echo "####apply-bundle####"
	echo "####apply-bundle#### prj: $prj"
	BUNDLE_FILEPATH="$WORKD/bundles/$prj.bundle"
	BUNDLE_DIR=${BUNDLE_FILEPATH%/*}
	git remote add bundle $BUNDLE_FILEPATH 2>/dev/null
	git fetch bundle 2>/dev/null
	git pull bundle $BRANCH_NEW 
	RES="$?"
	echo "####apply-bundle#### git pull bundle result (0 is OK): $RES"
	if [[ $RES != 0 ]];then 
		echo "####apply-bundle#### Something wrong! exiting..."
		exit
	fi
fi
cd $PTH
done <$WORKD/updated_projects.txt
echo "####apply-bundle#### Update Success!"
cd $PTH 
while read prj; do
if [ -n "$prj" ]; then
	mkdir -p $prj
	cd $prj
	echo "####apply-bundle new####"
	echo "####apply-bundle new#### prj: $prj"
	BUNDLE_FILEPATH="$WORKD/bundles/$prj.bundle"
	BUNDLE_DIR=${BUNDLE_FILEPATH%/*}
	git init
	git remote add bundle $BUNDLE_FILEPATH 2>/dev/null
	git fetch bundle $BRANCH_NEW:$BRANCH_NEW
	RES="$?"
	echo "####apply-bundle new#### git pull bundle result (0 is OK): $RES"
	if [[ $RES != 0 ]];then 
		echo "####apply-bundle new#### Something wrong! exiting..."
		exit
	fi
fi
cd $PTH
done <$WORKD/new_projects.txt
exit