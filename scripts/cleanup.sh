#!/bin/bash

echo "Launching cleanup script"
if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
  if [[ $OSTYPE == "linux-gnu" ]]; then
    if [ -f /etc/redhat-release ]; then
      package-cleanup -y --oldkernels --count=1
      yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
      yum -y remove perl yum-utils
      yum -y clean all
      #rm -f /etc/yum.repos.d/epel.repo

      # Remove traces of mac address from network configuration
      sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
      rm -f /etc/udev/rules.d/70-persistent-net.rules /etc/udev/rules.d/70-persistent-cd.rules /lib/udev/rules.d/75-persistent-net-generator.rules

    elif [[ -f /etc/debian_version ]]; then
      rm -rf /dev/.udev/
      rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
      echo "pre-up sleep 2" >> /etc/network/interfaces
      if [[ -d "/var/lib/dhcp" ]]; then
          rm /var/lib/dhcp/*
      fi
 
    fi
    rm -rf /tmp/*

  fi
fi
