#!/bin/bash
DIR=$(dirname $(readlink -f "$0"))

INSTALL_DIR=$DIR/../bin

mkdir -p $INSTALL_DIR

echo
echo "====================================="
echo "========== Creating chroots ========="
echo "====================================="
echo

sudo click chroot -a armhf -f ubuntu-sdk-15.04 -s vivid create
sudo click chroot -a i386 -f ubuntu-sdk-15.04 -s vivid create

echo
echo "====================================="
echo "========== Updating chroots ========="
echo "====================================="
echo

sudo click chroot -a armhf -f ubuntu-sdk-15.04 -s vivid upgrade
sudo click chroot -a i386 -f ubuntu-sdk-15.04 -s vivid upgrade

echo
echo "====================================="
echo "=== Installing packages in chroot ==="
echo "====================================="
echo

sudo click chroot -a i386 -f ubuntu-sdk-15.04 -s vivid maint apt-get install git qtdeclarative5-dev:i386 qtbase5-private-dev:i386 qtdeclarative5-private-dev:i386 libqt5opengl5-dev:i386 qtdeclarative5-qtquick2-plugin:i386
sudo click chroot -a armhf -f ubuntu-sdk-15.04 -s vivid maint apt-get install git qtdeclarative5-dev:armhf qtbase5-private-dev:armhf qtdeclarative5-private-dev:armhf libqt5opengl5-dev:armhf qtdeclarative5-qtquick2-plugin:armhf

echo
echo "====================================="
echo "======== Downloading golang 1.5.3 ==="
echo "====================================="
echo

rm $INSTALL_DIR/go1.5.3.linux-amd64.tar.gz
wget -P $INSTALL_DIR https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz

echo
echo "====================================="
echo "======= Installing new golang ======="
echo "====================================="
echo

echo $INSTALL_DIR

tar -C $INSTALL_DIR -xzf $INSTALL_DIR/go1.5.3.linux-amd64.tar.gz

cd $INSTALL_DIR/go/src

sudo GOROOT_BOOTSTRAP=$INSTALL_DIR/go CGO_ENABLED=1 GOARCH=386 GOOS=linux ./make.bash --no-clean
sudo GOROOT_BOOTSTRAP=$INSTALL_DIR/go CGO_ENABLED=1 GOARCH=arm GOARM=7 GOOS=linux ./make.bash --no-clean

rm $INSTALL_DIR/go1.5.3.linux-amd64.tar.gz

cd -

echo "Install finished! :)"
