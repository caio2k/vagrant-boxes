#!/bin/bash
#by caio2k

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
  VBOX_VERSION=$(cat /root/.vbox_version)

  #installing required packages
  if [ -f /etc/redhat-release ]; then
    yum -y install gcc-c++ kernel-devel-`uname -r` kernel-headers
  fi

  mount -o loop /root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
  cd /tmp
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt
  rm -f /root/VBoxGuestAdditions_*.iso

  if [ $VBOX_VERSION = "4.3.10" ]; then
    ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
  fi

  #uninstalling required packages and disabling uneeded service
  if [ -f /etc/redhat-release ]; then
    chkconfig vboxadd-x11 off
    yum -y remove gcc-c++ kernel-devel-`uname -r` kernel-headers
  fi
fi
