#!/bin/bash

DIR=$(dirname $(readlink -f "$0"))

ARCH=i386
GOARCH=386
ARCHNAME=i386-linux-gnu
GCC=i686-linux-gnu

source $DIR/build.sh
