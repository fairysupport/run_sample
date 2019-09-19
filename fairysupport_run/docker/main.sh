#!/bin/bash

. ../common/common.sh

validate_eq_exit "sudo -S docker version" "docker is already installed"

sudo -S yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

sudo -S yum install -y yum-utils device-mapper-persistent-data lvm2
sudo -S yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo -S yum install -y docker-ce docker-ce-cli containerd.io

systemctl_start docker
systemctl_enable docker
