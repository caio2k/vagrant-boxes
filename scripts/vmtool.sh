#!/bin/bash
#by caio2k

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
  if [[ $OSTYPE == "linux-gnu" ]]; then
    VBOX_VERSION=$(cat /root/.vbox_version)

    #installing required packages
    if [[ -f /etc/redhat-release ]]; then
      yum -y install gcc-c++ kernel-devel-`uname -r` kernel-headers perl bzip2
    fi

    mount -o loop /root/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    cd /tmp
    sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm -f /root/VBoxGuestAdditions_*.iso

    if [[ $VBOX_VERSION = "4.3.10" ]]; then
      ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    fi

    #uninstalling required packages and disabling uneeded service
    if [[ -f /etc/redhat-release ]]; then
      chkconfig vboxadd-x11 off
      yum -y remove gcc-c++ kernel-devel-`uname -r` kernel-headers perl
    fi
  elif [[ $OSTYPE =~ "solaris" ]]; then
    echo "Installing VirtualBox Guest Additions"
    echo "mail=\ninstance=overwrite\npartial=quit" > /tmp/noask.admin
    echo "runlevel=nocheck\nidepend=quit\nrdepend=quit" >> /tmp/noask.admin
    echo "space=quit\nsetuid=nocheck\nconflict=nocheck" >> /tmp/noask.admin
    echo "action=nocheck\nbasedir=default" >> /tmp/noask.admin
    DEV=`/usr/sbin/lofiadm -a /export/home/vagrant/VBoxGuestAdditions.iso`
    /usr/sbin/mount -o ro -F hsfs $DEV /mnt
    /usr/sbin/pkgadd -a /tmp/noask.admin -G -d /mnt/VBoxSolarisAdditions.pkg all
    /usr/sbin/umount /mnt
    /usr/sbin/lofiadm -d $DEV
    rm -f VBoxGuestAdditions.iso
  fi
fi
