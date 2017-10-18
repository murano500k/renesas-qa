 #!/bin/bash
resultFile=${BUILD_NAME}_$(date +%d-%m_%H-%M).csv
func () {
printf "\n$1," >> $resultFile
printf "\"" >> $resultFile
adb shell $2 && echo "\"" >> $resultFile 2>&1
echo "task completed:    $1     ("$2")"
}

adb root > /dev/null
sleep 3
adb remount > /dev/null
func "SYS_KERNEL_CHECK_0001" "cat /proc/version"
func "SYS_ROOTFS_CHECK_0001" "ls -al /vendor/lib/modules"
func "SYS_GFX_CHECK_0001" "cat /sys/kernel/debug/pvr/version"
func "SYS_SMP_CHECK_0001" "cat /proc/cpuinfo"
func "SYS_0007" "cat /proc/meminfo"
func "SYS_0001" "lsmod"
func "SYS_UBOOT_0002" "printenv"
func "SYS_SEL_0001" "getenforce"
