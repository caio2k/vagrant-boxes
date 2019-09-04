#!/bin/bash
# Base install

echo "Launching base script"
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
    # Add backport support
    if (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^8\.'`) ||
        (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^9\.'`) ||
        (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^10$'`) ; then
      echo "deb http://ftp.debian.org/debian `lsb_release -c -s`-backports main contrib" > /etc/apt/sources.list.d/backports.list
      echo "deb http://ftp.debian.org/debian sid main contrib" > /etc/apt/sources.list.d/sid.list
      echo 'Package: *'              >  /etc/apt/preferences.d/sid.pref
      echo 'Pin: release a=unstable' >> /etc/apt/preferences.d/sid.pref
      echo 'Pin-Priority: 50'        >> /etc/apt/preferences.d/sid.pref
    elif (`lsb_release -i -s | grep -q Ubuntu` && `lsb_release -r -s | grep -q '^18\.'`); then
      echo 'deb http://ubuntu.cica.es/ubuntu/ disco main restricted universe multiverse' > /etc/apt/sources.list.d/disco.list 
      echo 'Package: *'                     >  /etc/apt/preferences.d/disco.pref
      echo 'Pin: release o=Ubuntu, a=disco' >> /etc/apt/preferences.d/disco.pref
      echo 'Pin-Priority: 50'               >> /etc/apt/preferences.d/disco.pref
      sed -i 's/GRUB_CMDLINE_LINUX=".*/GRUB_CMDLINE_LINUX="net.ifnames=0"/g' /etc/default/grub
      update-grub
    fi
    #enable tmpfs
    if [ -f /usr/share/systemd/tmp.mount ]; then
      cp /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount
    else
      echo '[Unit]'                                                                         >  /etc/systemd/system/tmp.mount
      echo 'Description=Temporary Directory (/tmp)'                                         >> /etc/systemd/system/tmp.mount
      echo 'Documentation=man:hier(7)'                                                      >> /etc/systemd/system/tmp.mount
      echo 'Documentation=https://www.freedesktop.org/wiki/Software/systemd/APIFileSystems' >> /etc/systemd/system/tmp.mount
      echo 'ConditionPathIsSymbolicLink=!/tmp'                                              >> /etc/systemd/system/tmp.mount
      echo 'DefaultDependencies=no'                                                         >> /etc/systemd/system/tmp.mount
      echo 'Conflicts=umount.target'                                                        >> /etc/systemd/system/tmp.mount
      echo 'Before=local-fs.target umount.target'                                           >> /etc/systemd/system/tmp.mount
      echo 'After=swap.target'                                                              >> /etc/systemd/system/tmp.mount
      echo '[Mount]'                                    >> /etc/systemd/system/tmp.mount
      echo 'What=tmpfs'                                 >> /etc/systemd/system/tmp.mount
      echo 'Where=/tmp'                                 >> /etc/systemd/system/tmp.mount
      echo 'Type=tmpfs'                                 >> /etc/systemd/system/tmp.mount
      echo 'Options=mode=1777,strictatime,nosuid,nodev' >> /etc/systemd/system/tmp.mount
      echo '[Install]'                                  >> /etc/systemd/system/tmp.mount
      echo 'WantedBy=local-fs.target'                   >> /etc/systemd/system/tmp.mount
    fi
    systemctl enable tmp.mount
    systemctl start tmp.mount
    #mount apt cache's as tmpfs
    mkdir /tmp/apt-cache
    mount -o bind /tmp/apt-cache /var/cache/apt/archives
    DEBIAN_FRONTEND=noninteractive apt-get -y update
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade --with-new-pkgs
  fi

  # Make ssh faster by not waiting on DNS
  echo "UseDNS no" >> /etc/ssh/sshd_config

fi

# Rebooting to be sure we are using the latest kernel and update initramfs
reboot

# Just playing safe :)
sleep 300
