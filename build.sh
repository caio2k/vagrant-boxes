#!/bin/bash
#by caio2k

JSON_TO_BUILD=${1-debian-10-devel.json}
BUILDPREFIX=`grep '"box_name"' "$JSON_TO_BUILD" | sed 's/"//g;s/,//g;s/.*: //g'`-`grep '"box_version"' "$JSON_TO_BUILD" | sed 's/"//g;s/,//g;s/-.*//g;s/.*: //g'`
export BUILDDATE=`date +'%Y%m%d'`
export BUILDNAME=${BUILDPREFIX}.${BUILDDATE}

mkdir -p tmp
export TMPDIR=`pwd`/tmp

echo "launchig packer to build $BUILDNAME"

#fix to vbox 5.1.38
export PACKER_KEY_INTERVAL=150ms

#export PACKER_LOG=1
#PARAMETERS="--only=qemu"
PARAMETERS="--only=virtualbox"

mkdir -p boxes
rm -f boxes/${BUILDPREFIX}-*.box #2>/dev/null
time packer build -on-error=ask $PARAMETERS ${JSON_TO_BUILD} | tee "boxes/$BUILDNAME.log" && \
cd boxes && \
openssl sha1 packer-${BUILD_VERSION}.box
