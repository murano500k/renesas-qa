#!/bin/bash -x

bl_section ()
{
###########################################
#Bootloader section
if [[ true ]]; then
  return
fi
if [ ! -e "${bootloaderimg}" ] ; then
    echo "bootloader.img not found"
    echo "Try to build bootloader.img"
    echo "Checking required files exist..."
    verify_bins
    if [[ $? != 0 ]]; then
        echo
        echo "**************** NO bins for bootloader found."
        echo "**************** It's ok, skipping flash bootloader section"
        echo
        return
    else
        echo "Run packipl"
        verify_cmd $packipl all ./
    fi
fi
echo "Flash bootloader"
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash bootloader ${bootloaderimg}
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL oem flash all
echo "Waiting 30 sec for bootloaders update ..."
sleep 30
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL oem format
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL reboot-bootloader
return
}
verify_bins ()
{
	if [ ! -f "$bootparam" ]; then
		return 1
	fi
	if [ ! -f "$bl2" ]; then
		return 1
	fi
	if [ ! -f "$cert" ]; then
		return 1
	fi
	if [ ! -f "$bl31" ]; then
		return 1
	fi
	if [ ! -f "$tee" ]; then
		return 1
	fi
	if [ ! -f "$uboot" ]; then
		return 1
	fi
	if [ ! -f "$pack_ipl" ]; then
		return 1
	fi
}
#End Bootloader section
#################################################
##############################################################################################################################################################




if [ -z "$FASTBOOT_PATH" ]; then
  echo "FASTBOOT_PATH not set"
  return $ERROR_PREPARE
fi

export PRODUCT_OUT="."

bootimg="${PRODUCT_OUT}/boot.img"
vendorimg="${PRODUCT_OUT}/vendor.img"
systemimg="${PRODUCT_OUT}/system.img"
userdataimg="${PRODUCT_OUT}/userdata.img"
bootloaderimg="${PRODUCT_OUT}/bootloader.img"
bootparam="${PRODUCT_OUT}/bootparam_sa0.bin"
bl2="${PRODUCT_OUT}/bl2.bin"
cert="${PRODUCT_OUT}/cert_header_sa6.bin"
bl31="${PRODUCT_OUT}/bl31.bin"
tee="${PRODUCT_OUT}/tee.bin"
uboot="${PRODUCT_OUT}/u-boot.bin"
packipl="${PRODUCT_OUT}/pack_ipl"

verify_file ${bootimg}
verify_file ${systemimg}
verify_file ${vendorimg}
verify_file ${userdataimg}

###########################################################################################################

echo "start actions using fastboot_command = [$FASTBOOT_PATH]"

echo "Check device"
is_fastboot
sleep 5
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash boot ${bootimg}
bl_section
echo "Flash Android partitions"
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash system	${systemimg}
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash vendor	${vendorimg}
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL flash userdata	${userdataimg}
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL erase metadata
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL erase misc
#reboot now
verify_cmd $FASTBOOT_PATH -s $FASTBOOT_SERIAL reboot
echo "SUCCESS. Script finished successfully"



##########################################################################################################
