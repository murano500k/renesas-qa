#!/bin/bash -x

usage ()
{
	echo "Usage: %fastboot.sh ";
	echo "options:";
	echo "--pwd     Force usage of fastboot and images from pwd"
	return
}
##############################################################################################################################################################



# poll the board to find out its configuration
#product=`${FASTBOOT} getvar product 2>&1 | grep product | awk '{print$2}'`
# Create the filename


# Verify that all the files required for the fastboot flash
# process are available


# if [ ! -e "${bootloaderimg}" ] ; then
# 	echo "bootloader.img not found"
# 	echo "Try to build bootloader.img"
# 	echo "Checking requierd files exist..."
#
# 	#Need to build bootloader
# 	#Checking requierd files exist
# 	verify_file ${bootparam}
# 	verify_file ${bl2}
# 	verify_file ${cert}
# 	verify_file ${bl31}
# 	verify_file ${tee}
# 	verify_file ${uboot}
#   verify_cmd $packipl all ./
# fi

if [ "$1" = "--help" -o "$1" = "-h" ] ; then
	usage
fi

if [ -z "$FASTBOOT_PATH" ]; then
  echo "FASTBOOT_PATH not set"
  return $ERROR_PREPARE
fi

export PRODUCT_OUT="."

bootimg="${PRODUCT_OUT}/boot.img"
systemimg="${PRODUCT_OUT}/system.img"
vendorimg="${PRODUCT_OUT}/vendor.img"
cacheimg="${PRODUCT_OUT}/cache.img"
recoveryimg="${PRODUCT_OUT}/recovery.img"
userdataimg="${PRODUCT_OUT}/userdata.img"
bootloaderimg="${PRODUCT_OUT}/bootloader.img"

verify_file ${bootimg}
verify_file ${systemimg}
verify_file ${recoveryimg}
verify_file ${userdataimg}
if [ -f ${cacheimg} ]; then
	echo "SUCCESS. File [${cacheimg}] found"
else
	echo "cache.img not found in [$PRODUCT_OUT]"
	echo "Creating cache.img as empty ext4 img...."
	EXT4FS=`which make_ext4fs`
	if [ -z ${EXT4FS} ]; then
		echo "ERROR. make_ext4fs not found. Need to add executable to PATH"
	else
		verify_cmd ${EXT4FS} -s -l 512M -a cache ${cacheimg}
	fi
fi


###########################################################################################################

echo "start actions using fastboot_command = [$FASTBOOT_PATH]"

echo "Flash recovery"
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash recovery ${recoveryimg}

echo "Check if flash bootloader is needed"

if [ -e "${bootloaderimg}" ] ; then

  echo "Flash bootloader"

	$FASTBOOT_PATH -s $FASTBOOT_SERIAL flash bootloader ${bootloaderimg}
	$FASTBOOT_PATH -s $FASTBOOT_SERIAL oem flash all
	echo "Will sleep 60 sec for bootloaders update...."
	sleep 60
	$FASTBOOT_PATH -s $FASTBOOT_SERIAL oem format
	$FASTBOOT_PATH -s $FASTBOOT_SERIAL reboot-bootloader
else
  echo "No bootloader image found. It's ok"
fi

echo "Flash Android partitions"

verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash boot ${bootimg}
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash system	${systemimg}
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash vendor	${vendorimg}
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash userdata	${userdataimg}
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash cache ${cacheimg}

verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL erase metadata

verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL reboot
echo "SUCCESS. Script finished successfully"
##########################################################################################################
