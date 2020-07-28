#!/bin/bash

. ../common/common.sh
. ../common/db_user.sh

# check
yum_installed_exit "mysql-community-server" "MySQL is already installed"

echo "##uninstall mariadb##"
sudo -S yum remove -y mariadb-libs
sudo -S rm -rf /var/lib/mysql

echo "##rpm install##"
sudo -S rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
echo "##install MySQL##"
sudo -S yum --enablerepo=mysql80-community clean metadata
yum_install "mysql-community-server" "mysql-community-server"

echo "##set firewalld##"
if [ $# -ge 1 ] && [ ${1} = "local" ]; then
  firewalld_add_port "3306/tcp"
else
  firewalld_add_rich 'rule family="ipv4" source address="192.168.1.0/24" port port="3306" protocol="tcp" accept'
fi

echo "##initialize##"
sudo -S mysqld  --initialize-insecure
sudo -S touch /var/lib/mysql/mysql.sock
change_label mysqld_db_t /var/lib/mysql/mysql.sock
sudo -S chown -R mysql:mysql /var/lib/mysql

echo "##create log file##"
sudo -S mkdir /var/log/mysql
sudo -S touch /var/log/mysql/mysqld.log
sudo -S touch /var/log/mysql/general.log
sudo -S touch /var/log/mysql/slow.log
sudo -S chown -R mysql:mysql /var/log/mysql

echo "##set timezone and password##"
sudo -S systemctl start mysqld.service
sudo -S /usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -u${db_root_user} mysql
sudo -S echo "ALTER USER '${db_root_user}'@'localhost' identified WITH mysql_native_password BY '${db_root_pw}';" | mysql -u${db_root_user} mysql
sudo -S systemctl stop mysqld.service

echo "##replace my.cnf##"
bk_cp_mode_label "./my.cnf" "/etc/my.cnf" 644 mysqld_etc_t

echo "##start##"
systemctl_start mysqld
systemctl_enable mysqld
