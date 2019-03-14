#!/bin/bash
# Install Ansible 

echo "Launching ansible script"
if [[ $OSTYPE == "linux-gnu" ]]; then
  if [[ -f /etc/redhat-release ]]; then
    yum -y install epel-release
    yum -y install ansible
    #this is needed by vagrant-winnfs (vagrant NFS plugin). if you are behind proxy, it cannot be automagically installed
    yum -y install nfs-utils nfs-utils-lib
    yum -y remove epel-release
  elif [[ -f /etc/debian_version ]]; then
    apt-get -y install sshpass
    if (`lsb_release -i -s | grep -q Debian` ) && [[ -f /etc/apt/sources.list.d/backports.list ]] ; then
      apt-get -t `lsb_release -c -s`-backports -y install ansible
    else
      apt-get -y install ansible
    fi
  fi
elif [[ $OSTYPE == "solaris" ]]; then
  yes | pkgadd -d http://get.opencsw.org/now CSWpkgutil
  /opt/csw/bin/pkgutil -i ansible -y
fi
