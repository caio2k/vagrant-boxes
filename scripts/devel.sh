#!/bin/bash

if [[ $OSTYPE == "linux-gnu" ]]; then
  if [[ -f /etc/debian_version ]]; then
    USER_HOME='/home/vagrant'
    export DEBIAN_FRONTEND='noninteractive'
    
    #add i386 architecture
    dpkg --add-architecture i386
    apt-get update
    
    #apt-friendly apps
    ##python2 and python3
    DEBIAN_FRONTEND=noninteractive apt-get -y install python-minimal python-pip python3-minimal python3-pip nmap chromium

    ##debian8 only robotframework
    if (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^8\.'` ) ; then
      apt-get --no-install-recommends -y install libgconf2-4:amd64 libgnome-2-0:amd64 libgnome2-0:amd64 libgnome2-bin:amd64 libgnome2-common:amd64 libgnomevfs2-0:amd64 libgnomevfs2-common:amd64 libgnomevfs2-extra:amd64 maven:amd64 acpi-support:amd64 mc:amd64 jython:amd64 mysql-client:amd64 mercurial:amd64 dos2unix:amd64 libxml-libxml-simple-perl:amd64 libxml-simple-perl:amd64 libxml-validator-schema-perl:amd64 libmime-lite-html-perl:amd64 libarchive-zip-perl:amd64 libhtml-display-perl:amd64 perl-tk:amd64 libsoap-lite-perl:amd64 libc6-i386:amd64 lib32z1:amd64 libssl1.0.0:i386 libxml2:i386 libnspr4:i386 libxslt1.1:i386 libstdc++6:i386 libgtk2.0-0:i386 libxtst6:i386 libasound2:i386 libxxf86vm1:i386 libimage-magick-perl:amd64 cifs-utils:amd64 gnome-terminal:amd64 java-package libxslt1.1
      apt-get --no-install-recommends -t jessie-backports -y install libgl1-mesa-glx:i386
      DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential wget python-wxgtk3.0
      pip install robotframework
      pip install -q https://github.com/HelioGuilherme66/RIDE/archive/v1.7.tar.gz
    fi
    
    ##docker (debian8: 1705, others: 1809+)
    if (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^8\.'` ) ; then
      DEBIAN_FRONTEND=noninteractive apt-get -y install apt-transport-https ca-certificates

      sh -c "echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list"
      apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

      apt-get update
      apt-cache policy docker-engine
      DEBIAN_FRONTEND=noninteractive apt-get -y install docker-engine
    else
      curl -fsSL https://download.docker.com/linux/`lsb_release -i -s | tr '[:upper:]' '[:lower:]'`/gpg | apt-key add -
      echo "deb [arch=amd64] https://download.docker.com/linux/`lsb_release -i -s | tr '[:upper:]' '[:lower:]'` $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get -y install docker-ce docker-compose
    fi
    usermod -aG docker vagrant

    ##golang - in Ubuntu try to install latest version; in debian install from backports if available
    if (`lsb_release -i -s | grep -q Ubuntu`); then
      #install from ppa repo to receive automatic updates
      add-apt-repository ppa:longsleep/golang-backports
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go
    elif (`lsb_release -i -s | grep -q Debian` ) && [[ -f /etc/apt/sources.list.d/backports.list ]] ; then
      apt-get -t `lsb_release -c -s`-backports -y install golang
    else
      DEBIAN_FRONTEND=noninteractive apt-get -y install golang
    fi
    echo '# Go settings' > /etc/profile.d/go.sh
    echo 'export GOPATH=$HOME/dev/go'  >> /etc/profile.d/go.sh
    echo 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin' >> /etc/profile.d/go.sh
    echo 'mkdir -p $GOPATH' >> /etc/profile.d/go.sh
    chmod +x /etc/profile.d/go.sh

    ##vscode - cannot be seeded due to non-standard gpg
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y install code
    # Install vscode go extension
    su -c "code --install-extension ms-vscode.go" vagrant
    # Increment maximum number of watches
    echo "fs.inotify.max_user_watches=524288" > /etc/sysctl.d/60-max_user_watches.conf
    sysctl -p

    #snap-friendly apps
    if (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^8\.'` ) ; then
      echo 'Package: *'             >  /etc/apt/preferences.d/stretch.pref
      echo 'Pin: release a=stretch' >> /etc/apt/preferences.d/stretch.pref
      echo 'Pin-Priority: -10'       >> /etc/apt/preferences.d/stretch.pref
      echo "deb [arch=amd64] http://ftp.debian.org/debian stretch main" > /etc/apt/sources.list.d/stretch.list
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get -y install -t stretch gstreamer1.0-plugins-base snapd
    else
      DEBIAN_FRONTEND=noninteractive apt-get -y install snapd
    fi
    snap install intellij-idea-community --classic
    snap install pycharm-community --classic
    snap install goland --classic
    snap install postman

    #unfriendly apps
    ##install aws stuff
    DEBIAN_FRONTEND=noninteractive apt-get -y install awscli
    curl -fsSL https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest -o /usr/local/bin/ecs-cli
    chmod +x /usr/local/bin/ecs-cli

    #debian/ubuntu housekeeping
    ln -s $USER_HOME/.Xauthority /root/

    mkdir -p $USER_HOME/.config/gtk-3.0/
    echo '[Settings]'                          >  $USER_HOME/.config/gtk-3.0/settings.ini
    echo 'gtk-application-prefer-dark-theme=1' >> $USER_HOME/.config/gtk-3.0/settings.ini    
    chown -R vagrant $USER_HOME/.config

    #gdm fix
    if (`lsb_release -i -s | grep -q Ubuntu` && `lsb_release -r -s | grep -q '^18\.'`) ; then
      # Disable animations
      . <(dbus-launch --sh-syntax)
      su -c 'gsettings set org.gnome.desktop.interface enable-animations false' vagrant
      su -c 'gsettings set org.gnome.desktop.lockdown disable-lock-screen true' vagrant
      su -c 'gsettings set org.gnome.desktop.screensaver lock-enabled false' vagrant
      # Auto login as vagrant
      sed -i 's:#.*AutomaticLogin:AutomaticLogin:g;s:user1:vagrant:g' /etc/gdm3/custom.conf
    fi

    #removing useless things
    #apt-get remove --purge libreoffice*

  fi
fi
