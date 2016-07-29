%include https://mborodin.github.io/base.ks

%post
network --device eth0 --bootproto=static --ip=10.0.1.4 --netmask=255.255.255.0 --hostname=gluon01.emwnet.de
%end
