#!/bin/bash

. ../common/common.sh

validate_arg_num $# 1 "please input group name"

sudo -S groupadd ${1}
