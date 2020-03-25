#!/bin/bash

. ../common/common.sh

# check
yum_installed_exit "nginx" "nginx is already installed"

suffix=""
if [ $# -ge 1 ]; then
  suffix=".${1}"
  if [ "${1}" = "local" ]; then
    sudo sh -c "sed -i.bak -e 's/^\s*SELINUX=/#SELINUX=/g' /etc/selinux/config"
    sudo sh -c "echo SELINUX=disabled >> /etc/selinux/config"
    sudo -S setenforce 0
  fi
fi

# repo
cp_mode_label "./nginx.repo" "/etc/yum.repos.d/nginx.repo" 644 system_conf_t

# install nginx
yum_install "nginx.x86_64" "nginx"

# replace default.conf
bk_cp_mode_label "./default.conf${suffix}" "/etc/nginx/conf.d/default.conf" 644 httpd_config_t

# put html file
cp_mode_label "./index.html" "/usr/share/nginx/html/index.html" 644 httpd_sys_content_t
cp_mode_label "./error.html" "/usr/share/nginx/html/error.html" 644 httpd_sys_content_t

# set firewalld
firewalld_add_service http
firewalld_add_service https

# start
systemctl_start nginx
systemctl_enable nginx
