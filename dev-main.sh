#!/bin/bash -x


echo ""
echo "#############################################"

if [ "$1" == "m3" ]; then
    echo "DEV TEST USING m3"
    . $SCRIPTS_DIR/export-mock-environments-m3
else
    echo "DEV TEST USING h3"
    . $SCRIPTS_DIR/export-mock-environments-h3
fi
echo "#############################################"
echo ""

. $SCRIPTS_DIR/prepare.sh
. $SCRIPTS_DIR/main.sh

