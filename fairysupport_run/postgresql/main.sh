#!/bin/bash

. ../common/common.sh
. ../common/db_user.sh

RUN_DIR=`pwd`

# check
yum_installed_exit "postgresql11" "postgresql11 is already installed"

sudo -S yum -y install epel-release
sudo -S rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

echo "##rpm install##"
sudo -S yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

echo "##install postgresql##"
yum_install "postgresql11" "postgresql11"
yum_install "postgresql11-server" "postgresql11-server"
yum_install "postgresql11-contrib" "postgresql11-contrib"
yum_install "postgresql11-devel" "postgresql11-devel"
yum_install "centos-release-scl" "centos-release-scl"
yum_install "llvm-toolset-7" "llvm-toolset-7"
yum_install "llvm5.0" "llvm5.0"

echo "##set firewalld##"
firewalld_add_rich 'rule family="ipv4" source address="192.168.1.0/24" port port="5432" protocol="tcp" accept'

echo "##initialize##"
sudo -S PGSETUP_INITDB_OPTIONS="-E UTF8 --locale=C --text-search-config=simple" /usr/pgsql-11/bin/postgresql-11-setup initdb

echo "##set password##"
sudo -S systemctl start postgresql-11
cd /tmp
echo "create role ${db_root_user} with superuser login password '${db_root_pw}';" > /tmp/fairysupport_run_postgresql_new_role.sql
chmod 777 /tmp/fairysupport_run_postgresql_new_role.sql
sudo -u postgres psql -U postgres -f /tmp/fairysupport_run_postgresql_new_role.sql
sudo -S rm -rf /tmp/fairysupport_run_postgresql_new_role.sql
cd ${RUN_DIR}

echo "##pg_bigm##"
sudo -S systemctl stop postgresql-11
cd /tmp
sudo -S wget https://ja.osdn.net/dl/pgbigm/pg_bigm-1.2-20191003.tar.gz
sudo -S tar zxf pg_bigm-1.2-20191003.tar.gz
cd pg_bigm-1.2-20191003
sudo -S make USE_PGXS=1 PG_CONFIG=/usr/pgsql-11/bin/pg_config
sudo -S make USE_PGXS=1 PG_CONFIG=/usr/pgsql-11/bin/pg_config install

echo "##replace conf##"
bk_cp_mode_label "./postgresql.conf" "/var/lib/pgsql/11/data/postgresql.conf" 600 postgresql_db_t
sudo -S chown postgres:postgres /var/lib/pgsql/11/data/postgresql.conf

bk_cp_mode_label "./pg_hba.conf" "/var/lib/pgsql/11/data/pg_hba.conf" 600 postgresql_db_t
sudo -S chown postgres:postgres /var/lib/pgsql/11/data/pg_hba.conf

echo "##start##"
sudo -S systemctl start postgresql-11
sudo -S systemctl enable postgresql-11
