#!/bin/bash

. ../common/common.sh

validate_eq_exit "sudo -S docker-compose --version" "docker-compose is already installed"

sudo -S curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo -S chmod +x /usr/local/bin/docker-compose
sudo -S ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
