#!/bin/bash

. ../common/common.sh

# check
yum_installed_exit "php-fpm" "php-fpm is already installed"

sudo -S yum -y install epel-release
sudo -S rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

sudo -S yum -y install --enablerepo=remi,remi-php73 php-fpm

# replace default.conf
sudo -S mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bk
cp_mode_label "./default.conf" "/etc/nginx/conf.d/default.conf" 644 httpd_config_t

# replace www.conf
bk_cp_mode_label "./www.conf" "/etc/php-fpm.d/www.conf" 644 etc_t

# put php file
cp_mode_label "./index.php" "/usr/share/nginx/html/index.php" 644 httpd_sys_content_t

sudo -S semanage port -a -t http_port_t -p tcp 9002
systemctl_start php-fpm
systemctl_enable php-fpm

if sudo -S systemctl list-unit-files --type=service | grep nginx > /dev/null 2>&1; then
  sudo -S systemctl restart nginx.service
fi
