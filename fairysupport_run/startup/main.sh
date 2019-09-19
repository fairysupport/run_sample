#!/bin/bash

default_user=user1
ssh_port=2222

# DNS
sudo sh -c "sed -i.bak -e 's/^\s*DNS/#DNS/g' /etc/sysconfig/network-scripts/ifcfg-eth0"
sudo sh -c "echo DNS1=8.8.8.8 >> /etc/sysconfig/network-scripts/ifcfg-eth0"
sudo sh -c "echo DNS2=8.8.4.4 >> /etc/sysconfig/network-scripts/ifcfg-eth0"
echo "sudo -S systemctl restart network.service"
sudo -S systemctl restart network.service

# yum
echo "sudo -S yum -y update"
sudo -S yum -y update
sudo -S systemctl start firewalld
sudo -S systemctl enable firewalld
sudo -S yum -y install lsof
sudo -S yum -y install policycoreutils-python
sudo -S yum -y install iproute

# ssh
sudo sh -c "sed -i.bak -e 's/^\s*PasswordAuthentication/#PasswordAuthentication/g' -e 's/^\s*PermitRootLogin/#PermitRootLogin/g' -e 's/^\s*Port/#Port/g' /etc/ssh/sshd_config"
sudo sh -c "echo 'Port ${ssh_port}' >> /etc/ssh/sshd_config"
sudo sh -c "echo 'PermitRootLogin no' >> /etc/ssh/sshd_config"
sudo sh -c "echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config"

sudo -S semanage port -a -t ssh_port_t -p tcp ${ssh_port}
echo "sudo -S systemctl restart sshd.service"
sudo -S systemctl restart sshd.service

# firewalld
sudo sh -c "sed -i.bak -e 's/port=\"22\"/port=\"${ssh_port}\"/g' /usr/lib/firewalld/services/ssh.xml"
echo "sudo -S firewall-cmd --reload"
sudo -S firewall-cmd --reload

# user
sudo -S useradd ${default_user}
sudo -S passwd ${default_user}
sudo -S gpasswd -a ${default_user} wheel
