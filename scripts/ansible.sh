#!/bin/bash
# Install Ansible 

echo "Launching ansible script"
if [[ $OSTYPE == "linux-gnu" ]]; then
  if [[ -f /etc/redhat-release ]]; then
    yum -y install epel-release
    yum -y install ansible
    yum -y remove epel-release
  elif [[ -f /etc/debian_version ]]; then
    apt-get install -y sshpass
    if `grep -q ^8 /etc/debian_version`; then
      apt-get install -y -t jessie-backports ansible
	fi
  fi
elif [[ $OSTYPE == "solaris" ]]; then
  yes | pkgadd -d http://get.opencsw.org/now CSWpkgutil
  /opt/csw/bin/pkgutil -i ansible -y
fi
