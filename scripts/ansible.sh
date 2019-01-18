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
    apt-get install -y sshpass
    if `grep -q ^8 /etc/debian_version`; then
      apt-get install -y -t jessie-backports ansible
    elif `grep -q ^9 /etc/debian_version`; then
      apt-get install -y -t stretch-backports ansible
    fi
  fi
elif [[ $OSTYPE == "solaris" ]]; then
  yes | pkgadd -d http://get.opencsw.org/now CSWpkgutil
  /opt/csw/bin/pkgutil -i ansible -y
fi
