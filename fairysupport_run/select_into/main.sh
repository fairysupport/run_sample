#!/bin/bash

. ../common/common.sh
. ../common/db_user.sh

validate_arg_num $# 2 "please input database name and dir name"

mkdir ./output

outdir=$(echo "SELECT @@global.secure_file_priv" | mysql -u${db_root_user} -p${db_root_pw} ${1} -sN)
echo "show tables" | mysql -u${db_root_user} -p${db_root_pw} ${1} -sN > table_list.txt

while read line
do
  if [ -e ../${2}/${line} ]; then
    read_tpl ../${2}/${line} | mysql -u${db_root_user} -p${db_root_pw} -vvv ${1}
  else
    echo "SELECT * FROM ${line} INTO OUTFILE '${outdir}${line}_fairysupport_run'" | mysql -u${db_root_user} -p${db_root_pw} -vvv ${1}
  fi
  cp ${outdir}${line}_fairysupport_run ./output/${line}
  sudo -S rm -rf ${outdir}${line}_fairysupport_run
done < ./table_list.txt
