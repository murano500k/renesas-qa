#!/bin/bash
BRANCH_NEW=android-7.1.1_r22
BRANCH_OLD=r-car-7
PTH=/home/jenkins/aosp
WORKD="${PTH}/_changes_${BRANCH_NEW}_not_${BRANCH_OLD}"
[ -d $WORKD ] && rm -rf $WORKD
mkdir -p $WORKD
echo "####get-bundle#### PTH: $PTH"
echo "####get-bundle#### WORKD: $WORKD"
echo "####get-bundle#### BRANCH_OLD: $BRANCH_OLD"
echo "####get-bundle#### BRANCH_NEW: $BRANCH_NEW"
cd $PTH
for prj_path in `repo forall -j8 -c "pwd"`;do  
cd $prj_path
prj=$(pwd | sed -e "s@$PTH/@@")
echo "####get-bundle####"
echo "####get-bundle#### prj: $prj"
if [ $(git branch -r | grep $BRANCH_NEW | wc -l) -ne 0 ];then
	echo "####get-bundle#### $BRANCH_NEW exists for $prj"
	BUNDLE_FILEPATH="$WORKD/bundles/$prj.txt"
	BUNDLE_DIR=${BUNDLE_FILEPATH%/*}
	
	mkdir -p $BUNDLE_DIR
	if [ $(git branch -r | grep $BRANCH_OLD | wc -l) -eq 0 ];then
		echo "####get-bundle#### $BRANCH_OLD DOES NOT exist for $prj"
		echo "####get-bundle#### will create bundle with all commits from $BRANCH_NEW"
		echo "####get-bundle#### BUNDLE_FILEPATH: $BUNDLE_FILEPATH"
		echo "####get-bundle#### BUNDLE_DIR: $BUNDLE_DIR"

		git bundle create $BUNDLE_FILEPATH $BRANCH_NEW
		RES_CREATE_NEW="$?"
		echo "####get-bundle#### git bundle create result (0 is OK): $RES_CREATE_NEW"
		if [[ $RES_CREATE_NEW != 0 ]];then 
			exit;
		fi
		echo "$prj" >> $WORKD/new_projects.txt

	elif [ `git merge-base $BRANCH_NEW $BRANCH_OLD  | wc -l` -gt 0 ]; then
		if [ $(git log --oneline --no-merges $BRANCH_NEW ^$BRANCH_OLD | wc -l) -eq 0 ];then
       		echo "####get-bundle#### no difference"
       	else 

       		echo "####get-bundle#### $BRANCH_OLD and $BRANCH_NEW have same parent for $prj"
       		echo "####get-bundle#### $BRANCH_OLD and $BRANCH_NEW have different commits for $prj"
			echo "####get-bundle#### will create bundle with different commits"
			echo "####get-bundle#### BUNDLE_FILEPATH: $BUNDLE_FILEPATH"
			echo "####get-bundle#### BUNDLE_DIR: $BUNDLE_DIR"
			git log --oneline $BRANCH_OLD..$BRANCH_NEW >$BUNDLE_FILEPATH
			#git bundle create $BUNDLE_FILEPATH $BRANCH_OLD..$BRANCH_NEW
			RES_CREATE_DIFF="$?"
			echo "####get-bundle#### git bundle create result (0 is OK): $RES_CREATE_DIFF"
			if [[ $RES_CREATE_DIFF != 0 ]];then 
		    exit;
			fi
			echo "$prj" >> $WORKD/updated_projects.txt

		fi
	fi

else
	echo "####get-bundle#### $BRANCH_NEW DOES NOT exist for $prj";
fi 
cd $PTH
done;
#git diff --oneline --pretty $BRANCH_OLD..$BRANCH_NEW