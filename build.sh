#!/bin/sh

: ${BUILD_VERSION:="v$(date +'%Y%m%d')"}
export BUILD_VERSION

rm -i output/*-${BUILD_VERSION}.box 2>/dev/null
packer build CentOS-6.7.json
cd output
shasum -a 256 *-${BUILD_VERSION}.box