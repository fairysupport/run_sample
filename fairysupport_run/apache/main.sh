#!/bin/bash

. ../common/common.sh

suffix=""
if [ $# -ge 1 ]; then
  suffix=".${1}"
fi

# check
yum_installed_exit "httpd" "Apache HTTP SERVER is already installed"

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
