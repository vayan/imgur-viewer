#!/bin/bash

CLICK_PATH=$(find bin/ -name "*.click")
CLICK_NAME=$(basename $CLICK_PATH)

echo
echo "========== Sending $CLICK_NAME to device"
echo

adb push $CLICK_PATH /home/phablet
adb shell pkcon install-local $CLICK_NAME --allow-untrusted
