#!/bin/bash -ex

# OpenJDK

JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64



## workspace - Folder that contains build-essentials scripts
export workspace=${WORKSPACE}
export common_dir="${HOME}/.jenkins"
export artifacts_dir=${workspace}/build
export config_dir=${workspace}/config
export afs_root=${workspace}/afs_root
export fw_root=${workspace}/fw
export gerrit_srv=gerrit-ua.globallogic.com
export gerrit_port=29418
export gerrit_cherry_pick_url=ssh://${gerrit_srv}:${gerrit_port}
export afs_tree_prefix=renesas
export ci_scripts_url=http://build.globallogic.com.ua/upload/ci_scripts/Renesas-M/
export ci_generic_scripts_url=http://build.globallogic.com.ua/upload/ci_scripts/generic

## number of threads to build AFS (48 is expected)
export NUM_JOBS=$(($(grep ^processor /proc/cpuinfo | wc -l)*2))

## build_id and build_number determines Build Info
export build_number=${BUILD_NUMBER}

# Fetch CI scripts
/usr/bin/curl ${ci_scripts_url}/functions > ${WORKSPACE}/functions
/usr/bin/curl ${ci_scripts_url}/msmtp.ti > ${WORKSPACE}/msmtp.ti

# Load helpers
source ${workspace}/functions

#Making artifact directory
[ -d ${config_dir} ] && rm -rf ${config_dir}
[ -d ${artifacts_dir} ] && rm -rf ${artifacts_dir}

mkdir -p ${artifacts_dir}
mkdir -p ${config_dir}
mkdir -p ${afs_root}

env | tee ${config_dir}/environments

## repo init
cd ${workspace}
/usr/bin/curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ./repo
chmod +x ./repo

# Go to Android source code root
cd ${afs_root}


if [ -d ".repo" ]; then
if [ "${LIGHT_GIT_CLEANUP}" = "true" ]; then
${workspace}/repo forall -c "git reset --hard HEAD"
else
${workspace}/repo forall -c "git clean -fdx; git reset --hard; git rebase --abort"
echo "Will not clean"
fi
fi

branch_name="${BRANCH_NAME}"

# Add manifest name if defined
if [ ! -z "${MANIFEST_NAME}" ]; then
branch_name="${BRANCH_NAME} -m ${MANIFEST_NAME}.xml"
fi

if [ ! -z "${ABORT_CP_ON_PROJECT}" ]; then
	if [ -d ${afs_root}"/"${ABORT_CP_ON_PROJECT} ]; then
    echo "Will abort cherry-pick on"${afs_root}"/"${ABORT_CP_ON_PROJECT}
    pushd ${afs_root}"/"${ABORT_CP_ON_PROJECT}
    git rebase --abort
    if [ -d ".git/rebase-gerrit" ]; then
    	rm -rf .git/rebase-gerrit
        git reset --hard HEAD
        git clean -fdx
    fi
    popd
    fi
fi

${workspace}/repo init -u ssh://${gerrit_srv}:${gerrit_port}/${afs_tree_prefix}/platform/manifest -b ${branch_name}
${workspace}/repo sync -j8 --force-sync
${workspace}/repo manifest -r -o ${config_dir}/dbmanifest.xml

if [ "${USE_CCACHE}" = "true" ]; then
export USE_CCACHE=1
export CCACHE_DIR=${workspace}/.ccache
${afs_root}/prebuilts/misc/linux-x86/ccache/ccache -M 50G
fi

if [ ! -z "${SPECIFIC_SALVATOR_KERNEL_COMMIT}" ]; then
    pushd ${afs_root}/device/renesas/kernel
    git checkout ${SPECIFIC_SALVATOR_KERNEL_COMMIT}
    echo "== Forced to checkout kernel to "${SPECIFIC_SALVATOR_KERNEL_COMMIT}" commit =="
    popd
fi

if [ ! -z "${SPECIFIC_SALVATOR_HWC_COMMIT}" ]; then
    pushd ${afs_root}/hardware/renesas/hwcomposer
    git checkout ${SPECIFIC_SALVATOR_HWC_COMMIT}
    echo "== Forced to checkout kernel to "${SPECIFIC_SALVATOR_HWC_COMMIT}" commit =="
    popd
fi

# Apply patches
if [ -n "${LINKS_TO_PATCHES}" ]; then
    echo "Applying patches..."
    applyPatchAfs ${LINKS_TO_PATCHES}
