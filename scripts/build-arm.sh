#!/bin/bash

#TODO Test

DIR=$(dirname $(readlink -f "$0"))

ARCH=armhf
GOARCH=arm
ARCHNAME=arm-linux-gnueabihf
GCC=arm-linux-gnueabihf
GOARM=7

#source build.sh
