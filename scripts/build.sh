DIR=$(dirname $(readlink -f "$0"))

BIN_DIR=$DIR/../bin
CLICK_DIR=$BIN_DIR/click
WORK_DIR=$DIR/..
GO_DIR=$BIN_DIR/go
GO_BIN_DIR=$GO_DIR/bin

echo
echo "========== Recreate click build directory"
echo

rm -rf $CLICK_DIR
mkdir -p $CLICK_DIR

echo
echo "========== Remove old click packages"
echo

find $CLICK_DIR/.. -name "*.click" -exec rm {} \;

echo
echo "========== Build the project"
echo

click chroot -a $ARCH -f ubuntu-sdk-15.04 -s vivid run CGO_ENABLED=1 GOARCH=$GOARCH GOOS=linux PKG_CONFIG_LIBDIR=/usr/lib/$ARCHNAME/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig CC=$GCC-gcc GOROOT=$GO_DIR GOPATH=$WORK_DIR $GO_BIN_DIR/linux_$GOARCH/go get -d -u gopkg.in/qml.v1
click chroot -a $ARCH -f ubuntu-sdk-15.04 -s vivid run CGO_ENABLED=1 GOARCH=$GOARCH GOOS=linux PKG_CONFIG_LIBDIR=/usr/lib/$ARCHNAME/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig CC=$GCC-gcc CXX=$GCC-g++ GOROOT=$GO_DIR GOPATH=$WORK_DIR $GO_BIN_DIR/linux_$GOARCH/go install -v -x imgur-viewer

echo
echo "========== Copy files into click directory"
echo

cp $BIN_DIR/imgur-viewer $CLICK_DIR
cp -R $WORK_DIR/share $CLICK_DIR
cp $WORK_DIR/manifest.json $CLICK_DIR
cp $WORK_DIR/imgur-viewer.apparmor $CLICK_DIR
cp $WORK_DIR/imgur-viewer.desktop $CLICK_DIR
cp $WORK_DIR/imgur-viewer.png $CLICK_DIR

echo
echo "========== Build click package"
echo

cd $CLICK_DIR/..
click build $CLICK_DIR
