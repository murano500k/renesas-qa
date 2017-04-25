#!/bin/bash
BRANCH_NEW=r-car-7
BRANCH_OLD=android-7.0.0_r1
PTH=/home/jenkins/k49
WORKD=/home/jenkins/renesas_diff_output
OUT="$WORKD/_changes_${BRANCH_NEW}_not_${BRANCH_OLD}.csv"
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

	#mkdir -p $BUNDLE_DIR
	if [ $(git branch -r | grep $BRANCH_OLD | wc -l) -eq 0 ];then
		echo "####get-bundle#### $BRANCH_OLD DOES NOT exist for $prj"
		echo "####get-bundle#### will create bundle with all commits from $BRANCH_NEW"
		echo "####get-bundle#### BUNDLE_FILEPATH: $BUNDLE_FILEPATH"
		echo "####get-bundle#### BUNDLE_DIR: $BUNDLE_DIR"

		RES_CREATE_NEW="$?"
		echo "####get-bundle#### git bundle create result (0 is OK): $RES_CREATE_NEW"
		if [[ $RES_CREATE_NEW != 0 ]];then
			exit;
		fi
		echo "$prj" >> $WORKD/new_projects.txt

	elif [ `git merge-base $BRANCH_NEW $BRANCH_OLD  | wc -l` -gt 0 ]; then
		if [ $(git log --oneline $BRANCH_NEW ^$BRANCH_OLD | wc -l) -eq 0 ];then
       		echo "####get-bundle#### no difference"
       	else
       		echo "####get-bundle#### $BRANCH_OLD and $BRANCH_NEW have same parent for $prj"
       		echo "####get-bundle#### $BRANCH_OLD and $BRANCH_NEW have different commits for $prj"
			echo "####get-bundle#### will create bundle with different commits"
			echo "####get-bundle#### BUNDLE_FILEPATH: $BUNDLE_FILEPATH"
			echo "####get-bundle#### BUNDLE_DIR: $BUNDLE_DIR"
			echo  >>$OUT
			echo ${prj} >>$OUT
			git log --oneline --decorate $BRANCH_NEW ^$BRANCH_OLD >>$OUT
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
cd $WORKD
echo http-server
python3 -m http-server 8001

#git diff --oneline --pretty $BRANCH_OLD..$BRANCH_NEW
#git log --oneline --decorate r-car-7  ^android-7.0.0_r1