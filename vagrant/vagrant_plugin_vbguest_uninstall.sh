#!/bin/bash

CUR=$(dirname $0)

cd ${CUR}
vagrant plugin uninstall vagrant-vbguest