fi

# Load Android scripts and macroses
source build/envsetup.sh

if [ "${TARGET_USES_HIGHEST_DPI}" = "true" ]; then
echo "Will build 4k resolution support"
fi

if [ "${THREE_DISPLAY}" = "true" ]; then
echo "Will build with third display support"
fi

# Select device and build variant
lunch ${HW_PLATFORM}-${BUILD_VARIANT}

# Type of claening before general make
if [ "${MAKE_INSTALLCLEAN}" = "true" ]; then
make installclean
else
make clean
fi


########### Start Build ###########
m -j${NUM_JOBS}

if [ "${BUILD_OTA}" = "true" ]; then
#echo "== Force to build OTA =="
make -j${NUM_JOBS} otapackage
fi

if [ "${BUILD_BOOTLOADERS}" = "true" ]; then
echo "== Force to build Bootloaders =="

#make -j${NUM_JOBS} ipl optee tee-supp hyper_ca u-boot
#make -j${NUM_JOBS} optee
#make -j${NUM_JOBS} tee-supp
#make -j${NUM_JOBS} hyper_ca
	#if [ "${BUILD_TEE_LOADER}" = "true" ]; then
	#make -j${NUM_JOBS} tee_loader
    #fi

#make -j${NUM_JOBS} u-boot
#make recoveryimage
fi

if [ "${BUILD_UPDATEPACKAGE}" = "true" ]; then
make -j${NUM_JOBS} updatepackage
fi


########### End Build ###########

## Archive artifacts
cd ${ANDROID_PRODUCT_OUT}

[ -d ${ANDROID_PRODUCT_OUT}/db ] && rm -rf ${ANDROID_PRODUCT_OUT}/db
mkdir -p ${ANDROID_PRODUCT_OUT}/db

if [ "${BUILD_VARIANT}" = "user" ]; then
echo "Will copy adb keys..."
cp ${afs_root}/device/renesas/salvator/adb/adbkey* ${ANDROID_PRODUCT_OUT}/db/
fi


