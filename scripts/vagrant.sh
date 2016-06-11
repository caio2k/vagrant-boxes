#!/bin/bash

if [[ $OSTYPE == "linux-gnu" ]]; then
  if [[ -f /etc/redhat-release ]]; then
    yum -y install wget
    #this is to enable NFS mouting in vagrant
    yum -y install nfs-utils nfs-utils-lib
  fi

  # Vagrant specific
  date > /etc/vagrant_box_build_time

  # Add vagrant user
  /usr/sbin/groupadd vagrant
  /usr/sbin/useradd vagrant -g vagrant -G wheel
  echo "vagrant"|passwd --stdin vagrant
  echo "Defaults !requiretty" >> /etc/sudoers.d/vagrant
  echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
  chmod 0440 /etc/sudoers.d/vagrant

  # Installing vagrant keys
  mkdir -pm 700 /home/vagrant/.ssh
  wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
  chmod 0600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant /home/vagrant/.ssh

  # Customize the message of the day
  echo 'Welcome to your Vagrant-built virtual machine.' > /etc/motd

  if [[ -f /etc/redhat-release ]]; then
    yum -y remove wget
  fi
elif [[ $OSTYPE =~ "solaris" ]]; then
  echo "Setting the vagrant ssh pub key"
  mkdir /export/home/vagrant/.ssh
  chmod 700 /export/home/vagrant/.ssh
  touch /export/home/vagrant/.ssh/authorized_keys
  if [ -f /usr/sfw/bin/wget ] ; then
    /usr/sfw/bin/wget --no-check-certificate http://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub -O /export/home/vagrant/.ssh/authorized_keys
  else
    /usr/bin/wget --no-check-certificate http://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub -O /export/home/vagrant/.ssh/authorized_keys
  fi
  chmod 600 /export/home/vagrant/.ssh/authorized_keys
  chown -R vagrant:staff /export/home/vagrant/.ssh

  echo "Disabling sendmail and asr-norify"
  # disable the very annoying sendmail
  /usr/sbin/svcadm disable sendmail
  /usr/sbin/svcadm disable asr-notify
fi
