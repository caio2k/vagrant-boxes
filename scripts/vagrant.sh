#!/bin/bash

echo "Launching vagrant script"
if [[ $OSTYPE == "linux-gnu" ]]; then
  if [[ -f /etc/redhat-release ]]; then
    yum -y install wget
    #this is to enable NFS mouting in vagrant
    yum -y install nfs-utils nfs-utils-lib
  elif [[ -f /etc/debian_version ]]; then
    DEBIAN_FRONTEND=noninteractive apt-get -y install wget
  fi

  # Vagrant specific
  date > /etc/vagrant_box_build_time

  # Add vagrant user
  if ! id -u vagrant >/dev/null 2>&1; then
    /usr/sbin/groupadd vagrant
    /usr/sbin/useradd vagrant -g vagrant -G wheel
    echo "vagrant"|passwd --stdin vagrant
  fi
  echo "Defaults !requiretty"                         >  /tmp/vagrant
  echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /tmp/vagrant
  chmod 0440 /tmp/vagrant
  mv /tmp/vagrant /etc/sudoers.d/

  # Installing vagrant keys
  mkdir -pm 700 /home/vagrant/.ssh
  wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
  chmod 0600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant /home/vagrant/.ssh

  # Customize the message of the day
  echo 'Welcome to your Vagrant-built virtual machine.' > /etc/motd

  if [[ -f /etc/redhat-release ]]; then
    yum -y remove wget
  elif [[ -f /etc/debian_version ]]; then
    apt-get -y remove wget
    sed -i '/UsePAM/aUseDNS no' /etc/ssh/sshd_config
    sed -i '/env_reset/aDefaults        env_keep += "SSH_AUTH_SOCK"' /etc/sudoers;
    sed -i '/exit/i\/usr\/bin\/apt-get update' /etc/rc.local;
    adduser vagrant adm
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
