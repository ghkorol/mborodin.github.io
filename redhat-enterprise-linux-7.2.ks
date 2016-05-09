authconfig --enableshadow --passalgo=sha512
rootpw --iscrypted $6$16_CHARACTER_SAL$xgHKuVZ/ZFAVmbhDmHmYU1n0Nqzq4qsjgZq4iSiy/uWwPdzR6gjm9g4VqVomMcueXNIlK9onfnnZw3lZmQMzO0

bootloader --location=mbr
text
cdrom
zerombr


clearpart --all --initlabel
part /boot --size=1024
part pv.01 --size=10240 --grow
volgroup vg1 pv.01
logvol /        --vgname=vg1 --size=4096  --name=root --grow
logvol swap     --vgname=vg1 --recommended --name=swap --fstype=swap
ignoredisk --only-use=xvda

network --onboot yes --bootproto dhcp
firewall --enabled --ssh --port=4505:tcp,4506:tcp

lang de_DE
timezone Europe/Berlin

keyboard de

reboot					# reboot automatically when done
install					# instead of "upgrade"

selinux --enforcing

skipx

services --enabled sshd

%packages --nobase --ignoremissing
@core
@server-policy
@german-support
yum
openssh-server
wget
mc
vim
bzip2
%end

%post
exec < /dev/tty3 > /dev/tty3

chvt 3
rpm --import https://repo.saltstack.com/yum/redhat/7/x86_64/latest/SALTSTACK-GPG-KEY.pub
yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-2015.8-2.el7.noarch.rpm

yum -y install salt-minion

#echo "Enabling salt minion"
#chkconfig salt-minion enabled
%end
