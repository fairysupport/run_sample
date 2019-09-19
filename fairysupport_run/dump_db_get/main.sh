#!/bin/bash

. ../common/common.sh
. ../common/db_user.sh

validate_arg_num $# 1 "please input database name"

mysqldump -u${db_root_user} -p${db_root_pw} -vvv ${1} > ./mysqldump.sql
