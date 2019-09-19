#!/bin/bash

. ../common/common.sh
. ../common/db_user.sh

validate_arg_num $# 4 "please input database name and dir name and from and to"

for i in `seq 1 $#`
do
  eval "_ARG${i}=\"`eval echo '$'${i}`\""
done

mkdir output

for ver in `seq ${3} ${4}`;
do
  padver=$(printf "%09d\n" "${ver}")
  for file in `ls -1 ../${2}/${padver}`
  do
    mkdir -p ./output/${padver}
    echo "${padver}/${file}"
    read_tpl ../${2}/${padver}/${file} | mysql -u${db_root_user} -p${db_root_pw} -vvv ${1} > ./output/${padver}/${file}
  done
done
