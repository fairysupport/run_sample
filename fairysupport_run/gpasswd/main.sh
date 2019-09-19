#!/bin/bash

. ../common/common.sh

validate_arg_num $# 2 "please input user name and group name"

sudo -S gpasswd -a ${1} ${2}