echo "Packing Binaries"
#[ -e ${afs_root}/out/host/linux-x86/bin/pack_ipl ] &&  cp ${afs_root}/out/host/linux-x86/bin/pack_ipl ${ANDROID_PRODUCT_OUT}/db/ && cp ${afs_root}/out/host/linux-x86/bin/pack_ipl . && ./pack_ipl all ./
[ -e ${afs_root}/out/host/linux-x86/bin/fastboot ] &&  cp ${afs_root}/out/host/linux-x86/bin/fastboot ${ANDROID_PRODUCT_OUT}/db/
[ 0 -lt $(ls *.zip 2>/dev/null | wc -w) ] && cp ./*.zip ${ANDROID_PRODUCT_OUT}/db/
[ 0 -lt $(ls *.srec 2>/dev/null | wc -w) ] && mv ./*.srec ${ANDROID_PRODUCT_OUT}/db/
[ 0 -lt $(ls *.bin 2>/dev/null | wc -w) ] && cp ./*.bin ${ANDROID_PRODUCT_OUT}/db/
#[ 0 -lt $(ls *.img 2>/dev/null | wc -w) ] && cp ./*.img ${ANDROID_PRODUCT_OUT}/db/
[ -e ./recovery.img ] && cp ./recovery.img ${ANDROID_PRODUCT_OUT}/db/
[ -e ./system.img ] && cp ./system.img ${ANDROID_PRODUCT_OUT}/db/
[ -e ./boot.img ] && cp ./boot.img ${ANDROID_PRODUCT_OUT}/db/
[ -e ./cache.img ] && cp ./cache.img ${ANDROID_PRODUCT_OUT}/db/
[ -e ./bootloader.img ] && cp ./bootloader.img ${ANDROID_PRODUCT_OUT}/db/
[ -e ./userdata.img ] && cp ./userdata.img ${ANDROID_PRODUCT_OUT}/db/
[ -e ./vendor.img ] && cp ./vendor.img ${ANDROID_PRODUCT_OUT}/db/
[ -e ${afs_root}/device/renesas/common/fastboot.sh ] &&  cp ${afs_root}/device/renesas/common/fastboot.sh ${ANDROID_PRODUCT_OUT}/db/


if [ "${COPY_FW}" = "true" ]; then
[ -e ${fw_root}/* ] && cp ${fw_root}/* ${ANDROID_PRODUCT_OUT}/db/
fi

# Gereating package name
package_name=${afs_tree_prefix}_${build_number}_$(date +%Y%m%d)_${HW_PLATFORM}_${BUILD_VARIANT}

cd ${ANDROID_PRODUCT_OUT}/db
[ 0 -lt $(ls *.bin 2>/dev/null | wc -w) ] && tar -czf ${artifacts_dir}/${package_name}-bootloaders-bin.tar.gz ./*.bin  && rm ./*.bin
[ 0 -lt $(ls *.srec 2>/dev/null | wc -w) ] && tar -czf ${artifacts_dir}/${package_name}-bootloaders-srec.tar.gz ./*.srec  && rm ./*.srec
tar -czf ${artifacts_dir}/${package_name}.tar.gz ./*


## START Generating Patch difference from previous build ##
export JOB_TO_CHECK=${JOB_NAME}
export jobs_common_dir=${WORKSPACE}/../..
## Local build dirs
export job_art_prev=${WORKSPACE}/job_art_prev
[ -d ${job_art_prev} ] && rm -rf ${job_art_prev}
mkdir -p ${job_art_prev}
## Manifest XML - lets use user build only
cp -vf ${JENKINS_HOME}/jobs/${JOB_TO_CHECK}/lastSuccessful/archive/config/dbmanifest.xml ${job_art_prev}/dbmanifest.xml || true
#export $(grep "^workspace=" ${job_art_prev}/environments | sed 's/^workspace=/orig_ws=/')

## AFS diff
if [ -s ${job_art_prev}/dbmanifest.xml ]; then
  cd ${WORKSPACE}
  OUT_DEVICE=stdout ${jobs_common_dir}/support-tools/scripts/difftool.sh ${job_art_prev}/dbmanifest.xml ${config_dir}/dbmanifest.xml ${afs_root}/ > ${config_dir}/differences.txt
  if [ -s ${artifacts}/differences.txt ]; then
    export goforit=true
    cat ${artifacts}/differences.txt
  fi
fi
## END Generating Patch difference from previous build ##

# Send notification
export jj_send_notification=true
#export jj_smtp=smtp-ua.synapse.com
export jj_proj="Renesas"
export jj_name=${JOB_NAME}
#export jj_from="${BUILD_USER_EMAIL:-andriy.chepurnyy@globallogic.com}"
export jj_from='"Jenkings CI" <jenkins-no-replay@globallogic.com>'
export jj_to="renesas-android-general@globallogic.com"
#export jj_to="andriy.chepurnyy@globallogic.com"
export jj_cc=""

if [ ${jj_send_notification} = 'true' ]; then
  cd ${workspace}

  cat <<EOF > msmtp.ti
account ti
tls off
auth off
host ${jj_smtp}

## Set a default account
account default : ti
EOF

  chmod 0600 msmtp.ti

  echo "From: ${jj_from}
To: ${jj_to}
Cc: ${jj_cc}
Subject: [${jj_proj}] ${jj_name} - ${HW_PLATFORM} ${BUILD_VARIANT} build #${build_number}

Dear All,

The build #${build_number} has been completed.
It was built for : ${HW_PLATFORM}_${BUILD_VARIANT}


All binaries, configuration data can be accessed from
${BUILD_URL}


" | tee ${workspace}/notification_message

  if [ -n "${LINKS_TO_PATCHES}" ]; then
    echo "DB built with additional patches:" >> ${workspace}/notification_message
    echo ${LINKS_TO_PATCHES} >> ${config_dir}/applyed_patches.txt
    echo ${LINKS_TO_PATCHES} | tr " " "\n" >> ${workspace}/notification_message
  fi


  if [ -s ${config_dir}/differences.txt ]; then
  	echo "
    Patch differrence from previous build:
    " >> ${workspace}/notification_message
  	cat ${config_dir}/differences.txt >> ${workspace}/notification_message
  fi

  #cat ${workspace}/notification_message | msmtp -C ./msmtp.ti -t --from "${jj_from}"

  rm -fv ${WORKSPACE}/msmtp.cfg
  /usr/bin/curl ${ci_generic_scripts_url}/msmtp.cfg > ${WORKSPACE}/msmtp.cfg

  # Without this step msmtp report error
  chmod 400 ${WORKSPACE}/msmtp.cfg

  cat ${workspace}/notification_message | msmtp -C ${WORKSPACE}/msmtp.cfg -t

fi
