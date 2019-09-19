#!/bin/bash

. ../common/common.sh

validate_arg_num $# 1 "please input user name"
validate_eq_exit "id ${1}" "${1} already exists"

sudo -S useradd ${1}

if [ $# -lt 2 ]; then
  sudo -S passwd ${1}
else
  echo "${2}" | sudo -S passwd --stdin ${1}
fi
