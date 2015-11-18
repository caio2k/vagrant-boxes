#!/bin/sh

: ${BUILD_VERSION:="v$(date +'%Y%m%d')"}
export BUILD_VERSION

rm -f boxes/*-${BUILD_VERSION}.box #2>/dev/null
packer build CentOS-6.7-x86_64.json
cd boxes
openssl sha1 *-${BUILD_VERSION}.box
