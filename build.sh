#!/bin/bash
#by caio2k

export PATH=/mnt/nas/devel/devops/packer:$PATH

: ${BUILD_VERSION:="v$(date +'%Y%m%d')"}
export BUILD_VERSION

IMAGE_TO_BUILD=${1-CentOS-6.10-x86_64.json}

mkdir -p boxes
rm -f boxes/*-${BUILD_VERSION}.box #2>/dev/null
packer build ${IMAGE_TO_BUILD}
cd boxes
openssl sha1 *-${BUILD_VERSION}.box
