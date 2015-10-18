yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y remove perl yum-utils
yum -y clean all
#rm -f /etc/yum.repos.d/epel.repo
rm -rf /tmp/*

# Remove traces of mac address from network configuration
sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
rm /etc/udev/rules.d/70-persistent-net.rules /etc/udev/rules.d/70-persistent-cd.rules /lib/udev/rules.d/75-persistent-net-generator.rules
