#!/bin/bash

. ../common/common.sh

# check
yum_installed_exit "php" "PHP is already installed"

sudo -S yum -y install epel-release
sudo -S rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# install php
sudo -S yum -y install --enablerepo=remi,remi-php73 php php-devel php-mbstring php-pdo php-pdo_mysql php-pgsql php-gd php-soap php-xml php-xmlrpc php-opcache php-iconv php-zip php-openssl php-xdebug php-pecl-redis

# replace php.ini
bk_cp_mode_label "./php.ini" "/etc/php.ini" 644 etc_t

# put php file
if ls /var/www/html >/dev/null 2>&1; then
  cp_mode_label "./index.php" "/var/www/html/index.php" 644 httpd_sys_content_t
fi

if sudo -S systemctl list-unit-files --type=service | grep httpd > /dev/null 2>&1; then
  sudo -S systemctl restart httpd.service
fi
