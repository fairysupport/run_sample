#!/bin/bash

. ../common/common.sh

# check
yum_installed_exit "kibana.x86_64" "kibana is already installed"

# repo
cp_mode_label "./kibana.repo" "/etc/yum.repos.d/kibana.repo" 644 system_conf_t
sudo -S chown root:root /etc/yum.repos.d/kibana.repo

# install
sudo -S rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo -S yum -y install kibana

# replace kibana.yml
bk_cp_mode_label "./kibana.yml" "/etc/kibana/kibana.yml" 644 etc_t
sudo -S chown -R root:root /etc/kibana/kibana.yml

# set firewalld
sudo -S firewall-cmd --permanent --zone=public --add-port=5601/tcp
sudo -S firewall-cmd --reload

# start
sudo -S /bin/systemctl daemon-reload
sudo -S /bin/systemctl enable kibana.service
sudo -S systemctl start kibana.service
