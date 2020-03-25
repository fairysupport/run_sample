#!/bin/bash

. ../common/common.sh

# check
yum_installed_exit "httpd" "Apache HTTP SERVER is already installed"

suffix=""
if [ $# -ge 1 ]; then
  suffix=".${1}"
  if [ "${1}" = "local" ]; then
    sudo sh -c "sed -i.bak -e 's/^\s*SELINUX=/#SELINUX=/g' /etc/selinux/config"
    sudo sh -c "echo SELINUX=disabled >> /etc/selinux/config"
    sudo -S setenforce 0
  fi
fi

# install Apache HTTP SERVER
yum_install "httpd.x86_64" "httpd"

# replace httpd.conf
bk_cp_mode_label "./httpd.conf${suffix}" "/etc/httpd/conf/httpd.conf" 644 httpd_config_t

# put html file
cp_mode_label "./index.html" "/var/www/html/index.html" 644 httpd_sys_content_t
cp_mode_label "./error.html" "/var/www/html/error.html" 644 httpd_sys_content_t

# set firewalld
firewalld_add_service http
firewalld_add_service https

# start
systemctl_start httpd
systemctl_enable httpd
