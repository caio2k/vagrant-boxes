#!/bin/bash
# Base install

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
  if [[ $OSTYPE == "linux-gnu" ]]; then

    sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

    # Fix slow DNS lookups with VirtualBox's DNS proxy:
    # https://github.com/mitchellh/vagrant/issues/1172#issuecomment-9438465
    echo 'options single-request-reopen' >> /etc/resolv.conf

    if [[ -f /etc/redhat-release ]]; then
      yum update
      yum -y install deltarpm 
      yum -y upgrade
      yum -y install yum-utils
    elif [[ -f /etc/debian_version ]]; then
      sed -i "/^deb cdrom:/s/^/#/" /etc/apt/sources.list
      dpkg --purge apt-listchanges
      apt-get -y update
      apt-get -y upgrade
    fi

    # Make ssh faster by not waiting on DNS
    echo "UseDNS no" >> /etc/ssh/sshd_config

  fi
fi

# Rebooting to be sure we are using the latest kernel
reboot

# Just playing safe :)
sleep 300
