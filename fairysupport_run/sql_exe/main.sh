#!/bin/bash

. ../common/common.sh
. ../common/db_user.sh

validate_arg_num $# 2 "please input database name and dir name"

for i in `seq 1 $#`
do
  eval "_ARG${i}=\"`eval echo '$'${i}`\""
done

mkdir output

for file in `ls -1 ../${2}`
do
  echo "${file}"
  read_tpl ../${2}/${file} | mysql -u${db_root_user} -p${db_root_pw} -vvv ${1} > ./output/${file}
done
