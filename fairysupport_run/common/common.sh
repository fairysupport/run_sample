
validate_arg_num() {
  if [ ${1} -lt ${2} ]; then
    echo "${3}"
    exit 1
  fi
}

validate_eq_exit() {
  eval ${1} > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${2}"
    exit 1
  fi
}

validate_ne_exit() {
  eval ${1} > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "${2}"
    exit 1
  fi
}

yum_installed() {
  if sudo -S yum list installed | grep "${1}" > /dev/null 2>&1; then
     return 0
  fi
  return 1
}

yum_install() {
  if ! sudo -S yum list installed | grep "${1}" > /dev/null 2>&1; then
     echo "sudo -S yum -y install \"${2}\""
     sudo -S yum -y install "${2}"
  fi
}

yum_installed_exit() {
  if yum_installed "${1}" ; then
    echo "${2}"
    exit 0
  fi
}

rpm_installed() {
  if sudo -S rpm -qa | grep "${1}" > /dev/null 2>&1; then
     return 0
  fi
  return 1
}

rpm_install() {
  if ! sudo -S rpm -qa | grep "${1}" > /dev/null 2>&1; then
     echo "sudo -S rpm -ivh \"${2}\""
     sudo -S rpm -ivh "${2}"
  fi
}

change_label() {
  sudo -S semanage fcontext -a -t "${1}" "${2}"
  sudo -S restorecon -v "${2}"
}

cp_mode_label() {
  if ! sudo -S diff "${1}" "${2}" > /dev/null 2>&1; then
    sudo -S \cp -f "${1}" "${2}"
  fi
  sudo -S chmod ${3} "${2}"
  local file_con_list=(`ls -Z ${2} | tr ':' ' '`)
  if [ ${file_con_list[5]} != "${4}" ]; then
    change_label "${4}" "${2}"
  fi
}

bk_cp_mode_label() {
  if ! sudo -S diff "${1}" "${2}" > /dev/null 2>&1; then
    sudo -S mv "${2}" "${2}.bk"
  fi
  cp_mode_label "${1}" "${2}" "${3}" "${4}"
}

systemctl_start() {
  if sudo -S systemctl status "${1}" | grep "Active: inactive" > /dev/null 2>&1; then
    sudo -S systemctl start "${1}.service"
  fi
}

systemctl_enable() {
  if sudo -S systemctl is-enabled "${1}" | grep disabled > /dev/null 2>&1; then
    sudo -S systemctl enable "${1}.service"
  fi
}

firewalld_add_service() {
  if ! echo " `sudo -S firewall-cmd --list-services --permanent --zone=public` " | grep " ${1} " > /dev/null 2>&1; then
      sudo -S firewall-cmd --permanent --zone=public --add-service="${1}"
      sudo -S firewall-cmd --reload
  fi
}

firewalld_add_port() {
  if ! echo " `sudo -S firewall-cmd --list-ports --permanent --zone=public` " | grep "${1}" > /dev/null 2>&1; then
      sudo -S firewall-cmd --permanent --zone=public --add-port="${1}"
      sudo -S firewall-cmd --reload
  fi
}

firewalld_add_rich() {
  if ! sudo -S firewall-cmd --permanent --list-rich-rules | grep "${1}" > /dev/null 2>&1; then
    sudo -S firewall-cmd --permanent --zone=public --add-rich-rule="${1}"
    sudo -S firewall-cmd --reload
  fi
}

read_tpl() {
  echo "$(eval "echo \"$(cat ${1})\"")"
}
