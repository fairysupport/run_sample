#!/bin/bash

. ../common/common.sh

sudo sh -c "sed -i.bak -e 's/^\s*DNS/#DNS/g' /etc/sysconfig/network-scripts/ifcfg-eth0"
sudo sh -c "echo DNS1=8.8.8.8 >> /etc/sysconfig/network-scripts/ifcfg-eth0"
sudo sh -c "echo DNS2=8.8.4.4 >> /etc/sysconfig/network-scripts/ifcfg-eth0"
echo "sudo -S systemctl restart network.service"
sudo -S systemctl restart network.service
