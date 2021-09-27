#!/bin/bash

CUR=$(dirname $0)

cd ${CUR}
vagrant plugin install vagrant-vbguest --plugin-version 0.21
