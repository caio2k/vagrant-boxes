#!/bin/bash
# Install Ansible 

echo "Installing ansible"
if [[ $OSTYPE == "linux-gnu" ]]; then
  #check if redhat
  yum -y install epel-release
  yum -y install ansible
  yum -y remove epel-release
elif [[ $OSTYPE == "linux-gnu" ]]; then
  yes | pkgadd -d http://get.opencsw.org/now CSWpkgutil
  /opt/csw/bin/pkgutil -i ansible -y
fi
