#!/bin/bash
#by caio2k

echo "Launching vmtool script"
if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
  if [[ $OSTYPE == "linux-gnu" ]]; then
    if (`lsb_release -i -s | grep -q Debian` ); then
      DEBIAN_FRONTEND=noninteractive apt-get -y remove hyperv-daemons
      REPO="stable"
      if (`lsb_release -r -s | grep -q '^9\.'`); then
        REPO=`lsb_release -c -s`-backports
      elif (`lsb_release -r -s | grep -q '^10\.'`); then
        REPO=sid
      fi
        DEBIAN_FRONTEND=noninteractive apt-get -y -t ${REPO} install virtualbox-guest-x11
    elif (`lsb_release -i -s | grep -q Ubuntu` ); then
      DEBIAN_FRONTEND=noninteractive apt-get -y remove linux-tools-virtual linux-cloud-tools-virtual
      DEBIAN_FRONTEND=noninteractive apt-get -y install -t disco virtualbox-guest-utils-hwe virtualbox-guest-x11-hwe
#      apt remove --purge linux-image-generic
    #debian should always use debs to manage vbox guest, but I left below the option to install latest into debian as well
    elif (`lsb_release -i -s | grep -q Redhat` ) ; then
      echo "installing required packages"
      if [[ -f /etc/redhat-release ]]; then
        yum -y install gcc-c++ kernel-devel-`uname -r` kernel-headers perl bzip2
        VBOX_ADDITIONS_HOME=/root
      elif [[ -f /etc/debian_version ]]; then
        DEBIAN_FRONTEND=noninteractive apt-get -y install linux-headers-$(uname -r) perl
        DEBIAN_FRONTEND=noninteractive apt-get -y install dkms
        VBOX_ADDITIONS_HOME=/home/vagrant
      fi

      echo "compiling vbox guest additions"
      VBOX_VERSION=$(cat $VBOX_ADDITIONS_HOME/.vbox_version)

      mount -o loop $VBOX_ADDITIONS_HOME/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
      cd /tmp
      sh /mnt/VBoxLinuxAdditions.run
      umount /mnt
      rm -f $VBOX_ADDITIONS_HOME/VBoxGuestAdditions_*.iso

      if [[ $VBOX_VERSION = "4.3.10" ]]; then
        ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
      fi
      
      echo "uninstalling required packages and disabling uneeded service"
      if [[ -f /etc/redhat-release ]]; then
        chkconfig vboxadd-x11 off
        yum -y remove gcc-c++ kernel-devel-`uname -r` kernel-headers perl
      elif [[ -f /etc/debian_version ]]; then
        DEBIAN_FRONTEND=noninteractive apt-get -y remove linux-headers-$(uname -r) perl dkms
      fi
    fi
    echo "adding user vagrant into group vboxsf"
    usermod -a -G vboxsf vagrant
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
elif [[ $PACKER_BUILDER_TYPE =~ qemu ]]; then
  if [[ $OSTYPE == "linux-gnu" ]]; then
    if (`lsb_release -i -s | grep -q Debian` ); then
      DEBIAN_FRONTEND=noninteractive apt-get -y remove hyperv-daemons
    elif (`lsb_release -i -s | grep -q Ubuntu` ); then
      DEBIAN_FRONTEND=noninteractive apt-get -y remove linux-tools-virtual linux-cloud-tools-virtual
    fi
  fi
elif [[ $PACKER_BUILDER_TYPE =~ hyperv ]]; then
  if [[ $OSTYPE == "linux-gnu" ]]; then
    if (`lsb_release -i -s | grep -q Debian` ); then
      DEBIAN_FRONTEND=noninteractive apt-get -y install hyperv-daemons
    elif (`lsb_release -i -s | grep -q Ubuntu` ); then
      DEBIAN_FRONTEND=noninteractive apt-get -y install linux-tools-virtual linux-cloud-tools-virtual
    fi
  fi
fi
