#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
          __               __ 
   ____  / /_  ____ ____  / /_
  / __ \/ __ \/ __ `/ _ \/ __/
 / / / / /_/ / /_/ /  __/ /_  
/_/ /_/_.___/\__, /\___/\__/  
            /____/            
            
EOF
}
header_info
echo -e "Loading..."
APP="nzbget"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/nzbget ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating $APP"
systemctl stop nzbget.service

msg_info "Installing nzbget"
mkdir -p /opt/nzbget
cd /opt/nzbget
wget https://nzbget.net/download/nzbget-latest-bin-linux.run
chmod +x ./nzbget-latest-bin-linux.run
sh ./nzbget-latest-bin-linux.run
rm ./nzbget-latest-bin-linux.run
msg_ok "Installed nzbget"
systemctl start nzbget.service
msg_ok "Updated $APP"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:6789${CL} \n"