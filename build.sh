#!/usr/bin/env bash
rm -rf kernel
git clone $REPO -b $BRANCH kernel 
cd kernel

# Set Environment Configs
OUT=$(pwd)/out
DATE=$(date +"%m-%d-%y")
BUILD_START=$(date +"%s")
ARCH=arm
CC=clang
CCOMP=arm-linux-gnueabi-
CONF=j4primelte_defconfig

# Set CCcache
export USE_CCACHE=1 && export CCACHE_EXEC=/usr/bin/ccache && ccache -M 20G

# Export ARCH & SUBARCH
export ARCH=$ARCH
export SUBARCH=$ARCH

# Set Kernel & Host Name
# export VERSION=
export DEFCONFIG=$CONF

export LOCALVERSION=$VERSION

# Export Username & Machine Name
export KBUILD_BUILD_USER=Batu33TR
export KBUILD_BUILD_HOST=MicrosoftAzure

export PATH=$(pwd)/proton-clang/bin:$PATH
export CROSS_COMPILE=$(pwd)/proton-clang/bin/arm-linux-gnueabi-

# Make .config
make \
O=$OUT \
ARCH=$ARCH
CC=$CC \
HOSTCC=$CC \
CROSS_COMPILE=$CCOMP \
$CONF

# Compile Kernel
make \
O=$OUT \
ARCH=$ARCH \
CC=$CC \
HOSTCC=$CC \
CROSS_COMPILE=$CCOMP

# Find how much building has been long
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

echo
echo "Build completed in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds"
echo
