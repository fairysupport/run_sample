#!/bin/bash

. ../common/common.sh

for user_name in `ls -1 ./pubkey`
do
  if sudo -S ls /home/${user_name}/.ssh/authorized_keys > /dev/null 2>&1; then
    echo "${user_name} authorized_keys is already exists"
    continue
  fi

  echo "${user_name} : create authorized_keys"

  if ssh-keygen -i -f ./pubkey/${user_name} > /dev/null 2>&1; then
    ssh-keygen -i -f ./pubkey/${user_name} > ./pubkey/${user_name}.pub
  else
    cat ./pubkey/${user_name} > ./pubkey/${user_name}.pub
  fi

  sudo -S mkdir -p /home/${user_name}/.ssh
  sudo -S chmod 700 /home/${user_name}/.ssh
  sudo -S sh -c "cat ./pubkey/${user_name}.pub > /home/${user_name}/.ssh/authorized_keys"
  sudo -S chmod 600 /home/${user_name}/.ssh/authorized_keys
  sudo -S chown -R ${user_name}:${user_name} /home/${user_name}/.ssh

done
