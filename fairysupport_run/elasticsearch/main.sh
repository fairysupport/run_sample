#!/bin/bash

. ../common/common.sh

# check
yum_installed_exit "elasticsearch.x86_64" "elasticsearch is already installed"

# repo
cp_mode_label "./elasticsearch.repo" "/etc/yum.repos.d/elasticsearch.repo" 644 system_conf_t
sudo -S chown root:root /etc/yum.repos.d/elasticsearch.repo

# install
sudo -S rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo -S yum -y install elasticsearch

# replace elasticsearch.yml
bk_cp_mode_label "./elasticsearch.yml" "/etc/elasticsearch/elasticsearch.yml" 660 etc_t
sudo -S chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml

# set firewalld
firewalld_add_rich 'rule family="ipv4" source address="192.168.1.0/24" port port="9200" protocol="tcp" accept'
firewalld_add_rich 'rule family="ipv4" source address="192.168.33.0/24" port port="9200" protocol="tcp" accept'

# start
sudo -S /bin/systemctl daemon-reload
sudo -S /bin/systemctl enable elasticsearch.service
sudo -S systemctl start elasticsearch.service
