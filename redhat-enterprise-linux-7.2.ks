authconfig --enableshadow --passalgo=sha512
rootpw --iscrypted $6$16_CHARACTER_SAL$xgHKuVZ/ZFAVmbhDmHmYU1n0Nqzq4qsjgZq4iSiy/uWwPdzR6gjm9g4VqVomMcueXNIlK9onfnnZw3lZmQMzO0

bootloader --location=mbr --password=redhat
text
cdrom
zerombr


clearpart --all --initlabel
part /boot --size=1024
part pv.01 --size=10240 --grow
volgroup vg1 pv.01
logvol /        --vgname=vg1 --size=4096  --name=root --grow
logvol swap     --vgname=vg1 --recommended --name=swap --fstype=swap
ignoredisk --only-use=sda

network --onboot yes --bootproto dhcp
firewall --enabled --ssh

lang de_DE
timezone Europe/Berlin

keyboard de

repo --name=epel --baseurl=http://dl.fedoraproject.org/pub/epel/7/x86_64/

reboot					# reboot automatically when done
install					# instead of "upgrade"

selinux --enforcing

skipx

services --enabled sshd

user --name=vagrant --password=vagrant --uid=1024

%packages --nobase --ignoremissing
@core
@server-policy
@german-support
yum
openssh-server
wget
mc
vim
python-execnet
bzip2
gcc
kernel-devel
#salt-minion
%end

%post
exec < /dev/tty3 > /dev/tty3

chvt 3
#yum install http://192.168.50.1:8080/jdk-7u79-linux-x64.rpm

echo "Installing keys"
cd /home/vagrant
mkdir .ssh
wget -O .ssh/authorized_keys https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub

chmod 0700 .ssh
chmod 0600 .ssh/authorized_keys

chown -R vagrant .ssh

echo "Updating sudoers"
cat <<EOF > /etc/sudoers.d/1-vagrant
Defaults:vagrant !requiretty
vagrant ALL=(ALL) NOPASSWD: ALL
EOF

set -- `cat /proc/cmdline`
export -- `cat /proc/cmdline`

echo "Importing repository key"
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
rpm --import https://repo.saltstack.com/yum/redhat/7/x86_64/latest/SALTSTACK-GPG-KEY.pub
yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-2015.8-2.el7.noarch.rpm


%end
