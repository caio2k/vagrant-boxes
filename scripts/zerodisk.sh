#!/bin/bash
# Zero out the free space to save space in the final image:

echo "Launching zerodisk script"
echo "Clearing log files and zeroing disk, this might take a while"
if [[ $OSTYPE == "linux-gnu" ]]; then
  dd if=/dev/zero of=/EMPTY bs=1M
  rm -f /EMPTY
  sync
elif [[ $OSTYPE =~ "solaris" ]]; then
  cp /dev/null /var/adm/messages
  cp /dev/null /var/log/syslog
  cp /dev/null /var/adm/wtmpx
  cp /dev/null /var/adm/utmpx
  dd if=/dev/zero of=/EMPTY bs=1024
  rm -f /EMPTY
fi
