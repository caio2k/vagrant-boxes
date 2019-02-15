#!/bin/bash
#by caio2k

export PATH=/mnt/nas/devel/devops/packer:$PATH

: ${BUILD_VERSION:="v$(date +'%Y%m%d')"}
export BUILD_VERSION
#fix to vbox 5.1.38
export PACKER_KEY_INTERVAL=150ms

IMAGE_TO_BUILD=${1-debian-10-devel.json}

mkdir -p boxes
rm -f boxes/*-${BUILD_VERSION}.box #2>/dev/null
packer build ${IMAGE_TO_BUILD}
cd boxes
openssl sha1 *-${BUILD_VERSION}.box
