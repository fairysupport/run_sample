#!/bin/bash

. ../common/common.sh

# check
validate_eq_exit "sudo -S alternatives --display java | grep java-12" "java12 is already installed"

# install
sudo -S wget https://download.java.net/java/GA/jdk12/33/GPL/openjdk-12_linux-x64_bin.tar.gz
sudo -S tar xvf ./openjdk-12_linux-x64_bin.tar.gz
sudo -S mv ./jdk-12 /usr/lib/java-12

sudo -S alternatives --install /usr/bin/java java /usr/lib/java-12/bin/java 12000000
sudo -S alternatives --install /usr/bin/javac javac /usr/lib/java-12/bin/javac 12000000

sudo -S update-alternatives --auto java
sudo -S update-alternatives --auto javac
