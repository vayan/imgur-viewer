#!/bin/bash

DIR=$(dirname $(readlink -f "$0"))/../

export GOPATH=$DIR

rm $DIR/bin/imgur-viewer

$DIR/bin/go/bin/go get -d -u gopkg.in/qml.v1
$DIR/bin/go/bin/go install -v -x imgur-viewer

$DIR/bin/imgur-viewer
