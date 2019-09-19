#!/bin/bash

. ../common/common.sh

validate_arg_num $# 1 "please input user name"

if [ $# -lt 2 ]; then
  sudo -S passwd ${1}
else
  echo "${2}" | sudo -S passwd --stdin ${1}
fi
