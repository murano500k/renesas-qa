#!/bin/bash
echo ""
echo "************ Start google_fastboot_format.sh ***************"
FASTBOOT_DEVICES="$($FASTBOOT devices)"
if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
  echo fastboot device [$FASTBOOT_SERIAL] NOT found
  . $SCRIPTS_DIR/enable-fastboot.sh
  sleep 5
fi

for i in {1..100};
do echo "FASTBOOT_REBOOT_TEST Iteration $i";
  FASTBOOT_DEVICES="$($FASTBOOT devices)"
  if [[ $FASTBOOT_DEVICES != *$FASTBOOT_SERIAL* ]]; then
    echo ERROR. fastboot device [$FASTBOOT_SERIAL] NOT found
      export ERROR_COUNT=$((ERROR_COUNT+1))
      echo "ITERATION_COUNT=$i"
      echo "ERROR_COUNT=$ERROR_COUNT"
      exit 1
  fi
  $FASTBOOT -s $FASTBOOT_SERIAL format userdata;
  result=$?
  if [ $result != 0 ]; then
    export ERROR_COUNT=$((ERROR_COUNT+1))
    echo "ITERATION_COUNT=$i"
    echo "ERROR_COUNT=$ERROR_COUNT"
    exit 1
  fi
  sleep 5;
done

sleep 20
echo ""
echo "************ Finish google_fastboot_format.sh ***************"
echo "ITERATION_COUNT=$ITERATION_COUNT"
echo "ERROR_COUNT=$ERROR_COUNT"
