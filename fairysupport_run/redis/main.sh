#!/bin/bash

. ../common/common.sh

# check
yum_installed_exit "redis.x86_64" "redis is already installed"

suffix=""
if [ $# -ge 1 ]; then
  suffix=".${1}"
fi

sudo -S yum -y install epel-release
sudo -S rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# install redis
sudo -S yum -y install --enablerepo=remi redis

# replace redis.conf
bk_cp_mode_label "./redis.conf${suffix}" "/etc/redis.conf" 644 etc_t

# set firewalld
if [ $# -ge 1 ] && [ ${1} = "local" ]; then
  firewalld_add_port "6379/tcp"
else
  firewalld_add_rich 'rule family="ipv4" source address="192.168.1.0/24" port port="6379" protocol="tcp" accept'
fi

# start
sudo -S /bin/systemctl enable redis.service
sudo -S systemctl start redis.service
