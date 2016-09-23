#!/bin/bash

cat > gnome-terminal <<'EOL'
#!/bin/bash

case "$1" in
  start)
    echo "Starting script gnome-terminal "
    su - user -c "export DISPLAY=192.168.56.1:0.0; export `dbus-launch`; gnome-terminal"
    ;;
  stop)
    echo "Stopping script gnome-terminal"
    killall /usr/lib/gnome-terminal/gnome-terminal-server
    ;;
  *)
    echo "Usage: /etc/init.d/gnome-terminal {start|stop}"
    exit 1
    ;;
esac

exit 0

EOL
