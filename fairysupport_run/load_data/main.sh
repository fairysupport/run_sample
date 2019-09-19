#!/bin/bash

. ../common/common.sh
. ../common/db_user.sh

validate_arg_num $# 3 "please input database name and load_data dir name and data dir name"

echo "show tables" | mysql -u${db_root_user} -p${db_root_pw} ${1} -sN > table_list.txt

while read line
do
  if [ -e ../${2}/${line} ]; then
    read_tpl ../${2}/${line} | mysql -u${db_root_user} -p${db_root_pw} -vvv ${1}
  elif [ -e ../${3}/${line} ]; then
    data_dir=$(cd ../${3}; pwd)
    sql="LOAD DATA LOCAL INFILE '${data_dir}/${line}' REPLACE INTO TABLE ${line}"
    echo ${sql} | mysql -u${db_root_user} -p${db_root_pw} -vvv ${1}
  else
    echo "not found data file : ${line}"
  fi
done < ./table_list.txt
