#!/bin/bash

if [[ $OSTYPE == "linux-gnu" ]]; then
  if [[ -f /etc/debian_version ]]; then
    if `grep -q ^8 /etc/debian_version`; then
      USER_HOME='/home/vagrant'
  
      echo 'deb     [arch=i386] http://ftp.fr.debian.org/debian/ jessie main contrib'    >  /etc/apt/sources.list.d/jessie32.list
      echo 'deb-src [arch=i386] http://ftp.fr.debian.org/debian/ jessie main contrib'    >> /etc/apt/sources.list.d/jessie32.list
      echo 'deb     [arch=i386] http://security.debian.org/ jessie/updates main contrib' >> /etc/apt/sources.list.d/jessie32.list
      echo 'deb-src [arch=i386] http://security.debian.org/ jessie/updates main contrib' >> /etc/apt/sources.list.d/jessie32.list
      
      echo 'deb http://ftp.de.debian.org/debian jessie-backports main'                   >  /etc/apt/sources.list.d/backports.list
      
      dpkg --add-architecture i386
      
      apt-get update
      
      apt-get --no-install-recommends -y install docker.io:amd64 btrfs-tools:amd64 nmap:amd64 curl:amd64 libgconf2-4:amd64 libgnome-2-0:amd64 libgnome2-0:amd64 libgnome2-bin:amd64 libgnome2-common:amd64 libgnomevfs2-0:amd64 libgnomevfs2-common:amd64 libgnomevfs2-extra:amd64 maven:amd64 acpi-support:amd64 mc:amd64 jython:amd64 git:amd64 mysql-client:amd64 mercurial:amd64 dos2unix:amd64 libxml-libxml-simple-perl:amd64 libxml-simple-perl:amd64 libxml-validator-schema-perl:amd64 libmime-lite-html-perl:amd64 libarchive-zip-perl:amd64 libhtml-display-perl:amd64 perl-tk:amd64 libsoap-lite-perl:amd64 libc6-i386:amd64 lib32z1:amd64 libssl1.0.0:i386 libxml2:i386 libnspr4:i386 libxslt1.1:i386 libstdc++6:i386 libgtk2.0-0:i386 libxtst6:i386 libasound2:i386 libgl1-mesa-glx:i386 libxxf86vm1:i386 libimage-magick-perl:amd64 cifs-utils:amd64 gnome-terminal:amd64 java-package libxslt1.1
      apt-get -y install build-essential
      apt-get install wget python-pip
      apt-get install python-wxgtk3.0
      pip install robotframework
      pip install -q https://github.com/HelioGuilherme66/RIDE/archive/v1.6b3.tar.gz
      
      ln -s $USER_HOME/.Xauthority /root/

      mkdir -p $USER_HOME/.config/gtk-3.0/
      echo '[Settings]'                          >  $USER_HOME/.config/gtk-3.0/settings.ini
      echo 'gtk-application-prefer-dark-theme=1' >> $USER_HOME/.config/gtk-3.0/settings.ini
      
      chown -R vagrant $USER_HOME/.config

    elif `grep -q ^9 /etc/debian_version`; then
      USER_HOME='/home/vagrant'
  
      #docker
      curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
      echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

      #vscode - cannot be seeded due to non-standard gpg
      curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add -
      echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

      #install apt apps
      apt-get update
      apt-get install -y docker-ce code
      
      #snaps
      snap install intellij-idea-community --classic
      snap install pycharm-community --classic
      snap install postman

      ln -s $USER_HOME/.Xauthority /root/

      mkdir -p $USER_HOME/.config/gtk-3.0/
      echo '[Settings]'                          >  $USER_HOME/.config/gtk-3.0/settings.ini
      echo 'gtk-application-prefer-dark-theme=1' >> $USER_HOME/.config/gtk-3.0/settings.ini
      
      chown -R vagrant $USER_HOME/.config

    fi
  fi
fi
