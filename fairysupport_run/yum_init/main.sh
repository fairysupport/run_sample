#!/bin/bash

. ../common/common.sh

sudo -S yum -y update
sudo -S systemctl start firewalld
sudo -S systemctl enable firewalld
yum_install "lsof" "lsof"
yum_install "policycoreutils-python" "policycoreutils-python"
yum_install "iproute" "iproute"
yum_install "wget" "wget"
yum_install "gcc" "gcc"
