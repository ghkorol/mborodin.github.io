%post
rpm --import https://repo.saltstack.com/yum/redhat/7/x86_64/latest/SALTSTACK-GPG-KEY.pub
yum -y install http://repo.saltstack.com/yum/redhat/salt-repo-2016.3-1.el7.noarch.rpm

yum -y install salt-minion

systemctl enable salt-minion
%end
