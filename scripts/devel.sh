#!/bin/bash

if [[ $OSTYPE == "linux-gnu" ]]; then
  if [[ -f /etc/debian_version ]]; then
    if   (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^8\.'` ) ; then
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

    elif (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^9\.'` ) ||
         (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^10\.'`) ||
         (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^testing\.'`) ||
         (`lsb_release -i -s | grep -q Ubuntu` && `lsb_release -r -s | grep -q '^16\.'`) ||
         (`lsb_release -i -s | grep -q Ubuntu` && `lsb_release -r -s | grep -q '^17\.'`) ||
         (`lsb_release -i -s | grep -q Ubuntu` && `lsb_release -r -s | grep -q '^18\.'`) ; then
      USER_HOME='/home/vagrant'

      #apt-friendly apps
      ##docker
      usermod -aG docker vagrant
      if ! (`lsb_release -i -s | grep -q Debian` && `lsb_release -r -s | grep -q '^10\.'`); then
        #ignore debian10 as it comes with latest docker
        curl -fsSL https://download.docker.com/linux/`lsb_release -i -s | tr '[:upper:]' '[:lower:]'`/gpg | apt-key add -
        echo "deb [arch=amd64] https://download.docker.com/linux/`lsb_release -i -s | tr '[:upper:]' '[:lower:]'` $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
        apt-get update
        apt-get install -y docker-ce docker-compose

        #ignore debian10 as it comes with latest golang
        apt-get remove -y golang
        if [ ! -d "/opt/go" ] ; then
          # Download and install GO
          wget https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz -O /tmp/go.tar.gz
          tar zxvf /tmp/go.tar.gz --directory /opt/
        fi
        # When you execute go GET you need these defined path.
        echo '# Go settings' > /etc/profile.d/go.sh
        echo 'export GOROOT=/opt/go' >> /etc/profile.d/go.sh
        echo 'export GOPATH=$HOME/dev/go'  >> /etc/profile.d/go.sh
        echo 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin' >> /etc/profile.d/go.sh
        echo 'mkdir -p $GOPATH' >> /etc/profile.d/go.sh

        chmod +x /etc/profile.d/go.sh
      fi

      ##vscode - cannot be seeded due to non-standard gpg
      curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
      echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
      apt-get update
      apt-get install -y code
      # Install vscode go extension
      su -c "code --install-extension ms-vscode.go" vagrant
      # Increment maximum number of watches
      echo "fs.inotify.max_user_watches=524288" > /etc/sysctl.d/60-max_user_watches.conf
      sysctl -p

      #snap-friendly apps
      snap install intellij-idea-community --classic
      snap install pycharm-community --classic
      snap install goland --classic

      #install aws stuff
      apt-get -y install awscli
      curl -fsSL https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest -o /usr/local/bin/ecs-cli
      chmod +x /usr/local/bin/ecs-cli
      ln -s $USER_HOME/.Xauthority /root/

      mkdir -p $USER_HOME/.config/gtk-3.0/
      echo '[Settings]'                          >  $USER_HOME/.config/gtk-3.0/settings.ini
      echo 'gtk-application-prefer-dark-theme=1' >> $USER_HOME/.config/gtk-3.0/settings.ini
      
      chown -R vagrant $USER_HOME/.config

      if (`lsb_release -i -s | grep -q Ubuntu` && `lsb_release -r -s | grep -q '^18\.'`) ; then
        # Disable animations
        . <(dbus-launch --sh-syntax)
        su -c 'gsettings set org.gnome.desktop.interface enable-animations false' vagrant
        su -c 'gsettings set org.gnome.desktop.lockdown disable-lock-screen true' vagrant
        su -c 'gsettings set org.gnome.desktop.screensaver lock-enabled false' vagrant
        # Auto login as vagrant
        sed -i 's:#.*AutomaticLogin:AutomaticLogin:g;s:user1:vagrant:g' /etc/gdm3/custom.conf
      fi
    fi

    # Development tools common in debians/ubuntus
    apt-get install -y python-minimal
    apt-get install -y python-pip
    apt-get install -y python3-minimal
    apt-get install -y python3-pip

  fi
fi
