# Base install

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Fix slow DNS lookups with VirtualBox's DNS proxy:
# https://github.com/mitchellh/vagrant/issues/1172#issuecomment-9438465
echo 'options single-request-reopen' >> /etc/resolv.conf

if [ -f /etc/redhat-release ]; then
  yum update
  yum -y upgrade
  yum -y install yum-utils
  #yum -y install gcc make gcc-c++ kernel-devel-`uname -r` zlib-devel openssl-devel readline-devel sqlite-devel perl wget dkms nfs-utils
fi

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config

# Remove old kernels
package-cleanup --oldkernels --count=1

# Rebooting to be sure we are using the latest kernel
reboot

# Just playing safe :)
sleep 300
